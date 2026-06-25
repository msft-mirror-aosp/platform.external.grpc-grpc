# Android Emulator gRPC Merge & Upgrade Procedure

This document explains in detail the end-to-end workflow for upgrading the Android Emulator's gRPC dependency (`external/grpc`) to a newer upstream release branch (e.g., `v1.82.x`). It serves as a comprehensive reference for future developers and automated AI agents to navigate the specific architectural constraints, build generation tools, and compatibility quirks of the AOSP QEMU (AEMU) environment.

---

## 1. Architectural Context & Constraints

The Android Emulator relies on gRPC for various host control services, inter-process communication, and tooling plugins. However, the AOSP integration of gRPC differs significantly from the official upstream GitHub repository:
* **Stripped Submodules**: AOSP strict governance policies strip out external git submodules (`third_party/*`) and GitHub workflow directories (`.github`).
* **Custom CMake Build**: Instead of using upstream Bazel or default CMake definitions, AEMU uses custom Mako templates (`templates/emulator/`) to generate tailored CMake build files (`emulator/CMakeLists.txt`).
* **Shared Base Libraries**: AEMU links common dependencies (Abseil, Protobuf, BoringSSL, zlib, c-ares, RE2) from sibling directories in the AOSP tree (`external/abseil-cpp`, `external/protobuf`, etc.) rather than building them as submodules within `external/grpc`.

---

## 2. Phase 1: Rendering Mako Build Templates (Scratch Repository)

Because AOSP strips the upstream submodules necessary to execute Mako template generation, you **cannot** run the template generator directly within `external/grpc`. You must use an isolated external scratch repository.

### Step-by-Step Template Generation
1. **Clone Upstream gRPC in a Scratch Location**:
   Clone the official gRPC repository outside of your AOSP tree (e.g., in `/tmp` or an agent scratch directory):
   ```bash
   git clone https://github.com/grpc/grpc.git /path/to/scratch/grpc_upstream
   cd /path/to/scratch/grpc_upstream
   ```

2. **Checkout Target Branch & Initialize Submodules**:
   Checkout the desired release branch (e.g., `v1.82.x`) and pull the required submodules:
   ```bash
   git checkout v1.82.x
   git submodule update --init --recursive
   ```

3. **Copy Emulator Templates**:
   Copy the custom AEMU Mako templates from your AOSP workspace into the scratch repository:
   ```bash
   cp -r /path/to/aosp/external/grpc/templates/emulator /path/to/scratch/grpc_upstream/templates/
   ```

4. **Execute Mako Build Generator**:
   Run the project generation script to render the updated `CMakeLists.txt` files:
   ```bash
   ./tools/buildgen/generate_projects.sh
   ```
   *Note: This script requires Python 3, Mako (`pip install Mako`), and PyYAML (`pip install pyyaml`).*

---

## 3. Phase 2: Git Merge & Submodule Cleanup in AOSP

Once the new CMake files are rendered in your scratch repo, perform the actual git merge inside your AOSP workspace.

### Step-by-Step Merge Procedure
1. **Start Repo Branch**:
   ```bash
   cd /path/to/aosp/external/grpc
   repo start merge-in-grpc .
   git branch --set-upstream-to goog/emu-main-dev
   ```

2. **Merge Upstream Branch**:
   Initiate the git merge from the appropriate `goog/upstream-v1.XX.x` tracking branch:
   ```bash
   git merge goog/upstream-v1.82.x
   ```

3. **Resolve Content Merge Conflicts**:
   Common files that experience conflicts during upgrades include:
   * `src/core/tsi/ssl_transport_security.cc`: Reconcile OpenSSL/BoringSSL `crl_provider` validation logic. Accept upstream cleanups where legacy BoringSSL-specific `#ifdef` blocks have been unified.
   * `src/core/util/directory_reader.h`: Ensure `#endif` header guard comments match the file's current location.
   * `src/core/lib/debug/trace.h`, `src/core/lib/experiments/rollouts.yaml`, `src/core/lib/promise/detail/basic_seq.h`: Accept upstream structural refactors while preserving any explicit QEMU required includes (such as `absl/strings/str_cat.h`).

4. **Purge Submodules & GitHub Actions**:
   You **MUST** remove all upstream submodules and workflow folders before committing:
   ```bash
   git rm -rf .github .gitmodules third_party/abseil-cpp third_party/benchmark third_party/boringssl-with-bazel third_party/cares/cares third_party/googletest third_party/protobuf third_party/zlib
   ```

5. **Import Rendered CMake Files**:
   Copy the freshly generated build files from your scratch repository into `external/grpc/emulator/`:
   ```bash
   cp /path/to/scratch/grpc_upstream/emulator/CMakeLists.txt emulator/CMakeLists.txt
   cp /path/to/scratch/grpc_upstream/emulator/plugins/CMakeLists.txt emulator/plugins/CMakeLists.txt
   cp /path/to/scratch/grpc_upstream/emulator/tests/CMakeLists.txt emulator/tests/CMakeLists.txt
   ```

6. **Commit the Merge**:
   ```bash
   git add src emulator
   git commit -m "Merge goog/upstream-v1.82.x into external/grpc and regenerate emulator CMakeLists.txt"
   ```

---

## 4. Phase 3: Patching Build Definitions & Code Compatibility

Mako templates and upstream gRPC code often introduce patterns that clash with QEMU's specific CMake environment or older shared AOSP libraries. Address the following areas:

