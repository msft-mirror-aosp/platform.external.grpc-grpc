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
set(PACKAGE_VERSION       "1.50.0-dev")
set(gRPC_CORE_VERSION     "27.0.0")
set(gRPC_CORE_SOVERSION   "27")
set(gRPC_CPP_VERSION      "1.50.0-dev")
set(gRPC_CPP_SOVERSION    "1.50")
set(gRPC_CSHARP_VERSION   "2.50.0-dev")
set(gRPC_CSHARP_SOVERSION "2.50")
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
  absl_algorithm
  absl_algorithm_container
  absl_any_invocable
  absl_atomic_hook
  absl_bad_optional_access
  absl_bad_variant_access
  absl_base
  absl_base_internal
  absl_bind_front
  absl_bits
  absl_city
  absl_civil_time
  absl_cleanup
  absl_cleanup_internal
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
  absl_debugging_internal
  absl_demangle_internal
  absl_dynamic_annotations
  absl_endian
  absl_errno_saver
  absl_exponential_biased
  absl_fast_type_id
  absl_fixed_array
  absl_flat_hash_map
  absl_flat_hash_set
  absl_function_ref
  absl_graphcycles_internal
  absl_hash
  absl_hash_function_defaults
  absl_hash_policy_traits
  absl_hashtable_debug_hooks
  absl_hashtablez_sampler
  absl_inlined_vector
  absl_inlined_vector_internal
  absl_int128
  absl_kernel_timeout_internal
  absl_layout
  absl_log_severity
  absl_low_level_hash
  absl_malloc_internal
  absl_memory
  absl_numeric_representation
  absl_optional
  absl_prefetch
  absl_random_distributions
  absl_random_internal_distribution_caller
  absl_random_internal_fast_uniform_bits
  absl_random_internal_fastmath
  absl_random_internal_generate_real
  absl_random_internal_iostream_state_saver
  absl_random_internal_nonsecure_base
  absl_random_internal_pcg_engine
  absl_random_internal_platform
  absl_random_internal_pool_urbg
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
  absl_strings
  absl_strings_internal
  absl_symbolize
  absl_synchronization
  absl_throw_delegate
  absl_time
  absl_time_zone
  absl_type_traits
  absl_utility
  absl_variant
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
      COMMAND ${_gRPC_PROTOBUF_PROTOC_EXECUTABLE}
      ARGS --grpc_out=generate_mock_code=true:${grpc_OUTPUT_DIR}
           --cpp_out=${grpc_OUTPUT_DIR}
           --plugin=protoc-gen-grpc=${_gRPC_CPP_PLUGIN_EXECUTABLE}
           ${GRPC_INCLUDES}
           ${REL_FIL}
      DEPENDS ${ABS_FIL} ${_gRPC_PROTOBUF_PROTOC_EXECUTABLE} ${_gRPC_CPP_PLUGIN_EXECUTABLE}
      WORKING_DIRECTORY ${grpc_SOURCE_DIR}
      COMMENT "Running gRPC C++ protocol buffer compiler on ${FIL}"
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


# Not building test end2end_tests, private

android_add_library(TARGET gpr
LICENSE Apache-2.0
URL "https://android.googlesource.com/platform/external/grpc-grpc/+/refs/heads/emu-master-dev"
REPO "${ANDROID_QEMU2_TOP_DIR}/../grpc"
NOTICE "REPO/NOTICE.txt"

SRC # cmake-format: sortable
  ${_gRPC_ROOT}/src/core/lib/gpr/alloc.cc
  ${_gRPC_ROOT}/src/core/lib/gpr/atm.cc
  ${_gRPC_ROOT}/src/core/lib/gpr/cpu_iphone.cc
  ${_gRPC_ROOT}/src/core/lib/gpr/cpu_linux.cc
  ${_gRPC_ROOT}/src/core/lib/gpr/cpu_posix.cc
  ${_gRPC_ROOT}/src/core/lib/gpr/cpu_windows.cc
  ${_gRPC_ROOT}/src/core/lib/gpr/env_linux.cc
  ${_gRPC_ROOT}/src/core/lib/gpr/env_posix.cc
  ${_gRPC_ROOT}/src/core/lib/gpr/env_windows.cc
  ${_gRPC_ROOT}/src/core/lib/gpr/log.cc
  ${_gRPC_ROOT}/src/core/lib/gpr/log_android.cc
  ${_gRPC_ROOT}/src/core/lib/gpr/log_linux.cc
  ${_gRPC_ROOT}/src/core/lib/gpr/log_posix.cc
  ${_gRPC_ROOT}/src/core/lib/gpr/log_windows.cc
  ${_gRPC_ROOT}/src/core/lib/gpr/murmur_hash.cc
  ${_gRPC_ROOT}/src/core/lib/gpr/string.cc
  ${_gRPC_ROOT}/src/core/lib/gpr/string_posix.cc
  ${_gRPC_ROOT}/src/core/lib/gpr/string_util_windows.cc
  ${_gRPC_ROOT}/src/core/lib/gpr/string_windows.cc
  ${_gRPC_ROOT}/src/core/lib/gpr/sync.cc
  ${_gRPC_ROOT}/src/core/lib/gpr/sync_abseil.cc
  ${_gRPC_ROOT}/src/core/lib/gpr/sync_posix.cc
  ${_gRPC_ROOT}/src/core/lib/gpr/sync_windows.cc
  ${_gRPC_ROOT}/src/core/lib/gpr/time.cc
  ${_gRPC_ROOT}/src/core/lib/gpr/time_posix.cc
  ${_gRPC_ROOT}/src/core/lib/gpr/time_precise.cc
  ${_gRPC_ROOT}/src/core/lib/gpr/time_windows.cc
  ${_gRPC_ROOT}/src/core/lib/gpr/tmpfile_msys.cc
  ${_gRPC_ROOT}/src/core/lib/gpr/tmpfile_posix.cc
  ${_gRPC_ROOT}/src/core/lib/gpr/tmpfile_windows.cc
  ${_gRPC_ROOT}/src/core/lib/gpr/wrap_memcpy.cc
  ${_gRPC_ROOT}/src/core/lib/gprpp/examine_stack.cc
  ${_gRPC_ROOT}/src/core/lib/gprpp/fork.cc
  ${_gRPC_ROOT}/src/core/lib/gprpp/global_config_env.cc
  ${_gRPC_ROOT}/src/core/lib/gprpp/host_port.cc
  ${_gRPC_ROOT}/src/core/lib/gprpp/mpscq.cc
  ${_gRPC_ROOT}/src/core/lib/gprpp/stat_posix.cc
  ${_gRPC_ROOT}/src/core/lib/gprpp/stat_windows.cc
  ${_gRPC_ROOT}/src/core/lib/gprpp/thd_posix.cc
  ${_gRPC_ROOT}/src/core/lib/gprpp/thd_windows.cc
  ${_gRPC_ROOT}/src/core/lib/gprpp/time_util.cc
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
  absl::core_headers
  absl::memory
  absl::random_random
  absl::status
  absl::cord
  absl::str_format
  absl::strings
  absl::synchronization
  absl::time
  absl::optional
  absl::variant
)



