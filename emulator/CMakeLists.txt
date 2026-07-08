# THIS FILE IS FOR USE BY THE ANDROID EMULATOR CMAKE BUILD
# ========================================================
# This currently builds C and C++ code.
# This file has been automatically generated from a template file.
# Please look at the templates directory instead.
# This file can be regenerated from the template by running
# tools/buildgen/generate_projects.sh
#
# Copyright 2015 gRPC authors.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.




cmake_minimum_required(VERSION 3.5.1)
cmake_policy(SET CMP0079 NEW)


set(PACKAGE_NAME          "grpc")
set(PACKAGE_VERSION       "1.82.0-pre1")
set(gRPC_CORE_VERSION     "55.0.0")
set(gRPC_CORE_SOVERSION   "55")
set(gRPC_CPP_VERSION      "1.82.0-pre1")
set(gRPC_CPP_SOVERSION    "1.82")
set(gRPC_CSHARP_VERSION   "2.82.0-pre1")
set(gRPC_CSHARP_SOVERSION "2.82")
set(PACKAGE_STRING        "${PACKAGE_NAME} ${PACKAGE_VERSION}")
set(PACKAGE_TARNAME       "${PACKAGE_NAME}-${PACKAGE_VERSION}")
set(PACKAGE_BUGREPORT     "https://github.com/grpc/grpc/issues/")
project(${PACKAGE_NAME} LANGUAGES C CXX)

set(gRPC_INSTALL_BINDIR "bin" CACHE STRING "Installation directory for executables")
set(gRPC_INSTALL_LIBDIR "lib" CACHE STRING "Installation directory for libraries")
set(gRPC_INSTALL_INCLUDEDIR "include" CACHE STRING "Installation directory for headers")
set(gRPC_INSTALL_CMAKEDIR "lib/cmake/${PACKAGE_NAME}" CACHE STRING "Installation directory for cmake config files")
set(gRPC_INSTALL_SHAREDIR "share/grpc" CACHE STRING "Installation directory for root certificates")
set(gRPC_BUILD_MSVC_MP_COUNT 0 CACHE STRING "The maximum number of processes for MSVC /MP option")

# Options
option(gRPC_BUILD_TESTS "Build tests" OFF)
option(gRPC_BUILD_CODEGEN "Build codegen" ON)
option(gRPC_BUILD_CSHARP_EXT "Build C# extensions" OFF)
option(gRPC_BACKWARDS_COMPATIBILITY_MODE "Build libraries that are binary compatible across a larger number of OS and libc versions" OFF)

set(gRPC_INSTALL_default OFF)
if(NOT CMAKE_SOURCE_DIR STREQUAL CMAKE_CURRENT_SOURCE_DIR)
  # Disable gRPC_INSTALL by default if building as a submodule
  set(gRPC_INSTALL_default OFF)
endif()
set(gRPC_INSTALL ${gRPC_INSTALL_default} CACHE BOOL
    "Generate installation target")

# We can install dependencies from submodules if we're running
# CMake v3.13 or newer.
if(CMAKE_VERSION VERSION_LESS 3.13)
  set(_gRPC_INSTALL_SUPPORTED_FROM_MODULE OFF)
else()
  set(_gRPC_INSTALL_SUPPORTED_FROM_MODULE ON)
endif()

# Providers for third-party dependencies (gRPC_*_PROVIDER properties):
# "module": build the dependency using sources from git submodule (under third_party)
# "package": use cmake's find_package functionality to locate a pre-installed dependency

set(gRPC_ZLIB_PROVIDER "module" CACHE STRING "Provider of zlib library")
set_property(CACHE gRPC_ZLIB_PROVIDER PROPERTY STRINGS "module" "package")

set(gRPC_CARES_PROVIDER "module" CACHE STRING "Provider of c-ares library")
set_property(CACHE gRPC_CARES_PROVIDER PROPERTY STRINGS "module" "package")

set(gRPC_RE2_PROVIDER "module" CACHE STRING "Provider of re2 library")
set_property(CACHE gRPC_RE2_PROVIDER PROPERTY STRINGS "module" "package")

set(gRPC_SSL_PROVIDER "module" CACHE STRING "Provider of ssl library")
set_property(CACHE gRPC_SSL_PROVIDER PROPERTY STRINGS "module" "package")

set(gRPC_PROTOBUF_PROVIDER "module" CACHE STRING "Provider of protobuf library")
set_property(CACHE gRPC_PROTOBUF_PROVIDER PROPERTY STRINGS "module" "package")

set(gRPC_PROTOBUF_PACKAGE_TYPE "" CACHE STRING "Algorithm for searching protobuf package")
set_property(CACHE gRPC_PROTOBUF_PACKAGE_TYPE PROPERTY STRINGS "CONFIG" "MODULE")

if(gRPC_BUILD_TESTS)
  set(gRPC_BENCHMARK_PROVIDER "module" CACHE STRING "Provider of benchmark library")
  set_property(CACHE gRPC_BENCHMARK_PROVIDER PROPERTY STRINGS "module" "package")
else()
  set(gRPC_BENCHMARK_PROVIDER "none")
endif()

set(gRPC_ABSL_PROVIDER "module" CACHE STRING "Provider of absl library")
set_property(CACHE gRPC_ABSL_PROVIDER PROPERTY STRINGS "module" "package")

set(gRPC_ABSL_USED_TARGETS
  absl_absl_check
  absl_absl_log
  absl_absl_vlog_is_on
  absl_algorithm
  absl_algorithm_container
  absl_any_invocable
  absl_atomic_hook
  absl_base
  absl_base_internal
  absl_bind_front
  absl_bits
  absl_bounded_utf8_length_sequence
  absl_btree
  absl_charset
  absl_check
  absl_city
  absl_civil_time
  absl_cleanup
  absl_cleanup_internal
  absl_common_policy_traits
  absl_compare
  absl_compressed_tuple
  absl_config
  absl_container_common
  absl_container_memory
  absl_cord
  absl_cord_internal
  absl_cordz_functions
  absl_cordz_handle
  absl_cordz_info
  absl_cordz_statistics
  absl_cordz_update_scope
  absl_cordz_update_tracker
  absl_core_headers
  absl_crc32c
  absl_crc_cord_state
  absl_crc_cpu_detect
  absl_crc_internal
  absl_debugging_internal
  absl_decode_rust_punycode
  absl_demangle_internal
  absl_demangle_rust
  absl_dynamic_annotations
  absl_endian
  absl_errno_saver
  absl_examine_stack
  absl_exponential_biased
  absl_fast_type_id
  absl_fixed_array
  absl_flags
  absl_flags_commandlineflag
  absl_flags_commandlineflag_internal
  absl_flags_config
  absl_flags_internal
  absl_flags_marshalling
  absl_flags_path_util
  absl_flags_private_handle_accessor
  absl_flags_program_name
  absl_flags_reflection
  absl_flat_hash_map
  absl_flat_hash_set
  absl_function_ref
  absl_graphcycles_internal
  absl_has_ostream_operator
  absl_hash
  absl_hash_container_defaults
  absl_hash_function_defaults
  absl_hash_policy_traits
  absl_hashtable_control_bytes
  absl_hashtable_debug_hooks
  absl_hashtablez_sampler
  absl_inlined_vector
  absl_inlined_vector_internal
  absl_int128
  absl_iterator_traits_internal
  absl_kernel_timeout_internal
  absl_layout
  absl_leak_check
  absl_log
  absl_log_entry
  absl_log_globals
  absl_log_internal_append_truncated
  absl_log_internal_check_impl
  absl_log_internal_check_op
  absl_log_internal_conditions
  absl_log_internal_config
  absl_log_internal_fnmatch
  absl_log_internal_format
  absl_log_internal_globals
  absl_log_internal_log_impl
  absl_log_internal_log_sink_set
  absl_log_internal_message
  absl_log_internal_nullguard
  absl_log_internal_nullstream
  absl_log_internal_proto
  absl_log_internal_strip
  absl_log_internal_structured_proto
  absl_log_internal_voidify
  absl_log_severity
  absl_log_sink
  absl_log_sink_registry
  absl_low_level_hash
  absl_malloc_internal
  absl_memory
  absl_no_destructor
  absl_node_hash_map
  absl_node_slot_policy
  absl_non_temporal_arm_intrinsics
  absl_non_temporal_memcpy
  absl_nullability
  absl_numeric_representation
  absl_optional
  absl_prefetch
  absl_random_bit_gen_ref
  absl_random_distributions
  absl_random_internal_distribution_caller
  absl_random_internal_entropy_pool
  absl_random_internal_fast_uniform_bits
  absl_random_internal_fastmath
  absl_random_internal_generate_real
  absl_random_internal_iostream_state_saver
  absl_random_internal_nonsecure_base
  absl_random_internal_pcg_engine
  absl_random_internal_platform
  absl_random_internal_randen
  absl_random_internal_randen_engine
  absl_random_internal_randen_hwaes
  absl_random_internal_randen_hwaes_impl
  absl_random_internal_randen_slow
  absl_random_internal_salted_seed_seq
  absl_random_internal_seed_material
  absl_random_internal_traits
  absl_random_internal_uniform_helper
  absl_random_internal_wide_multiply
  absl_random_random
  absl_random_seed_gen_exception
  absl_random_seed_sequences
  absl_raw_hash_map
  absl_raw_hash_set
  absl_raw_hash_set_resize_impl
  absl_raw_logging_internal
  absl_sample_recorder
  absl_span
  absl_spinlock_wait
  absl_stacktrace
  absl_status
  absl_statusor
  absl_str_format
  absl_str_format_internal
  absl_strerror
  absl_string_view
  absl_strings
  absl_strings_internal
  absl_symbolize
  absl_synchronization
  absl_throw_delegate
  absl_time
  absl_time_zone
  absl_tracing_internal
  absl_type_traits
  absl_utf8_for_code_point
  absl_utility
  absl_variant
  absl_vlog_config_internal
  absl_vlog_is_on
  absl_weakly_mixed_integer
  absl_meta
)

set(gRPC_USE_PROTO_LITE OFF CACHE BOOL "Use the protobuf-lite library")

get_filename_component(_gRPC_ROOT "${CMAKE_CURRENT_LIST_DIR}/.." ABSOLUTE)

if(LINUX_X86_64 OR LINUX_AARCH64)
   set(_gRPC_PLATFORM_LINUX ON)
   set(_gRPC_PLATFORM_POSIX ON)
elseif(DARWIN_X86_64 OR DARWIN_AARCH64)
   set(_gRPC_PLATFORM_MAC ON)
   set(_gRPC_PLATFORM_POSIX ON)
else()
 set(_gRPC_PLATFORM_WINDOWS ON)
endif()

# Use C99 standard
if (NOT DEFINED CMAKE_C_STANDARD)
  set(CMAKE_C_STANDARD 99)
endif()


set(_gRPC_PROTOBUF_LIBRARY_NAME "libprotobuf")


include(${CMAKE_CURRENT_LIST_DIR}/../cmake/upb.cmake)
include(${CMAKE_CURRENT_LIST_DIR}/../cmake/xxhash.cmake)
include(${CMAKE_CURRENT_LIST_DIR}/../cmake/address_sorting.cmake)

# Make sure we have the protoc plugin available.
android_compile_for_host(grpc_cpp_plugin ${CMAKE_CURRENT_LIST_DIR}/plugins GRPC_CPP_PLUGIN_EXE)
set(_gRPC_CPP_PLUGIN_EXECUTABLE ${GRPC_CPP_PLUGIN_EXE} CACHE PATH "Grpc cpp plugin" FORCE)
set(_gRPC_PROTOBUF_PROTOC_EXECUTABLE ${PROTOBUF_PROTOC_EXECUTABLE} CACHE PATH "Protocol buffer executable" FORCE)

if(_gRPC_PLATFORM_MAC OR _gRPC_PLATFORM_IOS)
  set(_gRPC_ALLTARGETS_LIBRARIES ${CMAKE_DL_LIBS} m pthread)
elseif(_gRPC_PLATFORM_ANDROID)
  set(_gRPC_ALLTARGETS_LIBRARIES ${CMAKE_DL_LIBS} m)
elseif(_gRPC_PLATFORM_LINUX)
  set(_gRPC_ALLTARGETS_LIBRARIES ${CMAKE_DL_LIBS} rt m pthread)
endif()

if(WIN32)
  set(_gRPC_BASELIB_LIBRARIES ws2_32::ws2_32 crypt32::crypt32)
endif()

# Create directory for generated .proto files
set(_gRPC_PROTO_GENS_DIR ${CMAKE_BINARY_DIR}/gens)
file(MAKE_DIRECTORY ${_gRPC_PROTO_GENS_DIR})
#  protobuf_generate_grpc_cpp
#  --------------------------
#
#   Add custom commands to process ``.proto`` files to C++ using protoc and
#   GRPC plugin::
#
#     protobuf_generate_grpc_cpp [<ARGN>...]
#
#   ``SOURCE_DIR``
#      Root directory where sources can be found, defaults to CMAKE_CURRENT_SOURCE_DIR
#   ``OUTPUT_DIR``
#      Directory where the generated sources will be placed, defaults to CMAKE_CURRENT_BINARY_DIR/gens
#   ``INCLUDES``
#       Specify the directores in which to search for imports. Directories will be searched in order.
#   ``GENERATED``
#      Variable that should contain the list of generated sources.
#   ``SOURCES``
#     ``.proto`` files
#
function(protobuf_generate_grpc_cpp)
  # Parse arguments
  set(options)
  set(oneValueArgs SOURCE_DIR OUTPUT_DIR GENERATED INCLUDES)
  set(multiValueArgs SOURCES)
  cmake_parse_arguments(grpc "${options}"
                             "${oneValueArgs}"
                             "${multiValueArgs}"
                             ${ARGN})

  if (NOT grpc_OUTPUT_DIR)
      set(grpc_OUTPUT_DIR ${_gRPC_PROTO_GENS_DIR})
  endif()
  if (NOT grpc_SOURCE_DIR)
      set(grpc_SOURCE_DIR ${CMAKE_CURRENT_SOURCE_DIR})
  endif()
  if(NOT grpc_SOURCES)
    message(SEND_ERROR "Error: PROTOBUF_GENERATE_GRPC_CPP() called without any proto files")
    return()
  endif()
  list(APPEND grpc_INCLUDES ".")
  list(APPEND grpc_INCLUDES "${ANDROID_QEMU2_TOP_DIR}/../protobuf/src")
  unset(GRPC_INCLUDES)
  foreach(INC ${grpc_INCLUDES})
      set(GRPC_INCLUDES ${GRPC_INCLUDES} -I${INC})
  endforeach()

  set(GRPC_PROTO_GEN "")
  set(_LOCAL_GRPC "${ANDROID_QEMU2_TOP_DIR}/../grpc/emulator")

  if(NOT Python3_EXECUTABLE)
    find_package(Python3 COMPONENTS Interpreter)
    if(NOT Python3_FOUND)
      message(FATAL_ERROR "A python interpreter is required. ")
    endif()
  endif()
  set(exe "${_LOCAL_GRPC}/compile_grpc.py")

  foreach(FIL ${grpc_SOURCES})
    get_filename_component(ABS_FIL ${FIL} ABSOLUTE)
    if(NOT EXISTS "${ABS_FIL}")
      get_filename_component(ABS_FIL "${grpc_SOURCE_DIR}/${FIL}" ABSOLUTE)
    endif()
    get_filename_component(FIL_WE ${FIL} NAME_WE)
    file(RELATIVE_PATH REL_FIL ${grpc_SOURCE_DIR} ${ABS_FIL})
    get_filename_component(REL_DIR ${REL_FIL} DIRECTORY)
    set(RELFIL_WE "${REL_DIR}/${FIL_WE}")

    add_custom_command(
      OUTPUT "${grpc_OUTPUT_DIR}/${RELFIL_WE}.grpc.pb.cc"
             "${grpc_OUTPUT_DIR}/${RELFIL_WE}.grpc.pb.h"
             "${grpc_OUTPUT_DIR}/${RELFIL_WE}_mock.grpc.pb.h"
             "${grpc_OUTPUT_DIR}/${RELFIL_WE}.pb.cc"
             "${grpc_OUTPUT_DIR}/${RELFIL_WE}.pb.h"
      COMMAND ${Python3_EXECUTABLE} ${exe} ${_gRPC_PROTOBUF_PROTOC_EXECUTABLE}
      ARGS --grpc_out=generate_mock_code=true:${grpc_OUTPUT_DIR}
           --cpp_out=${grpc_OUTPUT_DIR}
           --plugin=protoc-gen-grpc=${_gRPC_CPP_PLUGIN_EXECUTABLE}
           ${GRPC_INCLUDES}
           ${REL_FIL}
      DEPENDS ${ABS_FIL} ${_gRPC_PROTOBUF_PROTOC_EXECUTABLE} ${_gRPC_CPP_PLUGIN_EXECUTABLE}
      WORKING_DIRECTORY ${grpc_SOURCE_DIR}
      COMMENT "Running gRPC C++ protocol buffer compiler on ${FIL} (using ${exe})"
      VERBATIM)

      list(APPEND GRPC_PROTO_GEN "${grpc_OUTPUT_DIR}/${RELFIL_WE}.grpc.pb.cc")
      list(APPEND GRPC_PROTO_GEN "${grpc_OUTPUT_DIR}/${RELFIL_WE}.grpc.pb.h")
      list(APPEND GRPC_PROTO_GEN "${grpc_OUTPUT_DIR}/${RELFIL_WE}_mock.grpc.pb.h")
      list(APPEND GRPC_PROTO_GEN "${grpc_OUTPUT_DIR}/${RELFIL_WE}.pb.cc")
      list(APPEND GRPC_PROTO_GEN "${grpc_OUTPUT_DIR}/${RELFIL_WE}.pb.h")
      set_source_files_properties("${grpc_OUTPUT_DIR}/${RELFIL_WE}.grpc.pb.cc" "${grpc_OUTPUT_DIR}/${RELFIL_WE}.grpc.pb.h"  "${grpc_OUTPUT_DIR}/${RELFIL_WE}_mock.grpc.pb.h" "${grpc_OUTPUT_DIR}/${RELFIL_WE}.pb.cc" "${grpc_OUTPUT_DIR}/${RELFIL_WE}.pb.h" PROPERTIES GENERATED TRUE)
  endforeach()
  if (grpc_GENERATED)
    set(${grpc_GENERATED} "${GRPC_PROTO_GEN}" PARENT_SCOPE)
  endif()
endfunction()

protobuf_generate_grpc_cpp(
  SOURCE_DIR ${_gRPC_ROOT}
  INCLUDES ${_gRPC_ROOT}/src//proto/grpc/reflection/v1alpha
  SOURCES src/proto/grpc/reflection/v1alpha/reflection.proto
  OUTPUT_DIR ${_gRPC_PROTO_GENS_DIR}
  GENERATED REFLECTION_GRPC_SRC)

protobuf_generate_grpc_cpp(
  SOURCE_DIR ${_gRPC_ROOT}
  INCLUDES ${_gRPC_ROOT}/src//proto/grpc/reflection/v1
  SOURCES src/proto/grpc/reflection/v1/reflection.proto
  OUTPUT_DIR ${_gRPC_PROTO_GENS_DIR}
  GENERATED REFLECTION_V1_GRPC_SRC)



android_add_library(TARGET address_sorting
LICENSE Apache-2.0
URL "https://android.googlesource.com/platform/external/grpc-grpc/+/refs/heads/emu-master-dev"
REPO "${ANDROID_QEMU2_TOP_DIR}/../grpc"
NOTICE "REPO/NOTICE.txt"

SRC # cmake-format: sortable
  ${_gRPC_ROOT}/third_party/address_sorting/address_sorting.c
  ${_gRPC_ROOT}/third_party/address_sorting/address_sorting_posix.c
  ${_gRPC_ROOT}/third_party/address_sorting/address_sorting_windows.c
)



target_include_directories(address_sorting
  PUBLIC  ${_gRPC_ROOT}/include
  PRIVATE
    ${_gRPC_ROOT}
    ${_gRPC_ADDRESS_SORTING_INCLUDE_DIR}
    ${_gRPC_RE2_INCLUDE_DIR}
    ${_gRPC_SSL_INCLUDE_DIR}
    ${_gRPC_UPB_GENERATED_DIR}
    ${_gRPC_UPB_GRPC_GENERATED_DIR}
    ${_gRPC_UPB_INCLUDE_DIR}
    ${_gRPC_XXHASH_INCLUDE_DIR}
    ${_gRPC_ZLIB_INCLUDE_DIR}
)
target_link_libraries(address_sorting PUBLIC
  ${_gRPC_BASELIB_LIBRARIES}
  ${_gRPC_ALLTARGETS_LIBRARIES}
)



android_add_library(TARGET gpr
LICENSE Apache-2.0
URL "https://android.googlesource.com/platform/external/grpc-grpc/+/refs/heads/emu-master-dev"
REPO "${ANDROID_QEMU2_TOP_DIR}/../grpc"
NOTICE "REPO/NOTICE.txt"

SRC # cmake-format: sortable
  ${_gRPC_ROOT}/src/core/config/config_vars.cc
  ${_gRPC_ROOT}/src/core/config/config_vars_non_generated.cc
  ${_gRPC_ROOT}/src/core/config/load_config.cc
  ${_gRPC_ROOT}/src/core/lib/event_engine/thread_local.cc
  ${_gRPC_ROOT}/src/core/util/alloc.cc
  ${_gRPC_ROOT}/src/core/util/crash.cc
  ${_gRPC_ROOT}/src/core/util/examine_stack.cc
  ${_gRPC_ROOT}/src/core/util/fork.cc
  ${_gRPC_ROOT}/src/core/util/gpr_time.cc
  ${_gRPC_ROOT}/src/core/util/host_port.cc
  ${_gRPC_ROOT}/src/core/util/iphone/cpu.cc
  ${_gRPC_ROOT}/src/core/util/linux/cpu.cc
  ${_gRPC_ROOT}/src/core/util/linux/env.cc
  ${_gRPC_ROOT}/src/core/util/log.cc
  ${_gRPC_ROOT}/src/core/util/mpscq.cc
  ${_gRPC_ROOT}/src/core/util/msys/tmpfile.cc
  ${_gRPC_ROOT}/src/core/util/posix/cpu.cc
  ${_gRPC_ROOT}/src/core/util/posix/env.cc
  ${_gRPC_ROOT}/src/core/util/posix/stat.cc
  ${_gRPC_ROOT}/src/core/util/posix/string.cc
  ${_gRPC_ROOT}/src/core/util/posix/sync.cc
  ${_gRPC_ROOT}/src/core/util/posix/thd.cc
  ${_gRPC_ROOT}/src/core/util/posix/time.cc
  ${_gRPC_ROOT}/src/core/util/posix/tmpfile.cc
  ${_gRPC_ROOT}/src/core/util/strerror.cc
  ${_gRPC_ROOT}/src/core/util/string.cc
  ${_gRPC_ROOT}/src/core/util/sync.cc
  ${_gRPC_ROOT}/src/core/util/sync_abseil.cc
  ${_gRPC_ROOT}/src/core/util/tchar.cc
  ${_gRPC_ROOT}/src/core/util/time_precise.cc
  ${_gRPC_ROOT}/src/core/util/time_util.cc
  ${_gRPC_ROOT}/src/core/util/windows/cpu.cc
  ${_gRPC_ROOT}/src/core/util/windows/env.cc
  ${_gRPC_ROOT}/src/core/util/windows/stat.cc
  ${_gRPC_ROOT}/src/core/util/windows/string.cc
  ${_gRPC_ROOT}/src/core/util/windows/string_util.cc
  ${_gRPC_ROOT}/src/core/util/windows/sync.cc
  ${_gRPC_ROOT}/src/core/util/windows/thd.cc
  ${_gRPC_ROOT}/src/core/util/windows/time.cc
  ${_gRPC_ROOT}/src/core/util/windows/tmpfile.cc
)



target_include_directories(gpr
  PUBLIC  ${_gRPC_ROOT}/include
  PRIVATE
    ${_gRPC_ROOT}
    ${_gRPC_ADDRESS_SORTING_INCLUDE_DIR}
    ${_gRPC_RE2_INCLUDE_DIR}
    ${_gRPC_SSL_INCLUDE_DIR}
    ${_gRPC_UPB_GENERATED_DIR}
    ${_gRPC_UPB_GRPC_GENERATED_DIR}
    ${_gRPC_UPB_INCLUDE_DIR}
    ${_gRPC_XXHASH_INCLUDE_DIR}
    ${_gRPC_ZLIB_INCLUDE_DIR}
)
target_link_libraries(gpr PUBLIC
  ${_gRPC_ALLTARGETS_LIBRARIES}
  absl::base
  absl::config
  absl::core_headers
  absl::log_severity
  absl::cleanup
  absl::flags
  absl::flags_marshalling
  absl::any_invocable
  absl::bind_front
  absl::check
  absl::log_globals
  absl::log
  absl::memory
  absl::bits
  absl::random_random
  absl::status
  absl::cord
  absl::str_format
  absl::strings
  absl::synchronization
  absl::time
  absl::optional
)