### 1. CMake Library Linking Cleanup
Mako templates frequently leak raw Bazel target strings (`absl/algorithm:container`) or plain library strings (`upb`, `protobuf`, `protoc`, `utf8_range_lib`) into `target_link_libraries` blocks within `emulator/CMakeLists.txt` and `emulator/plugins/CMakeLists.txt`.
* **The Fix**: Strip out plain strings (`upb`, `protobuf`, `protoc`, `utf8_range_lib`) and raw Bazel targets (`absl/*:*`) from `grpc`, `grpc_unsecure`, `grpc++`, `grpc++_unsecure`, `grpc_authorization_provider`, and `grpc_plugin_support`. AEMU targets already correctly receive base dependencies via `_gRPC_ALLTARGETS_LIBRARIES`.
* **Cross-Compilation (`utf8_range_lib`)**: `grpc_cpp_plugin_ext_cross` configures only `emulator/plugins/CMakeLists.txt` in isolation. Because `utf8_range_lib` is defined in `emulator/CMakeLists.txt`, leaving `utf8_range_lib` in `grpc_plugin_support` will break cross-compilation with `unable to locate the required dependency -lutf8_range_lib`.
* **Protobuf Variables**: In `emulator/plugins/CMakeLists.txt`, ensure `_gRPC_PROTOBUF_LIBRARIES` is set to `protobuf::libprotobuf` (not `protobuf::protobuf`, which is a directory name) and `_gRPC_PROTOBUF_PROTOC_LIBRARIES` is set to `protobuf::libprotoc` (not `protoc`, which is an executable).

### 2. Missing Protobuf Code Generation Rules
New gRPC releases may introduce additional `.proto` dependencies (e.g., `src/proto/grpc/reflection/v1/reflection.proto`).
* **The Fix**: If CMake reports missing `.pb.cc` files, add the corresponding `protobuf_generate_grpc_cpp` function call to `emulator/CMakeLists.txt`.

### 3. Abseil Logging & Stream Operator Overloads (`CHECK` Macros)
Upstream gRPC uses `AbslStringify` for custom types (`InstrumentLabel`, `CoreConfiguration::BuilderScope`, `UniqueTypeName`). However, QEMU's shared Abseil library may be an older version where check macros (`CHECK_NE`, `CHECK_EQ`) strictly require `operator<<` overloads to format failure messages.
* **The Fix**: If the compiler fails with `invalid operands to binary expression ('std::ostream' and 'const T')`, define an explicit `operator<<` stream overload for the affected type in its respective header file (`instrument.h`, `core_configuration.h`, `unique_type_name.h`).

### 4. `absl::BitGenRef` & Rvalue Temporaries
Older Abseil versions define `absl::BitGenRef` constructors that accept only lvalue references (`URBG&`). Upstream gRPC code passing rvalue temporaries like `SharedBitGen()` will fail to compile.
* **The Fix**: Add an implicit conversion operator to `SharedBitGen` in `src/core/util/shared_bit_gen.h`:
  ```cpp
  #include "absl/random/bit_gen_ref.h"
  // Inside SharedBitGen class definitions:
  operator absl::BitGenRef() { return absl::BitGenRef(bit_gen_); }
  ```

### 5. C# Plugin Custom Macros
If `csharp_generator.cc` fails with `use of undeclared identifier 'GRPC_CUSTOM_CSHARP_GETCLASSNAME'`, uncomment the C# macro definitions and `#include <google/protobuf/compiler/csharp/names.h>` in `src/compiler/config_protobuf.h`.

---

## 5. Phase 4: Sibling Project Compatibility (`external/qemu`)

An upgrade to `external/grpc` often requires corresponding adjustments in the main emulator repository (`external/qemu`).

### 1. CMake License Validation (`licensing.py`)
QEMU enforces strict licensing validation on all dependency targets. As gRPC introduces new interface targets (`protobuf`, `z`, `cares`, `re2`, `ssl`, `crypto`, `absl_meta`, `upb`, `utf8_range`, `address_sorting`, `absl`), the license validator will throw an exception (`You are distributing a target qsn that relies on a dependency X for which no license is declared`).
* **The Fix**: Add these interface dependency names to the `common_local_libs` list in `external/qemu/android/build/python/aemu/licensing.py`.

### 2. Logging API Evolution (`GrpcAndroidLogAdapter`)
When upstream gRPC fully retires legacy APIs (such as `gpr_set_log_function` and `gpr_log_func_args`), QEMU's gRPC control service wrappers will fail to compile.
* **The Fix**: Rather than rewriting QEMU's control stack, provide drop-in compatibility definitions in `external/qemu/android/android-grpc/services-stack/src/android/emulation/control/utils/GrpcAndroidLogAdapter.h`:
  ```cpp
  struct gpr_log_func_args {
      const char* file;
      int line;
      gpr_log_severity severity;
      const char* message;
  };
  inline void gpr_set_log_function(void (*)(gpr_log_func_args*)) {}
  ```

---

## 6. Phase 5: Rebuilding & Uploading to Gerrit

### Rapid Rebuilding
When debugging compilation breaks, avoid running the full `external/qemu/android/rebuild.sh` script, as it cleans and reconfigures the build from scratch. Once CMake configuration passes successfully, use Ninja directly for fast rebuilds:
```bash
cd /path/to/aosp
ninja -C objs
```

### Uploading to Gerrit
Once the build passes successfully, ensure both branches share the same topic so reviewers can evaluate the changes together:
```bash
# In external/grpc:
repo upload --cbr -t -y .

# In external/qemu:
git branch -m merge-in-grpc
repo upload --cbr -t -y .
```