android_add_library(TARGET grpc
LICENSE Apache-2.0
URL "https://android.googlesource.com/platform/external/grpc-grpc/+/refs/heads/emu-master-dev"
REPO "${ANDROID_QEMU2_TOP_DIR}/../grpc"
NOTICE "REPO/NOTICE.txt"

SRC # cmake-format: sortable
  ${_gRPC_ROOT}/src/core/ext/filters/census/grpc_context.cc
  ${_gRPC_ROOT}/src/core/ext/filters/channel_idle/channel_idle_filter.cc
  ${_gRPC_ROOT}/src/core/ext/filters/channel_idle/idle_filter_state.cc
  ${_gRPC_ROOT}/src/core/ext/filters/client_channel/backend_metric.cc
  ${_gRPC_ROOT}/src/core/ext/filters/client_channel/backup_poller.cc
  ${_gRPC_ROOT}/src/core/ext/filters/client_channel/channel_connectivity.cc
  ${_gRPC_ROOT}/src/core/ext/filters/client_channel/client_channel.cc
  ${_gRPC_ROOT}/src/core/ext/filters/client_channel/client_channel_channelz.cc
  ${_gRPC_ROOT}/src/core/ext/filters/client_channel/client_channel_factory.cc
  ${_gRPC_ROOT}/src/core/ext/filters/client_channel/client_channel_plugin.cc
  ${_gRPC_ROOT}/src/core/ext/filters/client_channel/config_selector.cc
  ${_gRPC_ROOT}/src/core/ext/filters/client_channel/dynamic_filters.cc
  ${_gRPC_ROOT}/src/core/ext/filters/client_channel/global_subchannel_pool.cc
  ${_gRPC_ROOT}/src/core/ext/filters/client_channel/health/health_check_client.cc
  ${_gRPC_ROOT}/src/core/ext/filters/client_channel/http_proxy.cc
  ${_gRPC_ROOT}/src/core/ext/filters/client_channel/lb_policy/address_filtering.cc
  ${_gRPC_ROOT}/src/core/ext/filters/client_channel/lb_policy/child_policy_handler.cc
  ${_gRPC_ROOT}/src/core/ext/filters/client_channel/lb_policy/grpclb/client_load_reporting_filter.cc
  ${_gRPC_ROOT}/src/core/ext/filters/client_channel/lb_policy/grpclb/grpclb.cc
  ${_gRPC_ROOT}/src/core/ext/filters/client_channel/lb_policy/grpclb/grpclb_balancer_addresses.cc
  ${_gRPC_ROOT}/src/core/ext/filters/client_channel/lb_policy/grpclb/grpclb_client_stats.cc
  ${_gRPC_ROOT}/src/core/ext/filters/client_channel/lb_policy/grpclb/load_balancer_api.cc
  ${_gRPC_ROOT}/src/core/ext/filters/client_channel/lb_policy/oob_backend_metric.cc
  ${_gRPC_ROOT}/src/core/ext/filters/client_channel/lb_policy/outlier_detection/outlier_detection.cc
  ${_gRPC_ROOT}/src/core/ext/filters/client_channel/lb_policy/pick_first/pick_first.cc
  ${_gRPC_ROOT}/src/core/ext/filters/client_channel/lb_policy/priority/priority.cc
  ${_gRPC_ROOT}/src/core/ext/filters/client_channel/lb_policy/ring_hash/ring_hash.cc
  ${_gRPC_ROOT}/src/core/ext/filters/client_channel/lb_policy/rls/rls.cc
  ${_gRPC_ROOT}/src/core/ext/filters/client_channel/lb_policy/round_robin/round_robin.cc
  ${_gRPC_ROOT}/src/core/ext/filters/client_channel/lb_policy/weighted_target/weighted_target.cc
  ${_gRPC_ROOT}/src/core/ext/filters/client_channel/lb_policy/xds/cds.cc
  ${_gRPC_ROOT}/src/core/ext/filters/client_channel/lb_policy/xds/xds_cluster_impl.cc
  ${_gRPC_ROOT}/src/core/ext/filters/client_channel/lb_policy/xds/xds_cluster_manager.cc
  ${_gRPC_ROOT}/src/core/ext/filters/client_channel/lb_policy/xds/xds_cluster_resolver.cc
  ${_gRPC_ROOT}/src/core/ext/filters/client_channel/local_subchannel_pool.cc
  ${_gRPC_ROOT}/src/core/ext/filters/client_channel/proxy_mapper_registry.cc
  ${_gRPC_ROOT}/src/core/ext/filters/client_channel/resolver/binder/binder_resolver.cc
  ${_gRPC_ROOT}/src/core/ext/filters/client_channel/resolver/dns/c_ares/dns_resolver_ares.cc
  ${_gRPC_ROOT}/src/core/ext/filters/client_channel/resolver/dns/c_ares/grpc_ares_ev_driver_posix.cc
  ${_gRPC_ROOT}/src/core/ext/filters/client_channel/resolver/dns/c_ares/grpc_ares_ev_driver_windows.cc
  ${_gRPC_ROOT}/src/core/ext/filters/client_channel/resolver/dns/c_ares/grpc_ares_wrapper.cc
  ${_gRPC_ROOT}/src/core/ext/filters/client_channel/resolver/dns/c_ares/grpc_ares_wrapper_posix.cc
  ${_gRPC_ROOT}/src/core/ext/filters/client_channel/resolver/dns/c_ares/grpc_ares_wrapper_windows.cc
  ${_gRPC_ROOT}/src/core/ext/filters/client_channel/resolver/dns/dns_resolver_selection.cc
  ${_gRPC_ROOT}/src/core/ext/filters/client_channel/resolver/dns/native/dns_resolver.cc
  ${_gRPC_ROOT}/src/core/ext/filters/client_channel/resolver/fake/fake_resolver.cc
  ${_gRPC_ROOT}/src/core/ext/filters/client_channel/resolver/google_c2p/google_c2p_resolver.cc
  ${_gRPC_ROOT}/src/core/ext/filters/client_channel/resolver/polling_resolver.cc
  ${_gRPC_ROOT}/src/core/ext/filters/client_channel/resolver/sockaddr/sockaddr_resolver.cc
  ${_gRPC_ROOT}/src/core/ext/filters/client_channel/resolver/xds/xds_resolver.cc
  ${_gRPC_ROOT}/src/core/ext/filters/client_channel/resolver_result_parsing.cc
  ${_gRPC_ROOT}/src/core/ext/filters/client_channel/retry_filter.cc
  ${_gRPC_ROOT}/src/core/ext/filters/client_channel/retry_service_config.cc
  ${_gRPC_ROOT}/src/core/ext/filters/client_channel/retry_throttle.cc
  ${_gRPC_ROOT}/src/core/ext/filters/client_channel/service_config_channel_arg_filter.cc
  ${_gRPC_ROOT}/src/core/ext/filters/client_channel/subchannel.cc
  ${_gRPC_ROOT}/src/core/ext/filters/client_channel/subchannel_pool_interface.cc
  ${_gRPC_ROOT}/src/core/ext/filters/client_channel/subchannel_stream_client.cc
  ${_gRPC_ROOT}/src/core/ext/filters/deadline/deadline_filter.cc
  ${_gRPC_ROOT}/src/core/ext/filters/fault_injection/fault_injection_filter.cc
  ${_gRPC_ROOT}/src/core/ext/filters/fault_injection/service_config_parser.cc
  ${_gRPC_ROOT}/src/core/ext/filters/http/client/http_client_filter.cc
  ${_gRPC_ROOT}/src/core/ext/filters/http/client_authority_filter.cc
  ${_gRPC_ROOT}/src/core/ext/filters/http/http_filters_plugin.cc
  ${_gRPC_ROOT}/src/core/ext/filters/http/message_compress/message_compress_filter.cc
  ${_gRPC_ROOT}/src/core/ext/filters/http/message_compress/message_decompress_filter.cc
  ${_gRPC_ROOT}/src/core/ext/filters/http/server/http_server_filter.cc
  ${_gRPC_ROOT}/src/core/ext/filters/message_size/message_size_filter.cc
  ${_gRPC_ROOT}/src/core/ext/filters/rbac/rbac_filter.cc
  ${_gRPC_ROOT}/src/core/ext/filters/rbac/rbac_service_config_parser.cc
  ${_gRPC_ROOT}/src/core/ext/filters/server_config_selector/server_config_selector.cc
  ${_gRPC_ROOT}/src/core/ext/filters/server_config_selector/server_config_selector_filter.cc
  ${_gRPC_ROOT}/src/core/ext/transport/chttp2/alpn/alpn.cc
  ${_gRPC_ROOT}/src/core/ext/transport/chttp2/client/chttp2_connector.cc
  ${_gRPC_ROOT}/src/core/ext/transport/chttp2/server/chttp2_server.cc
  ${_gRPC_ROOT}/src/core/ext/transport/chttp2/transport/bin_decoder.cc
  ${_gRPC_ROOT}/src/core/ext/transport/chttp2/transport/bin_encoder.cc
  ${_gRPC_ROOT}/src/core/ext/transport/chttp2/transport/chttp2_transport.cc
  ${_gRPC_ROOT}/src/core/ext/transport/chttp2/transport/context_list.cc
  ${_gRPC_ROOT}/src/core/ext/transport/chttp2/transport/flow_control.cc
  ${_gRPC_ROOT}/src/core/ext/transport/chttp2/transport/frame_data.cc
  ${_gRPC_ROOT}/src/core/ext/transport/chttp2/transport/frame_goaway.cc
  ${_gRPC_ROOT}/src/core/ext/transport/chttp2/transport/frame_ping.cc
  ${_gRPC_ROOT}/src/core/ext/transport/chttp2/transport/frame_rst_stream.cc
  ${_gRPC_ROOT}/src/core/ext/transport/chttp2/transport/frame_settings.cc
  ${_gRPC_ROOT}/src/core/ext/transport/chttp2/transport/frame_window_update.cc
  ${_gRPC_ROOT}/src/core/ext/transport/chttp2/transport/hpack_encoder.cc
  ${_gRPC_ROOT}/src/core/ext/transport/chttp2/transport/hpack_encoder_table.cc
  ${_gRPC_ROOT}/src/core/ext/transport/chttp2/transport/hpack_parser.cc
  ${_gRPC_ROOT}/src/core/ext/transport/chttp2/transport/hpack_parser_table.cc
  ${_gRPC_ROOT}/src/core/ext/transport/chttp2/transport/http2_settings.cc
  ${_gRPC_ROOT}/src/core/ext/transport/chttp2/transport/huffsyms.cc
  ${_gRPC_ROOT}/src/core/ext/transport/chttp2/transport/parsing.cc
  ${_gRPC_ROOT}/src/core/ext/transport/chttp2/transport/stream_lists.cc
  ${_gRPC_ROOT}/src/core/ext/transport/chttp2/transport/stream_map.cc
  ${_gRPC_ROOT}/src/core/ext/transport/chttp2/transport/varint.cc
  ${_gRPC_ROOT}/src/core/ext/transport/chttp2/transport/writing.cc
  ${_gRPC_ROOT}/src/core/ext/transport/inproc/inproc_plugin.cc
  ${_gRPC_ROOT}/src/core/ext/transport/inproc/inproc_transport.cc
  ${_gRPC_ROOT}/src/core/ext/upb-generated/envoy/admin/v3/certs.upb.c
  ${_gRPC_ROOT}/src/core/ext/upb-generated/envoy/admin/v3/clusters.upb.c
  ${_gRPC_ROOT}/src/core/ext/upb-generated/envoy/admin/v3/config_dump.upb.c
  ${_gRPC_ROOT}/src/core/ext/upb-generated/envoy/admin/v3/config_dump_shared.upb.c
  ${_gRPC_ROOT}/src/core/ext/upb-generated/envoy/admin/v3/init_dump.upb.c
  ${_gRPC_ROOT}/src/core/ext/upb-generated/envoy/admin/v3/listeners.upb.c
  ${_gRPC_ROOT}/src/core/ext/upb-generated/envoy/admin/v3/memory.upb.c
  ${_gRPC_ROOT}/src/core/ext/upb-generated/envoy/admin/v3/metrics.upb.c
  ${_gRPC_ROOT}/src/core/ext/upb-generated/envoy/admin/v3/mutex_stats.upb.c
  ${_gRPC_ROOT}/src/core/ext/upb-generated/envoy/admin/v3/server_info.upb.c
  ${_gRPC_ROOT}/src/core/ext/upb-generated/envoy/admin/v3/tap.upb.c
  ${_gRPC_ROOT}/src/core/ext/upb-generated/envoy/annotations/deprecation.upb.c
  ${_gRPC_ROOT}/src/core/ext/upb-generated/envoy/annotations/resource.upb.c
  ${_gRPC_ROOT}/src/core/ext/upb-generated/envoy/config/accesslog/v3/accesslog.upb.c
  ${_gRPC_ROOT}/src/core/ext/upb-generated/envoy/config/bootstrap/v3/bootstrap.upb.c
  ${_gRPC_ROOT}/src/core/ext/upb-generated/envoy/config/cluster/v3/circuit_breaker.upb.c
  ${_gRPC_ROOT}/src/core/ext/upb-generated/envoy/config/cluster/v3/cluster.upb.c
  ${_gRPC_ROOT}/src/core/ext/upb-generated/envoy/config/cluster/v3/filter.upb.c
  ${_gRPC_ROOT}/src/core/ext/upb-generated/envoy/config/cluster/v3/outlier_detection.upb.c
  ${_gRPC_ROOT}/src/core/ext/upb-generated/envoy/config/common/matcher/v3/matcher.upb.c
  ${_gRPC_ROOT}/src/core/ext/upb-generated/envoy/config/core/v3/address.upb.c
  ${_gRPC_ROOT}/src/core/ext/upb-generated/envoy/config/core/v3/backoff.upb.c
  ${_gRPC_ROOT}/src/core/ext/upb-generated/envoy/config/core/v3/base.upb.c
  ${_gRPC_ROOT}/src/core/ext/upb-generated/envoy/config/core/v3/config_source.upb.c
  ${_gRPC_ROOT}/src/core/ext/upb-generated/envoy/config/core/v3/event_service_config.upb.c
  ${_gRPC_ROOT}/src/core/ext/upb-generated/envoy/config/core/v3/extension.upb.c
  ${_gRPC_ROOT}/src/core/ext/upb-generated/envoy/config/core/v3/grpc_method_list.upb.c
  ${_gRPC_ROOT}/src/core/ext/upb-generated/envoy/config/core/v3/grpc_service.upb.c
  ${_gRPC_ROOT}/src/core/ext/upb-generated/envoy/config/core/v3/health_check.upb.c
  ${_gRPC_ROOT}/src/core/ext/upb-generated/envoy/config/core/v3/http_uri.upb.c
  ${_gRPC_ROOT}/src/core/ext/upb-generated/envoy/config/core/v3/protocol.upb.c
  ${_gRPC_ROOT}/src/core/ext/upb-generated/envoy/config/core/v3/proxy_protocol.upb.c
  ${_gRPC_ROOT}/src/core/ext/upb-generated/envoy/config/core/v3/resolver.upb.c
  ${_gRPC_ROOT}/src/core/ext/upb-generated/envoy/config/core/v3/socket_option.upb.c
  ${_gRPC_ROOT}/src/core/ext/upb-generated/envoy/config/core/v3/substitution_format_string.upb.c
  ${_gRPC_ROOT}/src/core/ext/upb-generated/envoy/config/core/v3/udp_socket_config.upb.c
  ${_gRPC_ROOT}/src/core/ext/upb-generated/envoy/config/endpoint/v3/endpoint.upb.c
  ${_gRPC_ROOT}/src/core/ext/upb-generated/envoy/config/endpoint/v3/endpoint_components.upb.c
  ${_gRPC_ROOT}/src/core/ext/upb-generated/envoy/config/endpoint/v3/load_report.upb.c
  ${_gRPC_ROOT}/src/core/ext/upb-generated/envoy/config/listener/v3/api_listener.upb.c
  ${_gRPC_ROOT}/src/core/ext/upb-generated/envoy/config/listener/v3/listener.upb.c
  ${_gRPC_ROOT}/src/core/ext/upb-generated/envoy/config/listener/v3/listener_components.upb.c
  ${_gRPC_ROOT}/src/core/ext/upb-generated/envoy/config/listener/v3/quic_config.upb.c
  ${_gRPC_ROOT}/src/core/ext/upb-generated/envoy/config/listener/v3/udp_listener_config.upb.c
  ${_gRPC_ROOT}/src/core/ext/upb-generated/envoy/config/metrics/v3/metrics_service.upb.c
  ${_gRPC_ROOT}/src/core/ext/upb-generated/envoy/config/metrics/v3/stats.upb.c
  ${_gRPC_ROOT}/src/core/ext/upb-generated/envoy/config/overload/v3/overload.upb.c
  ${_gRPC_ROOT}/src/core/ext/upb-generated/envoy/config/rbac/v3/rbac.upb.c
  ${_gRPC_ROOT}/src/core/ext/upb-generated/envoy/config/route/v3/route.upb.c
  ${_gRPC_ROOT}/src/core/ext/upb-generated/envoy/config/route/v3/route_components.upb.c
  ${_gRPC_ROOT}/src/core/ext/upb-generated/envoy/config/route/v3/scoped_route.upb.c
  ${_gRPC_ROOT}/src/core/ext/upb-generated/envoy/config/tap/v3/common.upb.c
  ${_gRPC_ROOT}/src/core/ext/upb-generated/envoy/config/trace/v3/datadog.upb.c
  ${_gRPC_ROOT}/src/core/ext/upb-generated/envoy/config/trace/v3/dynamic_ot.upb.c
  ${_gRPC_ROOT}/src/core/ext/upb-generated/envoy/config/trace/v3/http_tracer.upb.c
  ${_gRPC_ROOT}/src/core/ext/upb-generated/envoy/config/trace/v3/lightstep.upb.c
  ${_gRPC_ROOT}/src/core/ext/upb-generated/envoy/config/trace/v3/opencensus.upb.c
  ${_gRPC_ROOT}/src/core/ext/upb-generated/envoy/config/trace/v3/opentelemetry.upb.c
  ${_gRPC_ROOT}/src/core/ext/upb-generated/envoy/config/trace/v3/service.upb.c
  ${_gRPC_ROOT}/src/core/ext/upb-generated/envoy/config/trace/v3/skywalking.upb.c
  ${_gRPC_ROOT}/src/core/ext/upb-generated/envoy/config/trace/v3/trace.upb.c
  ${_gRPC_ROOT}/src/core/ext/upb-generated/envoy/config/trace/v3/xray.upb.c
  ${_gRPC_ROOT}/src/core/ext/upb-generated/envoy/config/trace/v3/zipkin.upb.c
  ${_gRPC_ROOT}/src/core/ext/upb-generated/envoy/extensions/clusters/aggregate/v3/cluster.upb.c
  ${_gRPC_ROOT}/src/core/ext/upb-generated/envoy/extensions/filters/common/fault/v3/fault.upb.c
  ${_gRPC_ROOT}/src/core/ext/upb-generated/envoy/extensions/filters/http/fault/v3/fault.upb.c
  ${_gRPC_ROOT}/src/core/ext/upb-generated/envoy/extensions/filters/http/rbac/v3/rbac.upb.c
  ${_gRPC_ROOT}/src/core/ext/upb-generated/envoy/extensions/filters/http/router/v3/router.upb.c
  ${_gRPC_ROOT}/src/core/ext/upb-generated/envoy/extensions/filters/network/http_connection_manager/v3/http_connection_manager.upb.c
  ${_gRPC_ROOT}/src/core/ext/upb-generated/envoy/extensions/load_balancing_policies/ring_hash/v3/ring_hash.upb.c
  ${_gRPC_ROOT}/src/core/ext/upb-generated/envoy/extensions/load_balancing_policies/wrr_locality/v3/wrr_locality.upb.c
  ${_gRPC_ROOT}/src/core/ext/upb-generated/envoy/extensions/transport_sockets/tls/v3/cert.upb.c
  ${_gRPC_ROOT}/src/core/ext/upb-generated/envoy/extensions/transport_sockets/tls/v3/common.upb.c
  ${_gRPC_ROOT}/src/core/ext/upb-generated/envoy/extensions/transport_sockets/tls/v3/secret.upb.c
  ${_gRPC_ROOT}/src/core/ext/upb-generated/envoy/extensions/transport_sockets/tls/v3/tls.upb.c
  ${_gRPC_ROOT}/src/core/ext/upb-generated/envoy/extensions/transport_sockets/tls/v3/tls_spiffe_validator_config.upb.c
  ${_gRPC_ROOT}/src/core/ext/upb-generated/envoy/service/discovery/v3/ads.upb.c
  ${_gRPC_ROOT}/src/core/ext/upb-generated/envoy/service/discovery/v3/discovery.upb.c
  ${_gRPC_ROOT}/src/core/ext/upb-generated/envoy/service/load_stats/v3/lrs.upb.c
  ${_gRPC_ROOT}/src/core/ext/upb-generated/envoy/service/status/v3/csds.upb.c
  ${_gRPC_ROOT}/src/core/ext/upb-generated/envoy/type/http/v3/cookie.upb.c
  ${_gRPC_ROOT}/src/core/ext/upb-generated/envoy/type/http/v3/path_transformation.upb.c
  ${_gRPC_ROOT}/src/core/ext/upb-generated/envoy/type/matcher/v3/http_inputs.upb.c
  ${_gRPC_ROOT}/src/core/ext/upb-generated/envoy/type/matcher/v3/metadata.upb.c
  ${_gRPC_ROOT}/src/core/ext/upb-generated/envoy/type/matcher/v3/node.upb.c
  ${_gRPC_ROOT}/src/core/ext/upb-generated/envoy/type/matcher/v3/number.upb.c
  ${_gRPC_ROOT}/src/core/ext/upb-generated/envoy/type/matcher/v3/path.upb.c
  ${_gRPC_ROOT}/src/core/ext/upb-generated/envoy/type/matcher/v3/regex.upb.c
  ${_gRPC_ROOT}/src/core/ext/upb-generated/envoy/type/matcher/v3/string.upb.c
  ${_gRPC_ROOT}/src/core/ext/upb-generated/envoy/type/matcher/v3/struct.upb.c
  ${_gRPC_ROOT}/src/core/ext/upb-generated/envoy/type/matcher/v3/value.upb.c
  ${_gRPC_ROOT}/src/core/ext/upb-generated/envoy/type/metadata/v3/metadata.upb.c
  ${_gRPC_ROOT}/src/core/ext/upb-generated/envoy/type/tracing/v3/custom_tag.upb.c
  ${_gRPC_ROOT}/src/core/ext/upb-generated/envoy/type/v3/hash_policy.upb.c
  ${_gRPC_ROOT}/src/core/ext/upb-generated/envoy/type/v3/http.upb.c
  ${_gRPC_ROOT}/src/core/ext/upb-generated/envoy/type/v3/http_status.upb.c
  ${_gRPC_ROOT}/src/core/ext/upb-generated/envoy/type/v3/percent.upb.c
  ${_gRPC_ROOT}/src/core/ext/upb-generated/envoy/type/v3/range.upb.c
  ${_gRPC_ROOT}/src/core/ext/upb-generated/envoy/type/v3/ratelimit_strategy.upb.c
  ${_gRPC_ROOT}/src/core/ext/upb-generated/envoy/type/v3/ratelimit_unit.upb.c
  ${_gRPC_ROOT}/src/core/ext/upb-generated/envoy/type/v3/semantic_version.upb.c
  ${_gRPC_ROOT}/src/core/ext/upb-generated/envoy/type/v3/token_bucket.upb.c
  ${_gRPC_ROOT}/src/core/ext/upb-generated/google/api/annotations.upb.c
  ${_gRPC_ROOT}/src/core/ext/upb-generated/google/api/expr/v1alpha1/checked.upb.c
  ${_gRPC_ROOT}/src/core/ext/upb-generated/google/api/expr/v1alpha1/syntax.upb.c
  ${_gRPC_ROOT}/src/core/ext/upb-generated/google/api/http.upb.c
  ${_gRPC_ROOT}/src/core/ext/upb-generated/google/api/httpbody.upb.c
  ${_gRPC_ROOT}/src/core/ext/upb-generated/google/protobuf/any.upb.c
  ${_gRPC_ROOT}/src/core/ext/upb-generated/google/protobuf/descriptor.upb.c
  ${_gRPC_ROOT}/src/core/ext/upb-generated/google/protobuf/duration.upb.c
  ${_gRPC_ROOT}/src/core/ext/upb-generated/google/protobuf/empty.upb.c
  ${_gRPC_ROOT}/src/core/ext/upb-generated/google/protobuf/struct.upb.c
  ${_gRPC_ROOT}/src/core/ext/upb-generated/google/protobuf/timestamp.upb.c
  ${_gRPC_ROOT}/src/core/ext/upb-generated/google/protobuf/wrappers.upb.c
  ${_gRPC_ROOT}/src/core/ext/upb-generated/google/rpc/status.upb.c
  ${_gRPC_ROOT}/src/core/ext/upb-generated/opencensus/proto/trace/v1/trace_config.upb.c
  ${_gRPC_ROOT}/src/core/ext/upb-generated/src/proto/grpc/gcp/altscontext.upb.c
  ${_gRPC_ROOT}/src/core/ext/upb-generated/src/proto/grpc/gcp/handshaker.upb.c
  ${_gRPC_ROOT}/src/core/ext/upb-generated/src/proto/grpc/gcp/transport_security_common.upb.c
  ${_gRPC_ROOT}/src/core/ext/upb-generated/src/proto/grpc/health/v1/health.upb.c
  ${_gRPC_ROOT}/src/core/ext/upb-generated/src/proto/grpc/lb/v1/load_balancer.upb.c
  ${_gRPC_ROOT}/src/core/ext/upb-generated/src/proto/grpc/lookup/v1/rls.upb.c
  ${_gRPC_ROOT}/src/core/ext/upb-generated/src/proto/grpc/lookup/v1/rls_config.upb.c
  ${_gRPC_ROOT}/src/core/ext/upb-generated/udpa/annotations/migrate.upb.c
  ${_gRPC_ROOT}/src/core/ext/upb-generated/udpa/annotations/security.upb.c
  ${_gRPC_ROOT}/src/core/ext/upb-generated/udpa/annotations/sensitive.upb.c
  ${_gRPC_ROOT}/src/core/ext/upb-generated/udpa/annotations/status.upb.c
  ${_gRPC_ROOT}/src/core/ext/upb-generated/udpa/annotations/versioning.upb.c
  ${_gRPC_ROOT}/src/core/ext/upb-generated/validate/validate.upb.c
  ${_gRPC_ROOT}/src/core/ext/upb-generated/xds/annotations/v3/migrate.upb.c
  ${_gRPC_ROOT}/src/core/ext/upb-generated/xds/annotations/v3/security.upb.c
  ${_gRPC_ROOT}/src/core/ext/upb-generated/xds/annotations/v3/sensitive.upb.c
  ${_gRPC_ROOT}/src/core/ext/upb-generated/xds/annotations/v3/status.upb.c
  ${_gRPC_ROOT}/src/core/ext/upb-generated/xds/annotations/v3/versioning.upb.c
  ${_gRPC_ROOT}/src/core/ext/upb-generated/xds/core/v3/authority.upb.c
  ${_gRPC_ROOT}/src/core/ext/upb-generated/xds/core/v3/collection_entry.upb.c
  ${_gRPC_ROOT}/src/core/ext/upb-generated/xds/core/v3/context_params.upb.c
  ${_gRPC_ROOT}/src/core/ext/upb-generated/xds/core/v3/extension.upb.c
  ${_gRPC_ROOT}/src/core/ext/upb-generated/xds/core/v3/resource.upb.c
  ${_gRPC_ROOT}/src/core/ext/upb-generated/xds/core/v3/resource_locator.upb.c
  ${_gRPC_ROOT}/src/core/ext/upb-generated/xds/core/v3/resource_name.upb.c
  ${_gRPC_ROOT}/src/core/ext/upb-generated/xds/data/orca/v3/orca_load_report.upb.c
  ${_gRPC_ROOT}/src/core/ext/upb-generated/xds/service/orca/v3/orca.upb.c
  ${_gRPC_ROOT}/src/core/ext/upb-generated/xds/type/matcher/v3/matcher.upb.c
  ${_gRPC_ROOT}/src/core/ext/upb-generated/xds/type/matcher/v3/regex.upb.c
  ${_gRPC_ROOT}/src/core/ext/upb-generated/xds/type/matcher/v3/string.upb.c
  ${_gRPC_ROOT}/src/core/ext/upb-generated/xds/type/v3/typed_struct.upb.c
  ${_gRPC_ROOT}/src/core/ext/upbdefs-generated/envoy/admin/v3/certs.upbdefs.c
  ${_gRPC_ROOT}/src/core/ext/upbdefs-generated/envoy/admin/v3/clusters.upbdefs.c
  ${_gRPC_ROOT}/src/core/ext/upbdefs-generated/envoy/admin/v3/config_dump.upbdefs.c
  ${_gRPC_ROOT}/src/core/ext/upbdefs-generated/envoy/admin/v3/config_dump_shared.upbdefs.c
  ${_gRPC_ROOT}/src/core/ext/upbdefs-generated/envoy/admin/v3/init_dump.upbdefs.c
  ${_gRPC_ROOT}/src/core/ext/upbdefs-generated/envoy/admin/v3/listeners.upbdefs.c
  ${_gRPC_ROOT}/src/core/ext/upbdefs-generated/envoy/admin/v3/memory.upbdefs.c
  ${_gRPC_ROOT}/src/core/ext/upbdefs-generated/envoy/admin/v3/metrics.upbdefs.c
  ${_gRPC_ROOT}/src/core/ext/upbdefs-generated/envoy/admin/v3/mutex_stats.upbdefs.c
  ${_gRPC_ROOT}/src/core/ext/upbdefs-generated/envoy/admin/v3/server_info.upbdefs.c
  ${_gRPC_ROOT}/src/core/ext/upbdefs-generated/envoy/admin/v3/tap.upbdefs.c
  ${_gRPC_ROOT}/src/core/ext/upbdefs-generated/envoy/annotations/deprecation.upbdefs.c
  ${_gRPC_ROOT}/src/core/ext/upbdefs-generated/envoy/annotations/resource.upbdefs.c
  ${_gRPC_ROOT}/src/core/ext/upbdefs-generated/envoy/config/accesslog/v3/accesslog.upbdefs.c
  ${_gRPC_ROOT}/src/core/ext/upbdefs-generated/envoy/config/bootstrap/v3/bootstrap.upbdefs.c
  ${_gRPC_ROOT}/src/core/ext/upbdefs-generated/envoy/config/cluster/v3/circuit_breaker.upbdefs.c
  ${_gRPC_ROOT}/src/core/ext/upbdefs-generated/envoy/config/cluster/v3/cluster.upbdefs.c
  ${_gRPC_ROOT}/src/core/ext/upbdefs-generated/envoy/config/cluster/v3/filter.upbdefs.c
  ${_gRPC_ROOT}/src/core/ext/upbdefs-generated/envoy/config/cluster/v3/outlier_detection.upbdefs.c
  ${_gRPC_ROOT}/src/core/ext/upbdefs-generated/envoy/config/common/matcher/v3/matcher.upbdefs.c
  ${_gRPC_ROOT}/src/core/ext/upbdefs-generated/envoy/config/core/v3/address.upbdefs.c
  ${_gRPC_ROOT}/src/core/ext/upbdefs-generated/envoy/config/core/v3/backoff.upbdefs.c
  ${_gRPC_ROOT}/src/core/ext/upbdefs-generated/envoy/config/core/v3/base.upbdefs.c
  ${_gRPC_ROOT}/src/core/ext/upbdefs-generated/envoy/config/core/v3/config_source.upbdefs.c
  ${_gRPC_ROOT}/src/core/ext/upbdefs-generated/envoy/config/core/v3/event_service_config.upbdefs.c
  ${_gRPC_ROOT}/src/core/ext/upbdefs-generated/envoy/config/core/v3/extension.upbdefs.c
  ${_gRPC_ROOT}/src/core/ext/upbdefs-generated/envoy/config/core/v3/grpc_method_list.upbdefs.c
  ${_gRPC_ROOT}/src/core/ext/upbdefs-generated/envoy/config/core/v3/grpc_service.upbdefs.c
  ${_gRPC_ROOT}/src/core/ext/upbdefs-generated/envoy/config/core/v3/health_check.upbdefs.c
  ${_gRPC_ROOT}/src/core/ext/upbdefs-generated/envoy/config/core/v3/http_uri.upbdefs.c
  ${_gRPC_ROOT}/src/core/ext/upbdefs-generated/envoy/config/core/v3/protocol.upbdefs.c
  ${_gRPC_ROOT}/src/core/ext/upbdefs-generated/envoy/config/core/v3/proxy_protocol.upbdefs.c
  ${_gRPC_ROOT}/src/core/ext/upbdefs-generated/envoy/config/core/v3/resolver.upbdefs.c
  ${_gRPC_ROOT}/src/core/ext/upbdefs-generated/envoy/config/core/v3/socket_option.upbdefs.c
  ${_gRPC_ROOT}/src/core/ext/upbdefs-generated/envoy/config/core/v3/substitution_format_string.upbdefs.c
  ${_gRPC_ROOT}/src/core/ext/upbdefs-generated/envoy/config/core/v3/udp_socket_config.upbdefs.c
  ${_gRPC_ROOT}/src/core/ext/upbdefs-generated/envoy/config/endpoint/v3/endpoint.upbdefs.c
  ${_gRPC_ROOT}/src/core/ext/upbdefs-generated/envoy/config/endpoint/v3/endpoint_components.upbdefs.c
  ${_gRPC_ROOT}/src/core/ext/upbdefs-generated/envoy/config/endpoint/v3/load_report.upbdefs.c
  ${_gRPC_ROOT}/src/core/ext/upbdefs-generated/envoy/config/listener/v3/api_listener.upbdefs.c
  ${_gRPC_ROOT}/src/core/ext/upbdefs-generated/envoy/config/listener/v3/listener.upbdefs.c
  ${_gRPC_ROOT}/src/core/ext/upbdefs-generated/envoy/config/listener/v3/listener_components.upbdefs.c
  ${_gRPC_ROOT}/src/core/ext/upbdefs-generated/envoy/config/listener/v3/quic_config.upbdefs.c
  ${_gRPC_ROOT}/src/core/ext/upbdefs-generated/envoy/config/listener/v3/udp_listener_config.upbdefs.c
  ${_gRPC_ROOT}/src/core/ext/upbdefs-generated/envoy/config/metrics/v3/metrics_service.upbdefs.c
  ${_gRPC_ROOT}/src/core/ext/upbdefs-generated/envoy/config/metrics/v3/stats.upbdefs.c
  ${_gRPC_ROOT}/src/core/ext/upbdefs-generated/envoy/config/overload/v3/overload.upbdefs.c
  ${_gRPC_ROOT}/src/core/ext/upbdefs-generated/envoy/config/rbac/v3/rbac.upbdefs.c
  ${_gRPC_ROOT}/src/core/ext/upbdefs-generated/envoy/config/route/v3/route.upbdefs.c
  ${_gRPC_ROOT}/src/core/ext/upbdefs-generated/envoy/config/route/v3/route_components.upbdefs.c
  ${_gRPC_ROOT}/src/core/ext/upbdefs-generated/envoy/config/route/v3/scoped_route.upbdefs.c
  ${_gRPC_ROOT}/src/core/ext/upbdefs-generated/envoy/config/tap/v3/common.upbdefs.c
  ${_gRPC_ROOT}/src/core/ext/upbdefs-generated/envoy/config/trace/v3/datadog.upbdefs.c
  ${_gRPC_ROOT}/src/core/ext/upbdefs-generated/envoy/config/trace/v3/dynamic_ot.upbdefs.c
  ${_gRPC_ROOT}/src/core/ext/upbdefs-generated/envoy/config/trace/v3/http_tracer.upbdefs.c
  ${_gRPC_ROOT}/src/core/ext/upbdefs-generated/envoy/config/trace/v3/lightstep.upbdefs.c
  ${_gRPC_ROOT}/src/core/ext/upbdefs-generated/envoy/config/trace/v3/opencensus.upbdefs.c
  ${_gRPC_ROOT}/src/core/ext/upbdefs-generated/envoy/config/trace/v3/opentelemetry.upbdefs.c
  ${_gRPC_ROOT}/src/core/ext/upbdefs-generated/envoy/config/trace/v3/service.upbdefs.c
  ${_gRPC_ROOT}/src/core/ext/upbdefs-generated/envoy/config/trace/v3/skywalking.upbdefs.c
  ${_gRPC_ROOT}/src/core/ext/upbdefs-generated/envoy/config/trace/v3/trace.upbdefs.c
  ${_gRPC_ROOT}/src/core/ext/upbdefs-generated/envoy/config/trace/v3/xray.upbdefs.c
  ${_gRPC_ROOT}/src/core/ext/upbdefs-generated/envoy/config/trace/v3/zipkin.upbdefs.c
  ${_gRPC_ROOT}/src/core/ext/upbdefs-generated/envoy/extensions/clusters/aggregate/v3/cluster.upbdefs.c
  ${_gRPC_ROOT}/src/core/ext/upbdefs-generated/envoy/extensions/filters/common/fault/v3/fault.upbdefs.c
  ${_gRPC_ROOT}/src/core/ext/upbdefs-generated/envoy/extensions/filters/http/fault/v3/fault.upbdefs.c
  ${_gRPC_ROOT}/src/core/ext/upbdefs-generated/envoy/extensions/filters/http/rbac/v3/rbac.upbdefs.c
  ${_gRPC_ROOT}/src/core/ext/upbdefs-generated/envoy/extensions/filters/http/router/v3/router.upbdefs.c
  ${_gRPC_ROOT}/src/core/ext/upbdefs-generated/envoy/extensions/filters/network/http_connection_manager/v3/http_connection_manager.upbdefs.c
  ${_gRPC_ROOT}/src/core/ext/upbdefs-generated/envoy/extensions/transport_sockets/tls/v3/cert.upbdefs.c
  ${_gRPC_ROOT}/src/core/ext/upbdefs-generated/envoy/extensions/transport_sockets/tls/v3/common.upbdefs.c
  ${_gRPC_ROOT}/src/core/ext/upbdefs-generated/envoy/extensions/transport_sockets/tls/v3/secret.upbdefs.c
  ${_gRPC_ROOT}/src/core/ext/upbdefs-generated/envoy/extensions/transport_sockets/tls/v3/tls.upbdefs.c
  ${_gRPC_ROOT}/src/core/ext/upbdefs-generated/envoy/extensions/transport_sockets/tls/v3/tls_spiffe_validator_config.upbdefs.c
  ${_gRPC_ROOT}/src/core/ext/upbdefs-generated/envoy/service/discovery/v3/ads.upbdefs.c
  ${_gRPC_ROOT}/src/core/ext/upbdefs-generated/envoy/service/discovery/v3/discovery.upbdefs.c
  ${_gRPC_ROOT}/src/core/ext/upbdefs-generated/envoy/service/load_stats/v3/lrs.upbdefs.c
  ${_gRPC_ROOT}/src/core/ext/upbdefs-generated/envoy/service/status/v3/csds.upbdefs.c
  ${_gRPC_ROOT}/src/core/ext/upbdefs-generated/envoy/type/http/v3/cookie.upbdefs.c
  ${_gRPC_ROOT}/src/core/ext/upbdefs-generated/envoy/type/http/v3/path_transformation.upbdefs.c
  ${_gRPC_ROOT}/src/core/ext/upbdefs-generated/envoy/type/matcher/v3/http_inputs.upbdefs.c
  ${_gRPC_ROOT}/src/core/ext/upbdefs-generated/envoy/type/matcher/v3/metadata.upbdefs.c
  ${_gRPC_ROOT}/src/core/ext/upbdefs-generated/envoy/type/matcher/v3/node.upbdefs.c
  ${_gRPC_ROOT}/src/core/ext/upbdefs-generated/envoy/type/matcher/v3/number.upbdefs.c
  ${_gRPC_ROOT}/src/core/ext/upbdefs-generated/envoy/type/matcher/v3/path.upbdefs.c
  ${_gRPC_ROOT}/src/core/ext/upbdefs-generated/envoy/type/matcher/v3/regex.upbdefs.c
  ${_gRPC_ROOT}/src/core/ext/upbdefs-generated/envoy/type/matcher/v3/string.upbdefs.c
  ${_gRPC_ROOT}/src/core/ext/upbdefs-generated/envoy/type/matcher/v3/struct.upbdefs.c
  ${_gRPC_ROOT}/src/core/ext/upbdefs-generated/envoy/type/matcher/v3/value.upbdefs.c
  ${_gRPC_ROOT}/src/core/ext/upbdefs-generated/envoy/type/metadata/v3/metadata.upbdefs.c
  ${_gRPC_ROOT}/src/core/ext/upbdefs-generated/envoy/type/tracing/v3/custom_tag.upbdefs.c
  ${_gRPC_ROOT}/src/core/ext/upbdefs-generated/envoy/type/v3/hash_policy.upbdefs.c
  ${_gRPC_ROOT}/src/core/ext/upbdefs-generated/envoy/type/v3/http.upbdefs.c
  ${_gRPC_ROOT}/src/core/ext/upbdefs-generated/envoy/type/v3/http_status.upbdefs.c
  ${_gRPC_ROOT}/src/core/ext/upbdefs-generated/envoy/type/v3/percent.upbdefs.c
  ${_gRPC_ROOT}/src/core/ext/upbdefs-generated/envoy/type/v3/range.upbdefs.c
  ${_gRPC_ROOT}/src/core/ext/upbdefs-generated/envoy/type/v3/ratelimit_strategy.upbdefs.c
  ${_gRPC_ROOT}/src/core/ext/upbdefs-generated/envoy/type/v3/ratelimit_unit.upbdefs.c
  ${_gRPC_ROOT}/src/core/ext/upbdefs-generated/envoy/type/v3/semantic_version.upbdefs.c
  ${_gRPC_ROOT}/src/core/ext/upbdefs-generated/envoy/type/v3/token_bucket.upbdefs.c
  ${_gRPC_ROOT}/src/core/ext/upbdefs-generated/google/api/annotations.upbdefs.c
  ${_gRPC_ROOT}/src/core/ext/upbdefs-generated/google/api/expr/v1alpha1/checked.upbdefs.c
  ${_gRPC_ROOT}/src/core/ext/upbdefs-generated/google/api/expr/v1alpha1/syntax.upbdefs.c
  ${_gRPC_ROOT}/src/core/ext/upbdefs-generated/google/api/http.upbdefs.c
  ${_gRPC_ROOT}/src/core/ext/upbdefs-generated/google/api/httpbody.upbdefs.c
  ${_gRPC_ROOT}/src/core/ext/upbdefs-generated/google/protobuf/any.upbdefs.c
  ${_gRPC_ROOT}/src/core/ext/upbdefs-generated/google/protobuf/descriptor.upbdefs.c
  ${_gRPC_ROOT}/src/core/ext/upbdefs-generated/google/protobuf/duration.upbdefs.c
  ${_gRPC_ROOT}/src/core/ext/upbdefs-generated/google/protobuf/empty.upbdefs.c
  ${_gRPC_ROOT}/src/core/ext/upbdefs-generated/google/protobuf/struct.upbdefs.c
  ${_gRPC_ROOT}/src/core/ext/upbdefs-generated/google/protobuf/timestamp.upbdefs.c
  ${_gRPC_ROOT}/src/core/ext/upbdefs-generated/google/protobuf/wrappers.upbdefs.c
  ${_gRPC_ROOT}/src/core/ext/upbdefs-generated/google/rpc/status.upbdefs.c
  ${_gRPC_ROOT}/src/core/ext/upbdefs-generated/opencensus/proto/trace/v1/trace_config.upbdefs.c
  ${_gRPC_ROOT}/src/core/ext/upbdefs-generated/src/proto/grpc/lookup/v1/rls_config.upbdefs.c
  ${_gRPC_ROOT}/src/core/ext/upbdefs-generated/udpa/annotations/migrate.upbdefs.c
  ${_gRPC_ROOT}/src/core/ext/upbdefs-generated/udpa/annotations/security.upbdefs.c
  ${_gRPC_ROOT}/src/core/ext/upbdefs-generated/udpa/annotations/sensitive.upbdefs.c
  ${_gRPC_ROOT}/src/core/ext/upbdefs-generated/udpa/annotations/status.upbdefs.c
  ${_gRPC_ROOT}/src/core/ext/upbdefs-generated/udpa/annotations/versioning.upbdefs.c
  ${_gRPC_ROOT}/src/core/ext/upbdefs-generated/validate/validate.upbdefs.c
  ${_gRPC_ROOT}/src/core/ext/upbdefs-generated/xds/annotations/v3/migrate.upbdefs.c
  ${_gRPC_ROOT}/src/core/ext/upbdefs-generated/xds/annotations/v3/security.upbdefs.c
  ${_gRPC_ROOT}/src/core/ext/upbdefs-generated/xds/annotations/v3/sensitive.upbdefs.c
  ${_gRPC_ROOT}/src/core/ext/upbdefs-generated/xds/annotations/v3/status.upbdefs.c
  ${_gRPC_ROOT}/src/core/ext/upbdefs-generated/xds/annotations/v3/versioning.upbdefs.c
  ${_gRPC_ROOT}/src/core/ext/upbdefs-generated/xds/core/v3/authority.upbdefs.c
  ${_gRPC_ROOT}/src/core/ext/upbdefs-generated/xds/core/v3/collection_entry.upbdefs.c
  ${_gRPC_ROOT}/src/core/ext/upbdefs-generated/xds/core/v3/context_params.upbdefs.c
  ${_gRPC_ROOT}/src/core/ext/upbdefs-generated/xds/core/v3/extension.upbdefs.c
  ${_gRPC_ROOT}/src/core/ext/upbdefs-generated/xds/core/v3/resource.upbdefs.c
  ${_gRPC_ROOT}/src/core/ext/upbdefs-generated/xds/core/v3/resource_locator.upbdefs.c
  ${_gRPC_ROOT}/src/core/ext/upbdefs-generated/xds/core/v3/resource_name.upbdefs.c
  ${_gRPC_ROOT}/src/core/ext/upbdefs-generated/xds/type/matcher/v3/matcher.upbdefs.c
  ${_gRPC_ROOT}/src/core/ext/upbdefs-generated/xds/type/matcher/v3/regex.upbdefs.c
  ${_gRPC_ROOT}/src/core/ext/upbdefs-generated/xds/type/matcher/v3/string.upbdefs.c
  ${_gRPC_ROOT}/src/core/ext/upbdefs-generated/xds/type/v3/typed_struct.upbdefs.c
  ${_gRPC_ROOT}/src/core/ext/xds/certificate_provider_registry.cc
  ${_gRPC_ROOT}/src/core/ext/xds/certificate_provider_store.cc
  ${_gRPC_ROOT}/src/core/ext/xds/file_watcher_certificate_provider_factory.cc
  ${_gRPC_ROOT}/src/core/ext/xds/xds_api.cc
  ${_gRPC_ROOT}/src/core/ext/xds/xds_bootstrap.cc
  ${_gRPC_ROOT}/src/core/ext/xds/xds_bootstrap_grpc.cc
  ${_gRPC_ROOT}/src/core/ext/xds/xds_certificate_provider.cc
  ${_gRPC_ROOT}/src/core/ext/xds/xds_channel_stack_modifier.cc
  ${_gRPC_ROOT}/src/core/ext/xds/xds_client.cc
  ${_gRPC_ROOT}/src/core/ext/xds/xds_client_grpc.cc
  ${_gRPC_ROOT}/src/core/ext/xds/xds_client_stats.cc
  ${_gRPC_ROOT}/src/core/ext/xds/xds_cluster.cc
  ${_gRPC_ROOT}/src/core/ext/xds/xds_cluster_specifier_plugin.cc
  ${_gRPC_ROOT}/src/core/ext/xds/xds_common_types.cc
  ${_gRPC_ROOT}/src/core/ext/xds/xds_endpoint.cc
  ${_gRPC_ROOT}/src/core/ext/xds/xds_http_fault_filter.cc
  ${_gRPC_ROOT}/src/core/ext/xds/xds_http_filters.cc
  ${_gRPC_ROOT}/src/core/ext/xds/xds_http_rbac_filter.cc
  ${_gRPC_ROOT}/src/core/ext/xds/xds_lb_policy_registry.cc
  ${_gRPC_ROOT}/src/core/ext/xds/xds_listener.cc
  ${_gRPC_ROOT}/src/core/ext/xds/xds_resource_type.cc
  ${_gRPC_ROOT}/src/core/ext/xds/xds_route_config.cc
  ${_gRPC_ROOT}/src/core/ext/xds/xds_routing.cc
  ${_gRPC_ROOT}/src/core/ext/xds/xds_server_config_fetcher.cc
  ${_gRPC_ROOT}/src/core/ext/xds/xds_transport_grpc.cc
  ${_gRPC_ROOT}/src/core/lib/address_utils/parse_address.cc
  ${_gRPC_ROOT}/src/core/lib/address_utils/sockaddr_utils.cc
  ${_gRPC_ROOT}/src/core/lib/backoff/backoff.cc
  ${_gRPC_ROOT}/src/core/lib/channel/channel_args.cc
  ${_gRPC_ROOT}/src/core/lib/channel/channel_args_preconditioning.cc
  ${_gRPC_ROOT}/src/core/lib/channel/channel_stack.cc
  ${_gRPC_ROOT}/src/core/lib/channel/channel_stack_builder.cc
  ${_gRPC_ROOT}/src/core/lib/channel/channel_stack_builder_impl.cc
  ${_gRPC_ROOT}/src/core/lib/channel/channel_trace.cc
  ${_gRPC_ROOT}/src/core/lib/channel/channelz.cc
  ${_gRPC_ROOT}/src/core/lib/channel/channelz_registry.cc
  ${_gRPC_ROOT}/src/core/lib/channel/connected_channel.cc
  ${_gRPC_ROOT}/src/core/lib/channel/promise_based_filter.cc
  ${_gRPC_ROOT}/src/core/lib/channel/status_util.cc
  ${_gRPC_ROOT}/src/core/lib/compression/compression.cc
  ${_gRPC_ROOT}/src/core/lib/compression/compression_internal.cc
  ${_gRPC_ROOT}/src/core/lib/compression/message_compress.cc
  ${_gRPC_ROOT}/src/core/lib/config/core_configuration.cc
  ${_gRPC_ROOT}/src/core/lib/debug/stats.cc
  ${_gRPC_ROOT}/src/core/lib/debug/stats_data.cc
  ${_gRPC_ROOT}/src/core/lib/debug/trace.cc
  ${_gRPC_ROOT}/src/core/lib/event_engine/channel_args_endpoint_config.cc
  ${_gRPC_ROOT}/src/core/lib/event_engine/default_event_engine.cc
  ${_gRPC_ROOT}/src/core/lib/event_engine/default_event_engine_factory.cc
  ${_gRPC_ROOT}/src/core/lib/event_engine/executor/threaded_executor.cc
  ${_gRPC_ROOT}/src/core/lib/event_engine/forkable.cc
  ${_gRPC_ROOT}/src/core/lib/event_engine/memory_allocator.cc
  ${_gRPC_ROOT}/src/core/lib/event_engine/posix_engine/posix_engine.cc
  ${_gRPC_ROOT}/src/core/lib/event_engine/posix_engine/timer.cc
  ${_gRPC_ROOT}/src/core/lib/event_engine/posix_engine/timer_heap.cc
  ${_gRPC_ROOT}/src/core/lib/event_engine/posix_engine/timer_manager.cc
  ${_gRPC_ROOT}/src/core/lib/event_engine/resolved_address.cc
  ${_gRPC_ROOT}/src/core/lib/event_engine/slice.cc
  ${_gRPC_ROOT}/src/core/lib/event_engine/slice_buffer.cc
  ${_gRPC_ROOT}/src/core/lib/event_engine/thread_pool.cc
  ${_gRPC_ROOT}/src/core/lib/event_engine/trace.cc
  ${_gRPC_ROOT}/src/core/lib/event_engine/utils.cc
  ${_gRPC_ROOT}/src/core/lib/event_engine/windows/iocp.cc
  ${_gRPC_ROOT}/src/core/lib/event_engine/windows/win_socket.cc
  ${_gRPC_ROOT}/src/core/lib/event_engine/windows/windows_engine.cc
  ${_gRPC_ROOT}/src/core/lib/experiments/experiments.cc
  ${_gRPC_ROOT}/src/core/lib/gprpp/status_helper.cc
  ${_gRPC_ROOT}/src/core/lib/gprpp/time.cc
  ${_gRPC_ROOT}/src/core/lib/gprpp/time_averaged_stats.cc
  ${_gRPC_ROOT}/src/core/lib/gprpp/work_serializer.cc
  ${_gRPC_ROOT}/src/core/lib/http/format_request.cc
  ${_gRPC_ROOT}/src/core/lib/http/httpcli.cc
  ${_gRPC_ROOT}/src/core/lib/http/httpcli_security_connector.cc
  ${_gRPC_ROOT}/src/core/lib/http/parser.cc
  ${_gRPC_ROOT}/src/core/lib/iomgr/buffer_list.cc
  ${_gRPC_ROOT}/src/core/lib/iomgr/call_combiner.cc
  ${_gRPC_ROOT}/src/core/lib/iomgr/cfstream_handle.cc
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
  ${_gRPC_ROOT}/src/core/lib/iomgr/ev_windows.cc
  ${_gRPC_ROOT}/src/core/lib/iomgr/exec_ctx.cc
  ${_gRPC_ROOT}/src/core/lib/iomgr/executor.cc
  ${_gRPC_ROOT}/src/core/lib/iomgr/fork_posix.cc
  ${_gRPC_ROOT}/src/core/lib/iomgr/fork_windows.cc
  ${_gRPC_ROOT}/src/core/lib/iomgr/gethostname_fallback.cc
  ${_gRPC_ROOT}/src/core/lib/iomgr/gethostname_host_name_max.cc
  ${_gRPC_ROOT}/src/core/lib/iomgr/gethostname_sysconf.cc
  ${_gRPC_ROOT}/src/core/lib/iomgr/grpc_if_nametoindex_posix.cc
  ${_gRPC_ROOT}/src/core/lib/iomgr/grpc_if_nametoindex_unsupported.cc
  ${_gRPC_ROOT}/src/core/lib/iomgr/internal_errqueue.cc
  ${_gRPC_ROOT}/src/core/lib/iomgr/iocp_windows.cc
  ${_gRPC_ROOT}/src/core/lib/iomgr/iomgr.cc
  ${_gRPC_ROOT}/src/core/lib/iomgr/iomgr_internal.cc
  ${_gRPC_ROOT}/src/core/lib/iomgr/iomgr_posix.cc
  ${_gRPC_ROOT}/src/core/lib/iomgr/iomgr_posix_cfstream.cc
  ${_gRPC_ROOT}/src/core/lib/iomgr/iomgr_windows.cc
  ${_gRPC_ROOT}/src/core/lib/iomgr/load_file.cc
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
  ${_gRPC_ROOT}/src/core/lib/iomgr/wakeup_fd_eventfd.cc
  ${_gRPC_ROOT}/src/core/lib/iomgr/wakeup_fd_nospecial.cc
  ${_gRPC_ROOT}/src/core/lib/iomgr/wakeup_fd_pipe.cc
  ${_gRPC_ROOT}/src/core/lib/iomgr/wakeup_fd_posix.cc
  ${_gRPC_ROOT}/src/core/lib/json/json_object_loader.cc
  ${_gRPC_ROOT}/src/core/lib/json/json_reader.cc
  ${_gRPC_ROOT}/src/core/lib/json/json_util.cc
  ${_gRPC_ROOT}/src/core/lib/json/json_writer.cc
  ${_gRPC_ROOT}/src/core/lib/load_balancing/lb_policy.cc
  ${_gRPC_ROOT}/src/core/lib/load_balancing/lb_policy_registry.cc
  ${_gRPC_ROOT}/src/core/lib/matchers/matchers.cc
  ${_gRPC_ROOT}/src/core/lib/promise/activity.cc
  ${_gRPC_ROOT}/src/core/lib/promise/sleep.cc
  ${_gRPC_ROOT}/src/core/lib/resolver/resolver.cc
  ${_gRPC_ROOT}/src/core/lib/resolver/resolver_registry.cc
  ${_gRPC_ROOT}/src/core/lib/resolver/server_address.cc
  ${_gRPC_ROOT}/src/core/lib/resource_quota/api.cc
  ${_gRPC_ROOT}/src/core/lib/resource_quota/arena.cc
  ${_gRPC_ROOT}/src/core/lib/resource_quota/memory_quota.cc
  ${_gRPC_ROOT}/src/core/lib/resource_quota/periodic_update.cc
  ${_gRPC_ROOT}/src/core/lib/resource_quota/resource_quota.cc
  ${_gRPC_ROOT}/src/core/lib/resource_quota/thread_quota.cc
  ${_gRPC_ROOT}/src/core/lib/resource_quota/trace.cc
  ${_gRPC_ROOT}/src/core/lib/security/authorization/authorization_policy_provider_vtable.cc
  ${_gRPC_ROOT}/src/core/lib/security/authorization/evaluate_args.cc
  ${_gRPC_ROOT}/src/core/lib/security/authorization/grpc_authorization_engine.cc
  ${_gRPC_ROOT}/src/core/lib/security/authorization/grpc_server_authz_filter.cc
  ${_gRPC_ROOT}/src/core/lib/security/authorization/matchers.cc
  ${_gRPC_ROOT}/src/core/lib/security/authorization/rbac_policy.cc
  ${_gRPC_ROOT}/src/core/lib/security/context/security_context.cc
  ${_gRPC_ROOT}/src/core/lib/security/credentials/alts/alts_credentials.cc
  ${_gRPC_ROOT}/src/core/lib/security/credentials/alts/check_gcp_environment.cc
  ${_gRPC_ROOT}/src/core/lib/security/credentials/alts/check_gcp_environment_linux.cc
  ${_gRPC_ROOT}/src/core/lib/security/credentials/alts/check_gcp_environment_no_op.cc
  ${_gRPC_ROOT}/src/core/lib/security/credentials/alts/check_gcp_environment_windows.cc
  ${_gRPC_ROOT}/src/core/lib/security/credentials/alts/grpc_alts_credentials_client_options.cc
  ${_gRPC_ROOT}/src/core/lib/security/credentials/alts/grpc_alts_credentials_options.cc
  ${_gRPC_ROOT}/src/core/lib/security/credentials/alts/grpc_alts_credentials_server_options.cc
  ${_gRPC_ROOT}/src/core/lib/security/credentials/call_creds_util.cc
  ${_gRPC_ROOT}/src/core/lib/security/credentials/channel_creds_registry_init.cc
  ${_gRPC_ROOT}/src/core/lib/security/credentials/composite/composite_credentials.cc
  ${_gRPC_ROOT}/src/core/lib/security/credentials/credentials.cc
  ${_gRPC_ROOT}/src/core/lib/security/credentials/external/aws_external_account_credentials.cc
  ${_gRPC_ROOT}/src/core/lib/security/credentials/external/aws_request_signer.cc
  ${_gRPC_ROOT}/src/core/lib/security/credentials/external/external_account_credentials.cc
  ${_gRPC_ROOT}/src/core/lib/security/credentials/external/file_external_account_credentials.cc
  ${_gRPC_ROOT}/src/core/lib/security/credentials/external/url_external_account_credentials.cc
  ${_gRPC_ROOT}/src/core/lib/security/credentials/fake/fake_credentials.cc
  ${_gRPC_ROOT}/src/core/lib/security/credentials/google_default/credentials_generic.cc
  ${_gRPC_ROOT}/src/core/lib/security/credentials/google_default/google_default_credentials.cc
  ${_gRPC_ROOT}/src/core/lib/security/credentials/iam/iam_credentials.cc
  ${_gRPC_ROOT}/src/core/lib/security/credentials/insecure/insecure_credentials.cc
  ${_gRPC_ROOT}/src/core/lib/security/credentials/jwt/json_token.cc
  ${_gRPC_ROOT}/src/core/lib/security/credentials/jwt/jwt_credentials.cc
  ${_gRPC_ROOT}/src/core/lib/security/credentials/jwt/jwt_verifier.cc
  ${_gRPC_ROOT}/src/core/lib/security/credentials/local/local_credentials.cc
  ${_gRPC_ROOT}/src/core/lib/security/credentials/oauth2/oauth2_credentials.cc
  ${_gRPC_ROOT}/src/core/lib/security/credentials/plugin/plugin_credentials.cc
  ${_gRPC_ROOT}/src/core/lib/security/credentials/ssl/ssl_credentials.cc
  ${_gRPC_ROOT}/src/core/lib/security/credentials/tls/grpc_tls_certificate_distributor.cc
  ${_gRPC_ROOT}/src/core/lib/security/credentials/tls/grpc_tls_certificate_provider.cc
  ${_gRPC_ROOT}/src/core/lib/security/credentials/tls/grpc_tls_certificate_verifier.cc
  ${_gRPC_ROOT}/src/core/lib/security/credentials/tls/grpc_tls_credentials_options.cc
  ${_gRPC_ROOT}/src/core/lib/security/credentials/tls/tls_credentials.cc
  ${_gRPC_ROOT}/src/core/lib/security/credentials/tls/tls_utils.cc
  ${_gRPC_ROOT}/src/core/lib/security/credentials/xds/xds_credentials.cc
  ${_gRPC_ROOT}/src/core/lib/security/security_connector/alts/alts_security_connector.cc
  ${_gRPC_ROOT}/src/core/lib/security/security_connector/fake/fake_security_connector.cc
  ${_gRPC_ROOT}/src/core/lib/security/security_connector/insecure/insecure_security_connector.cc
  ${_gRPC_ROOT}/src/core/lib/security/security_connector/load_system_roots_fallback.cc
  ${_gRPC_ROOT}/src/core/lib/security/security_connector/load_system_roots_supported.cc
  ${_gRPC_ROOT}/src/core/lib/security/security_connector/local/local_security_connector.cc
  ${_gRPC_ROOT}/src/core/lib/security/security_connector/security_connector.cc
  ${_gRPC_ROOT}/src/core/lib/security/security_connector/ssl/ssl_security_connector.cc
  ${_gRPC_ROOT}/src/core/lib/security/security_connector/ssl_utils.cc
  ${_gRPC_ROOT}/src/core/lib/security/security_connector/ssl_utils_config.cc
  ${_gRPC_ROOT}/src/core/lib/security/security_connector/tls/tls_security_connector.cc
  ${_gRPC_ROOT}/src/core/lib/security/transport/client_auth_filter.cc
  ${_gRPC_ROOT}/src/core/lib/security/transport/secure_endpoint.cc
  ${_gRPC_ROOT}/src/core/lib/security/transport/security_handshaker.cc
  ${_gRPC_ROOT}/src/core/lib/security/transport/server_auth_filter.cc
  ${_gRPC_ROOT}/src/core/lib/security/transport/tsi_error.cc
  ${_gRPC_ROOT}/src/core/lib/security/util/json_util.cc
  ${_gRPC_ROOT}/src/core/lib/service_config/service_config_impl.cc
  ${_gRPC_ROOT}/src/core/lib/service_config/service_config_parser.cc
  ${_gRPC_ROOT}/src/core/lib/slice/b64.cc
  ${_gRPC_ROOT}/src/core/lib/slice/percent_encoding.cc
  ${_gRPC_ROOT}/src/core/lib/slice/slice.cc
  ${_gRPC_ROOT}/src/core/lib/slice/slice_api.cc
  ${_gRPC_ROOT}/src/core/lib/slice/slice_buffer.cc
  ${_gRPC_ROOT}/src/core/lib/slice/slice_buffer_api.cc
  ${_gRPC_ROOT}/src/core/lib/slice/slice_refcount.cc
  ${_gRPC_ROOT}/src/core/lib/slice/slice_string_helpers.cc
  ${_gRPC_ROOT}/src/core/lib/surface/api_trace.cc
  ${_gRPC_ROOT}/src/core/lib/surface/builtins.cc
  ${_gRPC_ROOT}/src/core/lib/surface/byte_buffer.cc
  ${_gRPC_ROOT}/src/core/lib/surface/byte_buffer_reader.cc
  ${_gRPC_ROOT}/src/core/lib/surface/call.cc
  ${_gRPC_ROOT}/src/core/lib/surface/call_details.cc
  ${_gRPC_ROOT}/src/core/lib/surface/call_log_batch.cc
  ${_gRPC_ROOT}/src/core/lib/surface/channel.cc
  ${_gRPC_ROOT}/src/core/lib/surface/channel_init.cc
  ${_gRPC_ROOT}/src/core/lib/surface/channel_ping.cc
  ${_gRPC_ROOT}/src/core/lib/surface/channel_stack_type.cc
  ${_gRPC_ROOT}/src/core/lib/surface/completion_queue.cc
  ${_gRPC_ROOT}/src/core/lib/surface/completion_queue_factory.cc
  ${_gRPC_ROOT}/src/core/lib/surface/event_string.cc
  ${_gRPC_ROOT}/src/core/lib/surface/init.cc
  ${_gRPC_ROOT}/src/core/lib/surface/lame_client.cc
  ${_gRPC_ROOT}/src/core/lib/surface/metadata_array.cc
  ${_gRPC_ROOT}/src/core/lib/surface/server.cc
  ${_gRPC_ROOT}/src/core/lib/surface/validate_metadata.cc
  ${_gRPC_ROOT}/src/core/lib/surface/version.cc
  ${_gRPC_ROOT}/src/core/lib/transport/bdp_estimator.cc
  ${_gRPC_ROOT}/src/core/lib/transport/connectivity_state.cc
  ${_gRPC_ROOT}/src/core/lib/transport/error_utils.cc
  ${_gRPC_ROOT}/src/core/lib/transport/handshaker.cc
  ${_gRPC_ROOT}/src/core/lib/transport/handshaker_registry.cc
  ${_gRPC_ROOT}/src/core/lib/transport/http_connect_handshaker.cc
  ${_gRPC_ROOT}/src/core/lib/transport/metadata_batch.cc
  ${_gRPC_ROOT}/src/core/lib/transport/parsed_metadata.cc
  ${_gRPC_ROOT}/src/core/lib/transport/pid_controller.cc
  ${_gRPC_ROOT}/src/core/lib/transport/status_conversion.cc
  ${_gRPC_ROOT}/src/core/lib/transport/tcp_connect_handshaker.cc
  ${_gRPC_ROOT}/src/core/lib/transport/timeout_encoding.cc
  ${_gRPC_ROOT}/src/core/lib/transport/transport.cc
  ${_gRPC_ROOT}/src/core/lib/transport/transport_op_string.cc
  ${_gRPC_ROOT}/src/core/lib/uri/uri_parser.cc
  ${_gRPC_ROOT}/src/core/plugin_registry/grpc_plugin_registry.cc
  ${_gRPC_ROOT}/src/core/plugin_registry/grpc_plugin_registry_extra.cc
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
  ${_gRPC_ROOT}/src/core/tsi/transport_security.cc
  ${_gRPC_ROOT}/src/core/tsi/transport_security_grpc.cc
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
  upb
  ${_gRPC_ALLTARGETS_LIBRARIES}
  absl::flat_hash_map
  absl::flat_hash_set
  absl::inlined_vector
  absl::any_invocable
  absl::bind_front
  absl::function_ref
  absl::hash
  absl::type_traits
  absl::statusor
  absl::span
  absl::utility
  gpr
  ssl
  crypto
  address_sorting
  upb
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
  ${_gRPC_ROOT}/src/core/ext/filters/census/grpc_context.cc
  ${_gRPC_ROOT}/src/core/ext/filters/channel_idle/channel_idle_filter.cc
  ${_gRPC_ROOT}/src/core/ext/filters/channel_idle/idle_filter_state.cc
  ${_gRPC_ROOT}/src/core/ext/filters/client_channel/backend_metric.cc
  ${_gRPC_ROOT}/src/core/ext/filters/client_channel/backup_poller.cc
  ${_gRPC_ROOT}/src/core/ext/filters/client_channel/channel_connectivity.cc
  ${_gRPC_ROOT}/src/core/ext/filters/client_channel/client_channel.cc
  ${_gRPC_ROOT}/src/core/ext/filters/client_channel/client_channel_channelz.cc
  ${_gRPC_ROOT}/src/core/ext/filters/client_channel/client_channel_factory.cc
  ${_gRPC_ROOT}/src/core/ext/filters/client_channel/client_channel_plugin.cc
  ${_gRPC_ROOT}/src/core/ext/filters/client_channel/config_selector.cc
  ${_gRPC_ROOT}/src/core/ext/filters/client_channel/dynamic_filters.cc
  ${_gRPC_ROOT}/src/core/ext/filters/client_channel/global_subchannel_pool.cc
  ${_gRPC_ROOT}/src/core/ext/filters/client_channel/health/health_check_client.cc
  ${_gRPC_ROOT}/src/core/ext/filters/client_channel/http_proxy.cc
  ${_gRPC_ROOT}/src/core/ext/filters/client_channel/lb_policy/address_filtering.cc
  ${_gRPC_ROOT}/src/core/ext/filters/client_channel/lb_policy/child_policy_handler.cc
  ${_gRPC_ROOT}/src/core/ext/filters/client_channel/lb_policy/grpclb/client_load_reporting_filter.cc
  ${_gRPC_ROOT}/src/core/ext/filters/client_channel/lb_policy/grpclb/grpclb.cc
  ${_gRPC_ROOT}/src/core/ext/filters/client_channel/lb_policy/grpclb/grpclb_balancer_addresses.cc
  ${_gRPC_ROOT}/src/core/ext/filters/client_channel/lb_policy/grpclb/grpclb_client_stats.cc
  ${_gRPC_ROOT}/src/core/ext/filters/client_channel/lb_policy/grpclb/load_balancer_api.cc
  ${_gRPC_ROOT}/src/core/ext/filters/client_channel/lb_policy/oob_backend_metric.cc
  ${_gRPC_ROOT}/src/core/ext/filters/client_channel/lb_policy/outlier_detection/outlier_detection.cc
  ${_gRPC_ROOT}/src/core/ext/filters/client_channel/lb_policy/pick_first/pick_first.cc
  ${_gRPC_ROOT}/src/core/ext/filters/client_channel/lb_policy/priority/priority.cc
  ${_gRPC_ROOT}/src/core/ext/filters/client_channel/lb_policy/ring_hash/ring_hash.cc
  ${_gRPC_ROOT}/src/core/ext/filters/client_channel/lb_policy/rls/rls.cc
  ${_gRPC_ROOT}/src/core/ext/filters/client_channel/lb_policy/round_robin/round_robin.cc
  ${_gRPC_ROOT}/src/core/ext/filters/client_channel/lb_policy/weighted_target/weighted_target.cc
  ${_gRPC_ROOT}/src/core/ext/filters/client_channel/local_subchannel_pool.cc
  ${_gRPC_ROOT}/src/core/ext/filters/client_channel/proxy_mapper_registry.cc
  ${_gRPC_ROOT}/src/core/ext/filters/client_channel/resolver/binder/binder_resolver.cc
  ${_gRPC_ROOT}/src/core/ext/filters/client_channel/resolver/dns/c_ares/dns_resolver_ares.cc
  ${_gRPC_ROOT}/src/core/ext/filters/client_channel/resolver/dns/c_ares/grpc_ares_ev_driver_posix.cc
  ${_gRPC_ROOT}/src/core/ext/filters/client_channel/resolver/dns/c_ares/grpc_ares_ev_driver_windows.cc
  ${_gRPC_ROOT}/src/core/ext/filters/client_channel/resolver/dns/c_ares/grpc_ares_wrapper.cc
  ${_gRPC_ROOT}/src/core/ext/filters/client_channel/resolver/dns/c_ares/grpc_ares_wrapper_posix.cc
  ${_gRPC_ROOT}/src/core/ext/filters/client_channel/resolver/dns/c_ares/grpc_ares_wrapper_windows.cc
  ${_gRPC_ROOT}/src/core/ext/filters/client_channel/resolver/dns/dns_resolver_selection.cc
  ${_gRPC_ROOT}/src/core/ext/filters/client_channel/resolver/dns/native/dns_resolver.cc
  ${_gRPC_ROOT}/src/core/ext/filters/client_channel/resolver/fake/fake_resolver.cc
  ${_gRPC_ROOT}/src/core/ext/filters/client_channel/resolver/polling_resolver.cc
  ${_gRPC_ROOT}/src/core/ext/filters/client_channel/resolver/sockaddr/sockaddr_resolver.cc
  ${_gRPC_ROOT}/src/core/ext/filters/client_channel/resolver_result_parsing.cc
  ${_gRPC_ROOT}/src/core/ext/filters/client_channel/retry_filter.cc
  ${_gRPC_ROOT}/src/core/ext/filters/client_channel/retry_service_config.cc
  ${_gRPC_ROOT}/src/core/ext/filters/client_channel/retry_throttle.cc
  ${_gRPC_ROOT}/src/core/ext/filters/client_channel/service_config_channel_arg_filter.cc
  ${_gRPC_ROOT}/src/core/ext/filters/client_channel/subchannel.cc
  ${_gRPC_ROOT}/src/core/ext/filters/client_channel/subchannel_pool_interface.cc
  ${_gRPC_ROOT}/src/core/ext/filters/client_channel/subchannel_stream_client.cc
  ${_gRPC_ROOT}/src/core/ext/filters/deadline/deadline_filter.cc
  ${_gRPC_ROOT}/src/core/ext/filters/fault_injection/fault_injection_filter.cc
  ${_gRPC_ROOT}/src/core/ext/filters/fault_injection/service_config_parser.cc
  ${_gRPC_ROOT}/src/core/ext/filters/http/client/http_client_filter.cc
  ${_gRPC_ROOT}/src/core/ext/filters/http/client_authority_filter.cc
  ${_gRPC_ROOT}/src/core/ext/filters/http/http_filters_plugin.cc
  ${_gRPC_ROOT}/src/core/ext/filters/http/message_compress/message_compress_filter.cc
  ${_gRPC_ROOT}/src/core/ext/filters/http/message_compress/message_decompress_filter.cc
  ${_gRPC_ROOT}/src/core/ext/filters/http/server/http_server_filter.cc
  ${_gRPC_ROOT}/src/core/ext/filters/message_size/message_size_filter.cc
  ${_gRPC_ROOT}/src/core/ext/transport/chttp2/client/chttp2_connector.cc
  ${_gRPC_ROOT}/src/core/ext/transport/chttp2/server/chttp2_server.cc
  ${_gRPC_ROOT}/src/core/ext/transport/chttp2/transport/bin_decoder.cc
  ${_gRPC_ROOT}/src/core/ext/transport/chttp2/transport/bin_encoder.cc
  ${_gRPC_ROOT}/src/core/ext/transport/chttp2/transport/chttp2_transport.cc
  ${_gRPC_ROOT}/src/core/ext/transport/chttp2/transport/context_list.cc
  ${_gRPC_ROOT}/src/core/ext/transport/chttp2/transport/flow_control.cc
  ${_gRPC_ROOT}/src/core/ext/transport/chttp2/transport/frame_data.cc
  ${_gRPC_ROOT}/src/core/ext/transport/chttp2/transport/frame_goaway.cc
  ${_gRPC_ROOT}/src/core/ext/transport/chttp2/transport/frame_ping.cc
  ${_gRPC_ROOT}/src/core/ext/transport/chttp2/transport/frame_rst_stream.cc
  ${_gRPC_ROOT}/src/core/ext/transport/chttp2/transport/frame_settings.cc
  ${_gRPC_ROOT}/src/core/ext/transport/chttp2/transport/frame_window_update.cc
  ${_gRPC_ROOT}/src/core/ext/transport/chttp2/transport/hpack_encoder.cc
  ${_gRPC_ROOT}/src/core/ext/transport/chttp2/transport/hpack_encoder_table.cc
  ${_gRPC_ROOT}/src/core/ext/transport/chttp2/transport/hpack_parser.cc
  ${_gRPC_ROOT}/src/core/ext/transport/chttp2/transport/hpack_parser_table.cc
  ${_gRPC_ROOT}/src/core/ext/transport/chttp2/transport/http2_settings.cc
  ${_gRPC_ROOT}/src/core/ext/transport/chttp2/transport/huffsyms.cc
  ${_gRPC_ROOT}/src/core/ext/transport/chttp2/transport/parsing.cc
  ${_gRPC_ROOT}/src/core/ext/transport/chttp2/transport/stream_lists.cc
  ${_gRPC_ROOT}/src/core/ext/transport/chttp2/transport/stream_map.cc
  ${_gRPC_ROOT}/src/core/ext/transport/chttp2/transport/varint.cc
  ${_gRPC_ROOT}/src/core/ext/transport/chttp2/transport/writing.cc
  ${_gRPC_ROOT}/src/core/ext/transport/inproc/inproc_plugin.cc
  ${_gRPC_ROOT}/src/core/ext/transport/inproc/inproc_transport.cc
  ${_gRPC_ROOT}/src/core/ext/upb-generated/google/api/annotations.upb.c
  ${_gRPC_ROOT}/src/core/ext/upb-generated/google/api/http.upb.c
  ${_gRPC_ROOT}/src/core/ext/upb-generated/google/protobuf/any.upb.c
  ${_gRPC_ROOT}/src/core/ext/upb-generated/google/protobuf/descriptor.upb.c
  ${_gRPC_ROOT}/src/core/ext/upb-generated/google/protobuf/duration.upb.c
  ${_gRPC_ROOT}/src/core/ext/upb-generated/google/protobuf/empty.upb.c
  ${_gRPC_ROOT}/src/core/ext/upb-generated/google/protobuf/struct.upb.c
  ${_gRPC_ROOT}/src/core/ext/upb-generated/google/protobuf/timestamp.upb.c
  ${_gRPC_ROOT}/src/core/ext/upb-generated/google/protobuf/wrappers.upb.c
  ${_gRPC_ROOT}/src/core/ext/upb-generated/google/rpc/status.upb.c
  ${_gRPC_ROOT}/src/core/ext/upb-generated/src/proto/grpc/health/v1/health.upb.c
  ${_gRPC_ROOT}/src/core/ext/upb-generated/src/proto/grpc/lb/v1/load_balancer.upb.c
  ${_gRPC_ROOT}/src/core/ext/upb-generated/src/proto/grpc/lookup/v1/rls.upb.c
  ${_gRPC_ROOT}/src/core/ext/upb-generated/validate/validate.upb.c
  ${_gRPC_ROOT}/src/core/ext/upb-generated/xds/data/orca/v3/orca_load_report.upb.c
  ${_gRPC_ROOT}/src/core/ext/upb-generated/xds/service/orca/v3/orca.upb.c
  ${_gRPC_ROOT}/src/core/lib/address_utils/parse_address.cc
  ${_gRPC_ROOT}/src/core/lib/address_utils/sockaddr_utils.cc
  ${_gRPC_ROOT}/src/core/lib/backoff/backoff.cc
  ${_gRPC_ROOT}/src/core/lib/channel/channel_args.cc
  ${_gRPC_ROOT}/src/core/lib/channel/channel_args_preconditioning.cc
  ${_gRPC_ROOT}/src/core/lib/channel/channel_stack.cc
  ${_gRPC_ROOT}/src/core/lib/channel/channel_stack_builder.cc
  ${_gRPC_ROOT}/src/core/lib/channel/channel_stack_builder_impl.cc
  ${_gRPC_ROOT}/src/core/lib/channel/channel_trace.cc
  ${_gRPC_ROOT}/src/core/lib/channel/channelz.cc
  ${_gRPC_ROOT}/src/core/lib/channel/channelz_registry.cc
  ${_gRPC_ROOT}/src/core/lib/channel/connected_channel.cc
  ${_gRPC_ROOT}/src/core/lib/channel/promise_based_filter.cc
  ${_gRPC_ROOT}/src/core/lib/channel/status_util.cc
  ${_gRPC_ROOT}/src/core/lib/compression/compression.cc
  ${_gRPC_ROOT}/src/core/lib/compression/compression_internal.cc
  ${_gRPC_ROOT}/src/core/lib/compression/message_compress.cc
  ${_gRPC_ROOT}/src/core/lib/config/core_configuration.cc
  ${_gRPC_ROOT}/src/core/lib/debug/stats.cc
  ${_gRPC_ROOT}/src/core/lib/debug/stats_data.cc
  ${_gRPC_ROOT}/src/core/lib/debug/trace.cc
  ${_gRPC_ROOT}/src/core/lib/event_engine/channel_args_endpoint_config.cc
  ${_gRPC_ROOT}/src/core/lib/event_engine/default_event_engine.cc
  ${_gRPC_ROOT}/src/core/lib/event_engine/default_event_engine_factory.cc
  ${_gRPC_ROOT}/src/core/lib/event_engine/executor/threaded_executor.cc
  ${_gRPC_ROOT}/src/core/lib/event_engine/forkable.cc
  ${_gRPC_ROOT}/src/core/lib/event_engine/memory_allocator.cc
  ${_gRPC_ROOT}/src/core/lib/event_engine/posix_engine/posix_engine.cc
  ${_gRPC_ROOT}/src/core/lib/event_engine/posix_engine/timer.cc
  ${_gRPC_ROOT}/src/core/lib/event_engine/posix_engine/timer_heap.cc
  ${_gRPC_ROOT}/src/core/lib/event_engine/posix_engine/timer_manager.cc
  ${_gRPC_ROOT}/src/core/lib/event_engine/resolved_address.cc
  ${_gRPC_ROOT}/src/core/lib/event_engine/slice.cc
  ${_gRPC_ROOT}/src/core/lib/event_engine/slice_buffer.cc
  ${_gRPC_ROOT}/src/core/lib/event_engine/thread_pool.cc
  ${_gRPC_ROOT}/src/core/lib/event_engine/trace.cc
  ${_gRPC_ROOT}/src/core/lib/event_engine/utils.cc
  ${_gRPC_ROOT}/src/core/lib/event_engine/windows/iocp.cc
  ${_gRPC_ROOT}/src/core/lib/event_engine/windows/win_socket.cc
  ${_gRPC_ROOT}/src/core/lib/event_engine/windows/windows_engine.cc
  ${_gRPC_ROOT}/src/core/lib/experiments/experiments.cc
  ${_gRPC_ROOT}/src/core/lib/gprpp/status_helper.cc
  ${_gRPC_ROOT}/src/core/lib/gprpp/time.cc
  ${_gRPC_ROOT}/src/core/lib/gprpp/time_averaged_stats.cc
  ${_gRPC_ROOT}/src/core/lib/gprpp/work_serializer.cc
  ${_gRPC_ROOT}/src/core/lib/http/format_request.cc
  ${_gRPC_ROOT}/src/core/lib/http/httpcli.cc
  ${_gRPC_ROOT}/src/core/lib/http/parser.cc
  ${_gRPC_ROOT}/src/core/lib/iomgr/buffer_list.cc
  ${_gRPC_ROOT}/src/core/lib/iomgr/call_combiner.cc
  ${_gRPC_ROOT}/src/core/lib/iomgr/cfstream_handle.cc
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
  ${_gRPC_ROOT}/src/core/lib/iomgr/ev_windows.cc
  ${_gRPC_ROOT}/src/core/lib/iomgr/exec_ctx.cc
  ${_gRPC_ROOT}/src/core/lib/iomgr/executor.cc
  ${_gRPC_ROOT}/src/core/lib/iomgr/fork_posix.cc
  ${_gRPC_ROOT}/src/core/lib/iomgr/fork_windows.cc
  ${_gRPC_ROOT}/src/core/lib/iomgr/gethostname_fallback.cc
  ${_gRPC_ROOT}/src/core/lib/iomgr/gethostname_host_name_max.cc
  ${_gRPC_ROOT}/src/core/lib/iomgr/gethostname_sysconf.cc
  ${_gRPC_ROOT}/src/core/lib/iomgr/grpc_if_nametoindex_posix.cc
  ${_gRPC_ROOT}/src/core/lib/iomgr/grpc_if_nametoindex_unsupported.cc
  ${_gRPC_ROOT}/src/core/lib/iomgr/internal_errqueue.cc
  ${_gRPC_ROOT}/src/core/lib/iomgr/iocp_windows.cc
  ${_gRPC_ROOT}/src/core/lib/iomgr/iomgr.cc
  ${_gRPC_ROOT}/src/core/lib/iomgr/iomgr_internal.cc
  ${_gRPC_ROOT}/src/core/lib/iomgr/iomgr_posix.cc
  ${_gRPC_ROOT}/src/core/lib/iomgr/iomgr_posix_cfstream.cc
  ${_gRPC_ROOT}/src/core/lib/iomgr/iomgr_windows.cc
  ${_gRPC_ROOT}/src/core/lib/iomgr/load_file.cc
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
  ${_gRPC_ROOT}/src/core/lib/iomgr/wakeup_fd_eventfd.cc
  ${_gRPC_ROOT}/src/core/lib/iomgr/wakeup_fd_nospecial.cc
  ${_gRPC_ROOT}/src/core/lib/iomgr/wakeup_fd_pipe.cc
  ${_gRPC_ROOT}/src/core/lib/iomgr/wakeup_fd_posix.cc
  ${_gRPC_ROOT}/src/core/lib/json/json_object_loader.cc
  ${_gRPC_ROOT}/src/core/lib/json/json_reader.cc
  ${_gRPC_ROOT}/src/core/lib/json/json_util.cc
  ${_gRPC_ROOT}/src/core/lib/json/json_writer.cc
  ${_gRPC_ROOT}/src/core/lib/load_balancing/lb_policy.cc
  ${_gRPC_ROOT}/src/core/lib/load_balancing/lb_policy_registry.cc
  ${_gRPC_ROOT}/src/core/lib/promise/activity.cc
  ${_gRPC_ROOT}/src/core/lib/promise/sleep.cc
  ${_gRPC_ROOT}/src/core/lib/resolver/resolver.cc
  ${_gRPC_ROOT}/src/core/lib/resolver/resolver_registry.cc
  ${_gRPC_ROOT}/src/core/lib/resolver/server_address.cc
  ${_gRPC_ROOT}/src/core/lib/resource_quota/api.cc
  ${_gRPC_ROOT}/src/core/lib/resource_quota/arena.cc
  ${_gRPC_ROOT}/src/core/lib/resource_quota/memory_quota.cc
  ${_gRPC_ROOT}/src/core/lib/resource_quota/periodic_update.cc
  ${_gRPC_ROOT}/src/core/lib/resource_quota/resource_quota.cc
  ${_gRPC_ROOT}/src/core/lib/resource_quota/thread_quota.cc
  ${_gRPC_ROOT}/src/core/lib/resource_quota/trace.cc
  ${_gRPC_ROOT}/src/core/lib/security/authorization/authorization_policy_provider_vtable.cc
  ${_gRPC_ROOT}/src/core/lib/security/authorization/evaluate_args.cc
  ${_gRPC_ROOT}/src/core/lib/security/authorization/grpc_server_authz_filter.cc
  ${_gRPC_ROOT}/src/core/lib/security/context/security_context.cc
  ${_gRPC_ROOT}/src/core/lib/security/credentials/call_creds_util.cc
  ${_gRPC_ROOT}/src/core/lib/security/credentials/composite/composite_credentials.cc
  ${_gRPC_ROOT}/src/core/lib/security/credentials/credentials.cc
  ${_gRPC_ROOT}/src/core/lib/security/credentials/fake/fake_credentials.cc
  ${_gRPC_ROOT}/src/core/lib/security/credentials/insecure/insecure_credentials.cc
  ${_gRPC_ROOT}/src/core/lib/security/credentials/plugin/plugin_credentials.cc
  ${_gRPC_ROOT}/src/core/lib/security/credentials/tls/tls_utils.cc
  ${_gRPC_ROOT}/src/core/lib/security/security_connector/fake/fake_security_connector.cc
  ${_gRPC_ROOT}/src/core/lib/security/security_connector/insecure/insecure_security_connector.cc
  ${_gRPC_ROOT}/src/core/lib/security/security_connector/load_system_roots_fallback.cc
  ${_gRPC_ROOT}/src/core/lib/security/security_connector/load_system_roots_supported.cc
  ${_gRPC_ROOT}/src/core/lib/security/security_connector/security_connector.cc
  ${_gRPC_ROOT}/src/core/lib/security/transport/client_auth_filter.cc
  ${_gRPC_ROOT}/src/core/lib/security/transport/secure_endpoint.cc
  ${_gRPC_ROOT}/src/core/lib/security/transport/security_handshaker.cc
  ${_gRPC_ROOT}/src/core/lib/security/transport/server_auth_filter.cc
  ${_gRPC_ROOT}/src/core/lib/security/transport/tsi_error.cc
  ${_gRPC_ROOT}/src/core/lib/security/util/json_util.cc
  ${_gRPC_ROOT}/src/core/lib/service_config/service_config_impl.cc
  ${_gRPC_ROOT}/src/core/lib/service_config/service_config_parser.cc
  ${_gRPC_ROOT}/src/core/lib/slice/b64.cc
  ${_gRPC_ROOT}/src/core/lib/slice/percent_encoding.cc
  ${_gRPC_ROOT}/src/core/lib/slice/slice.cc
  ${_gRPC_ROOT}/src/core/lib/slice/slice_api.cc
  ${_gRPC_ROOT}/src/core/lib/slice/slice_buffer.cc
  ${_gRPC_ROOT}/src/core/lib/slice/slice_buffer_api.cc
  ${_gRPC_ROOT}/src/core/lib/slice/slice_refcount.cc
  ${_gRPC_ROOT}/src/core/lib/slice/slice_string_helpers.cc
  ${_gRPC_ROOT}/src/core/lib/surface/api_trace.cc
  ${_gRPC_ROOT}/src/core/lib/surface/builtins.cc
  ${_gRPC_ROOT}/src/core/lib/surface/byte_buffer.cc
  ${_gRPC_ROOT}/src/core/lib/surface/byte_buffer_reader.cc
  ${_gRPC_ROOT}/src/core/lib/surface/call.cc
  ${_gRPC_ROOT}/src/core/lib/surface/call_details.cc
  ${_gRPC_ROOT}/src/core/lib/surface/call_log_batch.cc
  ${_gRPC_ROOT}/src/core/lib/surface/channel.cc
  ${_gRPC_ROOT}/src/core/lib/surface/channel_init.cc
  ${_gRPC_ROOT}/src/core/lib/surface/channel_ping.cc
  ${_gRPC_ROOT}/src/core/lib/surface/channel_stack_type.cc
  ${_gRPC_ROOT}/src/core/lib/surface/completion_queue.cc
  ${_gRPC_ROOT}/src/core/lib/surface/completion_queue_factory.cc
  ${_gRPC_ROOT}/src/core/lib/surface/event_string.cc
  ${_gRPC_ROOT}/src/core/lib/surface/init.cc
  ${_gRPC_ROOT}/src/core/lib/surface/lame_client.cc
  ${_gRPC_ROOT}/src/core/lib/surface/metadata_array.cc
  ${_gRPC_ROOT}/src/core/lib/surface/server.cc
  ${_gRPC_ROOT}/src/core/lib/surface/validate_metadata.cc
  ${_gRPC_ROOT}/src/core/lib/surface/version.cc
  ${_gRPC_ROOT}/src/core/lib/transport/bdp_estimator.cc
  ${_gRPC_ROOT}/src/core/lib/transport/connectivity_state.cc
  ${_gRPC_ROOT}/src/core/lib/transport/error_utils.cc
  ${_gRPC_ROOT}/src/core/lib/transport/handshaker.cc
  ${_gRPC_ROOT}/src/core/lib/transport/handshaker_registry.cc
  ${_gRPC_ROOT}/src/core/lib/transport/http_connect_handshaker.cc
  ${_gRPC_ROOT}/src/core/lib/transport/metadata_batch.cc
  ${_gRPC_ROOT}/src/core/lib/transport/parsed_metadata.cc
  ${_gRPC_ROOT}/src/core/lib/transport/pid_controller.cc
  ${_gRPC_ROOT}/src/core/lib/transport/status_conversion.cc
  ${_gRPC_ROOT}/src/core/lib/transport/tcp_connect_handshaker.cc
  ${_gRPC_ROOT}/src/core/lib/transport/timeout_encoding.cc
  ${_gRPC_ROOT}/src/core/lib/transport/transport.cc
  ${_gRPC_ROOT}/src/core/lib/transport/transport_op_string.cc
  ${_gRPC_ROOT}/src/core/lib/uri/uri_parser.cc
  ${_gRPC_ROOT}/src/core/plugin_registry/grpc_plugin_registry.cc
  ${_gRPC_ROOT}/src/core/plugin_registry/grpc_plugin_registry_noextra.cc
  ${_gRPC_ROOT}/src/core/tsi/fake_transport_security.cc
  ${_gRPC_ROOT}/src/core/tsi/local_transport_security.cc
  ${_gRPC_ROOT}/src/core/tsi/transport_security.cc
  ${_gRPC_ROOT}/src/core/tsi/transport_security_grpc.cc
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
  upb
  ${_gRPC_ALLTARGETS_LIBRARIES}
  absl::flat_hash_map
  absl::flat_hash_set
  absl::inlined_vector
  absl::any_invocable
  absl::bind_front
  absl::function_ref
  absl::hash
  absl::type_traits
  absl::statusor
  absl::span
  absl::utility
  gpr
  address_sorting
  upb
)
if(_gRPC_PLATFORM_IOS OR _gRPC_PLATFORM_MAC)
  target_link_libraries(grpc_unsecure PRIVATE "-framework CoreFoundation")