android_add_library(TARGET grpc
LICENSE Apache-2.0
URL "https://android.googlesource.com/platform/external/grpc-grpc/+/refs/heads/emu-master-dev"
REPO "${ANDROID_QEMU2_TOP_DIR}/../grpc"
NOTICE "REPO/NOTICE.txt"

SRC # cmake-format: sortable
  ${_gRPC_ROOT}/src/core/call/call_arena_allocator.cc
  ${_gRPC_ROOT}/src/core/call/call_filters.cc
  ${_gRPC_ROOT}/src/core/call/call_spine.cc
  ${_gRPC_ROOT}/src/core/call/call_state.cc
  ${_gRPC_ROOT}/src/core/call/client_call.cc
  ${_gRPC_ROOT}/src/core/call/interception_chain.cc
  ${_gRPC_ROOT}/src/core/call/message.cc
  ${_gRPC_ROOT}/src/core/call/metadata.cc
  ${_gRPC_ROOT}/src/core/call/metadata_batch.cc
  ${_gRPC_ROOT}/src/core/call/metadata_info.cc
  ${_gRPC_ROOT}/src/core/call/parsed_metadata.cc
  ${_gRPC_ROOT}/src/core/call/request_buffer.cc
  ${_gRPC_ROOT}/src/core/call/security_context.cc
  ${_gRPC_ROOT}/src/core/call/server_call.cc
  ${_gRPC_ROOT}/src/core/call/status_util.cc
  ${_gRPC_ROOT}/src/core/channelz/channel_trace.cc
  ${_gRPC_ROOT}/src/core/channelz/channelz.cc
  ${_gRPC_ROOT}/src/core/channelz/channelz_registry.cc
  ${_gRPC_ROOT}/src/core/channelz/property_list.cc
  ${_gRPC_ROOT}/src/core/channelz/text_encode.cc
  ${_gRPC_ROOT}/src/core/channelz/v2tov1/convert.cc
  ${_gRPC_ROOT}/src/core/channelz/v2tov1/legacy_api.cc
  ${_gRPC_ROOT}/src/core/channelz/v2tov1/property_list.cc
  ${_gRPC_ROOT}/src/core/client_channel/backup_poller.cc
  ${_gRPC_ROOT}/src/core/client_channel/buffered_call.cc
  ${_gRPC_ROOT}/src/core/client_channel/client_channel.cc
  ${_gRPC_ROOT}/src/core/client_channel/client_channel_factory.cc
  ${_gRPC_ROOT}/src/core/client_channel/client_channel_filter.cc
  ${_gRPC_ROOT}/src/core/client_channel/client_channel_plugin.cc
  ${_gRPC_ROOT}/src/core/client_channel/client_channel_service_config.cc
  ${_gRPC_ROOT}/src/core/client_channel/direct_channel.cc
  ${_gRPC_ROOT}/src/core/client_channel/dynamic_filters.cc
  ${_gRPC_ROOT}/src/core/client_channel/global_subchannel_pool.cc
  ${_gRPC_ROOT}/src/core/client_channel/lb_metadata.cc
  ${_gRPC_ROOT}/src/core/client_channel/load_balanced_call_destination.cc
  ${_gRPC_ROOT}/src/core/client_channel/local_subchannel_pool.cc
  ${_gRPC_ROOT}/src/core/client_channel/retry_filter.cc
  ${_gRPC_ROOT}/src/core/client_channel/retry_filter_legacy_call_data.cc
  ${_gRPC_ROOT}/src/core/client_channel/retry_interceptor.cc
  ${_gRPC_ROOT}/src/core/client_channel/retry_service_config.cc
  ${_gRPC_ROOT}/src/core/client_channel/retry_throttle.cc
  ${_gRPC_ROOT}/src/core/client_channel/subchannel.cc
  ${_gRPC_ROOT}/src/core/client_channel/subchannel_pool_interface.cc
  ${_gRPC_ROOT}/src/core/client_channel/subchannel_stream_client.cc
  ${_gRPC_ROOT}/src/core/client_channel/subchannel_stream_limiter.cc
  ${_gRPC_ROOT}/src/core/config/core_configuration.cc
  ${_gRPC_ROOT}/src/core/credentials/call/call_creds_registry_init.cc
  ${_gRPC_ROOT}/src/core/credentials/call/call_creds_util.cc
  ${_gRPC_ROOT}/src/core/credentials/call/composite/composite_call_credentials.cc
  ${_gRPC_ROOT}/src/core/credentials/call/external/aws_external_account_credentials.cc
  ${_gRPC_ROOT}/src/core/credentials/call/external/aws_request_signer.cc
  ${_gRPC_ROOT}/src/core/credentials/call/external/external_account_credentials.cc
  ${_gRPC_ROOT}/src/core/credentials/call/external/file_external_account_credentials.cc
  ${_gRPC_ROOT}/src/core/credentials/call/external/url_external_account_credentials.cc
  ${_gRPC_ROOT}/src/core/credentials/call/gcp_service_account_identity/gcp_service_account_identity_credentials.cc
  ${_gRPC_ROOT}/src/core/credentials/call/iam/iam_credentials.cc
  ${_gRPC_ROOT}/src/core/credentials/call/json_util.cc
  ${_gRPC_ROOT}/src/core/credentials/call/jwt/json_token.cc
  ${_gRPC_ROOT}/src/core/credentials/call/jwt/jwt_credentials.cc
  ${_gRPC_ROOT}/src/core/credentials/call/jwt/jwt_verifier.cc
  ${_gRPC_ROOT}/src/core/credentials/call/jwt_token_file/jwt_token_file_call_credentials.cc
  ${_gRPC_ROOT}/src/core/credentials/call/jwt_util.cc
  ${_gRPC_ROOT}/src/core/credentials/call/oauth2/oauth2_credentials.cc
  ${_gRPC_ROOT}/src/core/credentials/call/plugin/plugin_credentials.cc
  ${_gRPC_ROOT}/src/core/credentials/call/regional_access_boundary_fetcher.cc
  ${_gRPC_ROOT}/src/core/credentials/call/token_fetcher/token_fetcher_credentials.cc
  ${_gRPC_ROOT}/src/core/credentials/transport/alts/alts_credentials.cc
  ${_gRPC_ROOT}/src/core/credentials/transport/alts/alts_security_connector.cc
  ${_gRPC_ROOT}/src/core/credentials/transport/alts/check_gcp_environment.cc
  ${_gRPC_ROOT}/src/core/credentials/transport/alts/check_gcp_environment_linux.cc
  ${_gRPC_ROOT}/src/core/credentials/transport/alts/check_gcp_environment_no_op.cc
  ${_gRPC_ROOT}/src/core/credentials/transport/alts/check_gcp_environment_windows.cc
  ${_gRPC_ROOT}/src/core/credentials/transport/alts/grpc_alts_credentials_client_options.cc
  ${_gRPC_ROOT}/src/core/credentials/transport/alts/grpc_alts_credentials_options.cc
  ${_gRPC_ROOT}/src/core/credentials/transport/alts/grpc_alts_credentials_server_options.cc
  ${_gRPC_ROOT}/src/core/credentials/transport/channel_creds_registry_init.cc
  ${_gRPC_ROOT}/src/core/credentials/transport/composite/composite_channel_credentials.cc
  ${_gRPC_ROOT}/src/core/credentials/transport/fake/fake_credentials.cc
  ${_gRPC_ROOT}/src/core/credentials/transport/fake/fake_security_connector.cc
  ${_gRPC_ROOT}/src/core/credentials/transport/google_default/credentials_generic.cc
  ${_gRPC_ROOT}/src/core/credentials/transport/google_default/google_default_credentials.cc
  ${_gRPC_ROOT}/src/core/credentials/transport/insecure/insecure_credentials.cc
  ${_gRPC_ROOT}/src/core/credentials/transport/insecure/insecure_security_connector.cc
  ${_gRPC_ROOT}/src/core/credentials/transport/local/local_credentials.cc
  ${_gRPC_ROOT}/src/core/credentials/transport/local/local_security_connector.cc
  ${_gRPC_ROOT}/src/core/credentials/transport/security_connector.cc
  ${_gRPC_ROOT}/src/core/credentials/transport/ssl/ssl_credentials.cc
  ${_gRPC_ROOT}/src/core/credentials/transport/ssl/ssl_security_connector.cc
  ${_gRPC_ROOT}/src/core/credentials/transport/tls/certificate_provider_registry.cc
  ${_gRPC_ROOT}/src/core/credentials/transport/tls/grpc_tls_certificate_distributor.cc
  ${_gRPC_ROOT}/src/core/credentials/transport/tls/grpc_tls_certificate_match.cc
  ${_gRPC_ROOT}/src/core/credentials/transport/tls/grpc_tls_certificate_provider.cc
  ${_gRPC_ROOT}/src/core/credentials/transport/tls/grpc_tls_certificate_verifier.cc
  ${_gRPC_ROOT}/src/core/credentials/transport/tls/grpc_tls_credentials_options.cc
  ${_gRPC_ROOT}/src/core/credentials/transport/tls/grpc_tls_crl_provider.cc
  ${_gRPC_ROOT}/src/core/credentials/transport/tls/load_system_roots_fallback.cc
  ${_gRPC_ROOT}/src/core/credentials/transport/tls/load_system_roots_supported.cc
  ${_gRPC_ROOT}/src/core/credentials/transport/tls/load_system_roots_windows.cc
  ${_gRPC_ROOT}/src/core/credentials/transport/tls/spiffe_utils.cc
  ${_gRPC_ROOT}/src/core/credentials/transport/tls/ssl_utils.cc
  ${_gRPC_ROOT}/src/core/credentials/transport/tls/tls_credentials.cc
  ${_gRPC_ROOT}/src/core/credentials/transport/tls/tls_security_connector.cc
  ${_gRPC_ROOT}/src/core/credentials/transport/tls/tls_utils.cc
  ${_gRPC_ROOT}/src/core/credentials/transport/transport_credentials.cc
  ${_gRPC_ROOT}/src/core/credentials/transport/xds/xds_credentials.cc
  ${_gRPC_ROOT}/src/core/ext/filters/backend_metrics/backend_metric_filter.cc
  ${_gRPC_ROOT}/src/core/ext/filters/census/grpc_context.cc
  ${_gRPC_ROOT}/src/core/ext/filters/channel_idle/idle_filter_state.cc
  ${_gRPC_ROOT}/src/core/ext/filters/channel_idle/legacy_channel_idle_filter.cc
  ${_gRPC_ROOT}/src/core/ext/filters/fault_injection/fault_injection_filter.cc
  ${_gRPC_ROOT}/src/core/ext/filters/gcp_authentication/gcp_authentication_filter.cc
  ${_gRPC_ROOT}/src/core/ext/filters/http/client/http_client_filter.cc
  ${_gRPC_ROOT}/src/core/ext/filters/http/client_authority_filter.cc
  ${_gRPC_ROOT}/src/core/ext/filters/http/http_filters_plugin.cc
  ${_gRPC_ROOT}/src/core/ext/filters/http/message_compress/compression_filter.cc
  ${_gRPC_ROOT}/src/core/ext/filters/http/server/http_server_filter.cc
  ${_gRPC_ROOT}/src/core/ext/filters/message_size/message_size_filter.cc
  ${_gRPC_ROOT}/src/core/ext/filters/rbac/rbac_filter.cc
  ${_gRPC_ROOT}/src/core/ext/filters/rbac/rbac_service_config_parser.cc
  ${_gRPC_ROOT}/src/core/ext/filters/stateful_session/stateful_session_filter.cc
  ${_gRPC_ROOT}/src/core/ext/transport/chttp2/alpn/alpn.cc
  ${_gRPC_ROOT}/src/core/ext/transport/chttp2/chttp2_plugin.cc
  ${_gRPC_ROOT}/src/core/ext/transport/chttp2/client/chttp2_connector.cc
  ${_gRPC_ROOT}/src/core/ext/transport/chttp2/server/chttp2_server.cc
  ${_gRPC_ROOT}/src/core/ext/transport/chttp2/transport/bin_decoder.cc
  ${_gRPC_ROOT}/src/core/ext/transport/chttp2/transport/bin_encoder.cc
  ${_gRPC_ROOT}/src/core/ext/transport/chttp2/transport/call_tracer_wrapper.cc
  ${_gRPC_ROOT}/src/core/ext/transport/chttp2/transport/chttp2_transport.cc
  ${_gRPC_ROOT}/src/core/ext/transport/chttp2/transport/decode_huff.cc
  ${_gRPC_ROOT}/src/core/ext/transport/chttp2/transport/flow_control.cc
  ${_gRPC_ROOT}/src/core/ext/transport/chttp2/transport/frame.cc
  ${_gRPC_ROOT}/src/core/ext/transport/chttp2/transport/frame_data.cc
  ${_gRPC_ROOT}/src/core/ext/transport/chttp2/transport/frame_goaway.cc
  ${_gRPC_ROOT}/src/core/ext/transport/chttp2/transport/frame_ping.cc
  ${_gRPC_ROOT}/src/core/ext/transport/chttp2/transport/frame_rst_stream.cc
  ${_gRPC_ROOT}/src/core/ext/transport/chttp2/transport/frame_security.cc
  ${_gRPC_ROOT}/src/core/ext/transport/chttp2/transport/frame_settings.cc
  ${_gRPC_ROOT}/src/core/ext/transport/chttp2/transport/frame_window_update.cc
  ${_gRPC_ROOT}/src/core/ext/transport/chttp2/transport/goaway.cc
  ${_gRPC_ROOT}/src/core/ext/transport/chttp2/transport/hpack_encoder.cc
  ${_gRPC_ROOT}/src/core/ext/transport/chttp2/transport/hpack_encoder_table.cc
  ${_gRPC_ROOT}/src/core/ext/transport/chttp2/transport/hpack_parse_result.cc
  ${_gRPC_ROOT}/src/core/ext/transport/chttp2/transport/hpack_parser.cc
  ${_gRPC_ROOT}/src/core/ext/transport/chttp2/transport/hpack_parser_table.cc
  ${_gRPC_ROOT}/src/core/ext/transport/chttp2/transport/http2_client_transport.cc
  ${_gRPC_ROOT}/src/core/ext/transport/chttp2/transport/http2_server_transport.cc
  ${_gRPC_ROOT}/src/core/ext/transport/chttp2/transport/http2_settings.cc
  ${_gRPC_ROOT}/src/core/ext/transport/chttp2/transport/http2_settings_manager.cc
  ${_gRPC_ROOT}/src/core/ext/transport/chttp2/transport/http2_stats_collector.cc
  ${_gRPC_ROOT}/src/core/ext/transport/chttp2/transport/http2_transport.cc
  ${_gRPC_ROOT}/src/core/ext/transport/chttp2/transport/huffsyms.cc
  ${_gRPC_ROOT}/src/core/ext/transport/chttp2/transport/keepalive.cc
  ${_gRPC_ROOT}/src/core/ext/transport/chttp2/transport/parsing.cc
  ${_gRPC_ROOT}/src/core/ext/transport/chttp2/transport/ping_abuse_policy.cc
  ${_gRPC_ROOT}/src/core/ext/transport/chttp2/transport/ping_callbacks.cc
  ${_gRPC_ROOT}/src/core/ext/transport/chttp2/transport/ping_promise.cc
  ${_gRPC_ROOT}/src/core/ext/transport/chttp2/transport/ping_rate_policy.cc
  ${_gRPC_ROOT}/src/core/ext/transport/chttp2/transport/stream_lists.cc
  ${_gRPC_ROOT}/src/core/ext/transport/chttp2/transport/transport_common.cc
  ${_gRPC_ROOT}/src/core/ext/transport/chttp2/transport/varint.cc
  ${_gRPC_ROOT}/src/core/ext/transport/chttp2/transport/write_cycle.cc
  ${_gRPC_ROOT}/src/core/ext/transport/chttp2/transport/write_size_policy.cc
  ${_gRPC_ROOT}/src/core/ext/transport/chttp2/transport/writing.cc
  ${_gRPC_ROOT}/src/core/ext/transport/inproc/inproc_transport.cc
  ${_gRPC_ROOT}/src/core/ext/transport/inproc/legacy_inproc_transport.cc
  ${_gRPC_ROOT}/src/core/ext/upb-gen/cel/expr/checked.upb_minitable.c
  ${_gRPC_ROOT}/src/core/ext/upb-gen/cel/expr/syntax.upb_minitable.c
  ${_gRPC_ROOT}/src/core/ext/upb-gen/envoy/admin/v3/certs.upb_minitable.c
  ${_gRPC_ROOT}/src/core/ext/upb-gen/envoy/admin/v3/clusters.upb_minitable.c
  ${_gRPC_ROOT}/src/core/ext/upb-gen/envoy/admin/v3/config_dump.upb_minitable.c
  ${_gRPC_ROOT}/src/core/ext/upb-gen/envoy/admin/v3/config_dump_shared.upb_minitable.c
  ${_gRPC_ROOT}/src/core/ext/upb-gen/envoy/admin/v3/init_dump.upb_minitable.c
  ${_gRPC_ROOT}/src/core/ext/upb-gen/envoy/admin/v3/listeners.upb_minitable.c
  ${_gRPC_ROOT}/src/core/ext/upb-gen/envoy/admin/v3/memory.upb_minitable.c
  ${_gRPC_ROOT}/src/core/ext/upb-gen/envoy/admin/v3/metrics.upb_minitable.c
  ${_gRPC_ROOT}/src/core/ext/upb-gen/envoy/admin/v3/mutex_stats.upb_minitable.c
  ${_gRPC_ROOT}/src/core/ext/upb-gen/envoy/admin/v3/server_info.upb_minitable.c
  ${_gRPC_ROOT}/src/core/ext/upb-gen/envoy/admin/v3/tap.upb_minitable.c
  ${_gRPC_ROOT}/src/core/ext/upb-gen/envoy/annotations/deprecation.upb_minitable.c
  ${_gRPC_ROOT}/src/core/ext/upb-gen/envoy/annotations/resource.upb_minitable.c
  ${_gRPC_ROOT}/src/core/ext/upb-gen/envoy/config/accesslog/v3/accesslog.upb_minitable.c
  ${_gRPC_ROOT}/src/core/ext/upb-gen/envoy/config/bootstrap/v3/bootstrap.upb_minitable.c
  ${_gRPC_ROOT}/src/core/ext/upb-gen/envoy/config/cluster/v3/circuit_breaker.upb_minitable.c
  ${_gRPC_ROOT}/src/core/ext/upb-gen/envoy/config/cluster/v3/cluster.upb_minitable.c
  ${_gRPC_ROOT}/src/core/ext/upb-gen/envoy/config/cluster/v3/filter.upb_minitable.c
  ${_gRPC_ROOT}/src/core/ext/upb-gen/envoy/config/cluster/v3/outlier_detection.upb_minitable.c
  ${_gRPC_ROOT}/src/core/ext/upb-gen/envoy/config/common/matcher/v3/matcher.upb_minitable.c
  ${_gRPC_ROOT}/src/core/ext/upb-gen/envoy/config/common/mutation_rules/v3/mutation_rules.upb_minitable.c
  ${_gRPC_ROOT}/src/core/ext/upb-gen/envoy/config/core/v3/address.upb_minitable.c
  ${_gRPC_ROOT}/src/core/ext/upb-gen/envoy/config/core/v3/backoff.upb_minitable.c
  ${_gRPC_ROOT}/src/core/ext/upb-gen/envoy/config/core/v3/base.upb_minitable.c
  ${_gRPC_ROOT}/src/core/ext/upb-gen/envoy/config/core/v3/cel.upb_minitable.c
  ${_gRPC_ROOT}/src/core/ext/upb-gen/envoy/config/core/v3/config_source.upb_minitable.c
  ${_gRPC_ROOT}/src/core/ext/upb-gen/envoy/config/core/v3/event_service_config.upb_minitable.c
  ${_gRPC_ROOT}/src/core/ext/upb-gen/envoy/config/core/v3/extension.upb_minitable.c
  ${_gRPC_ROOT}/src/core/ext/upb-gen/envoy/config/core/v3/grpc_method_list.upb_minitable.c
  ${_gRPC_ROOT}/src/core/ext/upb-gen/envoy/config/core/v3/grpc_service.upb_minitable.c
  ${_gRPC_ROOT}/src/core/ext/upb-gen/envoy/config/core/v3/health_check.upb_minitable.c
  ${_gRPC_ROOT}/src/core/ext/upb-gen/envoy/config/core/v3/http_service.upb_minitable.c
  ${_gRPC_ROOT}/src/core/ext/upb-gen/envoy/config/core/v3/http_uri.upb_minitable.c
  ${_gRPC_ROOT}/src/core/ext/upb-gen/envoy/config/core/v3/protocol.upb_minitable.c
  ${_gRPC_ROOT}/src/core/ext/upb-gen/envoy/config/core/v3/proxy_protocol.upb_minitable.c
  ${_gRPC_ROOT}/src/core/ext/upb-gen/envoy/config/core/v3/resolver.upb_minitable.c
  ${_gRPC_ROOT}/src/core/ext/upb-gen/envoy/config/core/v3/socket_cmsg_headers.upb_minitable.c
  ${_gRPC_ROOT}/src/core/ext/upb-gen/envoy/config/core/v3/socket_option.upb_minitable.c
  ${_gRPC_ROOT}/src/core/ext/upb-gen/envoy/config/core/v3/substitution_format_string.upb_minitable.c
  ${_gRPC_ROOT}/src/core/ext/upb-gen/envoy/config/core/v3/udp_socket_config.upb_minitable.c
  ${_gRPC_ROOT}/src/core/ext/upb-gen/envoy/config/endpoint/v3/endpoint.upb_minitable.c
  ${_gRPC_ROOT}/src/core/ext/upb-gen/envoy/config/endpoint/v3/endpoint_components.upb_minitable.c
  ${_gRPC_ROOT}/src/core/ext/upb-gen/envoy/config/endpoint/v3/load_report.upb_minitable.c
  ${_gRPC_ROOT}/src/core/ext/upb-gen/envoy/config/listener/v3/api_listener.upb_minitable.c
  ${_gRPC_ROOT}/src/core/ext/upb-gen/envoy/config/listener/v3/listener.upb_minitable.c
  ${_gRPC_ROOT}/src/core/ext/upb-gen/envoy/config/listener/v3/listener_components.upb_minitable.c
  ${_gRPC_ROOT}/src/core/ext/upb-gen/envoy/config/listener/v3/quic_config.upb_minitable.c
  ${_gRPC_ROOT}/src/core/ext/upb-gen/envoy/config/listener/v3/udp_listener_config.upb_minitable.c
  ${_gRPC_ROOT}/src/core/ext/upb-gen/envoy/config/metrics/v3/metrics_service.upb_minitable.c
  ${_gRPC_ROOT}/src/core/ext/upb-gen/envoy/config/metrics/v3/stats.upb_minitable.c
  ${_gRPC_ROOT}/src/core/ext/upb-gen/envoy/config/overload/v3/overload.upb_minitable.c
  ${_gRPC_ROOT}/src/core/ext/upb-gen/envoy/config/rbac/v3/rbac.upb_minitable.c
  ${_gRPC_ROOT}/src/core/ext/upb-gen/envoy/config/route/v3/route.upb_minitable.c
  ${_gRPC_ROOT}/src/core/ext/upb-gen/envoy/config/route/v3/route_components.upb_minitable.c
  ${_gRPC_ROOT}/src/core/ext/upb-gen/envoy/config/route/v3/scoped_route.upb_minitable.c
  ${_gRPC_ROOT}/src/core/ext/upb-gen/envoy/config/tap/v3/common.upb_minitable.c
  ${_gRPC_ROOT}/src/core/ext/upb-gen/envoy/config/trace/v3/datadog.upb_minitable.c
  ${_gRPC_ROOT}/src/core/ext/upb-gen/envoy/config/trace/v3/dynamic_ot.upb_minitable.c
  ${_gRPC_ROOT}/src/core/ext/upb-gen/envoy/config/trace/v3/http_tracer.upb_minitable.c
  ${_gRPC_ROOT}/src/core/ext/upb-gen/envoy/config/trace/v3/lightstep.upb_minitable.c
  ${_gRPC_ROOT}/src/core/ext/upb-gen/envoy/config/trace/v3/opentelemetry.upb_minitable.c
  ${_gRPC_ROOT}/src/core/ext/upb-gen/envoy/config/trace/v3/service.upb_minitable.c
  ${_gRPC_ROOT}/src/core/ext/upb-gen/envoy/config/trace/v3/skywalking.upb_minitable.c
  ${_gRPC_ROOT}/src/core/ext/upb-gen/envoy/config/trace/v3/trace.upb_minitable.c
  ${_gRPC_ROOT}/src/core/ext/upb-gen/envoy/config/trace/v3/xray.upb_minitable.c
  ${_gRPC_ROOT}/src/core/ext/upb-gen/envoy/config/trace/v3/zipkin.upb_minitable.c
  ${_gRPC_ROOT}/src/core/ext/upb-gen/envoy/data/accesslog/v3/accesslog.upb_minitable.c
  ${_gRPC_ROOT}/src/core/ext/upb-gen/envoy/extensions/clusters/aggregate/v3/cluster.upb_minitable.c
  ${_gRPC_ROOT}/src/core/ext/upb-gen/envoy/extensions/common/matching/v3/extension_matcher.upb_minitable.c
  ${_gRPC_ROOT}/src/core/ext/upb-gen/envoy/extensions/filters/common/fault/v3/fault.upb_minitable.c
  ${_gRPC_ROOT}/src/core/ext/upb-gen/envoy/extensions/filters/common/matcher/action/v3/skip_action.upb_minitable.c
  ${_gRPC_ROOT}/src/core/ext/upb-gen/envoy/extensions/filters/http/composite/v3/composite.upb_minitable.c
  ${_gRPC_ROOT}/src/core/ext/upb-gen/envoy/extensions/filters/http/fault/v3/fault.upb_minitable.c
  ${_gRPC_ROOT}/src/core/ext/upb-gen/envoy/extensions/filters/http/gcp_authn/v3/gcp_authn.upb_minitable.c
  ${_gRPC_ROOT}/src/core/ext/upb-gen/envoy/extensions/filters/http/rbac/v3/rbac.upb_minitable.c
  ${_gRPC_ROOT}/src/core/ext/upb-gen/envoy/extensions/filters/http/router/v3/router.upb_minitable.c
  ${_gRPC_ROOT}/src/core/ext/upb-gen/envoy/extensions/filters/http/stateful_session/v3/stateful_session.upb_minitable.c
  ${_gRPC_ROOT}/src/core/ext/upb-gen/envoy/extensions/filters/network/http_connection_manager/v3/http_connection_manager.upb_minitable.c
  ${_gRPC_ROOT}/src/core/ext/upb-gen/envoy/extensions/grpc_service/call_credentials/access_token/v3/access_token_credentials.upb_minitable.c
  ${_gRPC_ROOT}/src/core/ext/upb-gen/envoy/extensions/grpc_service/channel_credentials/tls/v3/tls_credentials.upb_minitable.c
  ${_gRPC_ROOT}/src/core/ext/upb-gen/envoy/extensions/grpc_service/channel_credentials/xds/v3/xds_credentials.upb_minitable.c
  ${_gRPC_ROOT}/src/core/ext/upb-gen/envoy/extensions/http/stateful_session/cookie/v3/cookie.upb_minitable.c
  ${_gRPC_ROOT}/src/core/ext/upb-gen/envoy/extensions/load_balancing_policies/client_side_weighted_round_robin/v3/client_side_weighted_round_robin.upb_minitable.c
  ${_gRPC_ROOT}/src/core/ext/upb-gen/envoy/extensions/load_balancing_policies/common/v3/common.upb_minitable.c
  ${_gRPC_ROOT}/src/core/ext/upb-gen/envoy/extensions/load_balancing_policies/pick_first/v3/pick_first.upb_minitable.c
  ${_gRPC_ROOT}/src/core/ext/upb-gen/envoy/extensions/load_balancing_policies/ring_hash/v3/ring_hash.upb_minitable.c
  ${_gRPC_ROOT}/src/core/ext/upb-gen/envoy/extensions/load_balancing_policies/wrr_locality/v3/wrr_locality.upb_minitable.c
  ${_gRPC_ROOT}/src/core/ext/upb-gen/envoy/extensions/transport_sockets/http_11_proxy/v3/upstream_http_11_connect.upb_minitable.c
  ${_gRPC_ROOT}/src/core/ext/upb-gen/envoy/extensions/transport_sockets/tls/v3/cert.upb_minitable.c
  ${_gRPC_ROOT}/src/core/ext/upb-gen/envoy/extensions/transport_sockets/tls/v3/common.upb_minitable.c
  ${_gRPC_ROOT}/src/core/ext/upb-gen/envoy/extensions/transport_sockets/tls/v3/secret.upb_minitable.c
  ${_gRPC_ROOT}/src/core/ext/upb-gen/envoy/extensions/transport_sockets/tls/v3/tls.upb_minitable.c
  ${_gRPC_ROOT}/src/core/ext/upb-gen/envoy/extensions/transport_sockets/tls/v3/tls_spiffe_validator_config.upb_minitable.c
  ${_gRPC_ROOT}/src/core/ext/upb-gen/envoy/extensions/upstreams/http/v3/http_protocol_options.upb_minitable.c
  ${_gRPC_ROOT}/src/core/ext/upb-gen/envoy/service/discovery/v3/ads.upb_minitable.c
  ${_gRPC_ROOT}/src/core/ext/upb-gen/envoy/service/discovery/v3/discovery.upb_minitable.c
  ${_gRPC_ROOT}/src/core/ext/upb-gen/envoy/service/load_stats/v3/lrs.upb_minitable.c
  ${_gRPC_ROOT}/src/core/ext/upb-gen/envoy/service/status/v3/csds.upb_minitable.c
  ${_gRPC_ROOT}/src/core/ext/upb-gen/envoy/type/http/v3/cookie.upb_minitable.c
  ${_gRPC_ROOT}/src/core/ext/upb-gen/envoy/type/http/v3/path_transformation.upb_minitable.c
  ${_gRPC_ROOT}/src/core/ext/upb-gen/envoy/type/matcher/v3/address.upb_minitable.c
  ${_gRPC_ROOT}/src/core/ext/upb-gen/envoy/type/matcher/v3/filter_state.upb_minitable.c
  ${_gRPC_ROOT}/src/core/ext/upb-gen/envoy/type/matcher/v3/http_inputs.upb_minitable.c
  ${_gRPC_ROOT}/src/core/ext/upb-gen/envoy/type/matcher/v3/metadata.upb_minitable.c
  ${_gRPC_ROOT}/src/core/ext/upb-gen/envoy/type/matcher/v3/node.upb_minitable.c
  ${_gRPC_ROOT}/src/core/ext/upb-gen/envoy/type/matcher/v3/number.upb_minitable.c
  ${_gRPC_ROOT}/src/core/ext/upb-gen/envoy/type/matcher/v3/path.upb_minitable.c
  ${_gRPC_ROOT}/src/core/ext/upb-gen/envoy/type/matcher/v3/regex.upb_minitable.c
  ${_gRPC_ROOT}/src/core/ext/upb-gen/envoy/type/matcher/v3/status_code_input.upb_minitable.c
  ${_gRPC_ROOT}/src/core/ext/upb-gen/envoy/type/matcher/v3/string.upb_minitable.c
  ${_gRPC_ROOT}/src/core/ext/upb-gen/envoy/type/matcher/v3/struct.upb_minitable.c
  ${_gRPC_ROOT}/src/core/ext/upb-gen/envoy/type/matcher/v3/value.upb_minitable.c
  ${_gRPC_ROOT}/src/core/ext/upb-gen/envoy/type/metadata/v3/metadata.upb_minitable.c
  ${_gRPC_ROOT}/src/core/ext/upb-gen/envoy/type/tracing/v3/custom_tag.upb_minitable.c
  ${_gRPC_ROOT}/src/core/ext/upb-gen/envoy/type/v3/hash_policy.upb_minitable.c
  ${_gRPC_ROOT}/src/core/ext/upb-gen/envoy/type/v3/http.upb_minitable.c
  ${_gRPC_ROOT}/src/core/ext/upb-gen/envoy/type/v3/http_status.upb_minitable.c
  ${_gRPC_ROOT}/src/core/ext/upb-gen/envoy/type/v3/percent.upb_minitable.c
  ${_gRPC_ROOT}/src/core/ext/upb-gen/envoy/type/v3/range.upb_minitable.c
  ${_gRPC_ROOT}/src/core/ext/upb-gen/envoy/type/v3/ratelimit_strategy.upb_minitable.c
  ${_gRPC_ROOT}/src/core/ext/upb-gen/envoy/type/v3/ratelimit_unit.upb_minitable.c
  ${_gRPC_ROOT}/src/core/ext/upb-gen/envoy/type/v3/semantic_version.upb_minitable.c
  ${_gRPC_ROOT}/src/core/ext/upb-gen/envoy/type/v3/token_bucket.upb_minitable.c
  ${_gRPC_ROOT}/src/core/ext/upb-gen/google/api/annotations.upb_minitable.c
  ${_gRPC_ROOT}/src/core/ext/upb-gen/google/api/expr/v1alpha1/checked.upb_minitable.c
  ${_gRPC_ROOT}/src/core/ext/upb-gen/google/api/expr/v1alpha1/syntax.upb_minitable.c
  ${_gRPC_ROOT}/src/core/ext/upb-gen/google/api/http.upb_minitable.c
  ${_gRPC_ROOT}/src/core/ext/upb-gen/google/api/httpbody.upb_minitable.c
  ${_gRPC_ROOT}/src/core/ext/upb-gen/google/protobuf/any.upb_minitable.c
  ${_gRPC_ROOT}/src/core/ext/upb-gen/google/protobuf/descriptor.upb_minitable.c
  ${_gRPC_ROOT}/src/core/ext/upb-gen/google/protobuf/duration.upb_minitable.c
  ${_gRPC_ROOT}/src/core/ext/upb-gen/google/protobuf/empty.upb_minitable.c
  ${_gRPC_ROOT}/src/core/ext/upb-gen/google/protobuf/struct.upb_minitable.c
  ${_gRPC_ROOT}/src/core/ext/upb-gen/google/protobuf/timestamp.upb_minitable.c
  ${_gRPC_ROOT}/src/core/ext/upb-gen/google/protobuf/wrappers.upb_minitable.c
  ${_gRPC_ROOT}/src/core/ext/upb-gen/google/rpc/status.upb_minitable.c
  ${_gRPC_ROOT}/src/core/ext/upb-gen/src/proto/grpc/channelz/channelz.upb_minitable.c
  ${_gRPC_ROOT}/src/core/ext/upb-gen/src/proto/grpc/channelz/v2/channelz.upb_minitable.c
  ${_gRPC_ROOT}/src/core/ext/upb-gen/src/proto/grpc/channelz/v2/promise.upb_minitable.c
  ${_gRPC_ROOT}/src/core/ext/upb-gen/src/proto/grpc/channelz/v2/property_list.upb_minitable.c
  ${_gRPC_ROOT}/src/core/ext/upb-gen/src/proto/grpc/channelz/v2/service.upb_minitable.c
  ${_gRPC_ROOT}/src/core/ext/upb-gen/src/proto/grpc/gcp/altscontext.upb_minitable.c
  ${_gRPC_ROOT}/src/core/ext/upb-gen/src/proto/grpc/gcp/handshaker.upb_minitable.c
  ${_gRPC_ROOT}/src/core/ext/upb-gen/src/proto/grpc/gcp/transport_security_common.upb_minitable.c
  ${_gRPC_ROOT}/src/core/ext/upb-gen/src/proto/grpc/health/v1/health.upb_minitable.c
  ${_gRPC_ROOT}/src/core/ext/upb-gen/src/proto/grpc/lb/v1/load_balancer.upb_minitable.c
  ${_gRPC_ROOT}/src/core/ext/upb-gen/src/proto/grpc/lookup/v1/rls.upb_minitable.c
  ${_gRPC_ROOT}/src/core/ext/upb-gen/src/proto/grpc/lookup/v1/rls_config.upb_minitable.c
  ${_gRPC_ROOT}/src/core/ext/upb-gen/udpa/annotations/migrate.upb_minitable.c
  ${_gRPC_ROOT}/src/core/ext/upb-gen/udpa/annotations/security.upb_minitable.c
  ${_gRPC_ROOT}/src/core/ext/upb-gen/udpa/annotations/sensitive.upb_minitable.c
  ${_gRPC_ROOT}/src/core/ext/upb-gen/udpa/annotations/status.upb_minitable.c
  ${_gRPC_ROOT}/src/core/ext/upb-gen/udpa/annotations/versioning.upb_minitable.c
  ${_gRPC_ROOT}/src/core/ext/upb-gen/validate/validate.upb_minitable.c
  ${_gRPC_ROOT}/src/core/ext/upb-gen/xds/annotations/v3/migrate.upb_minitable.c
  ${_gRPC_ROOT}/src/core/ext/upb-gen/xds/annotations/v3/security.upb_minitable.c
  ${_gRPC_ROOT}/src/core/ext/upb-gen/xds/annotations/v3/sensitive.upb_minitable.c
  ${_gRPC_ROOT}/src/core/ext/upb-gen/xds/annotations/v3/status.upb_minitable.c
  ${_gRPC_ROOT}/src/core/ext/upb-gen/xds/annotations/v3/versioning.upb_minitable.c
  ${_gRPC_ROOT}/src/core/ext/upb-gen/xds/core/v3/authority.upb_minitable.c
  ${_gRPC_ROOT}/src/core/ext/upb-gen/xds/core/v3/cidr.upb_minitable.c
  ${_gRPC_ROOT}/src/core/ext/upb-gen/xds/core/v3/collection_entry.upb_minitable.c
  ${_gRPC_ROOT}/src/core/ext/upb-gen/xds/core/v3/context_params.upb_minitable.c
  ${_gRPC_ROOT}/src/core/ext/upb-gen/xds/core/v3/extension.upb_minitable.c
  ${_gRPC_ROOT}/src/core/ext/upb-gen/xds/core/v3/resource.upb_minitable.c
  ${_gRPC_ROOT}/src/core/ext/upb-gen/xds/core/v3/resource_locator.upb_minitable.c
  ${_gRPC_ROOT}/src/core/ext/upb-gen/xds/core/v3/resource_name.upb_minitable.c
  ${_gRPC_ROOT}/src/core/ext/upb-gen/xds/data/orca/v3/orca_load_report.upb_minitable.c
  ${_gRPC_ROOT}/src/core/ext/upb-gen/xds/service/orca/v3/orca.upb_minitable.c
  ${_gRPC_ROOT}/src/core/ext/upb-gen/xds/type/matcher/v3/cel.upb_minitable.c
  ${_gRPC_ROOT}/src/core/ext/upb-gen/xds/type/matcher/v3/domain.upb_minitable.c
  ${_gRPC_ROOT}/src/core/ext/upb-gen/xds/type/matcher/v3/http_inputs.upb_minitable.c
  ${_gRPC_ROOT}/src/core/ext/upb-gen/xds/type/matcher/v3/ip.upb_minitable.c
  ${_gRPC_ROOT}/src/core/ext/upb-gen/xds/type/matcher/v3/matcher.upb_minitable.c
  ${_gRPC_ROOT}/src/core/ext/upb-gen/xds/type/matcher/v3/range.upb_minitable.c
  ${_gRPC_ROOT}/src/core/ext/upb-gen/xds/type/matcher/v3/regex.upb_minitable.c
  ${_gRPC_ROOT}/src/core/ext/upb-gen/xds/type/matcher/v3/string.upb_minitable.c
  ${_gRPC_ROOT}/src/core/ext/upb-gen/xds/type/v3/cel.upb_minitable.c
  ${_gRPC_ROOT}/src/core/ext/upb-gen/xds/type/v3/range.upb_minitable.c
  ${_gRPC_ROOT}/src/core/ext/upb-gen/xds/type/v3/typed_struct.upb_minitable.c
  ${_gRPC_ROOT}/src/core/ext/upbdefs-gen/cel/expr/checked.upbdefs.c
  ${_gRPC_ROOT}/src/core/ext/upbdefs-gen/cel/expr/syntax.upbdefs.c
  ${_gRPC_ROOT}/src/core/ext/upbdefs-gen/envoy/admin/v3/certs.upbdefs.c
  ${_gRPC_ROOT}/src/core/ext/upbdefs-gen/envoy/admin/v3/clusters.upbdefs.c
  ${_gRPC_ROOT}/src/core/ext/upbdefs-gen/envoy/admin/v3/config_dump.upbdefs.c
  ${_gRPC_ROOT}/src/core/ext/upbdefs-gen/envoy/admin/v3/config_dump_shared.upbdefs.c
  ${_gRPC_ROOT}/src/core/ext/upbdefs-gen/envoy/admin/v3/init_dump.upbdefs.c
  ${_gRPC_ROOT}/src/core/ext/upbdefs-gen/envoy/admin/v3/listeners.upbdefs.c
  ${_gRPC_ROOT}/src/core/ext/upbdefs-gen/envoy/admin/v3/memory.upbdefs.c
  ${_gRPC_ROOT}/src/core/ext/upbdefs-gen/envoy/admin/v3/metrics.upbdefs.c
  ${_gRPC_ROOT}/src/core/ext/upbdefs-gen/envoy/admin/v3/mutex_stats.upbdefs.c
  ${_gRPC_ROOT}/src/core/ext/upbdefs-gen/envoy/admin/v3/server_info.upbdefs.c
  ${_gRPC_ROOT}/src/core/ext/upbdefs-gen/envoy/admin/v3/tap.upbdefs.c
  ${_gRPC_ROOT}/src/core/ext/upbdefs-gen/envoy/annotations/deprecation.upbdefs.c
  ${_gRPC_ROOT}/src/core/ext/upbdefs-gen/envoy/annotations/resource.upbdefs.c
  ${_gRPC_ROOT}/src/core/ext/upbdefs-gen/envoy/config/accesslog/v3/accesslog.upbdefs.c
  ${_gRPC_ROOT}/src/core/ext/upbdefs-gen/envoy/config/bootstrap/v3/bootstrap.upbdefs.c
  ${_gRPC_ROOT}/src/core/ext/upbdefs-gen/envoy/config/cluster/v3/circuit_breaker.upbdefs.c
  ${_gRPC_ROOT}/src/core/ext/upbdefs-gen/envoy/config/cluster/v3/cluster.upbdefs.c
  ${_gRPC_ROOT}/src/core/ext/upbdefs-gen/envoy/config/cluster/v3/filter.upbdefs.c
  ${_gRPC_ROOT}/src/core/ext/upbdefs-gen/envoy/config/cluster/v3/outlier_detection.upbdefs.c
  ${_gRPC_ROOT}/src/core/ext/upbdefs-gen/envoy/config/common/matcher/v3/matcher.upbdefs.c
  ${_gRPC_ROOT}/src/core/ext/upbdefs-gen/envoy/config/common/mutation_rules/v3/mutation_rules.upbdefs.c
  ${_gRPC_ROOT}/src/core/ext/upbdefs-gen/envoy/config/core/v3/address.upbdefs.c
  ${_gRPC_ROOT}/src/core/ext/upbdefs-gen/envoy/config/core/v3/backoff.upbdefs.c
  ${_gRPC_ROOT}/src/core/ext/upbdefs-gen/envoy/config/core/v3/base.upbdefs.c
  ${_gRPC_ROOT}/src/core/ext/upbdefs-gen/envoy/config/core/v3/cel.upbdefs.c
  ${_gRPC_ROOT}/src/core/ext/upbdefs-gen/envoy/config/core/v3/config_source.upbdefs.c
  ${_gRPC_ROOT}/src/core/ext/upbdefs-gen/envoy/config/core/v3/event_service_config.upbdefs.c
  ${_gRPC_ROOT}/src/core/ext/upbdefs-gen/envoy/config/core/v3/extension.upbdefs.c
  ${_gRPC_ROOT}/src/core/ext/upbdefs-gen/envoy/config/core/v3/grpc_method_list.upbdefs.c
  ${_gRPC_ROOT}/src/core/ext/upbdefs-gen/envoy/config/core/v3/grpc_service.upbdefs.c
  ${_gRPC_ROOT}/src/core/ext/upbdefs-gen/envoy/config/core/v3/health_check.upbdefs.c
  ${_gRPC_ROOT}/src/core/ext/upbdefs-gen/envoy/config/core/v3/http_service.upbdefs.c
  ${_gRPC_ROOT}/src/core/ext/upbdefs-gen/envoy/config/core/v3/http_uri.upbdefs.c
  ${_gRPC_ROOT}/src/core/ext/upbdefs-gen/envoy/config/core/v3/protocol.upbdefs.c
  ${_gRPC_ROOT}/src/core/ext/upbdefs-gen/envoy/config/core/v3/proxy_protocol.upbdefs.c
  ${_gRPC_ROOT}/src/core/ext/upbdefs-gen/envoy/config/core/v3/resolver.upbdefs.c
  ${_gRPC_ROOT}/src/core/ext/upbdefs-gen/envoy/config/core/v3/socket_cmsg_headers.upbdefs.c
  ${_gRPC_ROOT}/src/core/ext/upbdefs-gen/envoy/config/core/v3/socket_option.upbdefs.c
  ${_gRPC_ROOT}/src/core/ext/upbdefs-gen/envoy/config/core/v3/substitution_format_string.upbdefs.c
  ${_gRPC_ROOT}/src/core/ext/upbdefs-gen/envoy/config/core/v3/udp_socket_config.upbdefs.c
  ${_gRPC_ROOT}/src/core/ext/upbdefs-gen/envoy/config/endpoint/v3/endpoint.upbdefs.c
  ${_gRPC_ROOT}/src/core/ext/upbdefs-gen/envoy/config/endpoint/v3/endpoint_components.upbdefs.c
  ${_gRPC_ROOT}/src/core/ext/upbdefs-gen/envoy/config/endpoint/v3/load_report.upbdefs.c
  ${_gRPC_ROOT}/src/core/ext/upbdefs-gen/envoy/config/listener/v3/api_listener.upbdefs.c
  ${_gRPC_ROOT}/src/core/ext/upbdefs-gen/envoy/config/listener/v3/listener.upbdefs.c
  ${_gRPC_ROOT}/src/core/ext/upbdefs-gen/envoy/config/listener/v3/listener_components.upbdefs.c
  ${_gRPC_ROOT}/src/core/ext/upbdefs-gen/envoy/config/listener/v3/quic_config.upbdefs.c
  ${_gRPC_ROOT}/src/core/ext/upbdefs-gen/envoy/config/listener/v3/udp_listener_config.upbdefs.c
  ${_gRPC_ROOT}/src/core/ext/upbdefs-gen/envoy/config/metrics/v3/metrics_service.upbdefs.c
  ${_gRPC_ROOT}/src/core/ext/upbdefs-gen/envoy/config/metrics/v3/stats.upbdefs.c
  ${_gRPC_ROOT}/src/core/ext/upbdefs-gen/envoy/config/overload/v3/overload.upbdefs.c
  ${_gRPC_ROOT}/src/core/ext/upbdefs-gen/envoy/config/rbac/v3/rbac.upbdefs.c
  ${_gRPC_ROOT}/src/core/ext/upbdefs-gen/envoy/config/route/v3/route.upbdefs.c
  ${_gRPC_ROOT}/src/core/ext/upbdefs-gen/envoy/config/route/v3/route_components.upbdefs.c
  ${_gRPC_ROOT}/src/core/ext/upbdefs-gen/envoy/config/route/v3/scoped_route.upbdefs.c
  ${_gRPC_ROOT}/src/core/ext/upbdefs-gen/envoy/config/tap/v3/common.upbdefs.c
  ${_gRPC_ROOT}/src/core/ext/upbdefs-gen/envoy/config/trace/v3/datadog.upbdefs.c
  ${_gRPC_ROOT}/src/core/ext/upbdefs-gen/envoy/config/trace/v3/dynamic_ot.upbdefs.c
  ${_gRPC_ROOT}/src/core/ext/upbdefs-gen/envoy/config/trace/v3/http_tracer.upbdefs.c
  ${_gRPC_ROOT}/src/core/ext/upbdefs-gen/envoy/config/trace/v3/lightstep.upbdefs.c
  ${_gRPC_ROOT}/src/core/ext/upbdefs-gen/envoy/config/trace/v3/opentelemetry.upbdefs.c
  ${_gRPC_ROOT}/src/core/ext/upbdefs-gen/envoy/config/trace/v3/service.upbdefs.c
  ${_gRPC_ROOT}/src/core/ext/upbdefs-gen/envoy/config/trace/v3/skywalking.upbdefs.c
  ${_gRPC_ROOT}/src/core/ext/upbdefs-gen/envoy/config/trace/v3/trace.upbdefs.c
  ${_gRPC_ROOT}/src/core/ext/upbdefs-gen/envoy/config/trace/v3/xray.upbdefs.c
  ${_gRPC_ROOT}/src/core/ext/upbdefs-gen/envoy/config/trace/v3/zipkin.upbdefs.c
  ${_gRPC_ROOT}/src/core/ext/upbdefs-gen/envoy/data/accesslog/v3/accesslog.upbdefs.c
  ${_gRPC_ROOT}/src/core/ext/upbdefs-gen/envoy/extensions/clusters/aggregate/v3/cluster.upbdefs.c
  ${_gRPC_ROOT}/src/core/ext/upbdefs-gen/envoy/extensions/common/matching/v3/extension_matcher.upbdefs.c
  ${_gRPC_ROOT}/src/core/ext/upbdefs-gen/envoy/extensions/filters/common/fault/v3/fault.upbdefs.c
  ${_gRPC_ROOT}/src/core/ext/upbdefs-gen/envoy/extensions/filters/common/matcher/action/v3/skip_action.upbdefs.c
  ${_gRPC_ROOT}/src/core/ext/upbdefs-gen/envoy/extensions/filters/http/composite/v3/composite.upbdefs.c
  ${_gRPC_ROOT}/src/core/ext/upbdefs-gen/envoy/extensions/filters/http/fault/v3/fault.upbdefs.c
  ${_gRPC_ROOT}/src/core/ext/upbdefs-gen/envoy/extensions/filters/http/gcp_authn/v3/gcp_authn.upbdefs.c
  ${_gRPC_ROOT}/src/core/ext/upbdefs-gen/envoy/extensions/filters/http/rbac/v3/rbac.upbdefs.c
  ${_gRPC_ROOT}/src/core/ext/upbdefs-gen/envoy/extensions/filters/http/router/v3/router.upbdefs.c
  ${_gRPC_ROOT}/src/core/ext/upbdefs-gen/envoy/extensions/filters/http/stateful_session/v3/stateful_session.upbdefs.c
  ${_gRPC_ROOT}/src/core/ext/upbdefs-gen/envoy/extensions/filters/network/http_connection_manager/v3/http_connection_manager.upbdefs.c
  ${_gRPC_ROOT}/src/core/ext/upbdefs-gen/envoy/extensions/http/stateful_session/cookie/v3/cookie.upbdefs.c
  ${_gRPC_ROOT}/src/core/ext/upbdefs-gen/envoy/extensions/transport_sockets/http_11_proxy/v3/upstream_http_11_connect.upbdefs.c
  ${_gRPC_ROOT}/src/core/ext/upbdefs-gen/envoy/extensions/transport_sockets/tls/v3/cert.upbdefs.c
  ${_gRPC_ROOT}/src/core/ext/upbdefs-gen/envoy/extensions/transport_sockets/tls/v3/common.upbdefs.c
  ${_gRPC_ROOT}/src/core/ext/upbdefs-gen/envoy/extensions/transport_sockets/tls/v3/secret.upbdefs.c
  ${_gRPC_ROOT}/src/core/ext/upbdefs-gen/envoy/extensions/transport_sockets/tls/v3/tls.upbdefs.c
  ${_gRPC_ROOT}/src/core/ext/upbdefs-gen/envoy/extensions/transport_sockets/tls/v3/tls_spiffe_validator_config.upbdefs.c
  ${_gRPC_ROOT}/src/core/ext/upbdefs-gen/envoy/extensions/upstreams/http/v3/http_protocol_options.upbdefs.c
  ${_gRPC_ROOT}/src/core/ext/upbdefs-gen/envoy/service/discovery/v3/ads.upbdefs.c
  ${_gRPC_ROOT}/src/core/ext/upbdefs-gen/envoy/service/discovery/v3/discovery.upbdefs.c
  ${_gRPC_ROOT}/src/core/ext/upbdefs-gen/envoy/service/load_stats/v3/lrs.upbdefs.c
  ${_gRPC_ROOT}/src/core/ext/upbdefs-gen/envoy/service/status/v3/csds.upbdefs.c
  ${_gRPC_ROOT}/src/core/ext/upbdefs-gen/envoy/type/http/v3/cookie.upbdefs.c
  ${_gRPC_ROOT}/src/core/ext/upbdefs-gen/envoy/type/http/v3/path_transformation.upbdefs.c
  ${_gRPC_ROOT}/src/core/ext/upbdefs-gen/envoy/type/matcher/v3/address.upbdefs.c
  ${_gRPC_ROOT}/src/core/ext/upbdefs-gen/envoy/type/matcher/v3/filter_state.upbdefs.c
  ${_gRPC_ROOT}/src/core/ext/upbdefs-gen/envoy/type/matcher/v3/http_inputs.upbdefs.c
  ${_gRPC_ROOT}/src/core/ext/upbdefs-gen/envoy/type/matcher/v3/metadata.upbdefs.c
  ${_gRPC_ROOT}/src/core/ext/upbdefs-gen/envoy/type/matcher/v3/node.upbdefs.c
  ${_gRPC_ROOT}/src/core/ext/upbdefs-gen/envoy/type/matcher/v3/number.upbdefs.c
  ${_gRPC_ROOT}/src/core/ext/upbdefs-gen/envoy/type/matcher/v3/path.upbdefs.c
  ${_gRPC_ROOT}/src/core/ext/upbdefs-gen/envoy/type/matcher/v3/regex.upbdefs.c
  ${_gRPC_ROOT}/src/core/ext/upbdefs-gen/envoy/type/matcher/v3/status_code_input.upbdefs.c
  ${_gRPC_ROOT}/src/core/ext/upbdefs-gen/envoy/type/matcher/v3/string.upbdefs.c
  ${_gRPC_ROOT}/src/core/ext/upbdefs-gen/envoy/type/matcher/v3/struct.upbdefs.c
  ${_gRPC_ROOT}/src/core/ext/upbdefs-gen/envoy/type/matcher/v3/value.upbdefs.c
  ${_gRPC_ROOT}/src/core/ext/upbdefs-gen/envoy/type/metadata/v3/metadata.upbdefs.c
  ${_gRPC_ROOT}/src/core/ext/upbdefs-gen/envoy/type/tracing/v3/custom_tag.upbdefs.c
  ${_gRPC_ROOT}/src/core/ext/upbdefs-gen/envoy/type/v3/hash_policy.upbdefs.c
  ${_gRPC_ROOT}/src/core/ext/upbdefs-gen/envoy/type/v3/http.upbdefs.c
  ${_gRPC_ROOT}/src/core/ext/upbdefs-gen/envoy/type/v3/http_status.upbdefs.c
  ${_gRPC_ROOT}/src/core/ext/upbdefs-gen/envoy/type/v3/percent.upbdefs.c
  ${_gRPC_ROOT}/src/core/ext/upbdefs-gen/envoy/type/v3/range.upbdefs.c
  ${_gRPC_ROOT}/src/core/ext/upbdefs-gen/envoy/type/v3/ratelimit_strategy.upbdefs.c
  ${_gRPC_ROOT}/src/core/ext/upbdefs-gen/envoy/type/v3/ratelimit_unit.upbdefs.c
  ${_gRPC_ROOT}/src/core/ext/upbdefs-gen/envoy/type/v3/semantic_version.upbdefs.c
  ${_gRPC_ROOT}/src/core/ext/upbdefs-gen/envoy/type/v3/token_bucket.upbdefs.c
  ${_gRPC_ROOT}/src/core/ext/upbdefs-gen/google/api/annotations.upbdefs.c
  ${_gRPC_ROOT}/src/core/ext/upbdefs-gen/google/api/expr/v1alpha1/checked.upbdefs.c
  ${_gRPC_ROOT}/src/core/ext/upbdefs-gen/google/api/expr/v1alpha1/syntax.upbdefs.c
  ${_gRPC_ROOT}/src/core/ext/upbdefs-gen/google/api/http.upbdefs.c
  ${_gRPC_ROOT}/src/core/ext/upbdefs-gen/google/api/httpbody.upbdefs.c
  ${_gRPC_ROOT}/src/core/ext/upbdefs-gen/google/protobuf/any.upbdefs.c
  ${_gRPC_ROOT}/src/core/ext/upbdefs-gen/google/protobuf/descriptor.upbdefs.c
  ${_gRPC_ROOT}/src/core/ext/upbdefs-gen/google/protobuf/duration.upbdefs.c
  ${_gRPC_ROOT}/src/core/ext/upbdefs-gen/google/protobuf/empty.upbdefs.c
  ${_gRPC_ROOT}/src/core/ext/upbdefs-gen/google/protobuf/struct.upbdefs.c
  ${_gRPC_ROOT}/src/core/ext/upbdefs-gen/google/protobuf/timestamp.upbdefs.c
  ${_gRPC_ROOT}/src/core/ext/upbdefs-gen/google/protobuf/wrappers.upbdefs.c
  ${_gRPC_ROOT}/src/core/ext/upbdefs-gen/google/rpc/status.upbdefs.c
  ${_gRPC_ROOT}/src/core/ext/upbdefs-gen/src/proto/grpc/channelz/channelz.upbdefs.c
  ${_gRPC_ROOT}/src/core/ext/upbdefs-gen/src/proto/grpc/channelz/v2/channelz.upbdefs.c
  ${_gRPC_ROOT}/src/core/ext/upbdefs-gen/src/proto/grpc/channelz/v2/promise.upbdefs.c
  ${_gRPC_ROOT}/src/core/ext/upbdefs-gen/src/proto/grpc/channelz/v2/property_list.upbdefs.c
  ${_gRPC_ROOT}/src/core/ext/upbdefs-gen/src/proto/grpc/channelz/v2/service.upbdefs.c
  ${_gRPC_ROOT}/src/core/ext/upbdefs-gen/src/proto/grpc/lookup/v1/rls_config.upbdefs.c
  ${_gRPC_ROOT}/src/core/ext/upbdefs-gen/udpa/annotations/migrate.upbdefs.c
  ${_gRPC_ROOT}/src/core/ext/upbdefs-gen/udpa/annotations/security.upbdefs.c
  ${_gRPC_ROOT}/src/core/ext/upbdefs-gen/udpa/annotations/sensitive.upbdefs.c
  ${_gRPC_ROOT}/src/core/ext/upbdefs-gen/udpa/annotations/status.upbdefs.c
  ${_gRPC_ROOT}/src/core/ext/upbdefs-gen/udpa/annotations/versioning.upbdefs.c
  ${_gRPC_ROOT}/src/core/ext/upbdefs-gen/validate/validate.upbdefs.c
  ${_gRPC_ROOT}/src/core/ext/upbdefs-gen/xds/annotations/v3/migrate.upbdefs.c
  ${_gRPC_ROOT}/src/core/ext/upbdefs-gen/xds/annotations/v3/security.upbdefs.c
  ${_gRPC_ROOT}/src/core/ext/upbdefs-gen/xds/annotations/v3/sensitive.upbdefs.c
  ${_gRPC_ROOT}/src/core/ext/upbdefs-gen/xds/annotations/v3/status.upbdefs.c
  ${_gRPC_ROOT}/src/core/ext/upbdefs-gen/xds/annotations/v3/versioning.upbdefs.c
  ${_gRPC_ROOT}/src/core/ext/upbdefs-gen/xds/core/v3/authority.upbdefs.c
  ${_gRPC_ROOT}/src/core/ext/upbdefs-gen/xds/core/v3/cidr.upbdefs.c
  ${_gRPC_ROOT}/src/core/ext/upbdefs-gen/xds/core/v3/collection_entry.upbdefs.c
  ${_gRPC_ROOT}/src/core/ext/upbdefs-gen/xds/core/v3/context_params.upbdefs.c
  ${_gRPC_ROOT}/src/core/ext/upbdefs-gen/xds/core/v3/extension.upbdefs.c
  ${_gRPC_ROOT}/src/core/ext/upbdefs-gen/xds/core/v3/resource.upbdefs.c
  ${_gRPC_ROOT}/src/core/ext/upbdefs-gen/xds/core/v3/resource_locator.upbdefs.c
  ${_gRPC_ROOT}/src/core/ext/upbdefs-gen/xds/core/v3/resource_name.upbdefs.c
  ${_gRPC_ROOT}/src/core/ext/upbdefs-gen/xds/type/matcher/v3/cel.upbdefs.c
  ${_gRPC_ROOT}/src/core/ext/upbdefs-gen/xds/type/matcher/v3/domain.upbdefs.c
  ${_gRPC_ROOT}/src/core/ext/upbdefs-gen/xds/type/matcher/v3/http_inputs.upbdefs.c
  ${_gRPC_ROOT}/src/core/ext/upbdefs-gen/xds/type/matcher/v3/ip.upbdefs.c
  ${_gRPC_ROOT}/src/core/ext/upbdefs-gen/xds/type/matcher/v3/matcher.upbdefs.c
  ${_gRPC_ROOT}/src/core/ext/upbdefs-gen/xds/type/matcher/v3/range.upbdefs.c
  ${_gRPC_ROOT}/src/core/ext/upbdefs-gen/xds/type/matcher/v3/regex.upbdefs.c
  ${_gRPC_ROOT}/src/core/ext/upbdefs-gen/xds/type/matcher/v3/string.upbdefs.c
  ${_gRPC_ROOT}/src/core/ext/upbdefs-gen/xds/type/v3/cel.upbdefs.c
  ${_gRPC_ROOT}/src/core/ext/upbdefs-gen/xds/type/v3/range.upbdefs.c
  ${_gRPC_ROOT}/src/core/ext/upbdefs-gen/xds/type/v3/typed_struct.upbdefs.c
  ${_gRPC_ROOT}/src/core/filter/auth/client_auth_filter.cc
  ${_gRPC_ROOT}/src/core/filter/auth/server_auth_filter.cc
  ${_gRPC_ROOT}/src/core/filter/composite/composite_filter.cc
  ${_gRPC_ROOT}/src/core/filter/fused_filters.cc
  ${_gRPC_ROOT}/src/core/handshaker/endpoint_info/endpoint_info_handshaker.cc
  ${_gRPC_ROOT}/src/core/handshaker/handshaker.cc
  ${_gRPC_ROOT}/src/core/handshaker/handshaker_registry.cc
  ${_gRPC_ROOT}/src/core/handshaker/http_connect/http_connect_client_handshaker.cc
  ${_gRPC_ROOT}/src/core/handshaker/http_connect/http_proxy_mapper.cc
  ${_gRPC_ROOT}/src/core/handshaker/http_connect/xds_http_proxy_mapper.cc
  ${_gRPC_ROOT}/src/core/handshaker/proxy_mapper_registry.cc
  ${_gRPC_ROOT}/src/core/handshaker/security/pipelined_secure_endpoint.cc
  ${_gRPC_ROOT}/src/core/handshaker/security/secure_endpoint.cc
  ${_gRPC_ROOT}/src/core/handshaker/security/security_handshaker.cc
  ${_gRPC_ROOT}/src/core/handshaker/tcp_connect/tcp_connect_handshaker.cc
  ${_gRPC_ROOT}/src/core/lib/address_utils/parse_address.cc
  ${_gRPC_ROOT}/src/core/lib/address_utils/sockaddr_utils.cc
  ${_gRPC_ROOT}/src/core/lib/channel/channel_args.cc
  ${_gRPC_ROOT}/src/core/lib/channel/channel_args_preconditioning.cc
  ${_gRPC_ROOT}/src/core/lib/channel/channel_stack.cc
  ${_gRPC_ROOT}/src/core/lib/channel/channel_stack_builder.cc
  ${_gRPC_ROOT}/src/core/lib/channel/channel_stack_builder_impl.cc
  ${_gRPC_ROOT}/src/core/lib/channel/connected_channel.cc
  ${_gRPC_ROOT}/src/core/lib/channel/promise_based_filter.cc
  ${_gRPC_ROOT}/src/core/lib/compression/compression.cc
  ${_gRPC_ROOT}/src/core/lib/compression/compression_internal.cc
  ${_gRPC_ROOT}/src/core/lib/compression/message_compress.cc
  ${_gRPC_ROOT}/src/core/lib/debug/trace.cc
  ${_gRPC_ROOT}/src/core/lib/debug/trace_flags.cc
  ${_gRPC_ROOT}/src/core/lib/event_engine/ares_resolver.cc
  ${_gRPC_ROOT}/src/core/lib/event_engine/cf_engine/cf_engine.cc
  ${_gRPC_ROOT}/src/core/lib/event_engine/cf_engine/cfsocket_listener.cc
  ${_gRPC_ROOT}/src/core/lib/event_engine/cf_engine/cfstream_endpoint.cc
  ${_gRPC_ROOT}/src/core/lib/event_engine/cf_engine/dns_service_resolver.cc
  ${_gRPC_ROOT}/src/core/lib/event_engine/channel_args_endpoint_config.cc
  ${_gRPC_ROOT}/src/core/lib/event_engine/default_event_engine.cc
  ${_gRPC_ROOT}/src/core/lib/event_engine/default_event_engine_factory.cc
  ${_gRPC_ROOT}/src/core/lib/event_engine/endpoint_channel_arg_wrapper.cc
  ${_gRPC_ROOT}/src/core/lib/event_engine/event_engine.cc
  ${_gRPC_ROOT}/src/core/lib/event_engine/posix_engine/ev_epoll1_linux.cc
  ${_gRPC_ROOT}/src/core/lib/event_engine/posix_engine/ev_poll_posix.cc
  ${_gRPC_ROOT}/src/core/lib/event_engine/posix_engine/event_poller_posix_default.cc
  ${_gRPC_ROOT}/src/core/lib/event_engine/posix_engine/file_descriptor_collection.cc
  ${_gRPC_ROOT}/src/core/lib/event_engine/posix_engine/internal_errqueue.cc
  ${_gRPC_ROOT}/src/core/lib/event_engine/posix_engine/lockfree_event.cc
  ${_gRPC_ROOT}/src/core/lib/event_engine/posix_engine/native_posix_dns_resolver.cc
  ${_gRPC_ROOT}/src/core/lib/event_engine/posix_engine/posix_endpoint.cc
  ${_gRPC_ROOT}/src/core/lib/event_engine/posix_engine/posix_engine.cc
  ${_gRPC_ROOT}/src/core/lib/event_engine/posix_engine/posix_engine_listener.cc
  ${_gRPC_ROOT}/src/core/lib/event_engine/posix_engine/posix_engine_listener_utils.cc
  ${_gRPC_ROOT}/src/core/lib/event_engine/posix_engine/posix_interface_posix.cc
  ${_gRPC_ROOT}/src/core/lib/event_engine/posix_engine/posix_interface_windows.cc
  ${_gRPC_ROOT}/src/core/lib/event_engine/posix_engine/posix_write_event_sink.cc
  ${_gRPC_ROOT}/src/core/lib/event_engine/posix_engine/set_socket_dualstack.cc
  ${_gRPC_ROOT}/src/core/lib/event_engine/posix_engine/tcp_socket_utils.cc
  ${_gRPC_ROOT}/src/core/lib/event_engine/posix_engine/timer.cc
  ${_gRPC_ROOT}/src/core/lib/event_engine/posix_engine/timer_heap.cc
  ${_gRPC_ROOT}/src/core/lib/event_engine/posix_engine/timer_manager.cc
  ${_gRPC_ROOT}/src/core/lib/event_engine/posix_engine/traced_buffer_list.cc
  ${_gRPC_ROOT}/src/core/lib/event_engine/posix_engine/wakeup_fd_eventfd.cc
  ${_gRPC_ROOT}/src/core/lib/event_engine/posix_engine/wakeup_fd_pipe.cc
  ${_gRPC_ROOT}/src/core/lib/event_engine/posix_engine/wakeup_fd_posix_default.cc
  ${_gRPC_ROOT}/src/core/lib/event_engine/resolved_address.cc
  ${_gRPC_ROOT}/src/core/lib/event_engine/shim.cc
  ${_gRPC_ROOT}/src/core/lib/event_engine/slice.cc
  ${_gRPC_ROOT}/src/core/lib/event_engine/slice_buffer.cc
  ${_gRPC_ROOT}/src/core/lib/event_engine/tcp_socket_utils.cc
  ${_gRPC_ROOT}/src/core/lib/event_engine/thread_pool/thread_count.cc
  ${_gRPC_ROOT}/src/core/lib/event_engine/thread_pool/thread_pool_factory.cc
  ${_gRPC_ROOT}/src/core/lib/event_engine/thread_pool/work_stealing_thread_pool.cc
  ${_gRPC_ROOT}/src/core/lib/event_engine/thready_event_engine/thready_event_engine.cc
  ${_gRPC_ROOT}/src/core/lib/event_engine/time_util.cc
  ${_gRPC_ROOT}/src/core/lib/event_engine/utils.cc
  ${_gRPC_ROOT}/src/core/lib/event_engine/windows/grpc_polled_fd_windows.cc
  ${_gRPC_ROOT}/src/core/lib/event_engine/windows/iocp.cc
  ${_gRPC_ROOT}/src/core/lib/event_engine/windows/native_windows_dns_resolver.cc
  ${_gRPC_ROOT}/src/core/lib/event_engine/windows/win_socket.cc
  ${_gRPC_ROOT}/src/core/lib/event_engine/windows/windows_endpoint.cc
  ${_gRPC_ROOT}/src/core/lib/event_engine/windows/windows_engine.cc
  ${_gRPC_ROOT}/src/core/lib/event_engine/windows/windows_listener.cc
  ${_gRPC_ROOT}/src/core/lib/event_engine/work_queue/basic_work_queue.cc
  ${_gRPC_ROOT}/src/core/lib/experiments/config.cc
  ${_gRPC_ROOT}/src/core/lib/experiments/experiments.cc
  ${_gRPC_ROOT}/src/core/lib/iomgr/buffer_list.cc
  ${_gRPC_ROOT}/src/core/lib/iomgr/call_combiner.cc
  ${_gRPC_ROOT}/src/core/lib/iomgr/cfstream_handle.cc
  ${_gRPC_ROOT}/src/core/lib/iomgr/closure.cc
  ${_gRPC_ROOT}/src/core/lib/iomgr/combiner.cc
  ${_gRPC_ROOT}/src/core/lib/iomgr/dualstack_socket_posix.cc
  ${_gRPC_ROOT}/src/core/lib/iomgr/endpoint.cc
  ${_gRPC_ROOT}/src/core/lib/iomgr/endpoint_cfstream.cc
  ${_gRPC_ROOT}/src/core/lib/iomgr/endpoint_pair_posix.cc
  ${_gRPC_ROOT}/src/core/lib/iomgr/endpoint_pair_windows.cc
  ${_gRPC_ROOT}/src/core/lib/iomgr/error.cc
  ${_gRPC_ROOT}/src/core/lib/iomgr/error_cfstream.cc
  ${_gRPC_ROOT}/src/core/lib/iomgr/ev_apple.cc
  ${_gRPC_ROOT}/src/core/lib/iomgr/ev_epoll1_linux.cc
  ${_gRPC_ROOT}/src/core/lib/iomgr/ev_poll_posix.cc
  ${_gRPC_ROOT}/src/core/lib/iomgr/ev_posix.cc
  ${_gRPC_ROOT}/src/core/lib/iomgr/event_engine_shims/closure.cc
  ${_gRPC_ROOT}/src/core/lib/iomgr/event_engine_shims/endpoint.cc
  ${_gRPC_ROOT}/src/core/lib/iomgr/event_engine_shims/tcp_client.cc
  ${_gRPC_ROOT}/src/core/lib/iomgr/exec_ctx.cc
  ${_gRPC_ROOT}/src/core/lib/iomgr/fork_posix.cc
  ${_gRPC_ROOT}/src/core/lib/iomgr/fork_windows.cc
  ${_gRPC_ROOT}/src/core/lib/iomgr/internal_errqueue.cc
  ${_gRPC_ROOT}/src/core/lib/iomgr/iocp_windows.cc
  ${_gRPC_ROOT}/src/core/lib/iomgr/iomgr.cc
  ${_gRPC_ROOT}/src/core/lib/iomgr/iomgr_internal.cc
  ${_gRPC_ROOT}/src/core/lib/iomgr/iomgr_posix.cc
  ${_gRPC_ROOT}/src/core/lib/iomgr/iomgr_posix_cfstream.cc
  ${_gRPC_ROOT}/src/core/lib/iomgr/iomgr_windows.cc
  ${_gRPC_ROOT}/src/core/lib/iomgr/lockfree_event.cc
  ${_gRPC_ROOT}/src/core/lib/iomgr/polling_entity.cc
  ${_gRPC_ROOT}/src/core/lib/iomgr/pollset.cc
  ${_gRPC_ROOT}/src/core/lib/iomgr/pollset_set.cc
  ${_gRPC_ROOT}/src/core/lib/iomgr/pollset_set_windows.cc
  ${_gRPC_ROOT}/src/core/lib/iomgr/pollset_windows.cc
  ${_gRPC_ROOT}/src/core/lib/iomgr/resolve_address.cc
  ${_gRPC_ROOT}/src/core/lib/iomgr/resolve_address_posix.cc
  ${_gRPC_ROOT}/src/core/lib/iomgr/resolve_address_windows.cc
  ${_gRPC_ROOT}/src/core/lib/iomgr/sockaddr_utils_posix.cc
  ${_gRPC_ROOT}/src/core/lib/iomgr/socket_factory_posix.cc
  ${_gRPC_ROOT}/src/core/lib/iomgr/socket_mutator.cc
  ${_gRPC_ROOT}/src/core/lib/iomgr/socket_utils_common_posix.cc
  ${_gRPC_ROOT}/src/core/lib/iomgr/socket_utils_linux.cc
  ${_gRPC_ROOT}/src/core/lib/iomgr/socket_utils_posix.cc
  ${_gRPC_ROOT}/src/core/lib/iomgr/socket_utils_windows.cc
  ${_gRPC_ROOT}/src/core/lib/iomgr/socket_windows.cc
  ${_gRPC_ROOT}/src/core/lib/iomgr/systemd_utils.cc
  ${_gRPC_ROOT}/src/core/lib/iomgr/tcp_client.cc
  ${_gRPC_ROOT}/src/core/lib/iomgr/tcp_client_cfstream.cc
  ${_gRPC_ROOT}/src/core/lib/iomgr/tcp_client_posix.cc
  ${_gRPC_ROOT}/src/core/lib/iomgr/tcp_client_windows.cc
  ${_gRPC_ROOT}/src/core/lib/iomgr/tcp_posix.cc
  ${_gRPC_ROOT}/src/core/lib/iomgr/tcp_server.cc
  ${_gRPC_ROOT}/src/core/lib/iomgr/tcp_server_posix.cc
  ${_gRPC_ROOT}/src/core/lib/iomgr/tcp_server_utils_posix_common.cc
  ${_gRPC_ROOT}/src/core/lib/iomgr/tcp_server_utils_posix_ifaddrs.cc
  ${_gRPC_ROOT}/src/core/lib/iomgr/tcp_server_utils_posix_noifaddrs.cc
  ${_gRPC_ROOT}/src/core/lib/iomgr/tcp_server_windows.cc
  ${_gRPC_ROOT}/src/core/lib/iomgr/tcp_windows.cc
  ${_gRPC_ROOT}/src/core/lib/iomgr/timer.cc
  ${_gRPC_ROOT}/src/core/lib/iomgr/timer_generic.cc
  ${_gRPC_ROOT}/src/core/lib/iomgr/timer_heap.cc
  ${_gRPC_ROOT}/src/core/lib/iomgr/timer_manager.cc
  ${_gRPC_ROOT}/src/core/lib/iomgr/unix_sockets_posix.cc
  ${_gRPC_ROOT}/src/core/lib/iomgr/unix_sockets_posix_noop.cc
  ${_gRPC_ROOT}/src/core/lib/iomgr/vsock.cc
  ${_gRPC_ROOT}/src/core/lib/iomgr/wakeup_fd_eventfd.cc
  ${_gRPC_ROOT}/src/core/lib/iomgr/wakeup_fd_nospecial.cc
  ${_gRPC_ROOT}/src/core/lib/iomgr/wakeup_fd_pipe.cc
  ${_gRPC_ROOT}/src/core/lib/iomgr/wakeup_fd_posix.cc
  ${_gRPC_ROOT}/src/core/lib/promise/activity.cc
  ${_gRPC_ROOT}/src/core/lib/promise/mpsc.cc
  ${_gRPC_ROOT}/src/core/lib/promise/party.cc
  ${_gRPC_ROOT}/src/core/lib/promise/sleep.cc
  ${_gRPC_ROOT}/src/core/lib/promise/wait_set.cc
  ${_gRPC_ROOT}/src/core/lib/resource_quota/api.cc
  ${_gRPC_ROOT}/src/core/lib/resource_quota/arena.cc
  ${_gRPC_ROOT}/src/core/lib/resource_quota/connection_quota.cc
  ${_gRPC_ROOT}/src/core/lib/resource_quota/memory_quota.cc
  ${_gRPC_ROOT}/src/core/lib/resource_quota/periodic_update.cc
  ${_gRPC_ROOT}/src/core/lib/resource_quota/resource_quota.cc
  ${_gRPC_ROOT}/src/core/lib/resource_quota/stream_quota.cc
  ${_gRPC_ROOT}/src/core/lib/resource_quota/telemetry.cc
  ${_gRPC_ROOT}/src/core/lib/resource_quota/thread_quota.cc
  ${_gRPC_ROOT}/src/core/lib/resource_tracker/resource_tracker.cc
  ${_gRPC_ROOT}/src/core/lib/security/authorization/audit_logging.cc
  ${_gRPC_ROOT}/src/core/lib/security/authorization/authorization_policy_provider_vtable.cc
  ${_gRPC_ROOT}/src/core/lib/security/authorization/evaluate_args.cc
  ${_gRPC_ROOT}/src/core/lib/security/authorization/grpc_authorization_engine.cc
  ${_gRPC_ROOT}/src/core/lib/security/authorization/grpc_server_authz_filter.cc
  ${_gRPC_ROOT}/src/core/lib/security/authorization/matchers.cc
  ${_gRPC_ROOT}/src/core/lib/security/authorization/rbac_policy.cc
  ${_gRPC_ROOT}/src/core/lib/security/authorization/stdout_logger.cc
  ${_gRPC_ROOT}/src/core/lib/slice/percent_encoding.cc
  ${_gRPC_ROOT}/src/core/lib/slice/slice.cc
  ${_gRPC_ROOT}/src/core/lib/slice/slice_buffer.cc
  ${_gRPC_ROOT}/src/core/lib/slice/slice_string_helpers.cc
  ${_gRPC_ROOT}/src/core/lib/surface/byte_buffer.cc
  ${_gRPC_ROOT}/src/core/lib/surface/byte_buffer_reader.cc
  ${_gRPC_ROOT}/src/core/lib/surface/call.cc
  ${_gRPC_ROOT}/src/core/lib/surface/call_details.cc
  ${_gRPC_ROOT}/src/core/lib/surface/call_log_batch.cc
  ${_gRPC_ROOT}/src/core/lib/surface/call_utils.cc
  ${_gRPC_ROOT}/src/core/lib/surface/channel.cc
  ${_gRPC_ROOT}/src/core/lib/surface/channel_create.cc
  ${_gRPC_ROOT}/src/core/lib/surface/channel_init.cc
  ${_gRPC_ROOT}/src/core/lib/surface/channel_stack_type.cc
  ${_gRPC_ROOT}/src/core/lib/surface/completion_queue.cc
  ${_gRPC_ROOT}/src/core/lib/surface/completion_queue_factory.cc
  ${_gRPC_ROOT}/src/core/lib/surface/connection_context.cc
  ${_gRPC_ROOT}/src/core/lib/surface/event_string.cc
  ${_gRPC_ROOT}/src/core/lib/surface/filter_stack_call.cc
  ${_gRPC_ROOT}/src/core/lib/surface/init.cc
  ${_gRPC_ROOT}/src/core/lib/surface/init_internally.cc
  ${_gRPC_ROOT}/src/core/lib/surface/lame_client.cc
  ${_gRPC_ROOT}/src/core/lib/surface/legacy_channel.cc
  ${_gRPC_ROOT}/src/core/lib/surface/metadata_array.cc
  ${_gRPC_ROOT}/src/core/lib/surface/validate_metadata.cc
  ${_gRPC_ROOT}/src/core/lib/surface/version.cc
  ${_gRPC_ROOT}/src/core/lib/transport/bdp_estimator.cc
  ${_gRPC_ROOT}/src/core/lib/transport/call_final_info.cc
  ${_gRPC_ROOT}/src/core/lib/transport/connectivity_state.cc
  ${_gRPC_ROOT}/src/core/lib/transport/error_utils.cc
  ${_gRPC_ROOT}/src/core/lib/transport/promise_endpoint.cc
  ${_gRPC_ROOT}/src/core/lib/transport/status_conversion.cc
  ${_gRPC_ROOT}/src/core/lib/transport/timeout_encoding.cc
  ${_gRPC_ROOT}/src/core/lib/transport/transport.cc
  ${_gRPC_ROOT}/src/core/lib/transport/transport_op_string.cc
  ${_gRPC_ROOT}/src/core/load_balancing/address_filtering.cc
  ${_gRPC_ROOT}/src/core/load_balancing/backend_metric_parser.cc
  ${_gRPC_ROOT}/src/core/load_balancing/child_policy_handler.cc
  ${_gRPC_ROOT}/src/core/load_balancing/endpoint_list.cc
  ${_gRPC_ROOT}/src/core/load_balancing/grpclb/client_load_reporting_filter.cc
  ${_gRPC_ROOT}/src/core/load_balancing/grpclb/grpclb.cc
  ${_gRPC_ROOT}/src/core/load_balancing/grpclb/grpclb_balancer_addresses.cc
  ${_gRPC_ROOT}/src/core/load_balancing/grpclb/grpclb_client_stats.cc
  ${_gRPC_ROOT}/src/core/load_balancing/grpclb/load_balancer_api.cc
  ${_gRPC_ROOT}/src/core/load_balancing/health_check_client.cc
  ${_gRPC_ROOT}/src/core/load_balancing/lb_policy.cc
  ${_gRPC_ROOT}/src/core/load_balancing/lb_policy_registry.cc
  ${_gRPC_ROOT}/src/core/load_balancing/oob_backend_metric.cc
  ${_gRPC_ROOT}/src/core/load_balancing/outlier_detection/outlier_detection.cc
  ${_gRPC_ROOT}/src/core/load_balancing/pick_first/pick_first.cc
  ${_gRPC_ROOT}/src/core/load_balancing/priority/priority.cc
  ${_gRPC_ROOT}/src/core/load_balancing/ring_hash/ring_hash.cc
  ${_gRPC_ROOT}/src/core/load_balancing/rls/rls.cc
  ${_gRPC_ROOT}/src/core/load_balancing/round_robin/round_robin.cc
  ${_gRPC_ROOT}/src/core/load_balancing/weighted_round_robin/static_stride_scheduler.cc
  ${_gRPC_ROOT}/src/core/load_balancing/weighted_round_robin/weighted_round_robin.cc
  ${_gRPC_ROOT}/src/core/load_balancing/weighted_target/weighted_target.cc
  ${_gRPC_ROOT}/src/core/load_balancing/xds/cds.cc
  ${_gRPC_ROOT}/src/core/load_balancing/xds/xds_cluster_impl.cc
  ${_gRPC_ROOT}/src/core/load_balancing/xds/xds_cluster_manager.cc
  ${_gRPC_ROOT}/src/core/load_balancing/xds/xds_override_host.cc
  ${_gRPC_ROOT}/src/core/load_balancing/xds/xds_wrr_locality.cc
  ${_gRPC_ROOT}/src/core/net/socket_mutator.cc
  ${_gRPC_ROOT}/src/core/plugin_registry/grpc_plugin_registry.cc
  ${_gRPC_ROOT}/src/core/plugin_registry/grpc_plugin_registry_extra.cc
  ${_gRPC_ROOT}/src/core/resolver/dns/c_ares/dns_resolver_ares.cc
  ${_gRPC_ROOT}/src/core/resolver/dns/c_ares/grpc_ares_ev_driver_posix.cc
  ${_gRPC_ROOT}/src/core/resolver/dns/c_ares/grpc_ares_ev_driver_windows.cc
  ${_gRPC_ROOT}/src/core/resolver/dns/c_ares/grpc_ares_wrapper.cc
  ${_gRPC_ROOT}/src/core/resolver/dns/c_ares/grpc_ares_wrapper_posix.cc
  ${_gRPC_ROOT}/src/core/resolver/dns/c_ares/grpc_ares_wrapper_windows.cc
  ${_gRPC_ROOT}/src/core/resolver/dns/dns_resolver_plugin.cc
  ${_gRPC_ROOT}/src/core/resolver/dns/event_engine/event_engine_client_channel_resolver.cc
  ${_gRPC_ROOT}/src/core/resolver/dns/event_engine/service_config_helper.cc
  ${_gRPC_ROOT}/src/core/resolver/dns/native/dns_resolver.cc
  ${_gRPC_ROOT}/src/core/resolver/endpoint_addresses.cc
  ${_gRPC_ROOT}/src/core/resolver/fake/fake_resolver.cc
  ${_gRPC_ROOT}/src/core/resolver/google_c2p/google_c2p_resolver.cc
  ${_gRPC_ROOT}/src/core/resolver/polling_resolver.cc
  ${_gRPC_ROOT}/src/core/resolver/resolver.cc
  ${_gRPC_ROOT}/src/core/resolver/resolver_registry.cc
  ${_gRPC_ROOT}/src/core/resolver/sockaddr/sockaddr_resolver.cc
  ${_gRPC_ROOT}/src/core/resolver/xds/xds_config.cc
  ${_gRPC_ROOT}/src/core/resolver/xds/xds_dependency_manager.cc
  ${_gRPC_ROOT}/src/core/resolver/xds/xds_resolver.cc
  ${_gRPC_ROOT}/src/core/server/add_port.cc
  ${_gRPC_ROOT}/src/core/server/server.cc
  ${_gRPC_ROOT}/src/core/server/server_call_tracer_filter.cc
  ${_gRPC_ROOT}/src/core/server/server_config_selector_filter.cc
  ${_gRPC_ROOT}/src/core/server/xds_channel_stack_modifier.cc
  ${_gRPC_ROOT}/src/core/server/xds_server_config_fetcher.cc
  ${_gRPC_ROOT}/src/core/server/xds_server_config_fetcher_legacy.cc
  ${_gRPC_ROOT}/src/core/service_config/service_config_channel_arg_filter.cc
  ${_gRPC_ROOT}/src/core/service_config/service_config_impl.cc
  ${_gRPC_ROOT}/src/core/service_config/service_config_parser.cc
  ${_gRPC_ROOT}/src/core/telemetry/call_tracer.cc
  ${_gRPC_ROOT}/src/core/telemetry/context_list_entry.cc
  ${_gRPC_ROOT}/src/core/telemetry/default_tcp_tracer.cc
  ${_gRPC_ROOT}/src/core/telemetry/histogram_view.cc
  ${_gRPC_ROOT}/src/core/telemetry/instrument.cc
  ${_gRPC_ROOT}/src/core/telemetry/metrics.cc
  ${_gRPC_ROOT}/src/core/telemetry/stats.cc
  ${_gRPC_ROOT}/src/core/telemetry/stats_data.cc
  ${_gRPC_ROOT}/src/core/telemetry/tcp_tracer.cc
  ${_gRPC_ROOT}/src/core/transport/auth_context.cc
  ${_gRPC_ROOT}/src/core/transport/endpoint_transport_client_channel_factory.cc
  ${_gRPC_ROOT}/src/core/transport/message_size_service_config.cc
  ${_gRPC_ROOT}/src/core/transport/session_endpoint.cc
  ${_gRPC_ROOT}/src/core/tsi/alts/crypt/aes_gcm.cc
  ${_gRPC_ROOT}/src/core/tsi/alts/crypt/gsec.cc
  ${_gRPC_ROOT}/src/core/tsi/alts/frame_protector/alts_counter.cc
  ${_gRPC_ROOT}/src/core/tsi/alts/frame_protector/alts_crypter.cc
  ${_gRPC_ROOT}/src/core/tsi/alts/frame_protector/alts_frame_protector.cc
  ${_gRPC_ROOT}/src/core/tsi/alts/frame_protector/alts_record_protocol_crypter_common.cc
  ${_gRPC_ROOT}/src/core/tsi/alts/frame_protector/alts_seal_privacy_integrity_crypter.cc
  ${_gRPC_ROOT}/src/core/tsi/alts/frame_protector/alts_unseal_privacy_integrity_crypter.cc
  ${_gRPC_ROOT}/src/core/tsi/alts/frame_protector/frame_handler.cc
  ${_gRPC_ROOT}/src/core/tsi/alts/handshaker/alts_handshaker_client.cc
  ${_gRPC_ROOT}/src/core/tsi/alts/handshaker/alts_shared_resource.cc
  ${_gRPC_ROOT}/src/core/tsi/alts/handshaker/alts_tsi_handshaker.cc
  ${_gRPC_ROOT}/src/core/tsi/alts/handshaker/alts_tsi_utils.cc
  ${_gRPC_ROOT}/src/core/tsi/alts/handshaker/transport_security_common_api.cc
  ${_gRPC_ROOT}/src/core/tsi/alts/zero_copy_frame_protector/alts_grpc_integrity_only_record_protocol.cc
  ${_gRPC_ROOT}/src/core/tsi/alts/zero_copy_frame_protector/alts_grpc_privacy_integrity_record_protocol.cc
  ${_gRPC_ROOT}/src/core/tsi/alts/zero_copy_frame_protector/alts_grpc_record_protocol_common.cc
  ${_gRPC_ROOT}/src/core/tsi/alts/zero_copy_frame_protector/alts_iovec_record_protocol.cc
  ${_gRPC_ROOT}/src/core/tsi/alts/zero_copy_frame_protector/alts_zero_copy_grpc_protector.cc
  ${_gRPC_ROOT}/src/core/tsi/fake_transport_security.cc
  ${_gRPC_ROOT}/src/core/tsi/local_transport_security.cc
  ${_gRPC_ROOT}/src/core/tsi/ssl/key_logging/ssl_key_logging.cc
  ${_gRPC_ROOT}/src/core/tsi/ssl/session_cache/ssl_session_boringssl.cc
  ${_gRPC_ROOT}/src/core/tsi/ssl/session_cache/ssl_session_cache.cc
  ${_gRPC_ROOT}/src/core/tsi/ssl/session_cache/ssl_session_openssl.cc
  ${_gRPC_ROOT}/src/core/tsi/ssl_transport_security.cc
  ${_gRPC_ROOT}/src/core/tsi/ssl_transport_security_utils.cc
  ${_gRPC_ROOT}/src/core/tsi/transport_security.cc
  ${_gRPC_ROOT}/src/core/tsi/transport_security_grpc.cc
  ${_gRPC_ROOT}/src/core/util/backoff.cc
  ${_gRPC_ROOT}/src/core/util/dump_args.cc
  ${_gRPC_ROOT}/src/core/util/event_log.cc
  ${_gRPC_ROOT}/src/core/util/gcp_metadata_query.cc
  ${_gRPC_ROOT}/src/core/util/gethostname_fallback.cc
  ${_gRPC_ROOT}/src/core/util/gethostname_host_name_max.cc
  ${_gRPC_ROOT}/src/core/util/gethostname_sysconf.cc
  ${_gRPC_ROOT}/src/core/util/glob.cc
  ${_gRPC_ROOT}/src/core/util/grpc_check.cc
  ${_gRPC_ROOT}/src/core/util/grpc_if_nametoindex_posix.cc
  ${_gRPC_ROOT}/src/core/util/grpc_if_nametoindex_unsupported.cc
  ${_gRPC_ROOT}/src/core/util/http_client/format_request.cc
  ${_gRPC_ROOT}/src/core/util/http_client/httpcli.cc
  ${_gRPC_ROOT}/src/core/util/http_client/httpcli_security_connector.cc
  ${_gRPC_ROOT}/src/core/util/http_client/parser.cc
  ${_gRPC_ROOT}/src/core/util/json/json_object_loader.cc
  ${_gRPC_ROOT}/src/core/util/json/json_reader.cc
  ${_gRPC_ROOT}/src/core/util/json/json_util.cc
  ${_gRPC_ROOT}/src/core/util/json/json_writer.cc
  ${_gRPC_ROOT}/src/core/util/latent_see.cc
  ${_gRPC_ROOT}/src/core/util/load_file.cc
  ${_gRPC_ROOT}/src/core/util/matchers.cc
  ${_gRPC_ROOT}/src/core/util/per_cpu.cc
  ${_gRPC_ROOT}/src/core/util/posix/directory_reader.cc
  ${_gRPC_ROOT}/src/core/util/postmortem_emit.cc
  ${_gRPC_ROOT}/src/core/util/random_early_detection.cc
  ${_gRPC_ROOT}/src/core/util/ref_counted_string.cc
  ${_gRPC_ROOT}/src/core/util/shared_bit_gen.cc
  ${_gRPC_ROOT}/src/core/util/status_helper.cc
  ${_gRPC_ROOT}/src/core/util/time.cc
  ${_gRPC_ROOT}/src/core/util/time_averaged_stats.cc
  ${_gRPC_ROOT}/src/core/util/uri.cc
  ${_gRPC_ROOT}/src/core/util/uuid_v4.cc
  ${_gRPC_ROOT}/src/core/util/validation_errors.cc
  ${_gRPC_ROOT}/src/core/util/wait_for_single_owner.cc
  ${_gRPC_ROOT}/src/core/util/windows/directory_reader.cc
  ${_gRPC_ROOT}/src/core/util/work_serializer.cc
  ${_gRPC_ROOT}/src/core/xds/grpc/blackboard.cc
  ${_gRPC_ROOT}/src/core/xds/grpc/certificate_provider_store.cc
  ${_gRPC_ROOT}/src/core/xds/grpc/file_watcher_certificate_provider_factory.cc
  ${_gRPC_ROOT}/src/core/xds/grpc/xds_audit_logger_registry.cc
  ${_gRPC_ROOT}/src/core/xds/grpc/xds_bootstrap_grpc.cc
  ${_gRPC_ROOT}/src/core/xds/grpc/xds_certificate_provider.cc
  ${_gRPC_ROOT}/src/core/xds/grpc/xds_client_grpc.cc
  ${_gRPC_ROOT}/src/core/xds/grpc/xds_cluster.cc
  ${_gRPC_ROOT}/src/core/xds/grpc/xds_cluster_parser.cc
  ${_gRPC_ROOT}/src/core/xds/grpc/xds_cluster_specifier_plugin.cc
  ${_gRPC_ROOT}/src/core/xds/grpc/xds_common_types.cc
  ${_gRPC_ROOT}/src/core/xds/grpc/xds_common_types_parser.cc
  ${_gRPC_ROOT}/src/core/xds/grpc/xds_endpoint.cc
  ${_gRPC_ROOT}/src/core/xds/grpc/xds_endpoint_parser.cc
  ${_gRPC_ROOT}/src/core/xds/grpc/xds_health_status.cc
  ${_gRPC_ROOT}/src/core/xds/grpc/xds_http_composite_filter.cc
  ${_gRPC_ROOT}/src/core/xds/grpc/xds_http_fault_filter.cc
  ${_gRPC_ROOT}/src/core/xds/grpc/xds_http_filter.cc
  ${_gRPC_ROOT}/src/core/xds/grpc/xds_http_filter_registry.cc
  ${_gRPC_ROOT}/src/core/xds/grpc/xds_http_gcp_authn_filter.cc
  ${_gRPC_ROOT}/src/core/xds/grpc/xds_http_rbac_filter.cc
  ${_gRPC_ROOT}/src/core/xds/grpc/xds_http_stateful_session_filter.cc
  ${_gRPC_ROOT}/src/core/xds/grpc/xds_lb_policy_registry.cc
  ${_gRPC_ROOT}/src/core/xds/grpc/xds_listener.cc
  ${_gRPC_ROOT}/src/core/xds/grpc/xds_listener_parser.cc
  ${_gRPC_ROOT}/src/core/xds/grpc/xds_matcher.cc
  ${_gRPC_ROOT}/src/core/xds/grpc/xds_matcher_action.cc
  ${_gRPC_ROOT}/src/core/xds/grpc/xds_matcher_context.cc
  ${_gRPC_ROOT}/src/core/xds/grpc/xds_matcher_input.cc
  ${_gRPC_ROOT}/src/core/xds/grpc/xds_matcher_parse.cc
  ${_gRPC_ROOT}/src/core/xds/grpc/xds_metadata.cc
  ${_gRPC_ROOT}/src/core/xds/grpc/xds_metadata_parser.cc
  ${_gRPC_ROOT}/src/core/xds/grpc/xds_route_config.cc
  ${_gRPC_ROOT}/src/core/xds/grpc/xds_route_config_parser.cc
  ${_gRPC_ROOT}/src/core/xds/grpc/xds_routing.cc
  ${_gRPC_ROOT}/src/core/xds/grpc/xds_server_grpc.cc
  ${_gRPC_ROOT}/src/core/xds/grpc/xds_transport_grpc.cc
  ${_gRPC_ROOT}/src/core/xds/xds_client/lrs_client.cc
  ${_gRPC_ROOT}/src/core/xds/xds_client/xds_api.cc
  ${_gRPC_ROOT}/src/core/xds/xds_client/xds_backend_metric_propagation.cc
  ${_gRPC_ROOT}/src/core/xds/xds_client/xds_bootstrap.cc
  ${_gRPC_ROOT}/src/core/xds/xds_client/xds_client.cc
)