endif()


# Not building test benchmark_helpers, test

android_add_library(TARGET grpc++
LICENSE Apache-2.0
URL "https://android.googlesource.com/platform/external/grpc-grpc/+/refs/heads/emu-master-dev"
REPO "${ANDROID_QEMU2_TOP_DIR}/../grpc"
NOTICE "REPO/NOTICE.txt"

SRC # cmake-format: sortable
  ${_gRPC_ROOT}/src/core/ext/transport/binder/client/binder_connector.cc
  ${_gRPC_ROOT}/src/core/ext/transport/binder/client/channel_create.cc
  ${_gRPC_ROOT}/src/core/ext/transport/binder/client/channel_create_impl.cc
  ${_gRPC_ROOT}/src/core/ext/transport/binder/client/connection_id_generator.cc
  ${_gRPC_ROOT}/src/core/ext/transport/binder/client/endpoint_binder_pool.cc
  ${_gRPC_ROOT}/src/core/ext/transport/binder/client/jni_utils.cc
  ${_gRPC_ROOT}/src/core/ext/transport/binder/client/security_policy_setting.cc
  ${_gRPC_ROOT}/src/core/ext/transport/binder/security_policy/binder_security_policy.cc
  ${_gRPC_ROOT}/src/core/ext/transport/binder/server/binder_server.cc
  ${_gRPC_ROOT}/src/core/ext/transport/binder/server/binder_server_credentials.cc
  ${_gRPC_ROOT}/src/core/ext/transport/binder/transport/binder_transport.cc
  ${_gRPC_ROOT}/src/core/ext/transport/binder/utils/ndk_binder.cc
  ${_gRPC_ROOT}/src/core/ext/transport/binder/utils/transport_stream_receiver_impl.cc
  ${_gRPC_ROOT}/src/core/ext/transport/binder/wire_format/binder_android.cc
  ${_gRPC_ROOT}/src/core/ext/transport/binder/wire_format/binder_constants.cc
  ${_gRPC_ROOT}/src/core/ext/transport/binder/wire_format/transaction.cc
  ${_gRPC_ROOT}/src/core/ext/transport/binder/wire_format/wire_reader_impl.cc
  ${_gRPC_ROOT}/src/core/ext/transport/binder/wire_format/wire_writer.cc
  ${_gRPC_ROOT}/src/cpp/client/channel_cc.cc
  ${_gRPC_ROOT}/src/cpp/client/client_callback.cc
  ${_gRPC_ROOT}/src/cpp/client/client_context.cc
  ${_gRPC_ROOT}/src/cpp/client/client_interceptor.cc
  ${_gRPC_ROOT}/src/cpp/client/create_channel.cc
  ${_gRPC_ROOT}/src/cpp/client/create_channel_internal.cc
  ${_gRPC_ROOT}/src/cpp/client/create_channel_posix.cc
  ${_gRPC_ROOT}/src/cpp/client/credentials_cc.cc
  ${_gRPC_ROOT}/src/cpp/client/insecure_credentials.cc
  ${_gRPC_ROOT}/src/cpp/client/secure_credentials.cc
  ${_gRPC_ROOT}/src/cpp/client/xds_credentials.cc
  ${_gRPC_ROOT}/src/cpp/codegen/codegen_init.cc
  ${_gRPC_ROOT}/src/cpp/common/alarm.cc
  ${_gRPC_ROOT}/src/cpp/common/auth_property_iterator.cc
  ${_gRPC_ROOT}/src/cpp/common/channel_arguments.cc
  ${_gRPC_ROOT}/src/cpp/common/channel_filter.cc
  ${_gRPC_ROOT}/src/cpp/common/completion_queue_cc.cc
  ${_gRPC_ROOT}/src/cpp/common/core_codegen.cc
  ${_gRPC_ROOT}/src/cpp/common/resource_quota_cc.cc
  ${_gRPC_ROOT}/src/cpp/common/rpc_method.cc
  ${_gRPC_ROOT}/src/cpp/common/secure_auth_context.cc
  ${_gRPC_ROOT}/src/cpp/common/secure_channel_arguments.cc
  ${_gRPC_ROOT}/src/cpp/common/secure_create_auth_context.cc
  ${_gRPC_ROOT}/src/cpp/common/tls_certificate_provider.cc
  ${_gRPC_ROOT}/src/cpp/common/tls_certificate_verifier.cc
  ${_gRPC_ROOT}/src/cpp/common/tls_credentials_options.cc
  ${_gRPC_ROOT}/src/cpp/common/validate_service_config.cc
  ${_gRPC_ROOT}/src/cpp/common/version_cc.cc
  ${_gRPC_ROOT}/src/cpp/server/async_generic_service.cc
  ${_gRPC_ROOT}/src/cpp/server/channel_argument_option.cc
  ${_gRPC_ROOT}/src/cpp/server/create_default_thread_pool.cc
  ${_gRPC_ROOT}/src/cpp/server/dynamic_thread_pool.cc
  ${_gRPC_ROOT}/src/cpp/server/external_connection_acceptor_impl.cc
  ${_gRPC_ROOT}/src/cpp/server/health/default_health_check_service.cc
  ${_gRPC_ROOT}/src/cpp/server/health/health_check_service.cc
  ${_gRPC_ROOT}/src/cpp/server/health/health_check_service_server_builder_option.cc
  ${_gRPC_ROOT}/src/cpp/server/insecure_server_credentials.cc
  ${_gRPC_ROOT}/src/cpp/server/orca/call_metric_recorder.cc
  ${_gRPC_ROOT}/src/cpp/server/secure_server_credentials.cc
  ${_gRPC_ROOT}/src/cpp/server/server_builder.cc
  ${_gRPC_ROOT}/src/cpp/server/server_callback.cc
  ${_gRPC_ROOT}/src/cpp/server/server_cc.cc
  ${_gRPC_ROOT}/src/cpp/server/server_context.cc
  ${_gRPC_ROOT}/src/cpp/server/server_credentials.cc
  ${_gRPC_ROOT}/src/cpp/server/server_posix.cc
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
  absl::cleanup
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
  ${_gRPC_ROOT}/src/cpp/client/channel_cc.cc
  ${_gRPC_ROOT}/src/cpp/client/client_callback.cc
  ${_gRPC_ROOT}/src/cpp/client/client_context.cc
  ${_gRPC_ROOT}/src/cpp/client/client_interceptor.cc
  ${_gRPC_ROOT}/src/cpp/client/create_channel.cc
  ${_gRPC_ROOT}/src/cpp/client/create_channel_internal.cc
  ${_gRPC_ROOT}/src/cpp/client/create_channel_posix.cc
  ${_gRPC_ROOT}/src/cpp/client/credentials_cc.cc
  ${_gRPC_ROOT}/src/cpp/client/insecure_credentials.cc
  ${_gRPC_ROOT}/src/cpp/codegen/codegen_init.cc
  ${_gRPC_ROOT}/src/cpp/common/alarm.cc
  ${_gRPC_ROOT}/src/cpp/common/channel_arguments.cc
  ${_gRPC_ROOT}/src/cpp/common/channel_filter.cc
  ${_gRPC_ROOT}/src/cpp/common/completion_queue_cc.cc
  ${_gRPC_ROOT}/src/cpp/common/core_codegen.cc
  ${_gRPC_ROOT}/src/cpp/common/insecure_create_auth_context.cc
  ${_gRPC_ROOT}/src/cpp/common/resource_quota_cc.cc
  ${_gRPC_ROOT}/src/cpp/common/rpc_method.cc
  ${_gRPC_ROOT}/src/cpp/common/validate_service_config.cc
  ${_gRPC_ROOT}/src/cpp/common/version_cc.cc
  ${_gRPC_ROOT}/src/cpp/server/async_generic_service.cc
  ${_gRPC_ROOT}/src/cpp/server/channel_argument_option.cc
  ${_gRPC_ROOT}/src/cpp/server/create_default_thread_pool.cc
  ${_gRPC_ROOT}/src/cpp/server/dynamic_thread_pool.cc
  ${_gRPC_ROOT}/src/cpp/server/external_connection_acceptor_impl.cc
  ${_gRPC_ROOT}/src/cpp/server/health/default_health_check_service.cc
  ${_gRPC_ROOT}/src/cpp/server/health/health_check_service.cc
  ${_gRPC_ROOT}/src/cpp/server/health/health_check_service_server_builder_option.cc
  ${_gRPC_ROOT}/src/cpp/server/insecure_server_credentials.cc
  ${_gRPC_ROOT}/src/cpp/server/orca/call_metric_recorder.cc
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
  grpc_unsecure
)