target_include_directories(grpc
  PUBLIC  ${_gRPC_ROOT}/include
  PRIVATE
    ${_gRPC_ROOT}
    ${_gRPC_ADDRESS_SORTING_INCLUDE_DIR}
    ${_gRPC_RE2_INCLUDE_DIR}
    ${_gRPC_SSL_INCLUDE_DIR}
    ${_gRPC_UPB_GENERATED_DIR}
    ${_gRPC_UPB_GRPC_GENERATED_DIR}
    ${_gRPC_UPB_INCLUDE_DIR}
    ${_gRPC_XXHASH_INCLUDE_DIR}
    ${_gRPC_ZLIB_INCLUDE_DIR}
)
target_link_libraries(grpc PUBLIC
  ${_gRPC_BASELIB_LIBRARIES}
  zlib
  cares
  address_sorting
  ${_gRPC_RE2_LIBRARIES}
  ${_gRPC_ALLTARGETS_LIBRARIES}
  upb_json_lib
  upb_textformat_lib
  re2
  absl::algorithm_container
  absl::no_destructor
  absl::btree
  absl::flat_hash_map
  absl::flat_hash_set
  absl::inlined_vector
  absl::node_hash_map
  absl::function_ref
  absl::hash
  absl::type_traits
  absl::random_bit_gen_ref
  absl::random_distributions
  absl::statusor
  absl::string_view
  absl::span
  absl::utility
  cares
  gpr
  ssl
  crypto
  address_sorting
)
if(_gRPC_PLATFORM_IOS OR _gRPC_PLATFORM_MAC)
  target_link_libraries(grpc PRIVATE "-framework CoreFoundation")
endif()


# Not building test grpc_test_util, private
# Not building test grpc_test_util_unsecure, private

android_add_library(TARGET grpc_unsecure
LICENSE Apache-2.0
URL "https://android.googlesource.com/platform/external/grpc-grpc/+/refs/heads/emu-master-dev"
REPO "${ANDROID_QEMU2_TOP_DIR}/../grpc"
NOTICE "REPO/NOTICE.txt"

SRC # cmake-format: sortable
  ${_gRPC_ROOT}/src/core/call/call_arena_allocator.cc
  ${_gRPC_ROOT}/src/core/call/call_filters.cc
  ${_gRPC_ROOT}/src/core/call/call_spine.cc
  ${_gRPC_ROOT}/src/core/call/call_state.cc
  ${_gRPC_ROOT}/src/core/call/client_call.cc
  ${_gRPC_ROOT}/src/core/call/interception_chain.cc
  ${_gRPC_ROOT}/src/core/call/message.cc
  ${_gRPC_ROOT}/src/core/call/metadata.cc
  ${_gRPC_ROOT}/src/core/call/metadata_batch.cc
  ${_gRPC_ROOT}/src/core/call/metadata_info.cc
  ${_gRPC_ROOT}/src/core/call/parsed_metadata.cc
  ${_gRPC_ROOT}/src/core/call/request_buffer.cc
  ${_gRPC_ROOT}/src/core/call/security_context.cc
  ${_gRPC_ROOT}/src/core/call/server_call.cc
  ${_gRPC_ROOT}/src/core/call/status_util.cc
  ${_gRPC_ROOT}/src/core/channelz/channel_trace.cc
  ${_gRPC_ROOT}/src/core/channelz/channelz.cc
  ${_gRPC_ROOT}/src/core/channelz/channelz_registry.cc
  ${_gRPC_ROOT}/src/core/channelz/property_list.cc
  ${_gRPC_ROOT}/src/core/channelz/text_encode.cc
  ${_gRPC_ROOT}/src/core/client_channel/backup_poller.cc
  ${_gRPC_ROOT}/src/core/client_channel/buffered_call.cc
  ${_gRPC_ROOT}/src/core/client_channel/client_channel.cc
  ${_gRPC_ROOT}/src/core/client_channel/client_channel_factory.cc
  ${_gRPC_ROOT}/src/core/client_channel/client_channel_filter.cc
  ${_gRPC_ROOT}/src/core/client_channel/client_channel_plugin.cc
  ${_gRPC_ROOT}/src/core/client_channel/client_channel_service_config.cc
  ${_gRPC_ROOT}/src/core/client_channel/direct_channel.cc
  ${_gRPC_ROOT}/src/core/client_channel/dynamic_filters.cc
  ${_gRPC_ROOT}/src/core/client_channel/global_subchannel_pool.cc
  ${_gRPC_ROOT}/src/core/client_channel/lb_metadata.cc
  ${_gRPC_ROOT}/src/core/client_channel/load_balanced_call_destination.cc
  ${_gRPC_ROOT}/src/core/client_channel/local_subchannel_pool.cc
  ${_gRPC_ROOT}/src/core/client_channel/retry_filter.cc
  ${_gRPC_ROOT}/src/core/client_channel/retry_filter_legacy_call_data.cc
  ${_gRPC_ROOT}/src/core/client_channel/retry_interceptor.cc
  ${_gRPC_ROOT}/src/core/client_channel/retry_service_config.cc
  ${_gRPC_ROOT}/src/core/client_channel/retry_throttle.cc
  ${_gRPC_ROOT}/src/core/client_channel/subchannel.cc
  ${_gRPC_ROOT}/src/core/client_channel/subchannel_pool_interface.cc
  ${_gRPC_ROOT}/src/core/client_channel/subchannel_stream_client.cc
  ${_gRPC_ROOT}/src/core/client_channel/subchannel_stream_limiter.cc
  ${_gRPC_ROOT}/src/core/config/core_configuration.cc
  ${_gRPC_ROOT}/src/core/credentials/call/call_creds_util.cc
  ${_gRPC_ROOT}/src/core/credentials/call/composite/composite_call_credentials.cc
  ${_gRPC_ROOT}/src/core/credentials/call/json_util.cc
  ${_gRPC_ROOT}/src/core/credentials/call/plugin/plugin_credentials.cc
  ${_gRPC_ROOT}/src/core/credentials/transport/alts/check_gcp_environment.cc
  ${_gRPC_ROOT}/src/core/credentials/transport/alts/check_gcp_environment_linux.cc
  ${_gRPC_ROOT}/src/core/credentials/transport/alts/check_gcp_environment_no_op.cc
  ${_gRPC_ROOT}/src/core/credentials/transport/alts/check_gcp_environment_windows.cc
  ${_gRPC_ROOT}/src/core/credentials/transport/alts/grpc_alts_credentials_client_options.cc
  ${_gRPC_ROOT}/src/core/credentials/transport/alts/grpc_alts_credentials_options.cc
  ${_gRPC_ROOT}/src/core/credentials/transport/alts/grpc_alts_credentials_server_options.cc
  ${_gRPC_ROOT}/src/core/credentials/transport/composite/composite_channel_credentials.cc
  ${_gRPC_ROOT}/src/core/credentials/transport/fake/fake_credentials.cc
  ${_gRPC_ROOT}/src/core/credentials/transport/fake/fake_security_connector.cc
  ${_gRPC_ROOT}/src/core/credentials/transport/insecure/insecure_credentials.cc
  ${_gRPC_ROOT}/src/core/credentials/transport/insecure/insecure_security_connector.cc
  ${_gRPC_ROOT}/src/core/credentials/transport/security_connector.cc
  ${_gRPC_ROOT}/src/core/credentials/transport/tls/certificate_provider_registry.cc
  ${_gRPC_ROOT}/src/core/credentials/transport/tls/load_system_roots_fallback.cc
  ${_gRPC_ROOT}/src/core/credentials/transport/tls/load_system_roots_supported.cc
  ${_gRPC_ROOT}/src/core/credentials/transport/tls/load_system_roots_windows.cc
  ${_gRPC_ROOT}/src/core/credentials/transport/tls/tls_utils.cc
  ${_gRPC_ROOT}/src/core/credentials/transport/transport_credentials.cc
  ${_gRPC_ROOT}/src/core/ext/filters/backend_metrics/backend_metric_filter.cc
  ${_gRPC_ROOT}/src/core/ext/filters/census/grpc_context.cc
  ${_gRPC_ROOT}/src/core/ext/filters/channel_idle/idle_filter_state.cc
  ${_gRPC_ROOT}/src/core/ext/filters/channel_idle/legacy_channel_idle_filter.cc
  ${_gRPC_ROOT}/src/core/ext/filters/fault_injection/fault_injection_filter.cc
  ${_gRPC_ROOT}/src/core/ext/filters/http/client/http_client_filter.cc
  ${_gRPC_ROOT}/src/core/ext/filters/http/client_authority_filter.cc
  ${_gRPC_ROOT}/src/core/ext/filters/http/http_filters_plugin.cc
  ${_gRPC_ROOT}/src/core/ext/filters/http/message_compress/compression_filter.cc
  ${_gRPC_ROOT}/src/core/ext/filters/http/server/http_server_filter.cc
  ${_gRPC_ROOT}/src/core/ext/filters/message_size/message_size_filter.cc
  ${_gRPC_ROOT}/src/core/ext/transport/chttp2/chttp2_plugin.cc
  ${_gRPC_ROOT}/src/core/ext/transport/chttp2/client/chttp2_connector.cc
  ${_gRPC_ROOT}/src/core/ext/transport/chttp2/server/chttp2_server.cc
  ${_gRPC_ROOT}/src/core/ext/transport/chttp2/transport/bin_decoder.cc
  ${_gRPC_ROOT}/src/core/ext/transport/chttp2/transport/bin_encoder.cc
  ${_gRPC_ROOT}/src/core/ext/transport/chttp2/transport/call_tracer_wrapper.cc
  ${_gRPC_ROOT}/src/core/ext/transport/chttp2/transport/chttp2_transport.cc
  ${_gRPC_ROOT}/src/core/ext/transport/chttp2/transport/decode_huff.cc
  ${_gRPC_ROOT}/src/core/ext/transport/chttp2/transport/flow_control.cc
  ${_gRPC_ROOT}/src/core/ext/transport/chttp2/transport/frame.cc
  ${_gRPC_ROOT}/src/core/ext/transport/chttp2/transport/frame_data.cc
  ${_gRPC_ROOT}/src/core/ext/transport/chttp2/transport/frame_goaway.cc
  ${_gRPC_ROOT}/src/core/ext/transport/chttp2/transport/frame_ping.cc
  ${_gRPC_ROOT}/src/core/ext/transport/chttp2/transport/frame_rst_stream.cc
  ${_gRPC_ROOT}/src/core/ext/transport/chttp2/transport/frame_security.cc
  ${_gRPC_ROOT}/src/core/ext/transport/chttp2/transport/frame_settings.cc
  ${_gRPC_ROOT}/src/core/ext/transport/chttp2/transport/frame_window_update.cc
  ${_gRPC_ROOT}/src/core/ext/transport/chttp2/transport/goaway.cc
  ${_gRPC_ROOT}/src/core/ext/transport/chttp2/transport/hpack_encoder.cc
  ${_gRPC_ROOT}/src/core/ext/transport/chttp2/transport/hpack_encoder_table.cc
  ${_gRPC_ROOT}/src/core/ext/transport/chttp2/transport/hpack_parse_result.cc
  ${_gRPC_ROOT}/src/core/ext/transport/chttp2/transport/hpack_parser.cc
  ${_gRPC_ROOT}/src/core/ext/transport/chttp2/transport/hpack_parser_table.cc
  ${_gRPC_ROOT}/src/core/ext/transport/chttp2/transport/http2_client_transport.cc
  ${_gRPC_ROOT}/src/core/ext/transport/chttp2/transport/http2_server_transport.cc
  ${_gRPC_ROOT}/src/core/ext/transport/chttp2/transport/http2_settings.cc
  ${_gRPC_ROOT}/src/core/ext/transport/chttp2/transport/http2_settings_manager.cc
  ${_gRPC_ROOT}/src/core/ext/transport/chttp2/transport/http2_stats_collector.cc
  ${_gRPC_ROOT}/src/core/ext/transport/chttp2/transport/http2_transport.cc
  ${_gRPC_ROOT}/src/core/ext/transport/chttp2/transport/huffsyms.cc
  ${_gRPC_ROOT}/src/core/ext/transport/chttp2/transport/keepalive.cc
  ${_gRPC_ROOT}/src/core/ext/transport/chttp2/transport/parsing.cc
  ${_gRPC_ROOT}/src/core/ext/transport/chttp2/transport/ping_abuse_policy.cc
  ${_gRPC_ROOT}/src/core/ext/transport/chttp2/transport/ping_callbacks.cc
  ${_gRPC_ROOT}/src/core/ext/transport/chttp2/transport/ping_promise.cc
  ${_gRPC_ROOT}/src/core/ext/transport/chttp2/transport/ping_rate_policy.cc
  ${_gRPC_ROOT}/src/core/ext/transport/chttp2/transport/stream_lists.cc
  ${_gRPC_ROOT}/src/core/ext/transport/chttp2/transport/transport_common.cc
  ${_gRPC_ROOT}/src/core/ext/transport/chttp2/transport/varint.cc
  ${_gRPC_ROOT}/src/core/ext/transport/chttp2/transport/write_cycle.cc
  ${_gRPC_ROOT}/src/core/ext/transport/chttp2/transport/write_size_policy.cc
  ${_gRPC_ROOT}/src/core/ext/transport/chttp2/transport/writing.cc
  ${_gRPC_ROOT}/src/core/ext/transport/inproc/inproc_transport.cc
  ${_gRPC_ROOT}/src/core/ext/transport/inproc/legacy_inproc_transport.cc
  ${_gRPC_ROOT}/src/core/ext/upb-gen/google/api/http.upb_minitable.c
  ${_gRPC_ROOT}/src/core/ext/upb-gen/google/protobuf/any.upb_minitable.c
  ${_gRPC_ROOT}/src/core/ext/upb-gen/google/protobuf/descriptor.upb_minitable.c
  ${_gRPC_ROOT}/src/core/ext/upb-gen/google/protobuf/duration.upb_minitable.c
  ${_gRPC_ROOT}/src/core/ext/upb-gen/google/protobuf/empty.upb_minitable.c
  ${_gRPC_ROOT}/src/core/ext/upb-gen/google/protobuf/struct.upb_minitable.c
  ${_gRPC_ROOT}/src/core/ext/upb-gen/google/protobuf/timestamp.upb_minitable.c
  ${_gRPC_ROOT}/src/core/ext/upb-gen/google/protobuf/wrappers.upb_minitable.c
  ${_gRPC_ROOT}/src/core/ext/upb-gen/google/rpc/status.upb_minitable.c
  ${_gRPC_ROOT}/src/core/ext/upb-gen/src/proto/grpc/channelz/v2/channelz.upb_minitable.c
  ${_gRPC_ROOT}/src/core/ext/upb-gen/src/proto/grpc/channelz/v2/promise.upb_minitable.c
  ${_gRPC_ROOT}/src/core/ext/upb-gen/src/proto/grpc/channelz/v2/property_list.upb_minitable.c
  ${_gRPC_ROOT}/src/core/ext/upb-gen/src/proto/grpc/channelz/v2/service.upb_minitable.c
  ${_gRPC_ROOT}/src/core/ext/upb-gen/src/proto/grpc/gcp/altscontext.upb_minitable.c
  ${_gRPC_ROOT}/src/core/ext/upb-gen/src/proto/grpc/gcp/handshaker.upb_minitable.c
  ${_gRPC_ROOT}/src/core/ext/upb-gen/src/proto/grpc/gcp/transport_security_common.upb_minitable.c
  ${_gRPC_ROOT}/src/core/ext/upb-gen/src/proto/grpc/health/v1/health.upb_minitable.c
  ${_gRPC_ROOT}/src/core/ext/upb-gen/src/proto/grpc/lb/v1/load_balancer.upb_minitable.c
  ${_gRPC_ROOT}/src/core/ext/upb-gen/src/proto/grpc/lookup/v1/rls.upb_minitable.c
  ${_gRPC_ROOT}/src/core/ext/upb-gen/validate/validate.upb_minitable.c
  ${_gRPC_ROOT}/src/core/ext/upb-gen/xds/data/orca/v3/orca_load_report.upb_minitable.c
  ${_gRPC_ROOT}/src/core/ext/upb-gen/xds/service/orca/v3/orca.upb_minitable.c
  ${_gRPC_ROOT}/src/core/ext/upbdefs-gen/google/protobuf/any.upbdefs.c
  ${_gRPC_ROOT}/src/core/ext/upbdefs-gen/google/protobuf/duration.upbdefs.c
  ${_gRPC_ROOT}/src/core/ext/upbdefs-gen/google/protobuf/empty.upbdefs.c
  ${_gRPC_ROOT}/src/core/ext/upbdefs-gen/google/protobuf/timestamp.upbdefs.c
  ${_gRPC_ROOT}/src/core/ext/upbdefs-gen/src/proto/grpc/channelz/v2/channelz.upbdefs.c
  ${_gRPC_ROOT}/src/core/ext/upbdefs-gen/src/proto/grpc/channelz/v2/promise.upbdefs.c
  ${_gRPC_ROOT}/src/core/ext/upbdefs-gen/src/proto/grpc/channelz/v2/property_list.upbdefs.c
  ${_gRPC_ROOT}/src/core/ext/upbdefs-gen/src/proto/grpc/channelz/v2/service.upbdefs.c
  ${_gRPC_ROOT}/src/core/filter/auth/client_auth_filter.cc
  ${_gRPC_ROOT}/src/core/filter/auth/server_auth_filter.cc
  ${_gRPC_ROOT}/src/core/filter/fused_filters.cc
  ${_gRPC_ROOT}/src/core/handshaker/endpoint_info/endpoint_info_handshaker.cc
  ${_gRPC_ROOT}/src/core/handshaker/handshaker.cc
  ${_gRPC_ROOT}/src/core/handshaker/handshaker_registry.cc
  ${_gRPC_ROOT}/src/core/handshaker/http_connect/http_connect_client_handshaker.cc
  ${_gRPC_ROOT}/src/core/handshaker/http_connect/http_proxy_mapper.cc
  ${_gRPC_ROOT}/src/core/handshaker/proxy_mapper_registry.cc
  ${_gRPC_ROOT}/src/core/handshaker/security/pipelined_secure_endpoint.cc
  ${_gRPC_ROOT}/src/core/handshaker/security/secure_endpoint.cc
  ${_gRPC_ROOT}/src/core/handshaker/security/security_handshaker.cc
  ${_gRPC_ROOT}/src/core/handshaker/tcp_connect/tcp_connect_handshaker.cc
  ${_gRPC_ROOT}/src/core/lib/address_utils/parse_address.cc
  ${_gRPC_ROOT}/src/core/lib/address_utils/sockaddr_utils.cc
  ${_gRPC_ROOT}/src/core/lib/channel/channel_args.cc
  ${_gRPC_ROOT}/src/core/lib/channel/channel_args_preconditioning.cc
  ${_gRPC_ROOT}/src/core/lib/channel/channel_stack.cc
  ${_gRPC_ROOT}/src/core/lib/channel/channel_stack_builder.cc
  ${_gRPC_ROOT}/src/core/lib/channel/channel_stack_builder_impl.cc
  ${_gRPC_ROOT}/src/core/lib/channel/connected_channel.cc
  ${_gRPC_ROOT}/src/core/lib/channel/promise_based_filter.cc
  ${_gRPC_ROOT}/src/core/lib/compression/compression.cc
  ${_gRPC_ROOT}/src/core/lib/compression/compression_internal.cc
  ${_gRPC_ROOT}/src/core/lib/compression/message_compress.cc
  ${_gRPC_ROOT}/src/core/lib/debug/trace.cc
  ${_gRPC_ROOT}/src/core/lib/debug/trace_flags.cc
  ${_gRPC_ROOT}/src/core/lib/event_engine/ares_resolver.cc
  ${_gRPC_ROOT}/src/core/lib/event_engine/cf_engine/cf_engine.cc
  ${_gRPC_ROOT}/src/core/lib/event_engine/cf_engine/cfsocket_listener.cc
  ${_gRPC_ROOT}/src/core/lib/event_engine/cf_engine/cfstream_endpoint.cc
  ${_gRPC_ROOT}/src/core/lib/event_engine/cf_engine/dns_service_resolver.cc
  ${_gRPC_ROOT}/src/core/lib/event_engine/channel_args_endpoint_config.cc
  ${_gRPC_ROOT}/src/core/lib/event_engine/default_event_engine.cc
  ${_gRPC_ROOT}/src/core/lib/event_engine/default_event_engine_factory.cc
  ${_gRPC_ROOT}/src/core/lib/event_engine/endpoint_channel_arg_wrapper.cc
  ${_gRPC_ROOT}/src/core/lib/event_engine/event_engine.cc
  ${_gRPC_ROOT}/src/core/lib/event_engine/posix_engine/ev_epoll1_linux.cc
  ${_gRPC_ROOT}/src/core/lib/event_engine/posix_engine/ev_poll_posix.cc
  ${_gRPC_ROOT}/src/core/lib/event_engine/posix_engine/event_poller_posix_default.cc
  ${_gRPC_ROOT}/src/core/lib/event_engine/posix_engine/file_descriptor_collection.cc
  ${_gRPC_ROOT}/src/core/lib/event_engine/posix_engine/internal_errqueue.cc
  ${_gRPC_ROOT}/src/core/lib/event_engine/posix_engine/lockfree_event.cc
  ${_gRPC_ROOT}/src/core/lib/event_engine/posix_engine/native_posix_dns_resolver.cc
  ${_gRPC_ROOT}/src/core/lib/event_engine/posix_engine/posix_endpoint.cc
  ${_gRPC_ROOT}/src/core/lib/event_engine/posix_engine/posix_engine.cc
  ${_gRPC_ROOT}/src/core/lib/event_engine/posix_engine/posix_engine_listener.cc
  ${_gRPC_ROOT}/src/core/lib/event_engine/posix_engine/posix_engine_listener_utils.cc
  ${_gRPC_ROOT}/src/core/lib/event_engine/posix_engine/posix_interface_posix.cc
  ${_gRPC_ROOT}/src/core/lib/event_engine/posix_engine/posix_interface_windows.cc
  ${_gRPC_ROOT}/src/core/lib/event_engine/posix_engine/posix_write_event_sink.cc
  ${_gRPC_ROOT}/src/core/lib/event_engine/posix_engine/set_socket_dualstack.cc
  ${_gRPC_ROOT}/src/core/lib/event_engine/posix_engine/tcp_socket_utils.cc
  ${_gRPC_ROOT}/src/core/lib/event_engine/posix_engine/timer.cc
  ${_gRPC_ROOT}/src/core/lib/event_engine/posix_engine/timer_heap.cc
  ${_gRPC_ROOT}/src/core/lib/event_engine/posix_engine/timer_manager.cc
  ${_gRPC_ROOT}/src/core/lib/event_engine/posix_engine/traced_buffer_list.cc
  ${_gRPC_ROOT}/src/core/lib/event_engine/posix_engine/wakeup_fd_eventfd.cc
  ${_gRPC_ROOT}/src/core/lib/event_engine/posix_engine/wakeup_fd_pipe.cc
  ${_gRPC_ROOT}/src/core/lib/event_engine/posix_engine/wakeup_fd_posix_default.cc
  ${_gRPC_ROOT}/src/core/lib/event_engine/resolved_address.cc
  ${_gRPC_ROOT}/src/core/lib/event_engine/shim.cc
  ${_gRPC_ROOT}/src/core/lib/event_engine/slice.cc
  ${_gRPC_ROOT}/src/core/lib/event_engine/slice_buffer.cc
  ${_gRPC_ROOT}/src/core/lib/event_engine/tcp_socket_utils.cc
  ${_gRPC_ROOT}/src/core/lib/event_engine/thread_pool/thread_count.cc
  ${_gRPC_ROOT}/src/core/lib/event_engine/thread_pool/thread_pool_factory.cc
  ${_gRPC_ROOT}/src/core/lib/event_engine/thread_pool/work_stealing_thread_pool.cc
  ${_gRPC_ROOT}/src/core/lib/event_engine/thready_event_engine/thready_event_engine.cc
  ${_gRPC_ROOT}/src/core/lib/event_engine/time_util.cc
  ${_gRPC_ROOT}/src/core/lib/event_engine/utils.cc
  ${_gRPC_ROOT}/src/core/lib/event_engine/windows/grpc_polled_fd_windows.cc
  ${_gRPC_ROOT}/src/core/lib/event_engine/windows/iocp.cc
  ${_gRPC_ROOT}/src/core/lib/event_engine/windows/native_windows_dns_resolver.cc
  ${_gRPC_ROOT}/src/core/lib/event_engine/windows/win_socket.cc
  ${_gRPC_ROOT}/src/core/lib/event_engine/windows/windows_endpoint.cc
  ${_gRPC_ROOT}/src/core/lib/event_engine/windows/windows_engine.cc
  ${_gRPC_ROOT}/src/core/lib/event_engine/windows/windows_listener.cc
  ${_gRPC_ROOT}/src/core/lib/event_engine/work_queue/basic_work_queue.cc
  ${_gRPC_ROOT}/src/core/lib/experiments/config.cc
  ${_gRPC_ROOT}/src/core/lib/experiments/experiments.cc
  ${_gRPC_ROOT}/src/core/lib/iomgr/buffer_list.cc
  ${_gRPC_ROOT}/src/core/lib/iomgr/call_combiner.cc
  ${_gRPC_ROOT}/src/core/lib/iomgr/cfstream_handle.cc
  ${_gRPC_ROOT}/src/core/lib/iomgr/closure.cc
  ${_gRPC_ROOT}/src/core/lib/iomgr/combiner.cc
  ${_gRPC_ROOT}/src/core/lib/iomgr/dualstack_socket_posix.cc
  ${_gRPC_ROOT}/src/core/lib/iomgr/endpoint.cc
  ${_gRPC_ROOT}/src/core/lib/iomgr/endpoint_cfstream.cc
  ${_gRPC_ROOT}/src/core/lib/iomgr/endpoint_pair_posix.cc
  ${_gRPC_ROOT}/src/core/lib/iomgr/endpoint_pair_windows.cc
  ${_gRPC_ROOT}/src/core/lib/iomgr/error.cc
  ${_gRPC_ROOT}/src/core/lib/iomgr/error_cfstream.cc
  ${_gRPC_ROOT}/src/core/lib/iomgr/ev_apple.cc
  ${_gRPC_ROOT}/src/core/lib/iomgr/ev_epoll1_linux.cc
  ${_gRPC_ROOT}/src/core/lib/iomgr/ev_poll_posix.cc
  ${_gRPC_ROOT}/src/core/lib/iomgr/ev_posix.cc
  ${_gRPC_ROOT}/src/core/lib/iomgr/event_engine_shims/closure.cc
  ${_gRPC_ROOT}/src/core/lib/iomgr/event_engine_shims/endpoint.cc
  ${_gRPC_ROOT}/src/core/lib/iomgr/event_engine_shims/tcp_client.cc
  ${_gRPC_ROOT}/src/core/lib/iomgr/exec_ctx.cc
  ${_gRPC_ROOT}/src/core/lib/iomgr/fork_posix.cc
  ${_gRPC_ROOT}/src/core/lib/iomgr/fork_windows.cc
  ${_gRPC_ROOT}/src/core/lib/iomgr/internal_errqueue.cc
  ${_gRPC_ROOT}/src/core/lib/iomgr/iocp_windows.cc
  ${_gRPC_ROOT}/src/core/lib/iomgr/iomgr.cc
  ${_gRPC_ROOT}/src/core/lib/iomgr/iomgr_internal.cc
  ${_gRPC_ROOT}/src/core/lib/iomgr/iomgr_posix.cc
  ${_gRPC_ROOT}/src/core/lib/iomgr/iomgr_posix_cfstream.cc
  ${_gRPC_ROOT}/src/core/lib/iomgr/iomgr_windows.cc
  ${_gRPC_ROOT}/src/core/lib/iomgr/lockfree_event.cc
  ${_gRPC_ROOT}/src/core/lib/iomgr/polling_entity.cc
  ${_gRPC_ROOT}/src/core/lib/iomgr/pollset.cc
  ${_gRPC_ROOT}/src/core/lib/iomgr/pollset_set.cc
  ${_gRPC_ROOT}/src/core/lib/iomgr/pollset_set_windows.cc
  ${_gRPC_ROOT}/src/core/lib/iomgr/pollset_windows.cc
  ${_gRPC_ROOT}/src/core/lib/iomgr/resolve_address.cc
  ${_gRPC_ROOT}/src/core/lib/iomgr/resolve_address_posix.cc
  ${_gRPC_ROOT}/src/core/lib/iomgr/resolve_address_windows.cc
  ${_gRPC_ROOT}/src/core/lib/iomgr/sockaddr_utils_posix.cc
  ${_gRPC_ROOT}/src/core/lib/iomgr/socket_factory_posix.cc
  ${_gRPC_ROOT}/src/core/lib/iomgr/socket_mutator.cc
  ${_gRPC_ROOT}/src/core/lib/iomgr/socket_utils_common_posix.cc
  ${_gRPC_ROOT}/src/core/lib/iomgr/socket_utils_linux.cc
  ${_gRPC_ROOT}/src/core/lib/iomgr/socket_utils_posix.cc
  ${_gRPC_ROOT}/src/core/lib/iomgr/socket_utils_windows.cc
  ${_gRPC_ROOT}/src/core/lib/iomgr/socket_windows.cc
  ${_gRPC_ROOT}/src/core/lib/iomgr/systemd_utils.cc
  ${_gRPC_ROOT}/src/core/lib/iomgr/tcp_client.cc
  ${_gRPC_ROOT}/src/core/lib/iomgr/tcp_client_cfstream.cc
  ${_gRPC_ROOT}/src/core/lib/iomgr/tcp_client_posix.cc
  ${_gRPC_ROOT}/src/core/lib/iomgr/tcp_client_windows.cc
  ${_gRPC_ROOT}/src/core/lib/iomgr/tcp_posix.cc
  ${_gRPC_ROOT}/src/core/lib/iomgr/tcp_server.cc
  ${_gRPC_ROOT}/src/core/lib/iomgr/tcp_server_posix.cc
  ${_gRPC_ROOT}/src/core/lib/iomgr/tcp_server_utils_posix_common.cc
  ${_gRPC_ROOT}/src/core/lib/iomgr/tcp_server_utils_posix_ifaddrs.cc
  ${_gRPC_ROOT}/src/core/lib/iomgr/tcp_server_utils_posix_noifaddrs.cc
  ${_gRPC_ROOT}/src/core/lib/iomgr/tcp_server_windows.cc
  ${_gRPC_ROOT}/src/core/lib/iomgr/tcp_windows.cc
  ${_gRPC_ROOT}/src/core/lib/iomgr/timer.cc
  ${_gRPC_ROOT}/src/core/lib/iomgr/timer_generic.cc
  ${_gRPC_ROOT}/src/core/lib/iomgr/timer_heap.cc
  ${_gRPC_ROOT}/src/core/lib/iomgr/timer_manager.cc
  ${_gRPC_ROOT}/src/core/lib/iomgr/unix_sockets_posix.cc
  ${_gRPC_ROOT}/src/core/lib/iomgr/unix_sockets_posix_noop.cc
  ${_gRPC_ROOT}/src/core/lib/iomgr/vsock.cc
  ${_gRPC_ROOT}/src/core/lib/iomgr/wakeup_fd_eventfd.cc
  ${_gRPC_ROOT}/src/core/lib/iomgr/wakeup_fd_nospecial.cc
  ${_gRPC_ROOT}/src/core/lib/iomgr/wakeup_fd_pipe.cc
  ${_gRPC_ROOT}/src/core/lib/iomgr/wakeup_fd_posix.cc
  ${_gRPC_ROOT}/src/core/lib/promise/activity.cc
  ${_gRPC_ROOT}/src/core/lib/promise/mpsc.cc
  ${_gRPC_ROOT}/src/core/lib/promise/party.cc
  ${_gRPC_ROOT}/src/core/lib/promise/sleep.cc
  ${_gRPC_ROOT}/src/core/lib/promise/wait_set.cc
  ${_gRPC_ROOT}/src/core/lib/resource_quota/api.cc
  ${_gRPC_ROOT}/src/core/lib/resource_quota/arena.cc
  ${_gRPC_ROOT}/src/core/lib/resource_quota/connection_quota.cc
  ${_gRPC_ROOT}/src/core/lib/resource_quota/memory_quota.cc
  ${_gRPC_ROOT}/src/core/lib/resource_quota/periodic_update.cc
  ${_gRPC_ROOT}/src/core/lib/resource_quota/resource_quota.cc
  ${_gRPC_ROOT}/src/core/lib/resource_quota/stream_quota.cc
  ${_gRPC_ROOT}/src/core/lib/resource_quota/telemetry.cc
  ${_gRPC_ROOT}/src/core/lib/resource_quota/thread_quota.cc
  ${_gRPC_ROOT}/src/core/lib/resource_tracker/resource_tracker.cc
  ${_gRPC_ROOT}/src/core/lib/security/authorization/authorization_policy_provider_vtable.cc
  ${_gRPC_ROOT}/src/core/lib/security/authorization/evaluate_args.cc
  ${_gRPC_ROOT}/src/core/lib/security/authorization/grpc_server_authz_filter.cc
  ${_gRPC_ROOT}/src/core/lib/slice/percent_encoding.cc
  ${_gRPC_ROOT}/src/core/lib/slice/slice.cc
  ${_gRPC_ROOT}/src/core/lib/slice/slice_buffer.cc
  ${_gRPC_ROOT}/src/core/lib/slice/slice_string_helpers.cc
  ${_gRPC_ROOT}/src/core/lib/surface/byte_buffer.cc
  ${_gRPC_ROOT}/src/core/lib/surface/byte_buffer_reader.cc
  ${_gRPC_ROOT}/src/core/lib/surface/call.cc
  ${_gRPC_ROOT}/src/core/lib/surface/call_details.cc
  ${_gRPC_ROOT}/src/core/lib/surface/call_log_batch.cc
  ${_gRPC_ROOT}/src/core/lib/surface/call_utils.cc
  ${_gRPC_ROOT}/src/core/lib/surface/channel.cc
  ${_gRPC_ROOT}/src/core/lib/surface/channel_create.cc
  ${_gRPC_ROOT}/src/core/lib/surface/channel_init.cc
  ${_gRPC_ROOT}/src/core/lib/surface/channel_stack_type.cc
  ${_gRPC_ROOT}/src/core/lib/surface/completion_queue.cc
  ${_gRPC_ROOT}/src/core/lib/surface/completion_queue_factory.cc
  ${_gRPC_ROOT}/src/core/lib/surface/connection_context.cc
  ${_gRPC_ROOT}/src/core/lib/surface/event_string.cc
  ${_gRPC_ROOT}/src/core/lib/surface/filter_stack_call.cc
  ${_gRPC_ROOT}/src/core/lib/surface/init.cc
  ${_gRPC_ROOT}/src/core/lib/surface/init_internally.cc
  ${_gRPC_ROOT}/src/core/lib/surface/lame_client.cc
  ${_gRPC_ROOT}/src/core/lib/surface/legacy_channel.cc
  ${_gRPC_ROOT}/src/core/lib/surface/metadata_array.cc
  ${_gRPC_ROOT}/src/core/lib/surface/validate_metadata.cc
  ${_gRPC_ROOT}/src/core/lib/surface/version.cc
  ${_gRPC_ROOT}/src/core/lib/transport/bdp_estimator.cc
  ${_gRPC_ROOT}/src/core/lib/transport/call_final_info.cc
  ${_gRPC_ROOT}/src/core/lib/transport/connectivity_state.cc
  ${_gRPC_ROOT}/src/core/lib/transport/error_utils.cc
  ${_gRPC_ROOT}/src/core/lib/transport/promise_endpoint.cc
  ${_gRPC_ROOT}/src/core/lib/transport/status_conversion.cc
  ${_gRPC_ROOT}/src/core/lib/transport/timeout_encoding.cc
  ${_gRPC_ROOT}/src/core/lib/transport/transport.cc
  ${_gRPC_ROOT}/src/core/lib/transport/transport_op_string.cc
  ${_gRPC_ROOT}/src/core/load_balancing/address_filtering.cc
  ${_gRPC_ROOT}/src/core/load_balancing/backend_metric_parser.cc
  ${_gRPC_ROOT}/src/core/load_balancing/child_policy_handler.cc
  ${_gRPC_ROOT}/src/core/load_balancing/endpoint_list.cc
  ${_gRPC_ROOT}/src/core/load_balancing/grpclb/client_load_reporting_filter.cc
  ${_gRPC_ROOT}/src/core/load_balancing/grpclb/grpclb.cc
  ${_gRPC_ROOT}/src/core/load_balancing/grpclb/grpclb_balancer_addresses.cc
  ${_gRPC_ROOT}/src/core/load_balancing/grpclb/grpclb_client_stats.cc
  ${_gRPC_ROOT}/src/core/load_balancing/grpclb/load_balancer_api.cc
  ${_gRPC_ROOT}/src/core/load_balancing/health_check_client.cc
  ${_gRPC_ROOT}/src/core/load_balancing/lb_policy.cc
  ${_gRPC_ROOT}/src/core/load_balancing/lb_policy_registry.cc
  ${_gRPC_ROOT}/src/core/load_balancing/oob_backend_metric.cc
  ${_gRPC_ROOT}/src/core/load_balancing/outlier_detection/outlier_detection.cc
  ${_gRPC_ROOT}/src/core/load_balancing/pick_first/pick_first.cc
  ${_gRPC_ROOT}/src/core/load_balancing/priority/priority.cc
  ${_gRPC_ROOT}/src/core/load_balancing/ring_hash/ring_hash.cc
  ${_gRPC_ROOT}/src/core/load_balancing/rls/rls.cc
  ${_gRPC_ROOT}/src/core/load_balancing/round_robin/round_robin.cc
  ${_gRPC_ROOT}/src/core/load_balancing/weighted_round_robin/static_stride_scheduler.cc
  ${_gRPC_ROOT}/src/core/load_balancing/weighted_round_robin/weighted_round_robin.cc
  ${_gRPC_ROOT}/src/core/load_balancing/weighted_target/weighted_target.cc
  ${_gRPC_ROOT}/src/core/net/socket_mutator.cc
  ${_gRPC_ROOT}/src/core/plugin_registry/grpc_plugin_registry.cc
  ${_gRPC_ROOT}/src/core/plugin_registry/grpc_plugin_registry_noextra.cc
  ${_gRPC_ROOT}/src/core/resolver/dns/c_ares/dns_resolver_ares.cc
  ${_gRPC_ROOT}/src/core/resolver/dns/c_ares/grpc_ares_ev_driver_posix.cc
  ${_gRPC_ROOT}/src/core/resolver/dns/c_ares/grpc_ares_ev_driver_windows.cc
  ${_gRPC_ROOT}/src/core/resolver/dns/c_ares/grpc_ares_wrapper.cc
  ${_gRPC_ROOT}/src/core/resolver/dns/c_ares/grpc_ares_wrapper_posix.cc
  ${_gRPC_ROOT}/src/core/resolver/dns/c_ares/grpc_ares_wrapper_windows.cc
  ${_gRPC_ROOT}/src/core/resolver/dns/dns_resolver_plugin.cc
  ${_gRPC_ROOT}/src/core/resolver/dns/event_engine/event_engine_client_channel_resolver.cc
  ${_gRPC_ROOT}/src/core/resolver/dns/event_engine/service_config_helper.cc
  ${_gRPC_ROOT}/src/core/resolver/dns/native/dns_resolver.cc
  ${_gRPC_ROOT}/src/core/resolver/endpoint_addresses.cc
  ${_gRPC_ROOT}/src/core/resolver/fake/fake_resolver.cc
  ${_gRPC_ROOT}/src/core/resolver/polling_resolver.cc
  ${_gRPC_ROOT}/src/core/resolver/resolver.cc
  ${_gRPC_ROOT}/src/core/resolver/resolver_registry.cc
  ${_gRPC_ROOT}/src/core/resolver/sockaddr/sockaddr_resolver.cc
  ${_gRPC_ROOT}/src/core/server/add_port.cc
  ${_gRPC_ROOT}/src/core/server/server.cc
  ${_gRPC_ROOT}/src/core/server/server_call_tracer_filter.cc
  ${_gRPC_ROOT}/src/core/service_config/service_config_channel_arg_filter.cc
  ${_gRPC_ROOT}/src/core/service_config/service_config_impl.cc
  ${_gRPC_ROOT}/src/core/service_config/service_config_parser.cc
  ${_gRPC_ROOT}/src/core/telemetry/call_tracer.cc
  ${_gRPC_ROOT}/src/core/telemetry/context_list_entry.cc
  ${_gRPC_ROOT}/src/core/telemetry/default_tcp_tracer.cc
  ${_gRPC_ROOT}/src/core/telemetry/histogram_view.cc
  ${_gRPC_ROOT}/src/core/telemetry/instrument.cc
  ${_gRPC_ROOT}/src/core/telemetry/metrics.cc
  ${_gRPC_ROOT}/src/core/telemetry/stats.cc
  ${_gRPC_ROOT}/src/core/telemetry/stats_data.cc
  ${_gRPC_ROOT}/src/core/telemetry/tcp_tracer.cc
  ${_gRPC_ROOT}/src/core/transport/auth_context.cc
  ${_gRPC_ROOT}/src/core/transport/endpoint_transport_client_channel_factory.cc
  ${_gRPC_ROOT}/src/core/transport/message_size_service_config.cc
  ${_gRPC_ROOT}/src/core/transport/session_endpoint.cc
  ${_gRPC_ROOT}/src/core/tsi/alts/handshaker/transport_security_common_api.cc
  ${_gRPC_ROOT}/src/core/tsi/fake_transport_security.cc
  ${_gRPC_ROOT}/src/core/tsi/local_transport_security.cc
  ${_gRPC_ROOT}/src/core/tsi/transport_security.cc
  ${_gRPC_ROOT}/src/core/tsi/transport_security_grpc.cc
  ${_gRPC_ROOT}/src/core/util/backoff.cc
  ${_gRPC_ROOT}/src/core/util/dump_args.cc
  ${_gRPC_ROOT}/src/core/util/event_log.cc
  ${_gRPC_ROOT}/src/core/util/gethostname_fallback.cc
  ${_gRPC_ROOT}/src/core/util/gethostname_host_name_max.cc
  ${_gRPC_ROOT}/src/core/util/gethostname_sysconf.cc
  ${_gRPC_ROOT}/src/core/util/glob.cc
  ${_gRPC_ROOT}/src/core/util/grpc_check.cc
  ${_gRPC_ROOT}/src/core/util/grpc_if_nametoindex_posix.cc
  ${_gRPC_ROOT}/src/core/util/grpc_if_nametoindex_unsupported.cc
  ${_gRPC_ROOT}/src/core/util/http_client/format_request.cc
  ${_gRPC_ROOT}/src/core/util/http_client/httpcli.cc
  ${_gRPC_ROOT}/src/core/util/http_client/parser.cc
  ${_gRPC_ROOT}/src/core/util/json/json_object_loader.cc
  ${_gRPC_ROOT}/src/core/util/json/json_reader.cc
  ${_gRPC_ROOT}/src/core/util/json/json_writer.cc
  ${_gRPC_ROOT}/src/core/util/latent_see.cc
  ${_gRPC_ROOT}/src/core/util/load_file.cc
  ${_gRPC_ROOT}/src/core/util/per_cpu.cc
  ${_gRPC_ROOT}/src/core/util/postmortem_emit.cc
  ${_gRPC_ROOT}/src/core/util/random_early_detection.cc
  ${_gRPC_ROOT}/src/core/util/ref_counted_string.cc
  ${_gRPC_ROOT}/src/core/util/shared_bit_gen.cc
  ${_gRPC_ROOT}/src/core/util/status_helper.cc
  ${_gRPC_ROOT}/src/core/util/time.cc
  ${_gRPC_ROOT}/src/core/util/time_averaged_stats.cc
  ${_gRPC_ROOT}/src/core/util/uri.cc
  ${_gRPC_ROOT}/src/core/util/uuid_v4.cc
  ${_gRPC_ROOT}/src/core/util/validation_errors.cc
  ${_gRPC_ROOT}/src/core/util/wait_for_single_owner.cc
  ${_gRPC_ROOT}/src/core/util/work_serializer.cc
)