# Not building grpc_plugin_support
# Not building grpcpp_channelz

android_add_library(TARGET upb
LICENSE Apache-2.0
URL "https://android.googlesource.com/platform/external/grpc-grpc/+/refs/heads/emu-master-dev"
REPO "${ANDROID_QEMU2_TOP_DIR}/../grpc"
NOTICE "REPO/NOTICE.txt"

SRC # cmake-format: sortable
  ${_gRPC_ROOT}/third_party/upb/third_party/utf8_range/naive.c
  ${_gRPC_ROOT}/third_party/upb/third_party/utf8_range/range2-neon.c
  ${_gRPC_ROOT}/third_party/upb/third_party/utf8_range/range2-sse.c
  ${_gRPC_ROOT}/third_party/upb/upb/arena.c
  ${_gRPC_ROOT}/third_party/upb/upb/array.c
  ${_gRPC_ROOT}/third_party/upb/upb/decode_fast.c
  ${_gRPC_ROOT}/third_party/upb/upb/decode.c
  ${_gRPC_ROOT}/third_party/upb/upb/def.c
  ${_gRPC_ROOT}/third_party/upb/upb/encode.c
  ${_gRPC_ROOT}/third_party/upb/upb/extension_registry.c
  ${_gRPC_ROOT}/third_party/upb/upb/json_decode.c
  ${_gRPC_ROOT}/third_party/upb/upb/json_encode.c
  ${_gRPC_ROOT}/third_party/upb/upb/map.c
  ${_gRPC_ROOT}/third_party/upb/upb/mini_table.c
  ${_gRPC_ROOT}/third_party/upb/upb/msg.c
  ${_gRPC_ROOT}/third_party/upb/upb/reflection.c
  ${_gRPC_ROOT}/third_party/upb/upb/status.c
  ${_gRPC_ROOT}/third_party/upb/upb/table.c
  ${_gRPC_ROOT}/third_party/upb/upb/text_encode.c
  ${_gRPC_ROOT}/third_party/upb/upb/upb.c
  ${_gRPC_ROOT}/src/core/ext/upb-generated/google/protobuf/descriptor.upb.c
  ${_gRPC_ROOT}/src/core/ext/upbdefs-generated/google/protobuf/descriptor.upbdefs.c
)