target_include_directories(grpc_unsecure
  PUBLIC  ${_gRPC_ROOT}/include
  PRIVATE
    ${_gRPC_ROOT}
    ${_gRPC_ADDRESS_SORTING_INCLUDE_DIR}
    ${_gRPC_RE2_INCLUDE_DIR}
    ${_gRPC_SSL_INCLUDE_DIR}
    ${_gRPC_UPB_GENERATED_DIR}
    ${_gRPC_UPB_GRPC_GENERATED_DIR}
    ${_gRPC_UPB_INCLUDE_DIR}
    ${_gRPC_XXHASH_INCLUDE_DIR}
    ${_gRPC_ZLIB_INCLUDE_DIR}
)
target_link_libraries(grpc_unsecure PUBLIC
  ${_gRPC_BASELIB_LIBRARIES}
  zlib
  cares
  address_sorting
  ${_gRPC_RE2_LIBRARIES}
  ${_gRPC_ALLTARGETS_LIBRARIES}
  upb_textformat_lib
  absl::algorithm_container
  absl::no_destructor
  absl::btree
  absl::flat_hash_map
  absl::flat_hash_set
  absl::inlined_vector
  absl::node_hash_map
  absl::function_ref
  absl::hash
  absl::type_traits
  absl::random_bit_gen_ref
  absl::random_distributions
  absl::statusor
  absl::string_view
  absl::span
  absl::utility
  cares
  gpr
  address_sorting
)
if(_gRPC_PLATFORM_IOS OR _gRPC_PLATFORM_MAC)
  target_link_libraries(grpc_unsecure PRIVATE "-framework CoreFoundation")
endif()


# Not building test gtest, private

android_add_library(TARGET upb_base_lib
LICENSE Apache-2.0
URL "https://android.googlesource.com/platform/external/grpc-grpc/+/refs/heads/emu-master-dev"
REPO "${ANDROID_QEMU2_TOP_DIR}/../grpc"
NOTICE "REPO/NOTICE.txt"

SRC # cmake-format: sortable
  ${_gRPC_ROOT}/third_party/upb/upb/base/status.c
)



target_include_directories(upb_base_lib
  PUBLIC  ${_gRPC_ROOT}/include
  PRIVATE
    ${_gRPC_ROOT}
    ${_gRPC_ADDRESS_SORTING_INCLUDE_DIR}
    ${_gRPC_RE2_INCLUDE_DIR}
    ${_gRPC_SSL_INCLUDE_DIR}
    ${_gRPC_UPB_GENERATED_DIR}
    ${_gRPC_UPB_GRPC_GENERATED_DIR}
    ${_gRPC_UPB_INCLUDE_DIR}
    ${_gRPC_XXHASH_INCLUDE_DIR}
    ${_gRPC_ZLIB_INCLUDE_DIR}
)
target_link_libraries(upb_base_lib PUBLIC
  ${_gRPC_ALLTARGETS_LIBRARIES}
)



android_add_library(TARGET upb_descriptor_lib
LICENSE Apache-2.0
URL "https://android.googlesource.com/platform/external/grpc-grpc/+/refs/heads/emu-master-dev"
REPO "${ANDROID_QEMU2_TOP_DIR}/../grpc"
NOTICE "REPO/NOTICE.txt"

SRC # cmake-format: sortable
  ${_gRPC_ROOT}/src/core/ext/upb-gen/google/protobuf/descriptor.upb_minitable.c
)



target_include_directories(upb_descriptor_lib
  PUBLIC  ${_gRPC_ROOT}/include
  PRIVATE
    ${_gRPC_ROOT}
    ${_gRPC_ADDRESS_SORTING_INCLUDE_DIR}
    ${_gRPC_RE2_INCLUDE_DIR}
    ${_gRPC_SSL_INCLUDE_DIR}
    ${_gRPC_UPB_GENERATED_DIR}
    ${_gRPC_UPB_GRPC_GENERATED_DIR}
    ${_gRPC_UPB_INCLUDE_DIR}
    ${_gRPC_XXHASH_INCLUDE_DIR}
    ${_gRPC_ZLIB_INCLUDE_DIR}
)
target_link_libraries(upb_descriptor_lib PUBLIC
  ${_gRPC_ALLTARGETS_LIBRARIES}
)



android_add_library(TARGET upb_hash_lib
LICENSE Apache-2.0
URL "https://android.googlesource.com/platform/external/grpc-grpc/+/refs/heads/emu-master-dev"
REPO "${ANDROID_QEMU2_TOP_DIR}/../grpc"
NOTICE "REPO/NOTICE.txt"

SRC # cmake-format: sortable
  ${_gRPC_ROOT}/third_party/upb/upb/hash/common.c
)



target_include_directories(upb_hash_lib
  PUBLIC  ${_gRPC_ROOT}/include
  PRIVATE
    ${_gRPC_ROOT}
    ${_gRPC_ADDRESS_SORTING_INCLUDE_DIR}
    ${_gRPC_RE2_INCLUDE_DIR}
    ${_gRPC_SSL_INCLUDE_DIR}
    ${_gRPC_UPB_GENERATED_DIR}
    ${_gRPC_UPB_GRPC_GENERATED_DIR}
    ${_gRPC_UPB_INCLUDE_DIR}
    ${_gRPC_XXHASH_INCLUDE_DIR}
    ${_gRPC_ZLIB_INCLUDE_DIR}
)
target_link_libraries(upb_hash_lib PUBLIC
  ${_gRPC_ALLTARGETS_LIBRARIES}
  upb_base_lib
  upb_mem_lib
)



android_add_library(TARGET upb_json_lib
LICENSE Apache-2.0
URL "https://android.googlesource.com/platform/external/grpc-grpc/+/refs/heads/emu-master-dev"
REPO "${ANDROID_QEMU2_TOP_DIR}/../grpc"
NOTICE "REPO/NOTICE.txt"

SRC # cmake-format: sortable
  ${_gRPC_ROOT}/third_party/upb/upb/json/decode.c
  ${_gRPC_ROOT}/third_party/upb/upb/json/encode.c
)



target_include_directories(upb_json_lib
  PUBLIC  ${_gRPC_ROOT}/include
  PRIVATE
    ${_gRPC_ROOT}
    ${_gRPC_ADDRESS_SORTING_INCLUDE_DIR}
    ${_gRPC_RE2_INCLUDE_DIR}
    ${_gRPC_SSL_INCLUDE_DIR}
    ${_gRPC_UPB_GENERATED_DIR}
    ${_gRPC_UPB_GRPC_GENERATED_DIR}
    ${_gRPC_UPB_INCLUDE_DIR}
    ${_gRPC_XXHASH_INCLUDE_DIR}
    ${_gRPC_ZLIB_INCLUDE_DIR}
)
target_link_libraries(upb_json_lib PUBLIC
  ${_gRPC_ALLTARGETS_LIBRARIES}
  upb_lex_lib
  upb_reflection_lib
)



android_add_library(TARGET upb_lex_lib
LICENSE Apache-2.0
URL "https://android.googlesource.com/platform/external/grpc-grpc/+/refs/heads/emu-master-dev"
REPO "${ANDROID_QEMU2_TOP_DIR}/../grpc"
NOTICE "REPO/NOTICE.txt"

SRC # cmake-format: sortable
  ${_gRPC_ROOT}/third_party/upb/upb/lex/atoi.c
  ${_gRPC_ROOT}/third_party/upb/upb/lex/round_trip.c
  ${_gRPC_ROOT}/third_party/upb/upb/lex/strtod.c
  ${_gRPC_ROOT}/third_party/upb/upb/lex/unicode.c
)



target_include_directories(upb_lex_lib
  PUBLIC  ${_gRPC_ROOT}/include
  PRIVATE
    ${_gRPC_ROOT}
    ${_gRPC_ADDRESS_SORTING_INCLUDE_DIR}
    ${_gRPC_RE2_INCLUDE_DIR}
    ${_gRPC_SSL_INCLUDE_DIR}
    ${_gRPC_UPB_GENERATED_DIR}
    ${_gRPC_UPB_GRPC_GENERATED_DIR}
    ${_gRPC_UPB_INCLUDE_DIR}
    ${_gRPC_XXHASH_INCLUDE_DIR}
    ${_gRPC_ZLIB_INCLUDE_DIR}
)
target_link_libraries(upb_lex_lib PUBLIC
  ${_gRPC_ALLTARGETS_LIBRARIES}
)



android_add_library(TARGET upb_mem_lib
LICENSE Apache-2.0
URL "https://android.googlesource.com/platform/external/grpc-grpc/+/refs/heads/emu-master-dev"
REPO "${ANDROID_QEMU2_TOP_DIR}/../grpc"
NOTICE "REPO/NOTICE.txt"

SRC # cmake-format: sortable
  ${_gRPC_ROOT}/third_party/upb/upb/mem/alloc.c
  ${_gRPC_ROOT}/third_party/upb/upb/mem/arena.c
)



target_include_directories(upb_mem_lib
  PUBLIC  ${_gRPC_ROOT}/include
  PRIVATE
    ${_gRPC_ROOT}
    ${_gRPC_ADDRESS_SORTING_INCLUDE_DIR}
    ${_gRPC_RE2_INCLUDE_DIR}
    ${_gRPC_SSL_INCLUDE_DIR}
    ${_gRPC_UPB_GENERATED_DIR}
    ${_gRPC_UPB_GRPC_GENERATED_DIR}
    ${_gRPC_UPB_INCLUDE_DIR}
    ${_gRPC_XXHASH_INCLUDE_DIR}
    ${_gRPC_ZLIB_INCLUDE_DIR}
)
target_link_libraries(upb_mem_lib PUBLIC
  ${_gRPC_ALLTARGETS_LIBRARIES}
)



android_add_library(TARGET upb_message_lib
LICENSE Apache-2.0
URL "https://android.googlesource.com/platform/external/grpc-grpc/+/refs/heads/emu-master-dev"
REPO "${ANDROID_QEMU2_TOP_DIR}/../grpc"
NOTICE "REPO/NOTICE.txt"

SRC # cmake-format: sortable
  ${_gRPC_ROOT}/third_party/upb/upb/message/accessors.c
  ${_gRPC_ROOT}/third_party/upb/upb/message/array.c
  ${_gRPC_ROOT}/third_party/upb/upb/message/compat.c
  ${_gRPC_ROOT}/third_party/upb/upb/message/internal/extension.c
  ${_gRPC_ROOT}/third_party/upb/upb/message/internal/message.c
  ${_gRPC_ROOT}/third_party/upb/upb/message/map.c
  ${_gRPC_ROOT}/third_party/upb/upb/message/map_sorter.c
  ${_gRPC_ROOT}/third_party/upb/upb/message/message.c
)



target_include_directories(upb_message_lib
  PUBLIC  ${_gRPC_ROOT}/include
  PRIVATE
    ${_gRPC_ROOT}
    ${_gRPC_ADDRESS_SORTING_INCLUDE_DIR}
    ${_gRPC_RE2_INCLUDE_DIR}
    ${_gRPC_SSL_INCLUDE_DIR}
    ${_gRPC_UPB_GENERATED_DIR}
    ${_gRPC_UPB_GRPC_GENERATED_DIR}
    ${_gRPC_UPB_INCLUDE_DIR}
    ${_gRPC_XXHASH_INCLUDE_DIR}
    ${_gRPC_ZLIB_INCLUDE_DIR}
)
target_link_libraries(upb_message_lib PUBLIC
  ${_gRPC_ALLTARGETS_LIBRARIES}
  upb_mini_table_lib
)



android_add_library(TARGET upb_mini_descriptor_lib
LICENSE Apache-2.0
URL "https://android.googlesource.com/platform/external/grpc-grpc/+/refs/heads/emu-master-dev"
REPO "${ANDROID_QEMU2_TOP_DIR}/../grpc"
NOTICE "REPO/NOTICE.txt"

SRC # cmake-format: sortable
  ${_gRPC_ROOT}/third_party/upb/upb/mini_descriptor/build_enum.c
  ${_gRPC_ROOT}/third_party/upb/upb/mini_descriptor/decode.c
  ${_gRPC_ROOT}/third_party/upb/upb/mini_descriptor/internal/base92.c
  ${_gRPC_ROOT}/third_party/upb/upb/mini_descriptor/internal/encode.c
  ${_gRPC_ROOT}/third_party/upb/upb/mini_descriptor/link.c
  ${_gRPC_ROOT}/third_party/upb/upb/wire/decode_fast/select.c
  ${_gRPC_ROOT}/third_party/upb/upb/wire/eps_copy_input_stream.c
  ${_gRPC_ROOT}/third_party/upb/upb/wire/reader.c
)



target_include_directories(upb_mini_descriptor_lib
  PUBLIC  ${_gRPC_ROOT}/include
  PRIVATE
    ${_gRPC_ROOT}
    ${_gRPC_ADDRESS_SORTING_INCLUDE_DIR}
    ${_gRPC_RE2_INCLUDE_DIR}
    ${_gRPC_SSL_INCLUDE_DIR}
    ${_gRPC_UPB_GENERATED_DIR}
    ${_gRPC_UPB_GRPC_GENERATED_DIR}
    ${_gRPC_UPB_INCLUDE_DIR}
    ${_gRPC_XXHASH_INCLUDE_DIR}
    ${_gRPC_ZLIB_INCLUDE_DIR}
)
target_link_libraries(upb_mini_descriptor_lib PUBLIC
  ${_gRPC_ALLTARGETS_LIBRARIES}
  upb_mini_table_lib
  absl::strings
)



android_add_library(TARGET upb_mini_table_lib
LICENSE Apache-2.0
URL "https://android.googlesource.com/platform/external/grpc-grpc/+/refs/heads/emu-master-dev"
REPO "${ANDROID_QEMU2_TOP_DIR}/../grpc"
NOTICE "REPO/NOTICE.txt"

SRC # cmake-format: sortable
  ${_gRPC_ROOT}/third_party/upb/upb/mini_table/extension_registry.c
  ${_gRPC_ROOT}/third_party/upb/upb/mini_table/generated_registry.c
  ${_gRPC_ROOT}/third_party/upb/upb/mini_table/internal/message.c
  ${_gRPC_ROOT}/third_party/upb/upb/mini_table/message.c
)



target_include_directories(upb_mini_table_lib
  PUBLIC  ${_gRPC_ROOT}/include
  PRIVATE
    ${_gRPC_ROOT}
    ${_gRPC_ADDRESS_SORTING_INCLUDE_DIR}
    ${_gRPC_RE2_INCLUDE_DIR}
    ${_gRPC_SSL_INCLUDE_DIR}
    ${_gRPC_UPB_GENERATED_DIR}
    ${_gRPC_UPB_GRPC_GENERATED_DIR}
    ${_gRPC_UPB_INCLUDE_DIR}
    ${_gRPC_XXHASH_INCLUDE_DIR}
    ${_gRPC_ZLIB_INCLUDE_DIR}
)
target_link_libraries(upb_mini_table_lib PUBLIC
  ${_gRPC_ALLTARGETS_LIBRARIES}
  upb_hash_lib
)



android_add_library(TARGET upb_reflection_lib
LICENSE Apache-2.0
URL "https://android.googlesource.com/platform/external/grpc-grpc/+/refs/heads/emu-master-dev"
REPO "${ANDROID_QEMU2_TOP_DIR}/../grpc"
NOTICE "REPO/NOTICE.txt"

SRC # cmake-format: sortable
  ${_gRPC_ROOT}/third_party/upb/upb/message/copy.c
  ${_gRPC_ROOT}/third_party/upb/upb/message/merge.c
  ${_gRPC_ROOT}/third_party/upb/upb/reflection/def_pool.c
  ${_gRPC_ROOT}/third_party/upb/upb/reflection/def_type.c
  ${_gRPC_ROOT}/third_party/upb/upb/reflection/desc_state.c
  ${_gRPC_ROOT}/third_party/upb/upb/reflection/enum_def.c
  ${_gRPC_ROOT}/third_party/upb/upb/reflection/enum_reserved_range.c
  ${_gRPC_ROOT}/third_party/upb/upb/reflection/enum_value_def.c
  ${_gRPC_ROOT}/third_party/upb/upb/reflection/extension_range.c
  ${_gRPC_ROOT}/third_party/upb/upb/reflection/field_def.c
  ${_gRPC_ROOT}/third_party/upb/upb/reflection/file_def.c
  ${_gRPC_ROOT}/third_party/upb/upb/reflection/internal/def_builder.c
  ${_gRPC_ROOT}/third_party/upb/upb/reflection/internal/strdup2.c
  ${_gRPC_ROOT}/third_party/upb/upb/reflection/message.c
  ${_gRPC_ROOT}/third_party/upb/upb/reflection/message_def.c
  ${_gRPC_ROOT}/third_party/upb/upb/reflection/message_reserved_range.c
  ${_gRPC_ROOT}/third_party/upb/upb/reflection/method_def.c
  ${_gRPC_ROOT}/third_party/upb/upb/reflection/oneof_def.c
  ${_gRPC_ROOT}/third_party/upb/upb/reflection/service_def.c
)