target_include_directories(upb
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
target_link_libraries(upb PUBLIC
  ${_gRPC_ALLTARGETS_LIBRARIES}
)




android_add_executable(TARGET gen_hpack_tables NODISTRIBUTE
SRC # cmake-format: sortable
  ${_gRPC_ROOT}/tools/codegen/core/gen_hpack_tables.cc
)

target_include_directories(gen_hpack_tables
  PRIVATE
    ${_gRPC_ROOT}
    ${_gRPC_ROOT}/include
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

target_link_libraries(gen_hpack_tables PRIVATE
  libprotobuf
  ${_gRPC_ALLTARGETS_LIBRARIES}
  grpc
  gpr
)


# Not building test: test
# Not building test: test
# Not building test: test
# Not building test: test
# Not building test: test
# Not building test: test
# Not building test: test
# Not building test: test
# Not building test: test
# Not building test: test
# Not building test: test
# Not building test: test
# Not building test: test
# Not building test: test
# Not building test: test
# Not building test: test
# Not building test: test
# Not building test: test
# Not building test: test
# Not building test: test
# Not building test: test
# Not building test: test
# Not building test: test
# Not building test: test
# Not building test: test
# Not building test: test
# Not building test: test
# Not building test: test
# Not building test: test
# Not building test: test
# Not building test: test
# Not building test: test
# Not building test: test
# Not building test: test
# Not building test: test
# Not building test: test
# Not building test: test
# Not building test: test
# Not building test: test
# Not building test: test
# Not building test: test
# Not building test: test
# Not building test: test
# Not building test: test
# Not building test: test
# Not building test: test
# Not building test: test
# Not building test: test
# Not building test: test
# Not building test: test
# Not building test: test
# Not building test: test
# Not building test: test
# Not building test: test
# Not building test: test
# Not building test: test
# Not building test: test
# Not building test: test
# Not building test: test
# Not building test: test
# Not building test: test
# Not building test: test
# Not building test: test
# Not building test: test
# Not building test: test
# Not building test: test
# Not building test: test
# Not building test: test
# Not building test: test
# Not building test: test
# Not building test: test
# Not building test: test
# Not building test: test
# Not building test: test
# Not building test: test
# Not building test: test
# Not building test: test
# Not building test: test
# Not building test: test
# Not building test: test
# Not building test: test
# Not building test: test
# Not building test: test
# Not building test: test
# Not building test: test
# Not building test: test
# Not building test: test
# Not building test: test
# Not building test: test
# Not building test: test
# Not building test: test
# Not building test: test
# Not building test: test
# Not building test: test
# Not building test: test
# Not building test: test
# Not building test: test
# Not building test: test
# Not building test: test
# Not building test: test
# Not building test: test
# Not building test: test
# Not building test: test
# Not building test: test
# Not building test: test
# Not building test: test
# Not building test: test
# Not building test: test
# Not building test: test
# Not building test: test
# Not building test: test
# Not building test: test
# Not building test: test
# Not building test: test
# Not building test: test
# Not building test: test
# Not building test: test
# Not building test: test
# Not building test: test
# Not building test: test
# Not building test: test
# Not building test: test
# Not building test: test
# Not building test: test
# Not building test: test
# Not building test: test
# Not building test: test
# Not building test: test
# Not building test: test
# Not building test: test
# Not building test: test
# Not building test: test
# Not building test: test
# Not building test: test
# Not building test: test
# Not building test: test
# Not building test: test
# Not building test: test
# Not building test: test
# Not building test: test
# Not building test: test
# Not building test: test
# Not building test: test
# Not building test: test
# Not building test: test
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