target_include_directories(upb_reflection_lib
  PUBLIC  ${_gRPC_ROOT}/include
  PRIVATE
    ${_gRPC_ROOT}
    ${_gRPC_ADDRESS_SORTING_INCLUDE_DIR}
    ${_gRPC_RE2_INCLUDE_DIR}
    ${_gRPC_SSL_INCLUDE_DIR}
    ${_gRPC_UPB_GENERATED_DIR}
    ${_gRPC_UPB_GRPC_GENERATED_DIR}
    ${_gRPC_UPB_INCLUDE_DIR}
    ${_gRPC_XXHASH_INCLUDE_DIR}
    ${_gRPC_ZLIB_INCLUDE_DIR}
)
target_link_libraries(upb_reflection_lib PUBLIC
  ${_gRPC_ALLTARGETS_LIBRARIES}
  upb_mini_descriptor_lib
  upb_descriptor_lib
  upb_wire_lib
)



android_add_library(TARGET upb_textformat_lib
LICENSE Apache-2.0
URL "https://android.googlesource.com/platform/external/grpc-grpc/+/refs/heads/emu-master-dev"
REPO "${ANDROID_QEMU2_TOP_DIR}/../grpc"
NOTICE "REPO/NOTICE.txt"

SRC # cmake-format: sortable
  ${_gRPC_ROOT}/third_party/upb/upb/text/encode.c
  ${_gRPC_ROOT}/third_party/upb/upb/text/internal/encode.c
)



target_include_directories(upb_textformat_lib
  PUBLIC  ${_gRPC_ROOT}/include
  PRIVATE
    ${_gRPC_ROOT}
    ${_gRPC_ADDRESS_SORTING_INCLUDE_DIR}
    ${_gRPC_RE2_INCLUDE_DIR}
    ${_gRPC_SSL_INCLUDE_DIR}
    ${_gRPC_UPB_GENERATED_DIR}
    ${_gRPC_UPB_GRPC_GENERATED_DIR}
    ${_gRPC_UPB_INCLUDE_DIR}
    ${_gRPC_XXHASH_INCLUDE_DIR}
    ${_gRPC_ZLIB_INCLUDE_DIR}
)
target_link_libraries(upb_textformat_lib PUBLIC
  ${_gRPC_ALLTARGETS_LIBRARIES}
  upb_lex_lib
  upb_reflection_lib
)



android_add_library(TARGET upb_wire_lib
LICENSE Apache-2.0
URL "https://android.googlesource.com/platform/external/grpc-grpc/+/refs/heads/emu-master-dev"
REPO "${ANDROID_QEMU2_TOP_DIR}/../grpc"
NOTICE "REPO/NOTICE.txt"

SRC # cmake-format: sortable
  ${_gRPC_ROOT}/third_party/upb/upb/message/internal/iterator.c
  ${_gRPC_ROOT}/third_party/upb/upb/wire/decode.c
  ${_gRPC_ROOT}/third_party/upb/upb/wire/encode.c
  ${_gRPC_ROOT}/third_party/upb/upb/wire/eps_copy_input_stream.c
  ${_gRPC_ROOT}/third_party/upb/upb/wire/internal/decoder.c
  ${_gRPC_ROOT}/third_party/upb/upb/wire/reader.c
)



target_include_directories(upb_wire_lib
  PUBLIC  ${_gRPC_ROOT}/include
  PRIVATE
    ${_gRPC_ROOT}
    ${_gRPC_ADDRESS_SORTING_INCLUDE_DIR}
    ${_gRPC_RE2_INCLUDE_DIR}
    ${_gRPC_SSL_INCLUDE_DIR}
    ${_gRPC_UPB_GENERATED_DIR}
    ${_gRPC_UPB_GRPC_GENERATED_DIR}
    ${_gRPC_UPB_INCLUDE_DIR}
    ${_gRPC_XXHASH_INCLUDE_DIR}
    ${_gRPC_ZLIB_INCLUDE_DIR}
)
target_link_libraries(upb_wire_lib PUBLIC
  ${_gRPC_ALLTARGETS_LIBRARIES}
  utf8_range_lib
  upb_message_lib
)



android_add_library(TARGET utf8_range_lib
LICENSE Apache-2.0
URL "https://android.googlesource.com/platform/external/grpc-grpc/+/refs/heads/emu-master-dev"
REPO "${ANDROID_QEMU2_TOP_DIR}/../grpc"
NOTICE "REPO/NOTICE.txt"

SRC # cmake-format: sortable
  ${_gRPC_ROOT}/third_party/utf8_range/utf8_range.c
)



target_include_directories(utf8_range_lib
  PUBLIC  ${_gRPC_ROOT}/include
  PRIVATE
    ${_gRPC_ROOT}
    ${_gRPC_ADDRESS_SORTING_INCLUDE_DIR}
    ${_gRPC_RE2_INCLUDE_DIR}
    ${_gRPC_SSL_INCLUDE_DIR}
    ${_gRPC_UPB_GENERATED_DIR}
    ${_gRPC_UPB_GRPC_GENERATED_DIR}
    ${_gRPC_UPB_INCLUDE_DIR}
    ${_gRPC_XXHASH_INCLUDE_DIR}
    ${_gRPC_ZLIB_INCLUDE_DIR}
)
target_link_libraries(utf8_range_lib PUBLIC
  ${_gRPC_ALLTARGETS_LIBRARIES}
)


# Not building test benchmark_helpers, test

android_add_library(TARGET grpc++
LICENSE Apache-2.0
URL "https://android.googlesource.com/platform/external/grpc-grpc/+/refs/heads/emu-master-dev"
REPO "${ANDROID_QEMU2_TOP_DIR}/../grpc"
NOTICE "REPO/NOTICE.txt"

SRC # cmake-format: sortable
  ${_gRPC_ROOT}/src/core/client_channel/virtual_channel.cc
  ${_gRPC_ROOT}/src/cpp/client/call_context_registry.cc
  ${_gRPC_ROOT}/src/cpp/client/call_credentials.cc
  ${_gRPC_ROOT}/src/cpp/client/channel_cc.cc
  ${_gRPC_ROOT}/src/cpp/client/channel_credentials.cc
  ${_gRPC_ROOT}/src/cpp/client/client_callback.cc
  ${_gRPC_ROOT}/src/cpp/client/client_context.cc
  ${_gRPC_ROOT}/src/cpp/client/client_interceptor.cc
  ${_gRPC_ROOT}/src/cpp/client/client_stats_interceptor.cc
  ${_gRPC_ROOT}/src/cpp/client/create_channel.cc
  ${_gRPC_ROOT}/src/cpp/client/create_channel_internal.cc
  ${_gRPC_ROOT}/src/cpp/client/create_channel_posix.cc
  ${_gRPC_ROOT}/src/cpp/client/global_callback_hook.cc
  ${_gRPC_ROOT}/src/cpp/client/insecure_credentials.cc
  ${_gRPC_ROOT}/src/cpp/client/secure_credentials.cc
  ${_gRPC_ROOT}/src/cpp/client/xds_credentials.cc
  ${_gRPC_ROOT}/src/cpp/common/alarm.cc
  ${_gRPC_ROOT}/src/cpp/common/auth_property_iterator.cc
  ${_gRPC_ROOT}/src/cpp/common/channel_arguments.cc
  ${_gRPC_ROOT}/src/cpp/common/completion_queue_cc.cc
  ${_gRPC_ROOT}/src/cpp/common/resource_quota_cc.cc
  ${_gRPC_ROOT}/src/cpp/common/rpc_method.cc
  ${_gRPC_ROOT}/src/cpp/common/secure_auth_context.cc
  ${_gRPC_ROOT}/src/cpp/common/secure_create_auth_context.cc
  ${_gRPC_ROOT}/src/cpp/common/tls_certificate_provider.cc
  ${_gRPC_ROOT}/src/cpp/common/tls_certificate_verifier.cc
  ${_gRPC_ROOT}/src/cpp/common/tls_credentials_options.cc
  ${_gRPC_ROOT}/src/cpp/common/validate_service_config.cc
  ${_gRPC_ROOT}/src/cpp/common/version_cc.cc
  ${_gRPC_ROOT}/src/cpp/server/async_generic_service.cc
  ${_gRPC_ROOT}/src/cpp/server/backend_metric_recorder.cc
  ${_gRPC_ROOT}/src/cpp/server/channel_argument_option.cc
  ${_gRPC_ROOT}/src/cpp/server/create_default_thread_pool.cc
  ${_gRPC_ROOT}/src/cpp/server/external_connection_acceptor_impl.cc
  ${_gRPC_ROOT}/src/cpp/server/health/default_health_check_service.cc
  ${_gRPC_ROOT}/src/cpp/server/health/health_check_service.cc
  ${_gRPC_ROOT}/src/cpp/server/health/health_check_service_server_builder_option.cc
  ${_gRPC_ROOT}/src/cpp/server/insecure_server_credentials.cc
  ${_gRPC_ROOT}/src/cpp/server/secure_server_credentials.cc
  ${_gRPC_ROOT}/src/cpp/server/server_builder.cc
  ${_gRPC_ROOT}/src/cpp/server/server_callback.cc
  ${_gRPC_ROOT}/src/cpp/server/server_cc.cc
  ${_gRPC_ROOT}/src/cpp/server/server_context.cc
  ${_gRPC_ROOT}/src/cpp/server/server_credentials.cc
  ${_gRPC_ROOT}/src/cpp/server/server_posix.cc
  ${_gRPC_ROOT}/src/cpp/server/xds_server_builder.cc
  ${_gRPC_ROOT}/src/cpp/server/xds_server_credentials.cc
  ${_gRPC_ROOT}/src/cpp/thread_manager/thread_manager.cc
  ${_gRPC_ROOT}/src/cpp/util/byte_buffer_cc.cc
  ${_gRPC_ROOT}/src/cpp/util/status.cc
  ${_gRPC_ROOT}/src/cpp/util/string_ref.cc
  ${_gRPC_ROOT}/src/cpp/util/time_cc.cc
)



target_include_directories(grpc++
  PUBLIC  ${_gRPC_ROOT}/include
  PRIVATE
    ${_gRPC_ROOT}
    ${_gRPC_ADDRESS_SORTING_INCLUDE_DIR}
    ${_gRPC_RE2_INCLUDE_DIR}
    ${_gRPC_SSL_INCLUDE_DIR}
    ${_gRPC_UPB_GENERATED_DIR}
    ${_gRPC_UPB_GRPC_GENERATED_DIR}
    ${_gRPC_UPB_INCLUDE_DIR}
    ${_gRPC_XXHASH_INCLUDE_DIR}
    ${_gRPC_ZLIB_INCLUDE_DIR}
    ${_gRPC_PROTO_GENS_DIR}
)
target_link_libraries(grpc++ PUBLIC
  ${_gRPC_BASELIB_LIBRARIES}
  libprotobuf
  ${_gRPC_ALLTARGETS_LIBRARIES}
  absl::dynamic_annotations
  absl::prefetch
  absl::layout
  absl::absl_check
  absl::absl_log
  absl::charset
  absl::strings_internal
  grpc
)



android_add_library(TARGET grpc++_alts
LICENSE Apache-2.0
URL "https://android.googlesource.com/platform/external/grpc-grpc/+/refs/heads/emu-master-dev"
REPO "${ANDROID_QEMU2_TOP_DIR}/../grpc"
NOTICE "REPO/NOTICE.txt"

SRC # cmake-format: sortable
  ${_gRPC_ROOT}/src/cpp/common/alts_context.cc
  ${_gRPC_ROOT}/src/cpp/common/alts_util.cc
)



target_include_directories(grpc++_alts
  PUBLIC  ${_gRPC_ROOT}/include
  PRIVATE
    ${_gRPC_ROOT}
    ${_gRPC_ADDRESS_SORTING_INCLUDE_DIR}
    ${_gRPC_RE2_INCLUDE_DIR}
    ${_gRPC_SSL_INCLUDE_DIR}
    ${_gRPC_UPB_GENERATED_DIR}
    ${_gRPC_UPB_GRPC_GENERATED_DIR}
    ${_gRPC_UPB_INCLUDE_DIR}
    ${_gRPC_XXHASH_INCLUDE_DIR}
    ${_gRPC_ZLIB_INCLUDE_DIR}
    ${_gRPC_PROTO_GENS_DIR}
)
target_link_libraries(grpc++_alts PUBLIC
  ${_gRPC_BASELIB_LIBRARIES}
  libprotobuf
  ${_gRPC_ALLTARGETS_LIBRARIES}
  grpc++
)



android_add_library(TARGET grpc++_error_details
LICENSE Apache-2.0
URL "https://android.googlesource.com/platform/external/grpc-grpc/+/refs/heads/emu-master-dev"
REPO "${ANDROID_QEMU2_TOP_DIR}/../grpc"
NOTICE "REPO/NOTICE.txt"

SRC # cmake-format: sortable
  ${_gRPC_ROOT}/src/cpp/util/error_details.cc
)



target_include_directories(grpc++_error_details
  PUBLIC  ${_gRPC_ROOT}/include
  PRIVATE
    ${_gRPC_ROOT}
    ${_gRPC_ADDRESS_SORTING_INCLUDE_DIR}
    ${_gRPC_RE2_INCLUDE_DIR}
    ${_gRPC_SSL_INCLUDE_DIR}
    ${_gRPC_UPB_GENERATED_DIR}
    ${_gRPC_UPB_GRPC_GENERATED_DIR}
    ${_gRPC_UPB_INCLUDE_DIR}
    ${_gRPC_XXHASH_INCLUDE_DIR}
    ${_gRPC_ZLIB_INCLUDE_DIR}
    ${_gRPC_PROTO_GENS_DIR}
)
target_link_libraries(grpc++_error_details PUBLIC
  libprotobuf
  ${_gRPC_ALLTARGETS_LIBRARIES}
  grpc++
)



if(gRPC_BUILD_CODEGEN)
android_add_library(TARGET grpc++_reflection
LICENSE Apache-2.0
URL "https://android.googlesource.com/platform/external/grpc-grpc/+/refs/heads/emu-master-dev"
REPO "${ANDROID_QEMU2_TOP_DIR}/../grpc"
NOTICE "REPO/NOTICE.txt"

SRC # cmake-format: sortable
  ${_gRPC_PROTO_GENS_DIR}/src/proto/grpc/reflection/v1/reflection.pb.cc
  ${_gRPC_PROTO_GENS_DIR}/src/proto/grpc/reflection/v1/reflection.grpc.pb.cc
  ${_gRPC_PROTO_GENS_DIR}/src/proto/grpc/reflection/v1/reflection.pb.h
  ${_gRPC_PROTO_GENS_DIR}/src/proto/grpc/reflection/v1/reflection.grpc.pb.h
  ${_gRPC_PROTO_GENS_DIR}/src/proto/grpc/reflection/v1alpha/reflection.pb.cc
  ${_gRPC_PROTO_GENS_DIR}/src/proto/grpc/reflection/v1alpha/reflection.grpc.pb.cc
  ${_gRPC_PROTO_GENS_DIR}/src/proto/grpc/reflection/v1alpha/reflection.pb.h
  ${_gRPC_PROTO_GENS_DIR}/src/proto/grpc/reflection/v1alpha/reflection.grpc.pb.h
  ${_gRPC_ROOT}/src/cpp/ext/proto_server_reflection.cc
  ${_gRPC_ROOT}/src/cpp/ext/proto_server_reflection_plugin.cc
)



target_include_directories(grpc++_reflection
  PUBLIC  ${_gRPC_ROOT}/include
  PRIVATE
    ${_gRPC_ROOT}
    ${_gRPC_ADDRESS_SORTING_INCLUDE_DIR}
    ${_gRPC_RE2_INCLUDE_DIR}
    ${_gRPC_SSL_INCLUDE_DIR}
    ${_gRPC_UPB_GENERATED_DIR}
    ${_gRPC_UPB_GRPC_GENERATED_DIR}
    ${_gRPC_UPB_INCLUDE_DIR}
    ${_gRPC_XXHASH_INCLUDE_DIR}
    ${_gRPC_ZLIB_INCLUDE_DIR}
    ${_gRPC_PROTO_GENS_DIR}
)
target_link_libraries(grpc++_reflection PUBLIC
  libprotobuf
  ${_gRPC_ALLTARGETS_LIBRARIES}
  grpc++
)

endif()

# Not building test grpc++_test, private
# Not building test grpc++_test_config, private
# Not building test grpc++_test_util, private

android_add_library(TARGET grpc++_unsecure
LICENSE Apache-2.0
URL "https://android.googlesource.com/platform/external/grpc-grpc/+/refs/heads/emu-master-dev"
REPO "${ANDROID_QEMU2_TOP_DIR}/../grpc"
NOTICE "REPO/NOTICE.txt"

SRC # cmake-format: sortable
  ${_gRPC_ROOT}/src/core/client_channel/virtual_channel.cc
  ${_gRPC_ROOT}/src/cpp/client/call_context_registry.cc
  ${_gRPC_ROOT}/src/cpp/client/call_credentials.cc
  ${_gRPC_ROOT}/src/cpp/client/channel_cc.cc
  ${_gRPC_ROOT}/src/cpp/client/channel_credentials.cc
  ${_gRPC_ROOT}/src/cpp/client/client_callback.cc
  ${_gRPC_ROOT}/src/cpp/client/client_context.cc
  ${_gRPC_ROOT}/src/cpp/client/client_interceptor.cc
  ${_gRPC_ROOT}/src/cpp/client/client_stats_interceptor.cc
  ${_gRPC_ROOT}/src/cpp/client/create_channel.cc
  ${_gRPC_ROOT}/src/cpp/client/create_channel_internal.cc
  ${_gRPC_ROOT}/src/cpp/client/create_channel_posix.cc
  ${_gRPC_ROOT}/src/cpp/client/global_callback_hook.cc
  ${_gRPC_ROOT}/src/cpp/client/insecure_credentials.cc
  ${_gRPC_ROOT}/src/cpp/common/alarm.cc
  ${_gRPC_ROOT}/src/cpp/common/channel_arguments.cc
  ${_gRPC_ROOT}/src/cpp/common/completion_queue_cc.cc
  ${_gRPC_ROOT}/src/cpp/common/insecure_create_auth_context.cc
  ${_gRPC_ROOT}/src/cpp/common/resource_quota_cc.cc
  ${_gRPC_ROOT}/src/cpp/common/rpc_method.cc
  ${_gRPC_ROOT}/src/cpp/common/validate_service_config.cc
  ${_gRPC_ROOT}/src/cpp/common/version_cc.cc
  ${_gRPC_ROOT}/src/cpp/server/async_generic_service.cc
  ${_gRPC_ROOT}/src/cpp/server/backend_metric_recorder.cc
  ${_gRPC_ROOT}/src/cpp/server/channel_argument_option.cc
  ${_gRPC_ROOT}/src/cpp/server/create_default_thread_pool.cc
  ${_gRPC_ROOT}/src/cpp/server/external_connection_acceptor_impl.cc
  ${_gRPC_ROOT}/src/cpp/server/health/default_health_check_service.cc
  ${_gRPC_ROOT}/src/cpp/server/health/health_check_service.cc
  ${_gRPC_ROOT}/src/cpp/server/health/health_check_service_server_builder_option.cc
  ${_gRPC_ROOT}/src/cpp/server/insecure_server_credentials.cc
  ${_gRPC_ROOT}/src/cpp/server/server_builder.cc
  ${_gRPC_ROOT}/src/cpp/server/server_callback.cc
  ${_gRPC_ROOT}/src/cpp/server/server_cc.cc
  ${_gRPC_ROOT}/src/cpp/server/server_context.cc
  ${_gRPC_ROOT}/src/cpp/server/server_credentials.cc
  ${_gRPC_ROOT}/src/cpp/server/server_posix.cc
  ${_gRPC_ROOT}/src/cpp/thread_manager/thread_manager.cc
  ${_gRPC_ROOT}/src/cpp/util/byte_buffer_cc.cc
  ${_gRPC_ROOT}/src/cpp/util/status.cc
  ${_gRPC_ROOT}/src/cpp/util/string_ref.cc
  ${_gRPC_ROOT}/src/cpp/util/time_cc.cc
)



target_include_directories(grpc++_unsecure
  PUBLIC  ${_gRPC_ROOT}/include
  PRIVATE
    ${_gRPC_ROOT}
    ${_gRPC_ADDRESS_SORTING_INCLUDE_DIR}
    ${_gRPC_RE2_INCLUDE_DIR}
    ${_gRPC_SSL_INCLUDE_DIR}
    ${_gRPC_UPB_GENERATED_DIR}
    ${_gRPC_UPB_GRPC_GENERATED_DIR}
    ${_gRPC_UPB_INCLUDE_DIR}
    ${_gRPC_XXHASH_INCLUDE_DIR}
    ${_gRPC_ZLIB_INCLUDE_DIR}
    ${_gRPC_PROTO_GENS_DIR}
)
target_link_libraries(grpc++_unsecure PUBLIC
  ${_gRPC_BASELIB_LIBRARIES}
  libprotobuf
  ${_gRPC_ALLTARGETS_LIBRARIES}
  absl::dynamic_annotations
  absl::prefetch
  absl::layout
  absl::absl_check
  absl::absl_log
  absl::charset
  absl::strings_internal
  grpc_unsecure
)



android_add_library(TARGET grpc_authorization_provider
LICENSE Apache-2.0
URL "https://android.googlesource.com/platform/external/grpc-grpc/+/refs/heads/emu-master-dev"
REPO "${ANDROID_QEMU2_TOP_DIR}/../grpc"
NOTICE "REPO/NOTICE.txt"

SRC # cmake-format: sortable
  ${_gRPC_ROOT}/src/core/call/call_arena_allocator.cc
  ${_gRPC_ROOT}/src/core/call/call_filters.cc
  ${_gRPC_ROOT}/src/core/call/call_spine.cc
  ${_gRPC_ROOT}/src/core/call/call_state.cc
  ${_gRPC_ROOT}/src/core/call/client_call.cc
  ${_gRPC_ROOT}/src/core/call/interception_chain.cc
  ${_gRPC_ROOT}/src/core/call/message.cc
  ${_gRPC_ROOT}/src/core/call/metadata.cc
  ${_gRPC_ROOT}/src/core/call/metadata_batch.cc
  ${_gRPC_ROOT}/src/core/call/parsed_metadata.cc
  ${_gRPC_ROOT}/src/core/call/security_context.cc
  ${_gRPC_ROOT}/src/core/call/server_call.cc
  ${_gRPC_ROOT}/src/core/call/status_util.cc
  ${_gRPC_ROOT}/src/core/channelz/channel_trace.cc
  ${_gRPC_ROOT}/src/core/channelz/channelz.cc
  ${_gRPC_ROOT}/src/core/channelz/channelz_registry.cc
  ${_gRPC_ROOT}/src/core/channelz/property_list.cc
  ${_gRPC_ROOT}/src/core/channelz/text_encode.cc
  ${_gRPC_ROOT}/src/core/config/core_configuration.cc
  ${_gRPC_ROOT}/src/core/credentials/call/call_creds_util.cc
  ${_gRPC_ROOT}/src/core/credentials/call/composite/composite_call_credentials.cc
  ${_gRPC_ROOT}/src/core/credentials/call/json_util.cc
  ${_gRPC_ROOT}/src/core/credentials/call/plugin/plugin_credentials.cc
  ${_gRPC_ROOT}/src/core/credentials/transport/alts/check_gcp_environment.cc
  ${_gRPC_ROOT}/src/core/credentials/transport/alts/check_gcp_environment_linux.cc
  ${_gRPC_ROOT}/src/core/credentials/transport/alts/check_gcp_environment_no_op.cc
  ${_gRPC_ROOT}/src/core/credentials/transport/alts/check_gcp_environment_windows.cc
  ${_gRPC_ROOT}/src/core/credentials/transport/alts/grpc_alts_credentials_client_options.cc
  ${_gRPC_ROOT}/src/core/credentials/transport/alts/grpc_alts_credentials_options.cc
  ${_gRPC_ROOT}/src/core/credentials/transport/alts/grpc_alts_credentials_server_options.cc
  ${_gRPC_ROOT}/src/core/credentials/transport/composite/composite_channel_credentials.cc
  ${_gRPC_ROOT}/src/core/credentials/transport/security_connector.cc
  ${_gRPC_ROOT}/src/core/credentials/transport/tls/certificate_provider_registry.cc
  ${_gRPC_ROOT}/src/core/credentials/transport/tls/load_system_roots_fallback.cc
  ${_gRPC_ROOT}/src/core/credentials/transport/tls/load_system_roots_supported.cc
  ${_gRPC_ROOT}/src/core/credentials/transport/tls/load_system_roots_windows.cc
  ${_gRPC_ROOT}/src/core/credentials/transport/tls/tls_utils.cc
  ${_gRPC_ROOT}/src/core/credentials/transport/transport_credentials.cc
  ${_gRPC_ROOT}/src/core/ext/upb-gen/google/protobuf/any.upb_minitable.c
  ${_gRPC_ROOT}/src/core/ext/upb-gen/google/protobuf/duration.upb_minitable.c
  ${_gRPC_ROOT}/src/core/ext/upb-gen/google/protobuf/empty.upb_minitable.c
  ${_gRPC_ROOT}/src/core/ext/upb-gen/google/protobuf/timestamp.upb_minitable.c
  ${_gRPC_ROOT}/src/core/ext/upb-gen/google/rpc/status.upb_minitable.c
  ${_gRPC_ROOT}/src/core/ext/upb-gen/src/proto/grpc/channelz/v2/channelz.upb_minitable.c
  ${_gRPC_ROOT}/src/core/ext/upb-gen/src/proto/grpc/channelz/v2/promise.upb_minitable.c
  ${_gRPC_ROOT}/src/core/ext/upb-gen/src/proto/grpc/channelz/v2/property_list.upb_minitable.c
  ${_gRPC_ROOT}/src/core/ext/upb-gen/src/proto/grpc/channelz/v2/service.upb_minitable.c
  ${_gRPC_ROOT}/src/core/ext/upb-gen/src/proto/grpc/gcp/altscontext.upb_minitable.c
  ${_gRPC_ROOT}/src/core/ext/upb-gen/src/proto/grpc/gcp/handshaker.upb_minitable.c
  ${_gRPC_ROOT}/src/core/ext/upb-gen/src/proto/grpc/gcp/transport_security_common.upb_minitable.c
  ${_gRPC_ROOT}/src/core/ext/upbdefs-gen/google/protobuf/any.upbdefs.c
  ${_gRPC_ROOT}/src/core/ext/upbdefs-gen/google/protobuf/duration.upbdefs.c
  ${_gRPC_ROOT}/src/core/ext/upbdefs-gen/google/protobuf/empty.upbdefs.c
  ${_gRPC_ROOT}/src/core/ext/upbdefs-gen/google/protobuf/timestamp.upbdefs.c
  ${_gRPC_ROOT}/src/core/ext/upbdefs-gen/src/proto/grpc/channelz/v2/channelz.upbdefs.c
  ${_gRPC_ROOT}/src/core/ext/upbdefs-gen/src/proto/grpc/channelz/v2/promise.upbdefs.c
  ${_gRPC_ROOT}/src/core/ext/upbdefs-gen/src/proto/grpc/channelz/v2/property_list.upbdefs.c
  ${_gRPC_ROOT}/src/core/ext/upbdefs-gen/src/proto/grpc/channelz/v2/service.upbdefs.c
  ${_gRPC_ROOT}/src/core/filter/auth/client_auth_filter.cc
  ${_gRPC_ROOT}/src/core/filter/auth/server_auth_filter.cc
  ${_gRPC_ROOT}/src/core/handshaker/endpoint_info/endpoint_info_handshaker.cc
  ${_gRPC_ROOT}/src/core/handshaker/handshaker.cc
  ${_gRPC_ROOT}/src/core/handshaker/handshaker_registry.cc
  ${_gRPC_ROOT}/src/core/handshaker/proxy_mapper_registry.cc
  ${_gRPC_ROOT}/src/core/handshaker/security/pipelined_secure_endpoint.cc
  ${_gRPC_ROOT}/src/core/handshaker/security/secure_endpoint.cc
  ${_gRPC_ROOT}/src/core/handshaker/security/security_handshaker.cc
  ${_gRPC_ROOT}/src/core/lib/address_utils/parse_address.cc
  ${_gRPC_ROOT}/src/core/lib/address_utils/sockaddr_utils.cc
  ${_gRPC_ROOT}/src/core/lib/channel/channel_args.cc
  ${_gRPC_ROOT}/src/core/lib/channel/channel_args_preconditioning.cc
  ${_gRPC_ROOT}/src/core/lib/channel/channel_stack.cc
  ${_gRPC_ROOT}/src/core/lib/channel/channel_stack_builder.cc
  ${_gRPC_ROOT}/src/core/lib/channel/channel_stack_builder_impl.cc
  ${_gRPC_ROOT}/src/core/lib/channel/connected_channel.cc
  ${_gRPC_ROOT}/src/core/lib/channel/promise_based_filter.cc
  ${_gRPC_ROOT}/src/core/lib/compression/compression.cc
  ${_gRPC_ROOT}/src/core/lib/compression/compression_internal.cc
  ${_gRPC_ROOT}/src/core/lib/compression/message_compress.cc
  ${_gRPC_ROOT}/src/core/lib/debug/trace.cc
  ${_gRPC_ROOT}/src/core/lib/debug/trace_flags.cc
  ${_gRPC_ROOT}/src/core/lib/event_engine/ares_resolver.cc
  ${_gRPC_ROOT}/src/core/lib/event_engine/cf_engine/cf_engine.cc
  ${_gRPC_ROOT}/src/core/lib/event_engine/cf_engine/cfsocket_listener.cc
  ${_gRPC_ROOT}/src/core/lib/event_engine/cf_engine/cfstream_endpoint.cc
  ${_gRPC_ROOT}/src/core/lib/event_engine/cf_engine/dns_service_resolver.cc
  ${_gRPC_ROOT}/src/core/lib/event_engine/channel_args_endpoint_config.cc
  ${_gRPC_ROOT}/src/core/lib/event_engine/default_event_engine.cc
  ${_gRPC_ROOT}/src/core/lib/event_engine/default_event_engine_factory.cc
  ${_gRPC_ROOT}/src/core/lib/event_engine/event_engine.cc
  ${_gRPC_ROOT}/src/core/lib/event_engine/posix_engine/ev_epoll1_linux.cc
  ${_gRPC_ROOT}/src/core/lib/event_engine/posix_engine/ev_poll_posix.cc
  ${_gRPC_ROOT}/src/core/lib/event_engine/posix_engine/event_poller_posix_default.cc
  ${_gRPC_ROOT}/src/core/lib/event_engine/posix_engine/file_descriptor_collection.cc
  ${_gRPC_ROOT}/src/core/lib/event_engine/posix_engine/internal_errqueue.cc
  ${_gRPC_ROOT}/src/core/lib/event_engine/posix_engine/lockfree_event.cc
  ${_gRPC_ROOT}/src/core/lib/event_engine/posix_engine/native_posix_dns_resolver.cc
  ${_gRPC_ROOT}/src/core/lib/event_engine/posix_engine/posix_endpoint.cc
  ${_gRPC_ROOT}/src/core/lib/event_engine/posix_engine/posix_engine.cc
  ${_gRPC_ROOT}/src/core/lib/event_engine/posix_engine/posix_engine_listener.cc
  ${_gRPC_ROOT}/src/core/lib/event_engine/posix_engine/posix_engine_listener_utils.cc
  ${_gRPC_ROOT}/src/core/lib/event_engine/posix_engine/posix_interface_posix.cc
  ${_gRPC_ROOT}/src/core/lib/event_engine/posix_engine/posix_interface_windows.cc
  ${_gRPC_ROOT}/src/core/lib/event_engine/posix_engine/posix_write_event_sink.cc
  ${_gRPC_ROOT}/src/core/lib/event_engine/posix_engine/set_socket_dualstack.cc
  ${_gRPC_ROOT}/src/core/lib/event_engine/posix_engine/tcp_socket_utils.cc
  ${_gRPC_ROOT}/src/core/lib/event_engine/posix_engine/timer.cc
  ${_gRPC_ROOT}/src/core/lib/event_engine/posix_engine/timer_heap.cc
  ${_gRPC_ROOT}/src/core/lib/event_engine/posix_engine/timer_manager.cc
  ${_gRPC_ROOT}/src/core/lib/event_engine/posix_engine/traced_buffer_list.cc
  ${_gRPC_ROOT}/src/core/lib/event_engine/posix_engine/wakeup_fd_eventfd.cc
  ${_gRPC_ROOT}/src/core/lib/event_engine/posix_engine/wakeup_fd_pipe.cc
  ${_gRPC_ROOT}/src/core/lib/event_engine/posix_engine/wakeup_fd_posix_default.cc
  ${_gRPC_ROOT}/src/core/lib/event_engine/resolved_address.cc
  ${_gRPC_ROOT}/src/core/lib/event_engine/shim.cc
  ${_gRPC_ROOT}/src/core/lib/event_engine/slice.cc
  ${_gRPC_ROOT}/src/core/lib/event_engine/slice_buffer.cc
  ${_gRPC_ROOT}/src/core/lib/event_engine/tcp_socket_utils.cc
  ${_gRPC_ROOT}/src/core/lib/event_engine/thread_pool/thread_count.cc
  ${_gRPC_ROOT}/src/core/lib/event_engine/thread_pool/thread_pool_factory.cc
  ${_gRPC_ROOT}/src/core/lib/event_engine/thread_pool/work_stealing_thread_pool.cc
  ${_gRPC_ROOT}/src/core/lib/event_engine/thready_event_engine/thready_event_engine.cc
  ${_gRPC_ROOT}/src/core/lib/event_engine/time_util.cc
  ${_gRPC_ROOT}/src/core/lib/event_engine/utils.cc
  ${_gRPC_ROOT}/src/core/lib/event_engine/windows/grpc_polled_fd_windows.cc
  ${_gRPC_ROOT}/src/core/lib/event_engine/windows/iocp.cc
  ${_gRPC_ROOT}/src/core/lib/event_engine/windows/native_windows_dns_resolver.cc
  ${_gRPC_ROOT}/src/core/lib/event_engine/windows/win_socket.cc
  ${_gRPC_ROOT}/src/core/lib/event_engine/windows/windows_endpoint.cc
  ${_gRPC_ROOT}/src/core/lib/event_engine/windows/windows_engine.cc
  ${_gRPC_ROOT}/src/core/lib/event_engine/windows/windows_listener.cc
  ${_gRPC_ROOT}/src/core/lib/event_engine/work_queue/basic_work_queue.cc
  ${_gRPC_ROOT}/src/core/lib/experiments/config.cc
  ${_gRPC_ROOT}/src/core/lib/experiments/experiments.cc
  ${_gRPC_ROOT}/src/core/lib/iomgr/buffer_list.cc
  ${_gRPC_ROOT}/src/core/lib/iomgr/call_combiner.cc
  ${_gRPC_ROOT}/src/core/lib/iomgr/cfstream_handle.cc
  ${_gRPC_ROOT}/src/core/lib/iomgr/closure.cc
  ${_gRPC_ROOT}/src/core/lib/iomgr/combiner.cc
  ${_gRPC_ROOT}/src/core/lib/iomgr/dualstack_socket_posix.cc
  ${_gRPC_ROOT}/src/core/lib/iomgr/endpoint.cc
  ${_gRPC_ROOT}/src/core/lib/iomgr/endpoint_cfstream.cc
  ${_gRPC_ROOT}/src/core/lib/iomgr/endpoint_pair_posix.cc
  ${_gRPC_ROOT}/src/core/lib/iomgr/endpoint_pair_windows.cc
  ${_gRPC_ROOT}/src/core/lib/iomgr/error.cc
  ${_gRPC_ROOT}/src/core/lib/iomgr/error_cfstream.cc
  ${_gRPC_ROOT}/src/core/lib/iomgr/ev_apple.cc
  ${_gRPC_ROOT}/src/core/lib/iomgr/ev_epoll1_linux.cc
  ${_gRPC_ROOT}/src/core/lib/iomgr/ev_poll_posix.cc
  ${_gRPC_ROOT}/src/core/lib/iomgr/ev_posix.cc
  ${_gRPC_ROOT}/src/core/lib/iomgr/event_engine_shims/closure.cc
  ${_gRPC_ROOT}/src/core/lib/iomgr/event_engine_shims/endpoint.cc
  ${_gRPC_ROOT}/src/core/lib/iomgr/event_engine_shims/tcp_client.cc
  ${_gRPC_ROOT}/src/core/lib/iomgr/exec_ctx.cc
  ${_gRPC_ROOT}/src/core/lib/iomgr/fork_posix.cc
  ${_gRPC_ROOT}/src/core/lib/iomgr/fork_windows.cc
  ${_gRPC_ROOT}/src/core/lib/iomgr/internal_errqueue.cc
  ${_gRPC_ROOT}/src/core/lib/iomgr/iocp_windows.cc
  ${_gRPC_ROOT}/src/core/lib/iomgr/iomgr.cc
  ${_gRPC_ROOT}/src/core/lib/iomgr/iomgr_internal.cc
  ${_gRPC_ROOT}/src/core/lib/iomgr/iomgr_posix.cc
  ${_gRPC_ROOT}/src/core/lib/iomgr/iomgr_posix_cfstream.cc
  ${_gRPC_ROOT}/src/core/lib/iomgr/iomgr_windows.cc
  ${_gRPC_ROOT}/src/core/lib/iomgr/lockfree_event.cc
  ${_gRPC_ROOT}/src/core/lib/iomgr/polling_entity.cc
  ${_gRPC_ROOT}/src/core/lib/iomgr/pollset.cc
  ${_gRPC_ROOT}/src/core/lib/iomgr/pollset_set.cc
  ${_gRPC_ROOT}/src/core/lib/iomgr/pollset_set_windows.cc
  ${_gRPC_ROOT}/src/core/lib/iomgr/pollset_windows.cc
  ${_gRPC_ROOT}/src/core/lib/iomgr/resolve_address.cc
  ${_gRPC_ROOT}/src/core/lib/iomgr/resolve_address_posix.cc
  ${_gRPC_ROOT}/src/core/lib/iomgr/resolve_address_windows.cc
  ${_gRPC_ROOT}/src/core/lib/iomgr/sockaddr_utils_posix.cc
  ${_gRPC_ROOT}/src/core/lib/iomgr/socket_factory_posix.cc
  ${_gRPC_ROOT}/src/core/lib/iomgr/socket_mutator.cc
  ${_gRPC_ROOT}/src/core/lib/iomgr/socket_utils_common_posix.cc
  ${_gRPC_ROOT}/src/core/lib/iomgr/socket_utils_linux.cc
  ${_gRPC_ROOT}/src/core/lib/iomgr/socket_utils_posix.cc
  ${_gRPC_ROOT}/src/core/lib/iomgr/socket_utils_windows.cc
  ${_gRPC_ROOT}/src/core/lib/iomgr/socket_windows.cc
  ${_gRPC_ROOT}/src/core/lib/iomgr/systemd_utils.cc
  ${_gRPC_ROOT}/src/core/lib/iomgr/tcp_client.cc
  ${_gRPC_ROOT}/src/core/lib/iomgr/tcp_client_cfstream.cc
  ${_gRPC_ROOT}/src/core/lib/iomgr/tcp_client_posix.cc
  ${_gRPC_ROOT}/src/core/lib/iomgr/tcp_client_windows.cc
  ${_gRPC_ROOT}/src/core/lib/iomgr/tcp_posix.cc
  ${_gRPC_ROOT}/src/core/lib/iomgr/tcp_server.cc
  ${_gRPC_ROOT}/src/core/lib/iomgr/tcp_server_posix.cc
  ${_gRPC_ROOT}/src/core/lib/iomgr/tcp_server_utils_posix_common.cc
  ${_gRPC_ROOT}/src/core/lib/iomgr/tcp_server_utils_posix_ifaddrs.cc
  ${_gRPC_ROOT}/src/core/lib/iomgr/tcp_server_utils_posix_noifaddrs.cc
  ${_gRPC_ROOT}/src/core/lib/iomgr/tcp_server_windows.cc
  ${_gRPC_ROOT}/src/core/lib/iomgr/tcp_windows.cc
  ${_gRPC_ROOT}/src/core/lib/iomgr/timer.cc
  ${_gRPC_ROOT}/src/core/lib/iomgr/timer_generic.cc
  ${_gRPC_ROOT}/src/core/lib/iomgr/timer_heap.cc
  ${_gRPC_ROOT}/src/core/lib/iomgr/timer_manager.cc
  ${_gRPC_ROOT}/src/core/lib/iomgr/unix_sockets_posix.cc
  ${_gRPC_ROOT}/src/core/lib/iomgr/unix_sockets_posix_noop.cc
  ${_gRPC_ROOT}/src/core/lib/iomgr/vsock.cc
  ${_gRPC_ROOT}/src/core/lib/iomgr/wakeup_fd_eventfd.cc
  ${_gRPC_ROOT}/src/core/lib/iomgr/wakeup_fd_nospecial.cc
  ${_gRPC_ROOT}/src/core/lib/iomgr/wakeup_fd_pipe.cc
  ${_gRPC_ROOT}/src/core/lib/iomgr/wakeup_fd_posix.cc
  ${_gRPC_ROOT}/src/core/lib/promise/activity.cc
  ${_gRPC_ROOT}/src/core/lib/promise/party.cc
  ${_gRPC_ROOT}/src/core/lib/promise/wait_set.cc
  ${_gRPC_ROOT}/src/core/lib/resource_quota/api.cc
  ${_gRPC_ROOT}/src/core/lib/resource_quota/arena.cc
  ${_gRPC_ROOT}/src/core/lib/resource_quota/memory_quota.cc
  ${_gRPC_ROOT}/src/core/lib/resource_quota/periodic_update.cc
  ${_gRPC_ROOT}/src/core/lib/resource_quota/resource_quota.cc
  ${_gRPC_ROOT}/src/core/lib/resource_quota/stream_quota.cc
  ${_gRPC_ROOT}/src/core/lib/resource_quota/telemetry.cc
  ${_gRPC_ROOT}/src/core/lib/resource_quota/thread_quota.cc
  ${_gRPC_ROOT}/src/core/lib/resource_tracker/resource_tracker.cc
  ${_gRPC_ROOT}/src/core/lib/security/authorization/audit_logging.cc
  ${_gRPC_ROOT}/src/core/lib/security/authorization/authorization_policy_provider_vtable.cc
  ${_gRPC_ROOT}/src/core/lib/security/authorization/evaluate_args.cc
  ${_gRPC_ROOT}/src/core/lib/security/authorization/grpc_authorization_engine.cc
  ${_gRPC_ROOT}/src/core/lib/security/authorization/grpc_authorization_policy_provider.cc
  ${_gRPC_ROOT}/src/core/lib/security/authorization/grpc_server_authz_filter.cc
  ${_gRPC_ROOT}/src/core/lib/security/authorization/matchers.cc
  ${_gRPC_ROOT}/src/core/lib/security/authorization/rbac_policy.cc
  ${_gRPC_ROOT}/src/core/lib/security/authorization/rbac_translator.cc
  ${_gRPC_ROOT}/src/core/lib/security/authorization/stdout_logger.cc
  ${_gRPC_ROOT}/src/core/lib/slice/percent_encoding.cc
  ${_gRPC_ROOT}/src/core/lib/slice/slice.cc
  ${_gRPC_ROOT}/src/core/lib/slice/slice_buffer.cc
  ${_gRPC_ROOT}/src/core/lib/slice/slice_string_helpers.cc
  ${_gRPC_ROOT}/src/core/lib/surface/byte_buffer.cc
  ${_gRPC_ROOT}/src/core/lib/surface/byte_buffer_reader.cc
  ${_gRPC_ROOT}/src/core/lib/surface/call.cc
  ${_gRPC_ROOT}/src/core/lib/surface/call_details.cc
  ${_gRPC_ROOT}/src/core/lib/surface/call_log_batch.cc
  ${_gRPC_ROOT}/src/core/lib/surface/call_utils.cc
  ${_gRPC_ROOT}/src/core/lib/surface/channel.cc
  ${_gRPC_ROOT}/src/core/lib/surface/channel_init.cc
  ${_gRPC_ROOT}/src/core/lib/surface/channel_stack_type.cc
  ${_gRPC_ROOT}/src/core/lib/surface/completion_queue.cc
  ${_gRPC_ROOT}/src/core/lib/surface/completion_queue_factory.cc
  ${_gRPC_ROOT}/src/core/lib/surface/connection_context.cc
  ${_gRPC_ROOT}/src/core/lib/surface/event_string.cc
  ${_gRPC_ROOT}/src/core/lib/surface/filter_stack_call.cc
  ${_gRPC_ROOT}/src/core/lib/surface/init_internally.cc
  ${_gRPC_ROOT}/src/core/lib/surface/lame_client.cc
  ${_gRPC_ROOT}/src/core/lib/surface/metadata_array.cc
  ${_gRPC_ROOT}/src/core/lib/surface/validate_metadata.cc
  ${_gRPC_ROOT}/src/core/lib/surface/version.cc
  ${_gRPC_ROOT}/src/core/lib/transport/call_final_info.cc
  ${_gRPC_ROOT}/src/core/lib/transport/connectivity_state.cc
  ${_gRPC_ROOT}/src/core/lib/transport/error_utils.cc
  ${_gRPC_ROOT}/src/core/lib/transport/status_conversion.cc
  ${_gRPC_ROOT}/src/core/lib/transport/timeout_encoding.cc
  ${_gRPC_ROOT}/src/core/lib/transport/transport.cc
  ${_gRPC_ROOT}/src/core/lib/transport/transport_op_string.cc
  ${_gRPC_ROOT}/src/core/load_balancing/lb_policy.cc
  ${_gRPC_ROOT}/src/core/load_balancing/lb_policy_registry.cc
  ${_gRPC_ROOT}/src/core/net/socket_mutator.cc
  ${_gRPC_ROOT}/src/core/resolver/endpoint_addresses.cc
  ${_gRPC_ROOT}/src/core/resolver/resolver.cc
  ${_gRPC_ROOT}/src/core/resolver/resolver_registry.cc
  ${_gRPC_ROOT}/src/core/service_config/service_config_parser.cc
  ${_gRPC_ROOT}/src/core/telemetry/call_tracer.cc
  ${_gRPC_ROOT}/src/core/telemetry/context_list_entry.cc
  ${_gRPC_ROOT}/src/core/telemetry/histogram_view.cc
  ${_gRPC_ROOT}/src/core/telemetry/instrument.cc
  ${_gRPC_ROOT}/src/core/telemetry/metrics.cc
  ${_gRPC_ROOT}/src/core/telemetry/stats.cc
  ${_gRPC_ROOT}/src/core/telemetry/stats_data.cc
  ${_gRPC_ROOT}/src/core/telemetry/tcp_tracer.cc
  ${_gRPC_ROOT}/src/core/transport/auth_context.cc
  ${_gRPC_ROOT}/src/core/tsi/alts/handshaker/transport_security_common_api.cc
  ${_gRPC_ROOT}/src/core/tsi/transport_security.cc
  ${_gRPC_ROOT}/src/core/tsi/transport_security_grpc.cc
  ${_gRPC_ROOT}/src/core/util/backoff.cc
  ${_gRPC_ROOT}/src/core/util/dump_args.cc
  ${_gRPC_ROOT}/src/core/util/event_log.cc
  ${_gRPC_ROOT}/src/core/util/gethostname_fallback.cc
  ${_gRPC_ROOT}/src/core/util/gethostname_host_name_max.cc
  ${_gRPC_ROOT}/src/core/util/gethostname_sysconf.cc
  ${_gRPC_ROOT}/src/core/util/glob.cc
  ${_gRPC_ROOT}/src/core/util/grpc_check.cc
  ${_gRPC_ROOT}/src/core/util/grpc_if_nametoindex_posix.cc
  ${_gRPC_ROOT}/src/core/util/grpc_if_nametoindex_unsupported.cc
  ${_gRPC_ROOT}/src/core/util/json/json_object_loader.cc
  ${_gRPC_ROOT}/src/core/util/json/json_reader.cc
  ${_gRPC_ROOT}/src/core/util/json/json_writer.cc
  ${_gRPC_ROOT}/src/core/util/latent_see.cc
  ${_gRPC_ROOT}/src/core/util/load_file.cc
  ${_gRPC_ROOT}/src/core/util/matchers.cc
  ${_gRPC_ROOT}/src/core/util/per_cpu.cc
  ${_gRPC_ROOT}/src/core/util/postmortem_emit.cc
  ${_gRPC_ROOT}/src/core/util/ref_counted_string.cc
  ${_gRPC_ROOT}/src/core/util/shared_bit_gen.cc
  ${_gRPC_ROOT}/src/core/util/status_helper.cc
  ${_gRPC_ROOT}/src/core/util/time.cc
  ${_gRPC_ROOT}/src/core/util/time_averaged_stats.cc
  ${_gRPC_ROOT}/src/core/util/uri.cc
  ${_gRPC_ROOT}/src/core/util/validation_errors.cc
  ${_gRPC_ROOT}/src/core/util/wait_for_single_owner.cc
  ${_gRPC_ROOT}/src/core/util/work_serializer.cc
)



target_include_directories(grpc_authorization_provider
  PUBLIC  ${_gRPC_ROOT}/include
  PRIVATE
    ${_gRPC_ROOT}
    ${_gRPC_ADDRESS_SORTING_INCLUDE_DIR}
    ${_gRPC_RE2_INCLUDE_DIR}
    ${_gRPC_SSL_INCLUDE_DIR}
    ${_gRPC_UPB_GENERATED_DIR}
    ${_gRPC_UPB_GRPC_GENERATED_DIR}
    ${_gRPC_UPB_INCLUDE_DIR}
    ${_gRPC_XXHASH_INCLUDE_DIR}
    ${_gRPC_ZLIB_INCLUDE_DIR}
    ${_gRPC_PROTO_GENS_DIR}
)
target_link_libraries(grpc_authorization_provider PUBLIC
  libprotobuf
  zlib
  cares
  address_sorting
  ${_gRPC_RE2_LIBRARIES}
  ${_gRPC_ALLTARGETS_LIBRARIES}
  upb_textformat_lib
  re2
  absl::no_destructor
  absl::btree
  absl::flat_hash_map
  absl::flat_hash_set
  absl::inlined_vector
  absl::node_hash_map
  absl::function_ref
  absl::hash
  absl::type_traits
  absl::statusor
  absl::string_view
  absl::span
  absl::utility
  cares
  gpr
  address_sorting
)


# Not building grpc_plugin_support
# Not building grpcpp_channelz
# Not building test cares, private

# Not building test: test
# Not building test: test
# Not building test: test
# Not building test: test
# Not building test: test
# Not building test: test
# Not building test: test
# Not building test: test
# Not building test: test
# Not building test: test
# Not building test: test
# Not building test: test
# Not building test: test
# Not building test: test
# Not building test: test
# Not building test: test
# Not building test: test
# Not building test: test
# Not building test: test
# Not building test: test
# Not building test: test
# Not building test: test
# Not building test: test
# Not building test: test
# Not building test: test
# Not building test: test
# Not building test: test
# Not building test: test
# Not building test: test
# Not building test: test
# Not building test: test
# Not building test: test
# Not building test: test
# Not building test: test
# Not building test: test
# Not building test: test
# Not building test: test
# Not building test: test
# Not building test: test
# Not building test: test
# Not building test: test
# Not building test: test
# Not building test: test
# Not building test: test
# Not building test: test
# Not building test: test
# Not building test: test
# Not building test: test
# Not building test: test
# Not building test: test
# Not building test: test
# Not building test: test
# Not building test: test
# Not building test: test
# Not building test: test
# Not building test: test
# Not building test: test
# Not building test: test
# Not building test: test
# Not building test: test
# Not building test: test
# Not building test: test
# Not building test: test
# Not building test: test
# Not building test: test
# Not building test: test
# Not building test: test
# Not building test: test
# Not building test: test
# Not building test: test
# Not building test: test
# Not building test: test
# Not building test: test
# Not building test: test
# Not building test: test
# Not building test: test
# Not building test: test
# Not building test: test
# Not building test: test
# Not building test: test
# Not building test: test
# Not building test: test
# Not building test: test
# Not building test: test
# Not building test: test
# Not building test: test
# Not building test: test
# Not building test: test
# Not building test: test
# Not building test: test
# Not building test: test
# Not building test: test
# Not building test: test
# Not building test: test
# Not building test: test
# Not building test: test
# Not building test: test
# Not building test: test
# Not building test: test
# Not building test: test
# Not building test: test
# Not building test: test
# Not building test: test
# Not building test: test
# Not building test: test
# Not building test: test
# Not building test: test
# Not building test: test
# Not building test: test
# Not building test: test
# Not building test: test
# Not building test: test
# Not building test: test
# Not building test: test
# Not building test: test
# Not building test: test
# Not building test: test
# Not building test: test
# Not building test: test
# Not building test: test
# Not building test: test
# Not building test: test
# Not building test: test
# Not building test: test
# Not building test: test
# Not building test: test
# Not building test: test
# Not building test: test
# Not building test: test
# Not building test: test
# Not building test: test
# Not building test: test
# Not building test: test
# Not building test: test
# Not building test: test
# Not building test: test
# Not building test: test
# Not building test: test
# Not building test: test
# Not building test: test
# Not building test: test
# Not building test: test
# Not building test: test
# Not building test: test
# Not building test: test
# Not building test: test
# Not building test: test
# Not building test: test
# Not building test: test
# Not building test: test
# Not building test: test
# Not building test: test
# Not building test: test
# Not building test: test
# Not building test: test
# Not building test: test
# Not building test: test
# Not building test: test
# Not building test: test
# Not building test: test
# Not building test: test
# Not building test: test
# Not building test: test
# Not building test: test
# Not building test: test
# Not building test: test
# Not building test: test
# Not building test: test
# Not building test: test
# Not building test: test
# Not building test: test
# Not building test: test
# Not building test: test
# Not building test: test
# Not building test: test
# Not building test: test
# Not building test: test
# Not building test: test
# Not building test: test
# Not building test: test
# Not building test: test
# Not building test: test
# Not building test: test
# Not building test: test
# Not building test: test
# Not building test: test
# Not building test: test
# Not building test: test
# Not building test: test
# Not building test: test
# Not building test: test
# Not building test: test
# No codegen grpc_cpp_plugin
# No codegen grpc_csharp_plugin
# Not building test: test
# No codegen grpc_node_plugin
# No codegen grpc_objective_c_plugin
# No codegen grpc_php_plugin
# No codegen grpc_python_plugin
# No codegen grpc_ruby_plugin
# Not building test: test
# Not building test: test
# Not building test: test
# Not building test: test
# Not building test: test
# Not building test: test
# Not building test: test
# Not building test: test
# Not building test: test
# Not building test: test
# Not building test: test
# Not building test: test
# Not building test: test
# Not building test: test
# Not building test: test
# Not building test: test
# Not building test: test
# Not building test: test
# Not building test: test
# Not building test: test
# Not building test: test
# Not building test: test
# Not building test: test
# Not building test: test
# Not building test: test
# Not building test: test
# Not building test: test
# Not building test: test
# Not building test: test
# Not building test: test
# Not building test: test
# Not building test: test
# Not building test: test
# Not building test: test
# Not building test: test
# Not building test: test
# Not building test: test
# Not building test: test
# Not building test: test
# Not building test: test
# Not building test: test
# Not building test: test
# Not building test: test
# Not building test: test
# Not building test: test
# Not building test: test
# Not building test: test
# Not building test: test
# Not building test: test
# Not building test: test
# Not building test: test
# Not building test: test
# Not building test: test
# Not building test: test
# Not building test: test
# Not building test: test
# Not building test: test
# Not building test: test
# Not building test: test
# Not building test: test
# Not building test: test
# Not building test: test
# Not building test: test
# Not building test: test
# Not building test: test
# Not building test: test
# Not building test: test
# Not building test: test
# Not building test: test
# Not building test: test
# Not building test: test
# Not building test: test
# Not building test: test
# Not building test: test
# Not building test: test
# Not building test: test
# Not building test: test
# Not building test: test
# Not building test: test
# Not building test: test
# Not building test: test
# Not building test: test
# Not building test: test
# Not building test: test
# Not building test: test
# Not building test: test
# Not building test: test
# Not building test: test
# Not building test: test
# Not building test: test
# Not building test: test
# Not building test: test
# Not building test: test
# Not building test: test
# Not building test: test
# Not building test: test
# Not building test: test
# Not building test: test
# Not building test: test
# Not building test: test
# Not building test: test
# Not building test: test
# Not building test: test
# Not building test: test
# Not building test: test
# Not building test: test
# Not building test: test
# Not building test: test
# Not building test: test
# Not building test: test
# Not building test: test
# Not building test: test
# Not building test: test
# Not building test: test
# Not building test: test
# Not building test: test
# Not building test: test
# Not building test: test
# Not building test: test
# Not building test: test
# Not building test: test
# Not building test: test
# Not building test: test
# Not building test: test
# Not building test: test
# Not building test: test
# Not building test: test
# Not building test: test
# Not building test: test
# Not building test: test
# Not building test: test
# Not building test: test
# Not building test: test
# Not building test: test
# Not building test: test
# Not building test: test
# Not building test: test
# Not building test: test
# Not building test: test
# Not building test: test
# Not building test: test
# Not building test: test
# Not building test: test
# Not building test: test
# Not building test: test
# Not building test: test
# Not building test: test
# Not building test: test
# Not building test: test
# Not building test: test
# Not building test: test
# Not building test: test
# Not building test: test
# Not building test: test
# Not building test: test
# Not building test: test
# Not building test: test
# Not building test: test
# Not building test: test
# Not building test: test
# Not building test: test
# Not building test: test
# Not building test: test
# Not building test: test
# Not building test: test
# Not building test: test
# Not building test: test
# Not building test: test
# Not building test: test
# Not building test: test
# Not building test: test
# Not building test: test
# Not building test: test
# Not building test: test
# Not building test: test
# Not building test: test
# Not building test: test
# Not building test: test
# Not building test: test
# Not building test: test
# Not building test: test
# Not building test: test
# Not building test: test
# Not building test: test
# Not building test: test
# Not building test: test
# Not building test: test
# Not building test: test
# Not building test: test
# Not building test: test
# Not building test: test
# Not building test: test
# Not building test: test
# Not building test: test
# Not building test: test
# Not building test: test
# Not building test: test
# Not building test: test
# Not building test: test
# Not building test: test
# Not building test: test
# Not building test: test
# Not building test: test
# Not building test: test
# Not building test: test
# Not building test: test
# Not building test: test
# Not building test: test
# Not building test: test
# Not building test: test
# Not building test: test
# Not building test: test
# Not building test: test
# Not building test: test
# Not building test: test
# Not building test: test
# Not building test: test
# Not building test: test
# Not building test: test
# Not building test: test
# Not building test: test
# Not building test: test
# Not building test: test
# Not building test: test
# Not building test: test
# Not building test: test
# Not building test: test
# Not building test: test
# Not building test: test
# Not building test: test
# Not building test: test
# Not building test: test
# Not building test: test
# Not building test: test
# Not building test: test
# Not building test: test
# Not building test: test
# Not building test: test
# Not building test: test
# Not building test: test
# Not building test: test
# Not building test: test
# Not building test: test
# Not building test: test
# Not building test: test
# Not building test: test
# Not building test: test
# Not building test: test
# Not building test: test
# Not building test: test
# Not building test: test
# Not building test: test
# Not building test: test
# Not building test: test
# Not building test: test
# Not building test: test
# Not building test: test
# Not building test: test
# Not building test: test
# Not building test: test
# Not building test: test
# Not building test: test
# Not building test: test
# Not building test: test
# Not building test: test
# Not building test: test
# Not building test: test
# Not building test: test
# Not building test: test
# Not building test: test
# Not building test: test
# Not building test: test
# Not building test: test
# Not building test: test
# Not building test: test
# Not building test: test
# Not building test: test
# Not building test: test
# Not building test: test
# Not building test: test
# Not building test: test
# Not building test: test
# Not building test: test
# Not building test: test
# Not building test: test
# Not building test: test
# Not building test: test
# Not building test: test
# Not building test: test
# Not building test: test
# Not building test: test
# Not building test: test
# Not building test: test
# Not building test: test
# Not building test: test
# Not building test: test
# Not building test: test
# Not building test: test
# Not building test: test
# Not building test: test
# Not building test: test
# Not building test: test
# Not building test: test
# Not building test: test
# Not building test: test
# Not building test: test
# Not building test: test
# Not building test: test
# Not building test: test
# Not building test: test
# Not building test: test
# Not building test: test
# Not building test: test
# Not building test: test
# Not building test: test
# Not building test: test
# Not building test: test
# Not building test: test
# Not building test: test
# Not building test: test
# Not building test: test
# Not building test: test
# Not building test: test
# Not building test: test
# Not building test: test
# Not building test: test
# Not building test: test
# Not building test: test
# Not building test: test
# Not building test: test
# Not building test: test
# Not building test: test
# Not building test: test
# Not building test: test
# Not building test: test
# Not building test: test
# Not building test: test
# Not building test: test
# Not building test: test
# Not building test: test
# Not building test: test
# Not building test: test
# Not building test: test
# Not building test: test
# Not building test: test
# Not building test: test
# Not building test: test






