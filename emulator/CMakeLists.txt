# THIS FILE IS FOR USE BY THE ANDROID EMULATOR CMAKE BUILD
# ========================================================
# This currently builds C and C++ code.
# This file has been automatically generated from a template file.
# Please look at the templates directory instead.
# This file can be regenerated from the template by running
# tools/buildgen/generate_projects.sh
#
#
# Copyright 2019 android emulator authors.
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

cmake_minimum_required(VERSION 3.5)
# Make sure android build extensions are available.
include(android)

set(PACKAGE_NAME      "grpc")
set(PACKAGE_VERSION   "1.16.0-dev")
set(PACKAGE_STRING    "${PACKAGE_NAME} ${PACKAGE_VERSION}")
set(PACKAGE_TARNAME   "${PACKAGE_NAME}-${PACKAGE_VERSION}")
set(PACKAGE_BUGREPORT "https://github.com/grpc/grpc/issues/")

# Options
option(gRPC_BUILD_TESTS "Build tests" OFF)
set(gRPC_BUILD_CODEGEN ${gRPC_BUILD_TESTS})

if(LINUX_X86_64)
   set(_gRPC_PLATFORM_LINUX ON)
   set(_gRPC_PLATFORM_POSIX ON)
elseif(DARWIN_X86_64)
   set(_gRPC_PLATFORM_MAC ON)
   set(_gRPC_PLATFORM_POSIX ON)
else()
 set(_gRPC_PLATFORM_WINDOWS ON)
endif()

get_filename_component(_gRPC_ROOT "${CMAKE_CURRENT_LIST_DIR}/.." ABSOLUTE)

# Make sure we have the protobuf client libraries
if (NOT TARGET libprotobuf)
  message(STATUS "Including protobuf")
  add_subdirectory(${ANDROID_QEMU2_TOP_DIR}/android/third_party/protobuf/ protobuf)
endif()
set(_gRPC_PROTOBUF_LIBRARIES libprotobuf)

# Make sure we have the crypto & ssl libraries
if (NOT TARGET ssl)
  message(STATUS "Including boring ssl")
  add_subdirectory(${ANDROID_QEMU2_TOP_DIR}/android/third_party/boringssl/ boringssl)
endif()
get_target_property(_gRPC_SSL_INCLUDE_DIR ssl INTERFACE_INCLUDE_DIRECTORIES)

# Make sure we have ssl/crypto
if (NOT TARGET ssl)
  add_subdirectory(${ANDROID_QEMU2_TOP_DIR}/android/third_party/boringssl boringssl)
endif()
# Extract the include directories we need for gtest
set(_gRPC_GTEST_INCLUDE_DIR ${ANDROID_QEMU2_TOP_DIR}/../googletest/googletest/include)


# Make sure we have the protoc plugin available.
android_compile_for_host(grpc_cpp_plugin ${CMAKE_CURRENT_LIST_DIR}/plugins GRPC_CPP_PLUGIN_EXE)
set(_gRPC_CPP_PLUGIN_EXECUTABLE ${GRPC_CPP_PLUGIN_EXE} CACHE PATH "Grpc cpp plugin" FORCE)
set(_gRPC_PROTOBUF_PROTOC_EXECUTABLE ${PROTOBUF_PROTOC_EXECUTABLE} CACHE PATH "Protocol buffer executable" FORCE)
add_subdirectory("${ANDROID_QEMU2_TOP_DIR}/../cares" cares)
set(_gRPC_ADDRESS_SORTING_INCLUDE_DIR "${_gRPC_ROOT}/third_party/address_sorting/include")
set(_gRPC_NANOPB_INCLUDE_DIR "${_gRPC_ROOT}/third_party/nanopb")
set(_gRPC_PROTOBUF_INCLUDE_DIR "${ANDROID_QEMU2_TOP_DIR}/../protobuf;${ANDROID_QEMU2_TOP_DIR}/../protobuf/src")

if(_gRPC_PLATFORM_MAC)
  set(_gRPC_ALLTARGETS_LIBRARIES  m pthread)
elseif(_gRPC_PLATFORM_LINUX)
  set(_gRPC_ALLTARGETS_LIBRARIES  rt m pthread)
endif()

if(_gRPC_PLATFORM_WINDOWS)
  set(_gRPC_BASELIB_LIBRARIES  ws2_32::ws2_32)
endif()

# Create directory for generated .proto files
set(_gRPC_PROTO_GENS_DIR ${CMAKE_CURRENT_BINARY_DIR}/gens)
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
#   ``GENERATED``
#      Variable that should contain the list of generated sources.
#   ``SOURCES``
#     ``.proto`` files
#
function(protobuf_generate_grpc_cpp)
  # Parse arguments
  set(options)
  set(oneValueArgs SOURCE_DIR OUTPUT_DIR GENERATED)
  set(multiValueArgs SOURCES)
  cmake_parse_arguments(grpc "${options}"
                             "${oneValueArgs}"
                             "${multiValueArgs}"
                             ${ARGN})

  set(_gRPC_PROTOBUF_INCLUDE "-I${ANDROID_QEMU2_TOP_DIR}/../protobuf/src")
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

  foreach(FIL ${grpc_SOURCES})
    get_filename_component(ABS_FIL ${FIL} ABSOLUTE)
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
           -I .
           ${_gRPC_PROTOBUF_INCLUDE}
           ${REL_FIL}
      DEPENDS ${ABS_FIL} ${_gRPC_PROTOBUF_PROTOC_EXECUTABLE} ${_gRPC_CPP_PLUGIN_EXECUTABLE}
      WORKING_DIRECTORY ${grpc_SOURCE_DIR}
      COMMENT "Running gRPC C++ protocol buffer compiler on ${FIL}"
      VERBATIM)

      set_source_files_properties("${grpc_OUTPUT_DIR}/${RELFIL_WE}.grpc.pb.cc" "${grpc_OUTPUT_DIR}/${RELFIL_WE}.grpc.pb.h"  "${grpc_OUTPUT_DIR}/${RELFIL_WE}_mock.grpc.pb.h" "${grpc_OUTPUT_DIR}/${RELFIL_WE}.pb.cc" "${grpc_OUTPUT_DIR}/${RELFIL_WE}.pb.h" PROPERTIES GENERATED TRUE)
      if (grpc_GENERATED)
        set(${grpc_GENERATED} "${grpc_OUTPUT_DIR}/${RELFIL_WE}.grpc.pb.cc"
                          "${grpc_OUTPUT_DIR}/${RELFIL_WE}.grpc.pb.h"
                          "${grpc_OUTPUT_DIR}/${RELFIL_WE}_mock.grpc.pb.h"
                          "${grpc_OUTPUT_DIR}/${RELFIL_WE}.pb.cc"
                          "${grpc_OUTPUT_DIR}/${RELFIL_WE}.pb.h" PARENT_SCOPE)
      endif()
  endforeach()
endfunction()



set(address_sorting_src
  ${_gRPC_ROOT}/third_party/address_sorting/address_sorting.c
  ${_gRPC_ROOT}/third_party/address_sorting/address_sorting_posix.c
  ${_gRPC_ROOT}/third_party/address_sorting/address_sorting_windows.c
)
android_add_library(address_sorting)


target_compile_definitions(address_sorting PRIVATE -DPB_FIELD_16BIT)
target_compile_definitions(address_sorting PUBLIC  -DGRPC_ALLOW_EXCEPTIONS=0)
target_compile_options(address_sorting PRIVATE $<$<COMPILE_LANGUAGE:C>:-std=c11>)
target_include_directories(address_sorting
  PUBLIC  ${_gRPC_ROOT}/include
  PRIVATE ${_gRPC_ROOT}
  PRIVATE ${_gRPC_SSL_INCLUDE_DIR}
  PRIVATE ${_gRPC_BENCHMARK_INCLUDE_DIR}
  PRIVATE ${_gRPC_CARES_INCLUDE_DIR}
  PRIVATE ${_gRPC_GFLAGS_INCLUDE_DIR}
  PRIVATE ${_gRPC_PROTOBUF_INCLUDE_DIR}
  PRIVATE ${_gRPC_NANOPB_INCLUDE_DIR}
  PRIVATE ${_gRPC_ADDRESS_SORTING_INCLUDE_DIR}
)

target_link_libraries(address_sorting PRIVATE
  ${_gRPC_BASELIB_LIBRARIES}
  ${_gRPC_ALLTARGETS_LIBRARIES}
)




set(gpr_src
  ${_gRPC_ROOT}/src/core/lib/gpr/alloc.cc
  ${_gRPC_ROOT}/src/core/lib/gpr/arena.cc
  ${_gRPC_ROOT}/src/core/lib/gpr/atm.cc
  ${_gRPC_ROOT}/src/core/lib/gpr/cpu_iphone.cc
  ${_gRPC_ROOT}/src/core/lib/gpr/cpu_linux.cc
  ${_gRPC_ROOT}/src/core/lib/gpr/cpu_posix.cc
  ${_gRPC_ROOT}/src/core/lib/gpr/cpu_windows.cc
  ${_gRPC_ROOT}/src/core/lib/gpr/env_linux.cc
  ${_gRPC_ROOT}/src/core/lib/gpr/env_posix.cc
  ${_gRPC_ROOT}/src/core/lib/gpr/env_windows.cc
  ${_gRPC_ROOT}/src/core/lib/gpr/host_port.cc
  ${_gRPC_ROOT}/src/core/lib/gpr/log.cc
  ${_gRPC_ROOT}/src/core/lib/gpr/log_android.cc
  ${_gRPC_ROOT}/src/core/lib/gpr/log_linux.cc
  ${_gRPC_ROOT}/src/core/lib/gpr/log_posix.cc
  ${_gRPC_ROOT}/src/core/lib/gpr/log_windows.cc
  ${_gRPC_ROOT}/src/core/lib/gpr/mpscq.cc
  ${_gRPC_ROOT}/src/core/lib/gpr/murmur_hash.cc
  ${_gRPC_ROOT}/src/core/lib/gpr/string.cc
  ${_gRPC_ROOT}/src/core/lib/gpr/string_posix.cc
  ${_gRPC_ROOT}/src/core/lib/gpr/string_util_windows.cc
  ${_gRPC_ROOT}/src/core/lib/gpr/string_windows.cc
  ${_gRPC_ROOT}/src/core/lib/gpr/sync.cc
  ${_gRPC_ROOT}/src/core/lib/gpr/sync_posix.cc
  ${_gRPC_ROOT}/src/core/lib/gpr/sync_windows.cc
  ${_gRPC_ROOT}/src/core/lib/gpr/time.cc
  ${_gRPC_ROOT}/src/core/lib/gpr/time_posix.cc
  ${_gRPC_ROOT}/src/core/lib/gpr/time_precise.cc
  ${_gRPC_ROOT}/src/core/lib/gpr/time_windows.cc
  ${_gRPC_ROOT}/src/core/lib/gpr/tls_pthread.cc
  ${_gRPC_ROOT}/src/core/lib/gpr/tmpfile_msys.cc
  ${_gRPC_ROOT}/src/core/lib/gpr/tmpfile_posix.cc
  ${_gRPC_ROOT}/src/core/lib/gpr/tmpfile_windows.cc
  ${_gRPC_ROOT}/src/core/lib/gpr/wrap_memcpy.cc
  ${_gRPC_ROOT}/src/core/lib/gprpp/fork.cc
  ${_gRPC_ROOT}/src/core/lib/gprpp/thd_posix.cc
  ${_gRPC_ROOT}/src/core/lib/gprpp/thd_windows.cc
  ${_gRPC_ROOT}/src/core/lib/profiling/basic_timers.cc
  ${_gRPC_ROOT}/src/core/lib/profiling/stap_timers.cc
)
android_add_library(gpr)


target_compile_definitions(gpr PRIVATE -DPB_FIELD_16BIT)
target_compile_definitions(gpr PUBLIC  -DGRPC_ALLOW_EXCEPTIONS=0)
target_compile_options(gpr PRIVATE $<$<COMPILE_LANGUAGE:C>:-std=c11>)
target_include_directories(gpr
  PUBLIC  ${_gRPC_ROOT}/include
  PRIVATE ${_gRPC_ROOT}
  PRIVATE ${_gRPC_SSL_INCLUDE_DIR}
  PRIVATE ${_gRPC_BENCHMARK_INCLUDE_DIR}
  PRIVATE ${_gRPC_CARES_INCLUDE_DIR}
  PRIVATE ${_gRPC_GFLAGS_INCLUDE_DIR}
  PRIVATE ${_gRPC_PROTOBUF_INCLUDE_DIR}
  PRIVATE ${_gRPC_NANOPB_INCLUDE_DIR}
  PRIVATE ${_gRPC_ADDRESS_SORTING_INCLUDE_DIR}
)

target_link_libraries(gpr PRIVATE
  ${_gRPC_ALLTARGETS_LIBRARIES}
)




set(grpc_src
  ${_gRPC_ROOT}/src/core/lib/surface/init.cc
  ${_gRPC_ROOT}/src/core/lib/avl/avl.cc
  ${_gRPC_ROOT}/src/core/lib/backoff/backoff.cc
  ${_gRPC_ROOT}/src/core/lib/channel/channel_args.cc
  ${_gRPC_ROOT}/src/core/lib/channel/channel_stack.cc
  ${_gRPC_ROOT}/src/core/lib/channel/channel_stack_builder.cc
  ${_gRPC_ROOT}/src/core/lib/channel/channel_trace.cc
  ${_gRPC_ROOT}/src/core/lib/channel/channelz.cc
  ${_gRPC_ROOT}/src/core/lib/channel/channelz_registry.cc
  ${_gRPC_ROOT}/src/core/lib/channel/connected_channel.cc
  ${_gRPC_ROOT}/src/core/lib/channel/handshaker.cc
  ${_gRPC_ROOT}/src/core/lib/channel/handshaker_factory.cc
  ${_gRPC_ROOT}/src/core/lib/channel/handshaker_registry.cc
  ${_gRPC_ROOT}/src/core/lib/channel/status_util.cc
  ${_gRPC_ROOT}/src/core/lib/compression/compression.cc
  ${_gRPC_ROOT}/src/core/lib/compression/compression_internal.cc
  ${_gRPC_ROOT}/src/core/lib/compression/message_compress.cc
  ${_gRPC_ROOT}/src/core/lib/compression/stream_compression.cc
  ${_gRPC_ROOT}/src/core/lib/compression/stream_compression_gzip.cc
  ${_gRPC_ROOT}/src/core/lib/compression/stream_compression_identity.cc
  ${_gRPC_ROOT}/src/core/lib/debug/stats.cc
  ${_gRPC_ROOT}/src/core/lib/debug/stats_data.cc
  ${_gRPC_ROOT}/src/core/lib/http/format_request.cc
  ${_gRPC_ROOT}/src/core/lib/http/httpcli.cc
  ${_gRPC_ROOT}/src/core/lib/http/parser.cc
  ${_gRPC_ROOT}/src/core/lib/iomgr/buffer_list.cc
  ${_gRPC_ROOT}/src/core/lib/iomgr/call_combiner.cc
  ${_gRPC_ROOT}/src/core/lib/iomgr/combiner.cc
  ${_gRPC_ROOT}/src/core/lib/iomgr/endpoint.cc
  ${_gRPC_ROOT}/src/core/lib/iomgr/endpoint_pair_posix.cc
  ${_gRPC_ROOT}/src/core/lib/iomgr/endpoint_pair_uv.cc
  ${_gRPC_ROOT}/src/core/lib/iomgr/endpoint_pair_windows.cc
  ${_gRPC_ROOT}/src/core/lib/iomgr/error.cc
  ${_gRPC_ROOT}/src/core/lib/iomgr/ev_epoll1_linux.cc
  ${_gRPC_ROOT}/src/core/lib/iomgr/ev_epollex_linux.cc
  ${_gRPC_ROOT}/src/core/lib/iomgr/ev_epollsig_linux.cc
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
  ${_gRPC_ROOT}/src/core/lib/iomgr/internal_errqueue.cc
  ${_gRPC_ROOT}/src/core/lib/iomgr/iocp_windows.cc
  ${_gRPC_ROOT}/src/core/lib/iomgr/iomgr.cc
  ${_gRPC_ROOT}/src/core/lib/iomgr/iomgr_custom.cc
  ${_gRPC_ROOT}/src/core/lib/iomgr/iomgr_internal.cc
  ${_gRPC_ROOT}/src/core/lib/iomgr/iomgr_posix.cc
  ${_gRPC_ROOT}/src/core/lib/iomgr/iomgr_uv.cc
  ${_gRPC_ROOT}/src/core/lib/iomgr/iomgr_windows.cc
  ${_gRPC_ROOT}/src/core/lib/iomgr/is_epollexclusive_available.cc
  ${_gRPC_ROOT}/src/core/lib/iomgr/load_file.cc
  ${_gRPC_ROOT}/src/core/lib/iomgr/lockfree_event.cc
  ${_gRPC_ROOT}/src/core/lib/iomgr/network_status_tracker.cc
  ${_gRPC_ROOT}/src/core/lib/iomgr/polling_entity.cc
  ${_gRPC_ROOT}/src/core/lib/iomgr/pollset.cc
  ${_gRPC_ROOT}/src/core/lib/iomgr/pollset_custom.cc
  ${_gRPC_ROOT}/src/core/lib/iomgr/pollset_set.cc
  ${_gRPC_ROOT}/src/core/lib/iomgr/pollset_set_custom.cc
  ${_gRPC_ROOT}/src/core/lib/iomgr/pollset_set_windows.cc
  ${_gRPC_ROOT}/src/core/lib/iomgr/pollset_uv.cc
  ${_gRPC_ROOT}/src/core/lib/iomgr/pollset_windows.cc
  ${_gRPC_ROOT}/src/core/lib/iomgr/resolve_address.cc
  ${_gRPC_ROOT}/src/core/lib/iomgr/resolve_address_custom.cc
  ${_gRPC_ROOT}/src/core/lib/iomgr/resolve_address_posix.cc
  ${_gRPC_ROOT}/src/core/lib/iomgr/resolve_address_windows.cc
  ${_gRPC_ROOT}/src/core/lib/iomgr/resource_quota.cc
  ${_gRPC_ROOT}/src/core/lib/iomgr/sockaddr_utils.cc
  ${_gRPC_ROOT}/src/core/lib/iomgr/socket_factory_posix.cc
  ${_gRPC_ROOT}/src/core/lib/iomgr/socket_mutator.cc
  ${_gRPC_ROOT}/src/core/lib/iomgr/socket_utils_common_posix.cc
  ${_gRPC_ROOT}/src/core/lib/iomgr/socket_utils_linux.cc
  ${_gRPC_ROOT}/src/core/lib/iomgr/socket_utils_posix.cc
  ${_gRPC_ROOT}/src/core/lib/iomgr/socket_utils_uv.cc
  ${_gRPC_ROOT}/src/core/lib/iomgr/socket_utils_windows.cc
  ${_gRPC_ROOT}/src/core/lib/iomgr/socket_windows.cc
  ${_gRPC_ROOT}/src/core/lib/iomgr/tcp_client.cc
  ${_gRPC_ROOT}/src/core/lib/iomgr/tcp_client_custom.cc
  ${_gRPC_ROOT}/src/core/lib/iomgr/tcp_client_posix.cc
  ${_gRPC_ROOT}/src/core/lib/iomgr/tcp_client_windows.cc
  ${_gRPC_ROOT}/src/core/lib/iomgr/tcp_custom.cc
  ${_gRPC_ROOT}/src/core/lib/iomgr/tcp_posix.cc
  ${_gRPC_ROOT}/src/core/lib/iomgr/tcp_server.cc
  ${_gRPC_ROOT}/src/core/lib/iomgr/tcp_server_custom.cc
  ${_gRPC_ROOT}/src/core/lib/iomgr/tcp_server_posix.cc
  ${_gRPC_ROOT}/src/core/lib/iomgr/tcp_server_utils_posix_common.cc
  ${_gRPC_ROOT}/src/core/lib/iomgr/tcp_server_utils_posix_ifaddrs.cc
  ${_gRPC_ROOT}/src/core/lib/iomgr/tcp_server_utils_posix_noifaddrs.cc
  ${_gRPC_ROOT}/src/core/lib/iomgr/tcp_server_windows.cc
  ${_gRPC_ROOT}/src/core/lib/iomgr/tcp_uv.cc
  ${_gRPC_ROOT}/src/core/lib/iomgr/tcp_windows.cc
  ${_gRPC_ROOT}/src/core/lib/iomgr/time_averaged_stats.cc
  ${_gRPC_ROOT}/src/core/lib/iomgr/timer.cc
  ${_gRPC_ROOT}/src/core/lib/iomgr/timer_custom.cc
  ${_gRPC_ROOT}/src/core/lib/iomgr/timer_generic.cc
  ${_gRPC_ROOT}/src/core/lib/iomgr/timer_heap.cc
  ${_gRPC_ROOT}/src/core/lib/iomgr/timer_manager.cc
  ${_gRPC_ROOT}/src/core/lib/iomgr/timer_uv.cc
  ${_gRPC_ROOT}/src/core/lib/iomgr/udp_server.cc
  ${_gRPC_ROOT}/src/core/lib/iomgr/unix_sockets_posix.cc
  ${_gRPC_ROOT}/src/core/lib/iomgr/unix_sockets_posix_noop.cc
  ${_gRPC_ROOT}/src/core/lib/iomgr/wakeup_fd_cv.cc
  ${_gRPC_ROOT}/src/core/lib/iomgr/wakeup_fd_eventfd.cc
  ${_gRPC_ROOT}/src/core/lib/iomgr/wakeup_fd_nospecial.cc
  ${_gRPC_ROOT}/src/core/lib/iomgr/wakeup_fd_pipe.cc
  ${_gRPC_ROOT}/src/core/lib/iomgr/wakeup_fd_posix.cc
  ${_gRPC_ROOT}/src/core/lib/json/json.cc
  ${_gRPC_ROOT}/src/core/lib/json/json_reader.cc
  ${_gRPC_ROOT}/src/core/lib/json/json_string.cc
  ${_gRPC_ROOT}/src/core/lib/json/json_writer.cc
  ${_gRPC_ROOT}/src/core/lib/slice/b64.cc
  ${_gRPC_ROOT}/src/core/lib/slice/percent_encoding.cc
  ${_gRPC_ROOT}/src/core/lib/slice/slice.cc
  ${_gRPC_ROOT}/src/core/lib/slice/slice_buffer.cc
  ${_gRPC_ROOT}/src/core/lib/slice/slice_intern.cc
  ${_gRPC_ROOT}/src/core/lib/slice/slice_string_helpers.cc
  ${_gRPC_ROOT}/src/core/lib/surface/api_trace.cc
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
  ${_gRPC_ROOT}/src/core/lib/surface/lame_client.cc
  ${_gRPC_ROOT}/src/core/lib/surface/metadata_array.cc
  ${_gRPC_ROOT}/src/core/lib/surface/server.cc
  ${_gRPC_ROOT}/src/core/lib/surface/validate_metadata.cc
  ${_gRPC_ROOT}/src/core/lib/surface/version.cc
  ${_gRPC_ROOT}/src/core/lib/transport/bdp_estimator.cc
  ${_gRPC_ROOT}/src/core/lib/transport/byte_stream.cc
  ${_gRPC_ROOT}/src/core/lib/transport/connectivity_state.cc
  ${_gRPC_ROOT}/src/core/lib/transport/error_utils.cc
  ${_gRPC_ROOT}/src/core/lib/transport/metadata.cc
  ${_gRPC_ROOT}/src/core/lib/transport/metadata_batch.cc
  ${_gRPC_ROOT}/src/core/lib/transport/pid_controller.cc
  ${_gRPC_ROOT}/src/core/lib/transport/service_config.cc
  ${_gRPC_ROOT}/src/core/lib/transport/static_metadata.cc
  ${_gRPC_ROOT}/src/core/lib/transport/status_conversion.cc
  ${_gRPC_ROOT}/src/core/lib/transport/status_metadata.cc
  ${_gRPC_ROOT}/src/core/lib/transport/timeout_encoding.cc
  ${_gRPC_ROOT}/src/core/lib/transport/transport.cc
  ${_gRPC_ROOT}/src/core/lib/transport/transport_op_string.cc
  ${_gRPC_ROOT}/src/core/lib/debug/trace.cc
  ${_gRPC_ROOT}/src/core/ext/transport/chttp2/server/secure/server_secure_chttp2.cc
  ${_gRPC_ROOT}/src/core/ext/transport/chttp2/transport/bin_decoder.cc
  ${_gRPC_ROOT}/src/core/ext/transport/chttp2/transport/bin_encoder.cc
  ${_gRPC_ROOT}/src/core/ext/transport/chttp2/transport/chttp2_plugin.cc
  ${_gRPC_ROOT}/src/core/ext/transport/chttp2/transport/chttp2_transport.cc
  ${_gRPC_ROOT}/src/core/ext/transport/chttp2/transport/flow_control.cc
  ${_gRPC_ROOT}/src/core/ext/transport/chttp2/transport/frame_data.cc
  ${_gRPC_ROOT}/src/core/ext/transport/chttp2/transport/frame_goaway.cc
  ${_gRPC_ROOT}/src/core/ext/transport/chttp2/transport/frame_ping.cc
  ${_gRPC_ROOT}/src/core/ext/transport/chttp2/transport/frame_rst_stream.cc
  ${_gRPC_ROOT}/src/core/ext/transport/chttp2/transport/frame_settings.cc
  ${_gRPC_ROOT}/src/core/ext/transport/chttp2/transport/frame_window_update.cc
  ${_gRPC_ROOT}/src/core/ext/transport/chttp2/transport/hpack_encoder.cc
  ${_gRPC_ROOT}/src/core/ext/transport/chttp2/transport/hpack_mapping.cc
  ${_gRPC_ROOT}/src/core/ext/transport/chttp2/transport/hpack_parser.cc
  ${_gRPC_ROOT}/src/core/ext/transport/chttp2/transport/hpack_table.cc
  ${_gRPC_ROOT}/src/core/ext/transport/chttp2/transport/http2_settings.cc
  ${_gRPC_ROOT}/src/core/ext/transport/chttp2/transport/huffsyms.cc
  ${_gRPC_ROOT}/src/core/ext/transport/chttp2/transport/incoming_metadata.cc
  ${_gRPC_ROOT}/src/core/ext/transport/chttp2/transport/parsing.cc
  ${_gRPC_ROOT}/src/core/ext/transport/chttp2/transport/stream_lists.cc
  ${_gRPC_ROOT}/src/core/ext/transport/chttp2/transport/stream_map.cc
  ${_gRPC_ROOT}/src/core/ext/transport/chttp2/transport/varint.cc
  ${_gRPC_ROOT}/src/core/ext/transport/chttp2/transport/writing.cc
  ${_gRPC_ROOT}/src/core/ext/transport/chttp2/alpn/alpn.cc
  ${_gRPC_ROOT}/src/core/ext/filters/http/client/http_client_filter.cc
  ${_gRPC_ROOT}/src/core/ext/filters/http/http_filters_plugin.cc
  ${_gRPC_ROOT}/src/core/ext/filters/http/message_compress/message_compress_filter.cc
  ${_gRPC_ROOT}/src/core/ext/filters/http/server/http_server_filter.cc
  ${_gRPC_ROOT}/src/core/lib/http/httpcli_security_connector.cc
  ${_gRPC_ROOT}/src/core/lib/security/context/security_context.cc
  ${_gRPC_ROOT}/src/core/lib/security/credentials/alts/alts_credentials.cc
  ${_gRPC_ROOT}/src/core/lib/security/credentials/composite/composite_credentials.cc
  ${_gRPC_ROOT}/src/core/lib/security/credentials/credentials.cc
  ${_gRPC_ROOT}/src/core/lib/security/credentials/credentials_metadata.cc
  ${_gRPC_ROOT}/src/core/lib/security/credentials/fake/fake_credentials.cc
  ${_gRPC_ROOT}/src/core/lib/security/credentials/google_default/credentials_generic.cc
  ${_gRPC_ROOT}/src/core/lib/security/credentials/google_default/google_default_credentials.cc
  ${_gRPC_ROOT}/src/core/lib/security/credentials/iam/iam_credentials.cc
  ${_gRPC_ROOT}/src/core/lib/security/credentials/jwt/json_token.cc
  ${_gRPC_ROOT}/src/core/lib/security/credentials/jwt/jwt_credentials.cc
  ${_gRPC_ROOT}/src/core/lib/security/credentials/jwt/jwt_verifier.cc
  ${_gRPC_ROOT}/src/core/lib/security/credentials/local/local_credentials.cc
  ${_gRPC_ROOT}/src/core/lib/security/credentials/oauth2/oauth2_credentials.cc
  ${_gRPC_ROOT}/src/core/lib/security/credentials/plugin/plugin_credentials.cc
  ${_gRPC_ROOT}/src/core/lib/security/credentials/ssl/ssl_credentials.cc
  ${_gRPC_ROOT}/src/core/lib/security/security_connector/alts_security_connector.cc
  ${_gRPC_ROOT}/src/core/lib/security/security_connector/load_system_roots_fallback.cc
  ${_gRPC_ROOT}/src/core/lib/security/security_connector/load_system_roots_linux.cc
  ${_gRPC_ROOT}/src/core/lib/security/security_connector/local_security_connector.cc
  ${_gRPC_ROOT}/src/core/lib/security/security_connector/security_connector.cc
  ${_gRPC_ROOT}/src/core/lib/security/transport/client_auth_filter.cc
  ${_gRPC_ROOT}/src/core/lib/security/transport/secure_endpoint.cc
  ${_gRPC_ROOT}/src/core/lib/security/transport/security_handshaker.cc
  ${_gRPC_ROOT}/src/core/lib/security/transport/server_auth_filter.cc
  ${_gRPC_ROOT}/src/core/lib/security/transport/target_authority_table.cc
  ${_gRPC_ROOT}/src/core/lib/security/transport/tsi_error.cc
  ${_gRPC_ROOT}/src/core/lib/security/util/json_util.cc
  ${_gRPC_ROOT}/src/core/lib/surface/init_secure.cc
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
  ${_gRPC_ROOT}/src/core/tsi/alts/handshaker/alts_tsi_event.cc
  ${_gRPC_ROOT}/src/core/tsi/alts/handshaker/alts_tsi_handshaker.cc
  ${_gRPC_ROOT}/src/core/tsi/alts/zero_copy_frame_protector/alts_grpc_integrity_only_record_protocol.cc
  ${_gRPC_ROOT}/src/core/tsi/alts/zero_copy_frame_protector/alts_grpc_privacy_integrity_record_protocol.cc
  ${_gRPC_ROOT}/src/core/tsi/alts/zero_copy_frame_protector/alts_grpc_record_protocol_common.cc
  ${_gRPC_ROOT}/src/core/tsi/alts/zero_copy_frame_protector/alts_iovec_record_protocol.cc
  ${_gRPC_ROOT}/src/core/tsi/alts/zero_copy_frame_protector/alts_zero_copy_grpc_protector.cc
  ${_gRPC_ROOT}/src/core/lib/security/credentials/alts/check_gcp_environment.cc
  ${_gRPC_ROOT}/src/core/lib/security/credentials/alts/check_gcp_environment_linux.cc
  ${_gRPC_ROOT}/src/core/lib/security/credentials/alts/check_gcp_environment_no_op.cc
  ${_gRPC_ROOT}/src/core/lib/security/credentials/alts/check_gcp_environment_windows.cc
  ${_gRPC_ROOT}/src/core/lib/security/credentials/alts/grpc_alts_credentials_client_options.cc
  ${_gRPC_ROOT}/src/core/lib/security/credentials/alts/grpc_alts_credentials_options.cc
  ${_gRPC_ROOT}/src/core/lib/security/credentials/alts/grpc_alts_credentials_server_options.cc
  ${_gRPC_ROOT}/src/core/tsi/alts/handshaker/alts_handshaker_service_api.cc
  ${_gRPC_ROOT}/src/core/tsi/alts/handshaker/alts_handshaker_service_api_util.cc
  ${_gRPC_ROOT}/src/core/tsi/alts/handshaker/alts_tsi_utils.cc
  ${_gRPC_ROOT}/src/core/tsi/alts/handshaker/transport_security_common_api.cc
  ${_gRPC_ROOT}/src/core/tsi/alts/handshaker/altscontext.pb.c
  ${_gRPC_ROOT}/src/core/tsi/alts/handshaker/handshaker.pb.c
  ${_gRPC_ROOT}/src/core/tsi/alts/handshaker/transport_security_common.pb.c
  ${_gRPC_ROOT}/third_party/nanopb/pb_common.c
  ${_gRPC_ROOT}/third_party/nanopb/pb_decode.c
  ${_gRPC_ROOT}/third_party/nanopb/pb_encode.c
  ${_gRPC_ROOT}/src/core/tsi/transport_security.cc
  ${_gRPC_ROOT}/src/core/ext/transport/chttp2/client/insecure/channel_create.cc
  ${_gRPC_ROOT}/src/core/ext/transport/chttp2/client/insecure/channel_create_posix.cc
  ${_gRPC_ROOT}/src/core/ext/transport/chttp2/client/authority.cc
  ${_gRPC_ROOT}/src/core/ext/transport/chttp2/client/chttp2_connector.cc
  ${_gRPC_ROOT}/src/core/ext/filters/client_channel/backup_poller.cc
  ${_gRPC_ROOT}/src/core/ext/filters/client_channel/channel_connectivity.cc
  ${_gRPC_ROOT}/src/core/ext/filters/client_channel/client_channel.cc
  ${_gRPC_ROOT}/src/core/ext/filters/client_channel/client_channel_channelz.cc
  ${_gRPC_ROOT}/src/core/ext/filters/client_channel/client_channel_factory.cc
  ${_gRPC_ROOT}/src/core/ext/filters/client_channel/client_channel_plugin.cc
  ${_gRPC_ROOT}/src/core/ext/filters/client_channel/connector.cc
  ${_gRPC_ROOT}/src/core/ext/filters/client_channel/http_connect_handshaker.cc
  ${_gRPC_ROOT}/src/core/ext/filters/client_channel/http_proxy.cc
  ${_gRPC_ROOT}/src/core/ext/filters/client_channel/lb_policy.cc
  ${_gRPC_ROOT}/src/core/ext/filters/client_channel/lb_policy_factory.cc
  ${_gRPC_ROOT}/src/core/ext/filters/client_channel/lb_policy_registry.cc
  ${_gRPC_ROOT}/src/core/ext/filters/client_channel/method_params.cc
  ${_gRPC_ROOT}/src/core/ext/filters/client_channel/parse_address.cc
  ${_gRPC_ROOT}/src/core/ext/filters/client_channel/proxy_mapper.cc
  ${_gRPC_ROOT}/src/core/ext/filters/client_channel/proxy_mapper_registry.cc
  ${_gRPC_ROOT}/src/core/ext/filters/client_channel/resolver.cc
  ${_gRPC_ROOT}/src/core/ext/filters/client_channel/resolver_registry.cc
  ${_gRPC_ROOT}/src/core/ext/filters/client_channel/retry_throttle.cc
  ${_gRPC_ROOT}/src/core/ext/filters/client_channel/subchannel.cc
  ${_gRPC_ROOT}/src/core/ext/filters/client_channel/subchannel_index.cc
  ${_gRPC_ROOT}/src/core/ext/filters/client_channel/uri_parser.cc
  ${_gRPC_ROOT}/src/core/ext/filters/deadline/deadline_filter.cc
  ${_gRPC_ROOT}/src/core/tsi/alts_transport_security.cc
  ${_gRPC_ROOT}/src/core/tsi/fake_transport_security.cc
  ${_gRPC_ROOT}/src/core/tsi/local_transport_security.cc
  ${_gRPC_ROOT}/src/core/tsi/ssl/session_cache/ssl_session_boringssl.cc
  ${_gRPC_ROOT}/src/core/tsi/ssl/session_cache/ssl_session_cache.cc
  ${_gRPC_ROOT}/src/core/tsi/ssl/session_cache/ssl_session_openssl.cc
  ${_gRPC_ROOT}/src/core/tsi/ssl_transport_security.cc
  ${_gRPC_ROOT}/src/core/tsi/transport_security_grpc.cc
  ${_gRPC_ROOT}/src/core/ext/transport/chttp2/server/chttp2_server.cc
  ${_gRPC_ROOT}/src/core/ext/transport/chttp2/client/secure/secure_channel_create.cc
  ${_gRPC_ROOT}/src/core/ext/transport/chttp2/server/insecure/server_chttp2.cc
  ${_gRPC_ROOT}/src/core/ext/transport/chttp2/server/insecure/server_chttp2_posix.cc
  ${_gRPC_ROOT}/src/core/ext/transport/inproc/inproc_plugin.cc
  ${_gRPC_ROOT}/src/core/ext/transport/inproc/inproc_transport.cc
  ${_gRPC_ROOT}/src/core/ext/filters/client_channel/lb_policy/grpclb/client_load_reporting_filter.cc
  ${_gRPC_ROOT}/src/core/ext/filters/client_channel/lb_policy/grpclb/grpclb.cc
  ${_gRPC_ROOT}/src/core/ext/filters/client_channel/lb_policy/grpclb/grpclb_channel_secure.cc
  ${_gRPC_ROOT}/src/core/ext/filters/client_channel/lb_policy/grpclb/grpclb_client_stats.cc
  ${_gRPC_ROOT}/src/core/ext/filters/client_channel/lb_policy/grpclb/load_balancer_api.cc
  ${_gRPC_ROOT}/src/core/ext/filters/client_channel/lb_policy/grpclb/proto/grpc/lb/v1/google/protobuf/duration.pb.c
  ${_gRPC_ROOT}/src/core/ext/filters/client_channel/lb_policy/grpclb/proto/grpc/lb/v1/google/protobuf/timestamp.pb.c
  ${_gRPC_ROOT}/src/core/ext/filters/client_channel/lb_policy/grpclb/proto/grpc/lb/v1/load_balancer.pb.c
  ${_gRPC_ROOT}/src/core/ext/filters/client_channel/resolver/fake/fake_resolver.cc
  ${_gRPC_ROOT}/src/core/ext/filters/client_channel/lb_policy/pick_first/pick_first.cc
  ${_gRPC_ROOT}/src/core/ext/filters/client_channel/lb_policy/round_robin/round_robin.cc
  ${_gRPC_ROOT}/src/core/ext/filters/client_channel/resolver/dns/c_ares/dns_resolver_ares.cc
  ${_gRPC_ROOT}/src/core/ext/filters/client_channel/resolver/dns/c_ares/grpc_ares_ev_driver.cc
  ${_gRPC_ROOT}/src/core/ext/filters/client_channel/resolver/dns/c_ares/grpc_ares_ev_driver_posix.cc
  ${_gRPC_ROOT}/src/core/ext/filters/client_channel/resolver/dns/c_ares/grpc_ares_ev_driver_windows.cc
  ${_gRPC_ROOT}/src/core/ext/filters/client_channel/resolver/dns/c_ares/grpc_ares_wrapper.cc
  ${_gRPC_ROOT}/src/core/ext/filters/client_channel/resolver/dns/c_ares/grpc_ares_wrapper_fallback.cc
  ${_gRPC_ROOT}/src/core/ext/filters/client_channel/resolver/dns/c_ares/grpc_ares_wrapper_posix.cc
  ${_gRPC_ROOT}/src/core/ext/filters/client_channel/resolver/dns/c_ares/grpc_ares_wrapper_windows.cc
  ${_gRPC_ROOT}/src/core/ext/filters/client_channel/resolver/dns/native/dns_resolver.cc
  ${_gRPC_ROOT}/src/core/ext/filters/client_channel/resolver/sockaddr/sockaddr_resolver.cc
  ${_gRPC_ROOT}/src/core/ext/filters/census/grpc_context.cc
  ${_gRPC_ROOT}/src/core/ext/filters/max_age/max_age_filter.cc
  ${_gRPC_ROOT}/src/core/ext/filters/message_size/message_size_filter.cc
  ${_gRPC_ROOT}/src/core/ext/filters/http/client_authority_filter.cc
  ${_gRPC_ROOT}/src/core/ext/filters/workarounds/workaround_cronet_compression_filter.cc
  ${_gRPC_ROOT}/src/core/ext/filters/workarounds/workaround_utils.cc
  ${_gRPC_ROOT}/src/core/plugin_registry/grpc_plugin_registry.cc
)
android_add_library(grpc)


target_compile_definitions(grpc PRIVATE -DPB_FIELD_16BIT)
target_compile_definitions(grpc PUBLIC  -DGRPC_ALLOW_EXCEPTIONS=0)
target_compile_options(grpc PRIVATE $<$<COMPILE_LANGUAGE:C>:-std=c11>)
target_include_directories(grpc
  PUBLIC  ${_gRPC_ROOT}/include
  PRIVATE ${_gRPC_ROOT}
  PRIVATE ${_gRPC_SSL_INCLUDE_DIR}
  PRIVATE ${_gRPC_BENCHMARK_INCLUDE_DIR}
  PRIVATE ${_gRPC_CARES_INCLUDE_DIR}
  PRIVATE ${_gRPC_GFLAGS_INCLUDE_DIR}
  PRIVATE ${_gRPC_PROTOBUF_INCLUDE_DIR}
  PRIVATE ${_gRPC_NANOPB_INCLUDE_DIR}
  PRIVATE ${_gRPC_ADDRESS_SORTING_INCLUDE_DIR}
)

target_link_libraries(grpc PRIVATE
  ${_gRPC_BASELIB_LIBRARIES}
  ssl
  crypto
  zlib
  cares
  address_sorting
  ${_gRPC_ALLTARGETS_LIBRARIES}
  gpr
)




set(grpc_cronet_src
  ${_gRPC_ROOT}/src/core/lib/surface/init.cc
  ${_gRPC_ROOT}/src/core/lib/avl/avl.cc
  ${_gRPC_ROOT}/src/core/lib/backoff/backoff.cc
  ${_gRPC_ROOT}/src/core/lib/channel/channel_args.cc
  ${_gRPC_ROOT}/src/core/lib/channel/channel_stack.cc
  ${_gRPC_ROOT}/src/core/lib/channel/channel_stack_builder.cc
  ${_gRPC_ROOT}/src/core/lib/channel/channel_trace.cc
  ${_gRPC_ROOT}/src/core/lib/channel/channelz.cc
  ${_gRPC_ROOT}/src/core/lib/channel/channelz_registry.cc
  ${_gRPC_ROOT}/src/core/lib/channel/connected_channel.cc
  ${_gRPC_ROOT}/src/core/lib/channel/handshaker.cc
  ${_gRPC_ROOT}/src/core/lib/channel/handshaker_factory.cc
  ${_gRPC_ROOT}/src/core/lib/channel/handshaker_registry.cc
  ${_gRPC_ROOT}/src/core/lib/channel/status_util.cc
  ${_gRPC_ROOT}/src/core/lib/compression/compression.cc
  ${_gRPC_ROOT}/src/core/lib/compression/compression_internal.cc
  ${_gRPC_ROOT}/src/core/lib/compression/message_compress.cc
  ${_gRPC_ROOT}/src/core/lib/compression/stream_compression.cc
  ${_gRPC_ROOT}/src/core/lib/compression/stream_compression_gzip.cc
  ${_gRPC_ROOT}/src/core/lib/compression/stream_compression_identity.cc
  ${_gRPC_ROOT}/src/core/lib/debug/stats.cc
  ${_gRPC_ROOT}/src/core/lib/debug/stats_data.cc
  ${_gRPC_ROOT}/src/core/lib/http/format_request.cc
  ${_gRPC_ROOT}/src/core/lib/http/httpcli.cc
  ${_gRPC_ROOT}/src/core/lib/http/parser.cc
  ${_gRPC_ROOT}/src/core/lib/iomgr/buffer_list.cc
  ${_gRPC_ROOT}/src/core/lib/iomgr/call_combiner.cc
  ${_gRPC_ROOT}/src/core/lib/iomgr/combiner.cc
  ${_gRPC_ROOT}/src/core/lib/iomgr/endpoint.cc
  ${_gRPC_ROOT}/src/core/lib/iomgr/endpoint_pair_posix.cc
  ${_gRPC_ROOT}/src/core/lib/iomgr/endpoint_pair_uv.cc
  ${_gRPC_ROOT}/src/core/lib/iomgr/endpoint_pair_windows.cc
  ${_gRPC_ROOT}/src/core/lib/iomgr/error.cc
  ${_gRPC_ROOT}/src/core/lib/iomgr/ev_epoll1_linux.cc
  ${_gRPC_ROOT}/src/core/lib/iomgr/ev_epollex_linux.cc
  ${_gRPC_ROOT}/src/core/lib/iomgr/ev_epollsig_linux.cc
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
  ${_gRPC_ROOT}/src/core/lib/iomgr/internal_errqueue.cc
  ${_gRPC_ROOT}/src/core/lib/iomgr/iocp_windows.cc
  ${_gRPC_ROOT}/src/core/lib/iomgr/iomgr.cc
  ${_gRPC_ROOT}/src/core/lib/iomgr/iomgr_custom.cc
  ${_gRPC_ROOT}/src/core/lib/iomgr/iomgr_internal.cc
  ${_gRPC_ROOT}/src/core/lib/iomgr/iomgr_posix.cc
  ${_gRPC_ROOT}/src/core/lib/iomgr/iomgr_uv.cc
  ${_gRPC_ROOT}/src/core/lib/iomgr/iomgr_windows.cc
  ${_gRPC_ROOT}/src/core/lib/iomgr/is_epollexclusive_available.cc
  ${_gRPC_ROOT}/src/core/lib/iomgr/load_file.cc
  ${_gRPC_ROOT}/src/core/lib/iomgr/lockfree_event.cc
  ${_gRPC_ROOT}/src/core/lib/iomgr/network_status_tracker.cc
  ${_gRPC_ROOT}/src/core/lib/iomgr/polling_entity.cc
  ${_gRPC_ROOT}/src/core/lib/iomgr/pollset.cc
  ${_gRPC_ROOT}/src/core/lib/iomgr/pollset_custom.cc
  ${_gRPC_ROOT}/src/core/lib/iomgr/pollset_set.cc
  ${_gRPC_ROOT}/src/core/lib/iomgr/pollset_set_custom.cc
  ${_gRPC_ROOT}/src/core/lib/iomgr/pollset_set_windows.cc
  ${_gRPC_ROOT}/src/core/lib/iomgr/pollset_uv.cc
  ${_gRPC_ROOT}/src/core/lib/iomgr/pollset_windows.cc
  ${_gRPC_ROOT}/src/core/lib/iomgr/resolve_address.cc
  ${_gRPC_ROOT}/src/core/lib/iomgr/resolve_address_custom.cc
  ${_gRPC_ROOT}/src/core/lib/iomgr/resolve_address_posix.cc
  ${_gRPC_ROOT}/src/core/lib/iomgr/resolve_address_windows.cc
  ${_gRPC_ROOT}/src/core/lib/iomgr/resource_quota.cc
  ${_gRPC_ROOT}/src/core/lib/iomgr/sockaddr_utils.cc
  ${_gRPC_ROOT}/src/core/lib/iomgr/socket_factory_posix.cc
  ${_gRPC_ROOT}/src/core/lib/iomgr/socket_mutator.cc
  ${_gRPC_ROOT}/src/core/lib/iomgr/socket_utils_common_posix.cc
  ${_gRPC_ROOT}/src/core/lib/iomgr/socket_utils_linux.cc
  ${_gRPC_ROOT}/src/core/lib/iomgr/socket_utils_posix.cc
  ${_gRPC_ROOT}/src/core/lib/iomgr/socket_utils_uv.cc
  ${_gRPC_ROOT}/src/core/lib/iomgr/socket_utils_windows.cc
  ${_gRPC_ROOT}/src/core/lib/iomgr/socket_windows.cc
  ${_gRPC_ROOT}/src/core/lib/iomgr/tcp_client.cc
  ${_gRPC_ROOT}/src/core/lib/iomgr/tcp_client_custom.cc
  ${_gRPC_ROOT}/src/core/lib/iomgr/tcp_client_posix.cc
  ${_gRPC_ROOT}/src/core/lib/iomgr/tcp_client_windows.cc
  ${_gRPC_ROOT}/src/core/lib/iomgr/tcp_custom.cc
  ${_gRPC_ROOT}/src/core/lib/iomgr/tcp_posix.cc
  ${_gRPC_ROOT}/src/core/lib/iomgr/tcp_server.cc
  ${_gRPC_ROOT}/src/core/lib/iomgr/tcp_server_custom.cc
  ${_gRPC_ROOT}/src/core/lib/iomgr/tcp_server_posix.cc
  ${_gRPC_ROOT}/src/core/lib/iomgr/tcp_server_utils_posix_common.cc
  ${_gRPC_ROOT}/src/core/lib/iomgr/tcp_server_utils_posix_ifaddrs.cc
  ${_gRPC_ROOT}/src/core/lib/iomgr/tcp_server_utils_posix_noifaddrs.cc
  ${_gRPC_ROOT}/src/core/lib/iomgr/tcp_server_windows.cc
  ${_gRPC_ROOT}/src/core/lib/iomgr/tcp_uv.cc
  ${_gRPC_ROOT}/src/core/lib/iomgr/tcp_windows.cc
  ${_gRPC_ROOT}/src/core/lib/iomgr/time_averaged_stats.cc
  ${_gRPC_ROOT}/src/core/lib/iomgr/timer.cc
  ${_gRPC_ROOT}/src/core/lib/iomgr/timer_custom.cc
  ${_gRPC_ROOT}/src/core/lib/iomgr/timer_generic.cc
  ${_gRPC_ROOT}/src/core/lib/iomgr/timer_heap.cc
  ${_gRPC_ROOT}/src/core/lib/iomgr/timer_manager.cc
  ${_gRPC_ROOT}/src/core/lib/iomgr/timer_uv.cc
  ${_gRPC_ROOT}/src/core/lib/iomgr/udp_server.cc
  ${_gRPC_ROOT}/src/core/lib/iomgr/unix_sockets_posix.cc
  ${_gRPC_ROOT}/src/core/lib/iomgr/unix_sockets_posix_noop.cc
  ${_gRPC_ROOT}/src/core/lib/iomgr/wakeup_fd_cv.cc
  ${_gRPC_ROOT}/src/core/lib/iomgr/wakeup_fd_eventfd.cc
  ${_gRPC_ROOT}/src/core/lib/iomgr/wakeup_fd_nospecial.cc
  ${_gRPC_ROOT}/src/core/lib/iomgr/wakeup_fd_pipe.cc
  ${_gRPC_ROOT}/src/core/lib/iomgr/wakeup_fd_posix.cc
  ${_gRPC_ROOT}/src/core/lib/json/json.cc
  ${_gRPC_ROOT}/src/core/lib/json/json_reader.cc
  ${_gRPC_ROOT}/src/core/lib/json/json_string.cc
  ${_gRPC_ROOT}/src/core/lib/json/json_writer.cc
  ${_gRPC_ROOT}/src/core/lib/slice/b64.cc
  ${_gRPC_ROOT}/src/core/lib/slice/percent_encoding.cc
  ${_gRPC_ROOT}/src/core/lib/slice/slice.cc
  ${_gRPC_ROOT}/src/core/lib/slice/slice_buffer.cc
  ${_gRPC_ROOT}/src/core/lib/slice/slice_intern.cc
  ${_gRPC_ROOT}/src/core/lib/slice/slice_string_helpers.cc
  ${_gRPC_ROOT}/src/core/lib/surface/api_trace.cc
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
  ${_gRPC_ROOT}/src/core/lib/surface/lame_client.cc
  ${_gRPC_ROOT}/src/core/lib/surface/metadata_array.cc
  ${_gRPC_ROOT}/src/core/lib/surface/server.cc
  ${_gRPC_ROOT}/src/core/lib/surface/validate_metadata.cc
  ${_gRPC_ROOT}/src/core/lib/surface/version.cc
  ${_gRPC_ROOT}/src/core/lib/transport/bdp_estimator.cc
  ${_gRPC_ROOT}/src/core/lib/transport/byte_stream.cc
  ${_gRPC_ROOT}/src/core/lib/transport/connectivity_state.cc
  ${_gRPC_ROOT}/src/core/lib/transport/error_utils.cc
  ${_gRPC_ROOT}/src/core/lib/transport/metadata.cc
  ${_gRPC_ROOT}/src/core/lib/transport/metadata_batch.cc
  ${_gRPC_ROOT}/src/core/lib/transport/pid_controller.cc
  ${_gRPC_ROOT}/src/core/lib/transport/service_config.cc
  ${_gRPC_ROOT}/src/core/lib/transport/static_metadata.cc
  ${_gRPC_ROOT}/src/core/lib/transport/status_conversion.cc
  ${_gRPC_ROOT}/src/core/lib/transport/status_metadata.cc
  ${_gRPC_ROOT}/src/core/lib/transport/timeout_encoding.cc
  ${_gRPC_ROOT}/src/core/lib/transport/transport.cc
  ${_gRPC_ROOT}/src/core/lib/transport/transport_op_string.cc
  ${_gRPC_ROOT}/src/core/lib/debug/trace.cc
  ${_gRPC_ROOT}/src/core/ext/transport/cronet/client/secure/cronet_channel_create.cc
  ${_gRPC_ROOT}/src/core/ext/transport/cronet/transport/cronet_api_dummy.cc
  ${_gRPC_ROOT}/src/core/ext/transport/cronet/transport/cronet_transport.cc
  ${_gRPC_ROOT}/src/core/ext/transport/chttp2/client/secure/secure_channel_create.cc
  ${_gRPC_ROOT}/src/core/ext/transport/chttp2/transport/bin_decoder.cc
  ${_gRPC_ROOT}/src/core/ext/transport/chttp2/transport/bin_encoder.cc
  ${_gRPC_ROOT}/src/core/ext/transport/chttp2/transport/chttp2_plugin.cc
  ${_gRPC_ROOT}/src/core/ext/transport/chttp2/transport/chttp2_transport.cc
  ${_gRPC_ROOT}/src/core/ext/transport/chttp2/transport/flow_control.cc
  ${_gRPC_ROOT}/src/core/ext/transport/chttp2/transport/frame_data.cc
  ${_gRPC_ROOT}/src/core/ext/transport/chttp2/transport/frame_goaway.cc
  ${_gRPC_ROOT}/src/core/ext/transport/chttp2/transport/frame_ping.cc
  ${_gRPC_ROOT}/src/core/ext/transport/chttp2/transport/frame_rst_stream.cc
  ${_gRPC_ROOT}/src/core/ext/transport/chttp2/transport/frame_settings.cc
  ${_gRPC_ROOT}/src/core/ext/transport/chttp2/transport/frame_window_update.cc
  ${_gRPC_ROOT}/src/core/ext/transport/chttp2/transport/hpack_encoder.cc
  ${_gRPC_ROOT}/src/core/ext/transport/chttp2/transport/hpack_mapping.cc
  ${_gRPC_ROOT}/src/core/ext/transport/chttp2/transport/hpack_parser.cc
  ${_gRPC_ROOT}/src/core/ext/transport/chttp2/transport/hpack_table.cc
  ${_gRPC_ROOT}/src/core/ext/transport/chttp2/transport/http2_settings.cc
  ${_gRPC_ROOT}/src/core/ext/transport/chttp2/transport/huffsyms.cc
  ${_gRPC_ROOT}/src/core/ext/transport/chttp2/transport/incoming_metadata.cc
  ${_gRPC_ROOT}/src/core/ext/transport/chttp2/transport/parsing.cc
  ${_gRPC_ROOT}/src/core/ext/transport/chttp2/transport/stream_lists.cc
  ${_gRPC_ROOT}/src/core/ext/transport/chttp2/transport/stream_map.cc
  ${_gRPC_ROOT}/src/core/ext/transport/chttp2/transport/varint.cc
  ${_gRPC_ROOT}/src/core/ext/transport/chttp2/transport/writing.cc
  ${_gRPC_ROOT}/src/core/ext/transport/chttp2/alpn/alpn.cc
  ${_gRPC_ROOT}/src/core/ext/filters/http/client/http_client_filter.cc
  ${_gRPC_ROOT}/src/core/ext/filters/http/http_filters_plugin.cc
  ${_gRPC_ROOT}/src/core/ext/filters/http/message_compress/message_compress_filter.cc
  ${_gRPC_ROOT}/src/core/ext/filters/http/server/http_server_filter.cc
  ${_gRPC_ROOT}/src/core/ext/filters/client_channel/backup_poller.cc
  ${_gRPC_ROOT}/src/core/ext/filters/client_channel/channel_connectivity.cc
  ${_gRPC_ROOT}/src/core/ext/filters/client_channel/client_channel.cc
  ${_gRPC_ROOT}/src/core/ext/filters/client_channel/client_channel_channelz.cc
  ${_gRPC_ROOT}/src/core/ext/filters/client_channel/client_channel_factory.cc
  ${_gRPC_ROOT}/src/core/ext/filters/client_channel/client_channel_plugin.cc
  ${_gRPC_ROOT}/src/core/ext/filters/client_channel/connector.cc
  ${_gRPC_ROOT}/src/core/ext/filters/client_channel/http_connect_handshaker.cc
  ${_gRPC_ROOT}/src/core/ext/filters/client_channel/http_proxy.cc
  ${_gRPC_ROOT}/src/core/ext/filters/client_channel/lb_policy.cc
  ${_gRPC_ROOT}/src/core/ext/filters/client_channel/lb_policy_factory.cc
  ${_gRPC_ROOT}/src/core/ext/filters/client_channel/lb_policy_registry.cc
  ${_gRPC_ROOT}/src/core/ext/filters/client_channel/method_params.cc
  ${_gRPC_ROOT}/src/core/ext/filters/client_channel/parse_address.cc
  ${_gRPC_ROOT}/src/core/ext/filters/client_channel/proxy_mapper.cc
  ${_gRPC_ROOT}/src/core/ext/filters/client_channel/proxy_mapper_registry.cc
  ${_gRPC_ROOT}/src/core/ext/filters/client_channel/resolver.cc
  ${_gRPC_ROOT}/src/core/ext/filters/client_channel/resolver_registry.cc
  ${_gRPC_ROOT}/src/core/ext/filters/client_channel/retry_throttle.cc
  ${_gRPC_ROOT}/src/core/ext/filters/client_channel/subchannel.cc
  ${_gRPC_ROOT}/src/core/ext/filters/client_channel/subchannel_index.cc
  ${_gRPC_ROOT}/src/core/ext/filters/client_channel/uri_parser.cc
  ${_gRPC_ROOT}/src/core/ext/filters/deadline/deadline_filter.cc
  ${_gRPC_ROOT}/src/core/lib/http/httpcli_security_connector.cc
  ${_gRPC_ROOT}/src/core/lib/security/context/security_context.cc
  ${_gRPC_ROOT}/src/core/lib/security/credentials/alts/alts_credentials.cc
  ${_gRPC_ROOT}/src/core/lib/security/credentials/composite/composite_credentials.cc
  ${_gRPC_ROOT}/src/core/lib/security/credentials/credentials.cc
  ${_gRPC_ROOT}/src/core/lib/security/credentials/credentials_metadata.cc
  ${_gRPC_ROOT}/src/core/lib/security/credentials/fake/fake_credentials.cc
  ${_gRPC_ROOT}/src/core/lib/security/credentials/google_default/credentials_generic.cc
  ${_gRPC_ROOT}/src/core/lib/security/credentials/google_default/google_default_credentials.cc
  ${_gRPC_ROOT}/src/core/lib/security/credentials/iam/iam_credentials.cc
  ${_gRPC_ROOT}/src/core/lib/security/credentials/jwt/json_token.cc
  ${_gRPC_ROOT}/src/core/lib/security/credentials/jwt/jwt_credentials.cc
  ${_gRPC_ROOT}/src/core/lib/security/credentials/jwt/jwt_verifier.cc
  ${_gRPC_ROOT}/src/core/lib/security/credentials/local/local_credentials.cc
  ${_gRPC_ROOT}/src/core/lib/security/credentials/oauth2/oauth2_credentials.cc
  ${_gRPC_ROOT}/src/core/lib/security/credentials/plugin/plugin_credentials.cc
  ${_gRPC_ROOT}/src/core/lib/security/credentials/ssl/ssl_credentials.cc
  ${_gRPC_ROOT}/src/core/lib/security/security_connector/alts_security_connector.cc
  ${_gRPC_ROOT}/src/core/lib/security/security_connector/load_system_roots_fallback.cc
  ${_gRPC_ROOT}/src/core/lib/security/security_connector/load_system_roots_linux.cc
  ${_gRPC_ROOT}/src/core/lib/security/security_connector/local_security_connector.cc
  ${_gRPC_ROOT}/src/core/lib/security/security_connector/security_connector.cc
  ${_gRPC_ROOT}/src/core/lib/security/transport/client_auth_filter.cc
  ${_gRPC_ROOT}/src/core/lib/security/transport/secure_endpoint.cc
  ${_gRPC_ROOT}/src/core/lib/security/transport/security_handshaker.cc
  ${_gRPC_ROOT}/src/core/lib/security/transport/server_auth_filter.cc
  ${_gRPC_ROOT}/src/core/lib/security/transport/target_authority_table.cc
  ${_gRPC_ROOT}/src/core/lib/security/transport/tsi_error.cc
  ${_gRPC_ROOT}/src/core/lib/security/util/json_util.cc
  ${_gRPC_ROOT}/src/core/lib/surface/init_secure.cc
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
  ${_gRPC_ROOT}/src/core/tsi/alts/handshaker/alts_tsi_event.cc
  ${_gRPC_ROOT}/src/core/tsi/alts/handshaker/alts_tsi_handshaker.cc
  ${_gRPC_ROOT}/src/core/tsi/alts/zero_copy_frame_protector/alts_grpc_integrity_only_record_protocol.cc
  ${_gRPC_ROOT}/src/core/tsi/alts/zero_copy_frame_protector/alts_grpc_privacy_integrity_record_protocol.cc
  ${_gRPC_ROOT}/src/core/tsi/alts/zero_copy_frame_protector/alts_grpc_record_protocol_common.cc
  ${_gRPC_ROOT}/src/core/tsi/alts/zero_copy_frame_protector/alts_iovec_record_protocol.cc
  ${_gRPC_ROOT}/src/core/tsi/alts/zero_copy_frame_protector/alts_zero_copy_grpc_protector.cc
  ${_gRPC_ROOT}/src/core/lib/security/credentials/alts/check_gcp_environment.cc
  ${_gRPC_ROOT}/src/core/lib/security/credentials/alts/check_gcp_environment_linux.cc
  ${_gRPC_ROOT}/src/core/lib/security/credentials/alts/check_gcp_environment_no_op.cc
  ${_gRPC_ROOT}/src/core/lib/security/credentials/alts/check_gcp_environment_windows.cc
  ${_gRPC_ROOT}/src/core/lib/security/credentials/alts/grpc_alts_credentials_client_options.cc
  ${_gRPC_ROOT}/src/core/lib/security/credentials/alts/grpc_alts_credentials_options.cc
  ${_gRPC_ROOT}/src/core/lib/security/credentials/alts/grpc_alts_credentials_server_options.cc
  ${_gRPC_ROOT}/src/core/tsi/alts/handshaker/alts_handshaker_service_api.cc
  ${_gRPC_ROOT}/src/core/tsi/alts/handshaker/alts_handshaker_service_api_util.cc
  ${_gRPC_ROOT}/src/core/tsi/alts/handshaker/alts_tsi_utils.cc
  ${_gRPC_ROOT}/src/core/tsi/alts/handshaker/transport_security_common_api.cc
  ${_gRPC_ROOT}/src/core/tsi/alts/handshaker/altscontext.pb.c
  ${_gRPC_ROOT}/src/core/tsi/alts/handshaker/handshaker.pb.c
  ${_gRPC_ROOT}/src/core/tsi/alts/handshaker/transport_security_common.pb.c
  ${_gRPC_ROOT}/third_party/nanopb/pb_common.c
  ${_gRPC_ROOT}/third_party/nanopb/pb_decode.c
  ${_gRPC_ROOT}/third_party/nanopb/pb_encode.c
  ${_gRPC_ROOT}/src/core/tsi/transport_security.cc
  ${_gRPC_ROOT}/src/core/ext/transport/chttp2/client/insecure/channel_create.cc
  ${_gRPC_ROOT}/src/core/ext/transport/chttp2/client/insecure/channel_create_posix.cc
  ${_gRPC_ROOT}/src/core/ext/transport/chttp2/client/authority.cc
  ${_gRPC_ROOT}/src/core/ext/transport/chttp2/client/chttp2_connector.cc
  ${_gRPC_ROOT}/src/core/tsi/alts_transport_security.cc
  ${_gRPC_ROOT}/src/core/tsi/fake_transport_security.cc
  ${_gRPC_ROOT}/src/core/tsi/local_transport_security.cc
  ${_gRPC_ROOT}/src/core/tsi/ssl/session_cache/ssl_session_boringssl.cc
  ${_gRPC_ROOT}/src/core/tsi/ssl/session_cache/ssl_session_cache.cc
  ${_gRPC_ROOT}/src/core/tsi/ssl/session_cache/ssl_session_openssl.cc
  ${_gRPC_ROOT}/src/core/tsi/ssl_transport_security.cc
  ${_gRPC_ROOT}/src/core/tsi/transport_security_grpc.cc
  ${_gRPC_ROOT}/src/core/plugin_registry/grpc_cronet_plugin_registry.cc
)
android_add_library(grpc_cronet)


target_compile_definitions(grpc_cronet PRIVATE -DPB_FIELD_16BIT)
target_compile_definitions(grpc_cronet PUBLIC  -DGRPC_ALLOW_EXCEPTIONS=0)
target_compile_options(grpc_cronet PRIVATE $<$<COMPILE_LANGUAGE:C>:-std=c11>)
target_include_directories(grpc_cronet
  PUBLIC  ${_gRPC_ROOT}/include
  PRIVATE ${_gRPC_ROOT}
  PRIVATE ${_gRPC_SSL_INCLUDE_DIR}
  PRIVATE ${_gRPC_BENCHMARK_INCLUDE_DIR}
  PRIVATE ${_gRPC_CARES_INCLUDE_DIR}
  PRIVATE ${_gRPC_GFLAGS_INCLUDE_DIR}
  PRIVATE ${_gRPC_PROTOBUF_INCLUDE_DIR}
  PRIVATE ${_gRPC_NANOPB_INCLUDE_DIR}
  PRIVATE ${_gRPC_ADDRESS_SORTING_INCLUDE_DIR}
)

target_link_libraries(grpc_cronet PRIVATE
  ${_gRPC_BASELIB_LIBRARIES}
  ssl
  crypto
  zlib
  cares
  address_sorting
  ${_gRPC_ALLTARGETS_LIBRARIES}
  gpr
)




set(grpc_unsecure_src
  ${_gRPC_ROOT}/src/core/lib/surface/init.cc
  ${_gRPC_ROOT}/src/core/lib/surface/init_unsecure.cc
  ${_gRPC_ROOT}/src/core/lib/avl/avl.cc
  ${_gRPC_ROOT}/src/core/lib/backoff/backoff.cc
  ${_gRPC_ROOT}/src/core/lib/channel/channel_args.cc
  ${_gRPC_ROOT}/src/core/lib/channel/channel_stack.cc
  ${_gRPC_ROOT}/src/core/lib/channel/channel_stack_builder.cc
  ${_gRPC_ROOT}/src/core/lib/channel/channel_trace.cc
  ${_gRPC_ROOT}/src/core/lib/channel/channelz.cc
  ${_gRPC_ROOT}/src/core/lib/channel/channelz_registry.cc
  ${_gRPC_ROOT}/src/core/lib/channel/connected_channel.cc
  ${_gRPC_ROOT}/src/core/lib/channel/handshaker.cc
  ${_gRPC_ROOT}/src/core/lib/channel/handshaker_factory.cc
  ${_gRPC_ROOT}/src/core/lib/channel/handshaker_registry.cc
  ${_gRPC_ROOT}/src/core/lib/channel/status_util.cc
  ${_gRPC_ROOT}/src/core/lib/compression/compression.cc
  ${_gRPC_ROOT}/src/core/lib/compression/compression_internal.cc
  ${_gRPC_ROOT}/src/core/lib/compression/message_compress.cc
  ${_gRPC_ROOT}/src/core/lib/compression/stream_compression.cc
  ${_gRPC_ROOT}/src/core/lib/compression/stream_compression_gzip.cc
  ${_gRPC_ROOT}/src/core/lib/compression/stream_compression_identity.cc
  ${_gRPC_ROOT}/src/core/lib/debug/stats.cc
  ${_gRPC_ROOT}/src/core/lib/debug/stats_data.cc
  ${_gRPC_ROOT}/src/core/lib/http/format_request.cc
  ${_gRPC_ROOT}/src/core/lib/http/httpcli.cc
  ${_gRPC_ROOT}/src/core/lib/http/parser.cc
  ${_gRPC_ROOT}/src/core/lib/iomgr/buffer_list.cc
  ${_gRPC_ROOT}/src/core/lib/iomgr/call_combiner.cc
  ${_gRPC_ROOT}/src/core/lib/iomgr/combiner.cc
  ${_gRPC_ROOT}/src/core/lib/iomgr/endpoint.cc
  ${_gRPC_ROOT}/src/core/lib/iomgr/endpoint_pair_posix.cc
  ${_gRPC_ROOT}/src/core/lib/iomgr/endpoint_pair_uv.cc
  ${_gRPC_ROOT}/src/core/lib/iomgr/endpoint_pair_windows.cc
  ${_gRPC_ROOT}/src/core/lib/iomgr/error.cc
  ${_gRPC_ROOT}/src/core/lib/iomgr/ev_epoll1_linux.cc
  ${_gRPC_ROOT}/src/core/lib/iomgr/ev_epollex_linux.cc
  ${_gRPC_ROOT}/src/core/lib/iomgr/ev_epollsig_linux.cc
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
  ${_gRPC_ROOT}/src/core/lib/iomgr/internal_errqueue.cc
  ${_gRPC_ROOT}/src/core/lib/iomgr/iocp_windows.cc
  ${_gRPC_ROOT}/src/core/lib/iomgr/iomgr.cc
  ${_gRPC_ROOT}/src/core/lib/iomgr/iomgr_custom.cc
  ${_gRPC_ROOT}/src/core/lib/iomgr/iomgr_internal.cc
  ${_gRPC_ROOT}/src/core/lib/iomgr/iomgr_posix.cc
  ${_gRPC_ROOT}/src/core/lib/iomgr/iomgr_uv.cc
  ${_gRPC_ROOT}/src/core/lib/iomgr/iomgr_windows.cc
  ${_gRPC_ROOT}/src/core/lib/iomgr/is_epollexclusive_available.cc
  ${_gRPC_ROOT}/src/core/lib/iomgr/load_file.cc
  ${_gRPC_ROOT}/src/core/lib/iomgr/lockfree_event.cc
  ${_gRPC_ROOT}/src/core/lib/iomgr/network_status_tracker.cc
  ${_gRPC_ROOT}/src/core/lib/iomgr/polling_entity.cc
  ${_gRPC_ROOT}/src/core/lib/iomgr/pollset.cc
  ${_gRPC_ROOT}/src/core/lib/iomgr/pollset_custom.cc
  ${_gRPC_ROOT}/src/core/lib/iomgr/pollset_set.cc
  ${_gRPC_ROOT}/src/core/lib/iomgr/pollset_set_custom.cc
  ${_gRPC_ROOT}/src/core/lib/iomgr/pollset_set_windows.cc
  ${_gRPC_ROOT}/src/core/lib/iomgr/pollset_uv.cc
  ${_gRPC_ROOT}/src/core/lib/iomgr/pollset_windows.cc
  ${_gRPC_ROOT}/src/core/lib/iomgr/resolve_address.cc
  ${_gRPC_ROOT}/src/core/lib/iomgr/resolve_address_custom.cc
  ${_gRPC_ROOT}/src/core/lib/iomgr/resolve_address_posix.cc
  ${_gRPC_ROOT}/src/core/lib/iomgr/resolve_address_windows.cc
  ${_gRPC_ROOT}/src/core/lib/iomgr/resource_quota.cc
  ${_gRPC_ROOT}/src/core/lib/iomgr/sockaddr_utils.cc
  ${_gRPC_ROOT}/src/core/lib/iomgr/socket_factory_posix.cc
  ${_gRPC_ROOT}/src/core/lib/iomgr/socket_mutator.cc
  ${_gRPC_ROOT}/src/core/lib/iomgr/socket_utils_common_posix.cc
  ${_gRPC_ROOT}/src/core/lib/iomgr/socket_utils_linux.cc
  ${_gRPC_ROOT}/src/core/lib/iomgr/socket_utils_posix.cc
  ${_gRPC_ROOT}/src/core/lib/iomgr/socket_utils_uv.cc
  ${_gRPC_ROOT}/src/core/lib/iomgr/socket_utils_windows.cc
  ${_gRPC_ROOT}/src/core/lib/iomgr/socket_windows.cc
  ${_gRPC_ROOT}/src/core/lib/iomgr/tcp_client.cc
  ${_gRPC_ROOT}/src/core/lib/iomgr/tcp_client_custom.cc
  ${_gRPC_ROOT}/src/core/lib/iomgr/tcp_client_posix.cc
  ${_gRPC_ROOT}/src/core/lib/iomgr/tcp_client_windows.cc
  ${_gRPC_ROOT}/src/core/lib/iomgr/tcp_custom.cc
  ${_gRPC_ROOT}/src/core/lib/iomgr/tcp_posix.cc
  ${_gRPC_ROOT}/src/core/lib/iomgr/tcp_server.cc
  ${_gRPC_ROOT}/src/core/lib/iomgr/tcp_server_custom.cc
  ${_gRPC_ROOT}/src/core/lib/iomgr/tcp_server_posix.cc
  ${_gRPC_ROOT}/src/core/lib/iomgr/tcp_server_utils_posix_common.cc
  ${_gRPC_ROOT}/src/core/lib/iomgr/tcp_server_utils_posix_ifaddrs.cc
  ${_gRPC_ROOT}/src/core/lib/iomgr/tcp_server_utils_posix_noifaddrs.cc
  ${_gRPC_ROOT}/src/core/lib/iomgr/tcp_server_windows.cc
  ${_gRPC_ROOT}/src/core/lib/iomgr/tcp_uv.cc
  ${_gRPC_ROOT}/src/core/lib/iomgr/tcp_windows.cc
  ${_gRPC_ROOT}/src/core/lib/iomgr/time_averaged_stats.cc
  ${_gRPC_ROOT}/src/core/lib/iomgr/timer.cc
  ${_gRPC_ROOT}/src/core/lib/iomgr/timer_custom.cc
  ${_gRPC_ROOT}/src/core/lib/iomgr/timer_generic.cc
  ${_gRPC_ROOT}/src/core/lib/iomgr/timer_heap.cc
  ${_gRPC_ROOT}/src/core/lib/iomgr/timer_manager.cc
  ${_gRPC_ROOT}/src/core/lib/iomgr/timer_uv.cc
  ${_gRPC_ROOT}/src/core/lib/iomgr/udp_server.cc
  ${_gRPC_ROOT}/src/core/lib/iomgr/unix_sockets_posix.cc
  ${_gRPC_ROOT}/src/core/lib/iomgr/unix_sockets_posix_noop.cc
  ${_gRPC_ROOT}/src/core/lib/iomgr/wakeup_fd_cv.cc
  ${_gRPC_ROOT}/src/core/lib/iomgr/wakeup_fd_eventfd.cc
  ${_gRPC_ROOT}/src/core/lib/iomgr/wakeup_fd_nospecial.cc
  ${_gRPC_ROOT}/src/core/lib/iomgr/wakeup_fd_pipe.cc
  ${_gRPC_ROOT}/src/core/lib/iomgr/wakeup_fd_posix.cc
  ${_gRPC_ROOT}/src/core/lib/json/json.cc
  ${_gRPC_ROOT}/src/core/lib/json/json_reader.cc
  ${_gRPC_ROOT}/src/core/lib/json/json_string.cc
  ${_gRPC_ROOT}/src/core/lib/json/json_writer.cc
  ${_gRPC_ROOT}/src/core/lib/slice/b64.cc
  ${_gRPC_ROOT}/src/core/lib/slice/percent_encoding.cc
  ${_gRPC_ROOT}/src/core/lib/slice/slice.cc
  ${_gRPC_ROOT}/src/core/lib/slice/slice_buffer.cc
  ${_gRPC_ROOT}/src/core/lib/slice/slice_intern.cc
  ${_gRPC_ROOT}/src/core/lib/slice/slice_string_helpers.cc
  ${_gRPC_ROOT}/src/core/lib/surface/api_trace.cc
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
  ${_gRPC_ROOT}/src/core/lib/surface/lame_client.cc
  ${_gRPC_ROOT}/src/core/lib/surface/metadata_array.cc
  ${_gRPC_ROOT}/src/core/lib/surface/server.cc
  ${_gRPC_ROOT}/src/core/lib/surface/validate_metadata.cc
  ${_gRPC_ROOT}/src/core/lib/surface/version.cc
  ${_gRPC_ROOT}/src/core/lib/transport/bdp_estimator.cc
  ${_gRPC_ROOT}/src/core/lib/transport/byte_stream.cc
  ${_gRPC_ROOT}/src/core/lib/transport/connectivity_state.cc
  ${_gRPC_ROOT}/src/core/lib/transport/error_utils.cc
  ${_gRPC_ROOT}/src/core/lib/transport/metadata.cc
  ${_gRPC_ROOT}/src/core/lib/transport/metadata_batch.cc
  ${_gRPC_ROOT}/src/core/lib/transport/pid_controller.cc
  ${_gRPC_ROOT}/src/core/lib/transport/service_config.cc
  ${_gRPC_ROOT}/src/core/lib/transport/static_metadata.cc
  ${_gRPC_ROOT}/src/core/lib/transport/status_conversion.cc
  ${_gRPC_ROOT}/src/core/lib/transport/status_metadata.cc
  ${_gRPC_ROOT}/src/core/lib/transport/timeout_encoding.cc
  ${_gRPC_ROOT}/src/core/lib/transport/transport.cc
  ${_gRPC_ROOT}/src/core/lib/transport/transport_op_string.cc
  ${_gRPC_ROOT}/src/core/lib/debug/trace.cc
  ${_gRPC_ROOT}/src/core/ext/transport/chttp2/server/insecure/server_chttp2.cc
  ${_gRPC_ROOT}/src/core/ext/transport/chttp2/server/insecure/server_chttp2_posix.cc
  ${_gRPC_ROOT}/src/core/ext/transport/chttp2/transport/bin_decoder.cc
  ${_gRPC_ROOT}/src/core/ext/transport/chttp2/transport/bin_encoder.cc
  ${_gRPC_ROOT}/src/core/ext/transport/chttp2/transport/chttp2_plugin.cc
  ${_gRPC_ROOT}/src/core/ext/transport/chttp2/transport/chttp2_transport.cc
  ${_gRPC_ROOT}/src/core/ext/transport/chttp2/transport/flow_control.cc
  ${_gRPC_ROOT}/src/core/ext/transport/chttp2/transport/frame_data.cc
  ${_gRPC_ROOT}/src/core/ext/transport/chttp2/transport/frame_goaway.cc
  ${_gRPC_ROOT}/src/core/ext/transport/chttp2/transport/frame_ping.cc
  ${_gRPC_ROOT}/src/core/ext/transport/chttp2/transport/frame_rst_stream.cc
  ${_gRPC_ROOT}/src/core/ext/transport/chttp2/transport/frame_settings.cc
  ${_gRPC_ROOT}/src/core/ext/transport/chttp2/transport/frame_window_update.cc
  ${_gRPC_ROOT}/src/core/ext/transport/chttp2/transport/hpack_encoder.cc
  ${_gRPC_ROOT}/src/core/ext/transport/chttp2/transport/hpack_mapping.cc
  ${_gRPC_ROOT}/src/core/ext/transport/chttp2/transport/hpack_parser.cc
  ${_gRPC_ROOT}/src/core/ext/transport/chttp2/transport/hpack_table.cc
  ${_gRPC_ROOT}/src/core/ext/transport/chttp2/transport/http2_settings.cc
  ${_gRPC_ROOT}/src/core/ext/transport/chttp2/transport/huffsyms.cc
  ${_gRPC_ROOT}/src/core/ext/transport/chttp2/transport/incoming_metadata.cc
  ${_gRPC_ROOT}/src/core/ext/transport/chttp2/transport/parsing.cc
  ${_gRPC_ROOT}/src/core/ext/transport/chttp2/transport/stream_lists.cc
  ${_gRPC_ROOT}/src/core/ext/transport/chttp2/transport/stream_map.cc
  ${_gRPC_ROOT}/src/core/ext/transport/chttp2/transport/varint.cc
  ${_gRPC_ROOT}/src/core/ext/transport/chttp2/transport/writing.cc
  ${_gRPC_ROOT}/src/core/ext/transport/chttp2/alpn/alpn.cc
  ${_gRPC_ROOT}/src/core/ext/filters/http/client/http_client_filter.cc
  ${_gRPC_ROOT}/src/core/ext/filters/http/http_filters_plugin.cc
  ${_gRPC_ROOT}/src/core/ext/filters/http/message_compress/message_compress_filter.cc
  ${_gRPC_ROOT}/src/core/ext/filters/http/server/http_server_filter.cc
  ${_gRPC_ROOT}/src/core/ext/transport/chttp2/server/chttp2_server.cc
  ${_gRPC_ROOT}/src/core/ext/transport/chttp2/client/insecure/channel_create.cc
  ${_gRPC_ROOT}/src/core/ext/transport/chttp2/client/insecure/channel_create_posix.cc
  ${_gRPC_ROOT}/src/core/ext/transport/chttp2/client/authority.cc
  ${_gRPC_ROOT}/src/core/ext/transport/chttp2/client/chttp2_connector.cc
  ${_gRPC_ROOT}/src/core/ext/filters/client_channel/backup_poller.cc
  ${_gRPC_ROOT}/src/core/ext/filters/client_channel/channel_connectivity.cc
  ${_gRPC_ROOT}/src/core/ext/filters/client_channel/client_channel.cc
  ${_gRPC_ROOT}/src/core/ext/filters/client_channel/client_channel_channelz.cc
  ${_gRPC_ROOT}/src/core/ext/filters/client_channel/client_channel_factory.cc
  ${_gRPC_ROOT}/src/core/ext/filters/client_channel/client_channel_plugin.cc
  ${_gRPC_ROOT}/src/core/ext/filters/client_channel/connector.cc
  ${_gRPC_ROOT}/src/core/ext/filters/client_channel/http_connect_handshaker.cc
  ${_gRPC_ROOT}/src/core/ext/filters/client_channel/http_proxy.cc
  ${_gRPC_ROOT}/src/core/ext/filters/client_channel/lb_policy.cc
  ${_gRPC_ROOT}/src/core/ext/filters/client_channel/lb_policy_factory.cc
  ${_gRPC_ROOT}/src/core/ext/filters/client_channel/lb_policy_registry.cc
  ${_gRPC_ROOT}/src/core/ext/filters/client_channel/method_params.cc
  ${_gRPC_ROOT}/src/core/ext/filters/client_channel/parse_address.cc
  ${_gRPC_ROOT}/src/core/ext/filters/client_channel/proxy_mapper.cc
  ${_gRPC_ROOT}/src/core/ext/filters/client_channel/proxy_mapper_registry.cc
  ${_gRPC_ROOT}/src/core/ext/filters/client_channel/resolver.cc
  ${_gRPC_ROOT}/src/core/ext/filters/client_channel/resolver_registry.cc
  ${_gRPC_ROOT}/src/core/ext/filters/client_channel/retry_throttle.cc
  ${_gRPC_ROOT}/src/core/ext/filters/client_channel/subchannel.cc
  ${_gRPC_ROOT}/src/core/ext/filters/client_channel/subchannel_index.cc
  ${_gRPC_ROOT}/src/core/ext/filters/client_channel/uri_parser.cc
  ${_gRPC_ROOT}/src/core/ext/filters/deadline/deadline_filter.cc
  ${_gRPC_ROOT}/src/core/ext/transport/inproc/inproc_plugin.cc
  ${_gRPC_ROOT}/src/core/ext/transport/inproc/inproc_transport.cc
  ${_gRPC_ROOT}/src/core/ext/filters/client_channel/resolver/dns/c_ares/dns_resolver_ares.cc
  ${_gRPC_ROOT}/src/core/ext/filters/client_channel/resolver/dns/c_ares/grpc_ares_ev_driver.cc
  ${_gRPC_ROOT}/src/core/ext/filters/client_channel/resolver/dns/c_ares/grpc_ares_ev_driver_posix.cc
  ${_gRPC_ROOT}/src/core/ext/filters/client_channel/resolver/dns/c_ares/grpc_ares_ev_driver_windows.cc
  ${_gRPC_ROOT}/src/core/ext/filters/client_channel/resolver/dns/c_ares/grpc_ares_wrapper.cc
  ${_gRPC_ROOT}/src/core/ext/filters/client_channel/resolver/dns/c_ares/grpc_ares_wrapper_fallback.cc
  ${_gRPC_ROOT}/src/core/ext/filters/client_channel/resolver/dns/c_ares/grpc_ares_wrapper_posix.cc
  ${_gRPC_ROOT}/src/core/ext/filters/client_channel/resolver/dns/c_ares/grpc_ares_wrapper_windows.cc
  ${_gRPC_ROOT}/src/core/ext/filters/client_channel/resolver/dns/native/dns_resolver.cc
  ${_gRPC_ROOT}/src/core/ext/filters/client_channel/resolver/sockaddr/sockaddr_resolver.cc
  ${_gRPC_ROOT}/src/core/ext/filters/client_channel/resolver/fake/fake_resolver.cc
  ${_gRPC_ROOT}/src/core/ext/filters/client_channel/lb_policy/grpclb/client_load_reporting_filter.cc
  ${_gRPC_ROOT}/src/core/ext/filters/client_channel/lb_policy/grpclb/grpclb.cc
  ${_gRPC_ROOT}/src/core/ext/filters/client_channel/lb_policy/grpclb/grpclb_channel.cc
  ${_gRPC_ROOT}/src/core/ext/filters/client_channel/lb_policy/grpclb/grpclb_client_stats.cc
  ${_gRPC_ROOT}/src/core/ext/filters/client_channel/lb_policy/grpclb/load_balancer_api.cc
  ${_gRPC_ROOT}/src/core/ext/filters/client_channel/lb_policy/grpclb/proto/grpc/lb/v1/google/protobuf/duration.pb.c
  ${_gRPC_ROOT}/src/core/ext/filters/client_channel/lb_policy/grpclb/proto/grpc/lb/v1/google/protobuf/timestamp.pb.c
  ${_gRPC_ROOT}/src/core/ext/filters/client_channel/lb_policy/grpclb/proto/grpc/lb/v1/load_balancer.pb.c
  ${_gRPC_ROOT}/third_party/nanopb/pb_common.c
  ${_gRPC_ROOT}/third_party/nanopb/pb_decode.c
  ${_gRPC_ROOT}/third_party/nanopb/pb_encode.c
  ${_gRPC_ROOT}/src/core/ext/filters/client_channel/lb_policy/pick_first/pick_first.cc
  ${_gRPC_ROOT}/src/core/ext/filters/client_channel/lb_policy/round_robin/round_robin.cc
  ${_gRPC_ROOT}/src/core/ext/filters/census/grpc_context.cc
  ${_gRPC_ROOT}/src/core/ext/filters/max_age/max_age_filter.cc
  ${_gRPC_ROOT}/src/core/ext/filters/message_size/message_size_filter.cc
  ${_gRPC_ROOT}/src/core/ext/filters/http/client_authority_filter.cc
  ${_gRPC_ROOT}/src/core/ext/filters/workarounds/workaround_cronet_compression_filter.cc
  ${_gRPC_ROOT}/src/core/ext/filters/workarounds/workaround_utils.cc
  ${_gRPC_ROOT}/src/core/plugin_registry/grpc_unsecure_plugin_registry.cc
)
android_add_library(grpc_unsecure)


target_compile_definitions(grpc_unsecure PRIVATE -DPB_FIELD_16BIT)
target_compile_definitions(grpc_unsecure PUBLIC  -DGRPC_ALLOW_EXCEPTIONS=0)
target_compile_options(grpc_unsecure PRIVATE $<$<COMPILE_LANGUAGE:C>:-std=c11>)
target_include_directories(grpc_unsecure
  PUBLIC  ${_gRPC_ROOT}/include
  PRIVATE ${_gRPC_ROOT}
  PRIVATE ${_gRPC_SSL_INCLUDE_DIR}
  PRIVATE ${_gRPC_BENCHMARK_INCLUDE_DIR}
  PRIVATE ${_gRPC_CARES_INCLUDE_DIR}
  PRIVATE ${_gRPC_GFLAGS_INCLUDE_DIR}
  PRIVATE ${_gRPC_PROTOBUF_INCLUDE_DIR}
  PRIVATE ${_gRPC_NANOPB_INCLUDE_DIR}
  PRIVATE ${_gRPC_ADDRESS_SORTING_INCLUDE_DIR}
)

target_link_libraries(grpc_unsecure PRIVATE
  ${_gRPC_BASELIB_LIBRARIES}
  zlib
  cares
  address_sorting
  ${_gRPC_ALLTARGETS_LIBRARIES}
  gpr
)




set(grpc++_src
  ${_gRPC_ROOT}/src/cpp/client/insecure_credentials.cc
  ${_gRPC_ROOT}/src/cpp/client/secure_credentials.cc
  ${_gRPC_ROOT}/src/cpp/common/auth_property_iterator.cc
  ${_gRPC_ROOT}/src/cpp/common/secure_auth_context.cc
  ${_gRPC_ROOT}/src/cpp/common/secure_channel_arguments.cc
  ${_gRPC_ROOT}/src/cpp/common/secure_create_auth_context.cc
  ${_gRPC_ROOT}/src/cpp/server/insecure_server_credentials.cc
  ${_gRPC_ROOT}/src/cpp/server/secure_server_credentials.cc
  ${_gRPC_ROOT}/src/cpp/client/channel_cc.cc
  ${_gRPC_ROOT}/src/cpp/client/client_context.cc
  ${_gRPC_ROOT}/src/cpp/client/create_channel.cc
  ${_gRPC_ROOT}/src/cpp/client/create_channel_internal.cc
  ${_gRPC_ROOT}/src/cpp/client/create_channel_posix.cc
  ${_gRPC_ROOT}/src/cpp/client/credentials_cc.cc
  ${_gRPC_ROOT}/src/cpp/client/generic_stub.cc
  ${_gRPC_ROOT}/src/cpp/common/alarm.cc
  ${_gRPC_ROOT}/src/cpp/common/channel_arguments.cc
  ${_gRPC_ROOT}/src/cpp/common/channel_filter.cc
  ${_gRPC_ROOT}/src/cpp/common/completion_queue_cc.cc
  ${_gRPC_ROOT}/src/cpp/common/core_codegen.cc
  ${_gRPC_ROOT}/src/cpp/common/resource_quota_cc.cc
  ${_gRPC_ROOT}/src/cpp/common/rpc_method.cc
  ${_gRPC_ROOT}/src/cpp/common/version_cc.cc
  ${_gRPC_ROOT}/src/cpp/server/async_generic_service.cc
  ${_gRPC_ROOT}/src/cpp/server/channel_argument_option.cc
  ${_gRPC_ROOT}/src/cpp/server/create_default_thread_pool.cc
  ${_gRPC_ROOT}/src/cpp/server/dynamic_thread_pool.cc
  ${_gRPC_ROOT}/src/cpp/server/health/default_health_check_service.cc
  ${_gRPC_ROOT}/src/cpp/server/health/health.pb.c
  ${_gRPC_ROOT}/src/cpp/server/health/health_check_service.cc
  ${_gRPC_ROOT}/src/cpp/server/health/health_check_service_server_builder_option.cc
  ${_gRPC_ROOT}/src/cpp/server/server_builder.cc
  ${_gRPC_ROOT}/src/cpp/server/server_cc.cc
  ${_gRPC_ROOT}/src/cpp/server/server_context.cc
  ${_gRPC_ROOT}/src/cpp/server/server_credentials.cc
  ${_gRPC_ROOT}/src/cpp/server/server_posix.cc
  ${_gRPC_ROOT}/src/cpp/thread_manager/thread_manager.cc
  ${_gRPC_ROOT}/src/cpp/util/byte_buffer_cc.cc
  ${_gRPC_ROOT}/src/cpp/util/status.cc
  ${_gRPC_ROOT}/src/cpp/util/string_ref.cc
  ${_gRPC_ROOT}/src/cpp/util/time_cc.cc
  ${_gRPC_ROOT}/src/cpp/codegen/codegen_init.cc
)
android_add_library(grpc++)


target_compile_definitions(grpc++ PRIVATE -DPB_FIELD_16BIT)
target_compile_definitions(grpc++ PUBLIC  -DGRPC_ALLOW_EXCEPTIONS=0)
target_compile_options(grpc++ PRIVATE $<$<COMPILE_LANGUAGE:C>:-std=c11>)
target_include_directories(grpc++
  PUBLIC  ${_gRPC_ROOT}/include
  PRIVATE ${_gRPC_ROOT}
  PRIVATE ${_gRPC_SSL_INCLUDE_DIR}
  PRIVATE ${_gRPC_BENCHMARK_INCLUDE_DIR}
  PRIVATE ${_gRPC_CARES_INCLUDE_DIR}
  PRIVATE ${_gRPC_GFLAGS_INCLUDE_DIR}
  PRIVATE ${_gRPC_PROTOBUF_INCLUDE_DIR}
  PRIVATE ${_gRPC_NANOPB_INCLUDE_DIR}
  PRIVATE ${_gRPC_ADDRESS_SORTING_INCLUDE_DIR}
  PRIVATE ${_gRPC_PROTO_GENS_DIR}
)

target_link_libraries(grpc++ PRIVATE
  ${_gRPC_BASELIB_LIBRARIES}
  ssl
  crypto
  ${_gRPC_PROTOBUF_LIBRARIES}
  ${_gRPC_ALLTARGETS_LIBRARIES}
  grpc
  gpr
)




set(grpc++_cronet_src
  ${_gRPC_ROOT}/src/cpp/client/cronet_credentials.cc
  ${_gRPC_ROOT}/src/cpp/client/insecure_credentials.cc
  ${_gRPC_ROOT}/src/cpp/common/insecure_create_auth_context.cc
  ${_gRPC_ROOT}/src/cpp/server/insecure_server_credentials.cc
  ${_gRPC_ROOT}/src/cpp/client/channel_cc.cc
  ${_gRPC_ROOT}/src/cpp/client/client_context.cc
  ${_gRPC_ROOT}/src/cpp/client/create_channel.cc
  ${_gRPC_ROOT}/src/cpp/client/create_channel_internal.cc
  ${_gRPC_ROOT}/src/cpp/client/create_channel_posix.cc
  ${_gRPC_ROOT}/src/cpp/client/credentials_cc.cc
  ${_gRPC_ROOT}/src/cpp/client/generic_stub.cc
  ${_gRPC_ROOT}/src/cpp/common/alarm.cc
  ${_gRPC_ROOT}/src/cpp/common/channel_arguments.cc
  ${_gRPC_ROOT}/src/cpp/common/channel_filter.cc
  ${_gRPC_ROOT}/src/cpp/common/completion_queue_cc.cc
  ${_gRPC_ROOT}/src/cpp/common/core_codegen.cc
  ${_gRPC_ROOT}/src/cpp/common/resource_quota_cc.cc
  ${_gRPC_ROOT}/src/cpp/common/rpc_method.cc
  ${_gRPC_ROOT}/src/cpp/common/version_cc.cc
  ${_gRPC_ROOT}/src/cpp/server/async_generic_service.cc
  ${_gRPC_ROOT}/src/cpp/server/channel_argument_option.cc
  ${_gRPC_ROOT}/src/cpp/server/create_default_thread_pool.cc
  ${_gRPC_ROOT}/src/cpp/server/dynamic_thread_pool.cc
  ${_gRPC_ROOT}/src/cpp/server/health/default_health_check_service.cc
  ${_gRPC_ROOT}/src/cpp/server/health/health.pb.c
  ${_gRPC_ROOT}/src/cpp/server/health/health_check_service.cc
  ${_gRPC_ROOT}/src/cpp/server/health/health_check_service_server_builder_option.cc
  ${_gRPC_ROOT}/src/cpp/server/server_builder.cc
  ${_gRPC_ROOT}/src/cpp/server/server_cc.cc
  ${_gRPC_ROOT}/src/cpp/server/server_context.cc
  ${_gRPC_ROOT}/src/cpp/server/server_credentials.cc
  ${_gRPC_ROOT}/src/cpp/server/server_posix.cc
  ${_gRPC_ROOT}/src/cpp/thread_manager/thread_manager.cc
  ${_gRPC_ROOT}/src/cpp/util/byte_buffer_cc.cc
  ${_gRPC_ROOT}/src/cpp/util/status.cc
  ${_gRPC_ROOT}/src/cpp/util/string_ref.cc
  ${_gRPC_ROOT}/src/cpp/util/time_cc.cc
  ${_gRPC_ROOT}/src/cpp/codegen/codegen_init.cc
  ${_gRPC_ROOT}/src/core/ext/transport/chttp2/client/insecure/channel_create.cc
  ${_gRPC_ROOT}/src/core/ext/transport/chttp2/client/insecure/channel_create_posix.cc
  ${_gRPC_ROOT}/src/core/ext/transport/chttp2/client/authority.cc
  ${_gRPC_ROOT}/src/core/ext/transport/chttp2/client/chttp2_connector.cc
  ${_gRPC_ROOT}/src/core/ext/transport/chttp2/transport/bin_decoder.cc
  ${_gRPC_ROOT}/src/core/ext/transport/chttp2/transport/bin_encoder.cc
  ${_gRPC_ROOT}/src/core/ext/transport/chttp2/transport/chttp2_plugin.cc
  ${_gRPC_ROOT}/src/core/ext/transport/chttp2/transport/chttp2_transport.cc
  ${_gRPC_ROOT}/src/core/ext/transport/chttp2/transport/flow_control.cc
  ${_gRPC_ROOT}/src/core/ext/transport/chttp2/transport/frame_data.cc
  ${_gRPC_ROOT}/src/core/ext/transport/chttp2/transport/frame_goaway.cc
  ${_gRPC_ROOT}/src/core/ext/transport/chttp2/transport/frame_ping.cc
  ${_gRPC_ROOT}/src/core/ext/transport/chttp2/transport/frame_rst_stream.cc
  ${_gRPC_ROOT}/src/core/ext/transport/chttp2/transport/frame_settings.cc
  ${_gRPC_ROOT}/src/core/ext/transport/chttp2/transport/frame_window_update.cc
  ${_gRPC_ROOT}/src/core/ext/transport/chttp2/transport/hpack_encoder.cc
  ${_gRPC_ROOT}/src/core/ext/transport/chttp2/transport/hpack_mapping.cc
  ${_gRPC_ROOT}/src/core/ext/transport/chttp2/transport/hpack_parser.cc
  ${_gRPC_ROOT}/src/core/ext/transport/chttp2/transport/hpack_table.cc
  ${_gRPC_ROOT}/src/core/ext/transport/chttp2/transport/http2_settings.cc
  ${_gRPC_ROOT}/src/core/ext/transport/chttp2/transport/huffsyms.cc
  ${_gRPC_ROOT}/src/core/ext/transport/chttp2/transport/incoming_metadata.cc
  ${_gRPC_ROOT}/src/core/ext/transport/chttp2/transport/parsing.cc
  ${_gRPC_ROOT}/src/core/ext/transport/chttp2/transport/stream_lists.cc
  ${_gRPC_ROOT}/src/core/ext/transport/chttp2/transport/stream_map.cc
  ${_gRPC_ROOT}/src/core/ext/transport/chttp2/transport/varint.cc
  ${_gRPC_ROOT}/src/core/ext/transport/chttp2/transport/writing.cc
  ${_gRPC_ROOT}/src/core/lib/avl/avl.cc
  ${_gRPC_ROOT}/src/core/lib/backoff/backoff.cc
  ${_gRPC_ROOT}/src/core/lib/channel/channel_args.cc
  ${_gRPC_ROOT}/src/core/lib/channel/channel_stack.cc
  ${_gRPC_ROOT}/src/core/lib/channel/channel_stack_builder.cc
  ${_gRPC_ROOT}/src/core/lib/channel/channel_trace.cc
  ${_gRPC_ROOT}/src/core/lib/channel/channelz.cc
  ${_gRPC_ROOT}/src/core/lib/channel/channelz_registry.cc
  ${_gRPC_ROOT}/src/core/lib/channel/connected_channel.cc
  ${_gRPC_ROOT}/src/core/lib/channel/handshaker.cc
  ${_gRPC_ROOT}/src/core/lib/channel/handshaker_factory.cc
  ${_gRPC_ROOT}/src/core/lib/channel/handshaker_registry.cc
  ${_gRPC_ROOT}/src/core/lib/channel/status_util.cc
  ${_gRPC_ROOT}/src/core/lib/compression/compression.cc
  ${_gRPC_ROOT}/src/core/lib/compression/compression_internal.cc
  ${_gRPC_ROOT}/src/core/lib/compression/message_compress.cc
  ${_gRPC_ROOT}/src/core/lib/compression/stream_compression.cc
  ${_gRPC_ROOT}/src/core/lib/compression/stream_compression_gzip.cc
  ${_gRPC_ROOT}/src/core/lib/compression/stream_compression_identity.cc
  ${_gRPC_ROOT}/src/core/lib/debug/stats.cc
  ${_gRPC_ROOT}/src/core/lib/debug/stats_data.cc
  ${_gRPC_ROOT}/src/core/lib/http/format_request.cc
  ${_gRPC_ROOT}/src/core/lib/http/httpcli.cc
  ${_gRPC_ROOT}/src/core/lib/http/parser.cc
  ${_gRPC_ROOT}/src/core/lib/iomgr/buffer_list.cc
  ${_gRPC_ROOT}/src/core/lib/iomgr/call_combiner.cc
  ${_gRPC_ROOT}/src/core/lib/iomgr/combiner.cc
  ${_gRPC_ROOT}/src/core/lib/iomgr/endpoint.cc
  ${_gRPC_ROOT}/src/core/lib/iomgr/endpoint_pair_posix.cc
  ${_gRPC_ROOT}/src/core/lib/iomgr/endpoint_pair_uv.cc
  ${_gRPC_ROOT}/src/core/lib/iomgr/endpoint_pair_windows.cc
  ${_gRPC_ROOT}/src/core/lib/iomgr/error.cc
  ${_gRPC_ROOT}/src/core/lib/iomgr/ev_epoll1_linux.cc
  ${_gRPC_ROOT}/src/core/lib/iomgr/ev_epollex_linux.cc
  ${_gRPC_ROOT}/src/core/lib/iomgr/ev_epollsig_linux.cc
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
  ${_gRPC_ROOT}/src/core/lib/iomgr/internal_errqueue.cc
  ${_gRPC_ROOT}/src/core/lib/iomgr/iocp_windows.cc
  ${_gRPC_ROOT}/src/core/lib/iomgr/iomgr.cc
  ${_gRPC_ROOT}/src/core/lib/iomgr/iomgr_custom.cc
  ${_gRPC_ROOT}/src/core/lib/iomgr/iomgr_internal.cc
  ${_gRPC_ROOT}/src/core/lib/iomgr/iomgr_posix.cc
  ${_gRPC_ROOT}/src/core/lib/iomgr/iomgr_uv.cc
  ${_gRPC_ROOT}/src/core/lib/iomgr/iomgr_windows.cc
  ${_gRPC_ROOT}/src/core/lib/iomgr/is_epollexclusive_available.cc
  ${_gRPC_ROOT}/src/core/lib/iomgr/load_file.cc
  ${_gRPC_ROOT}/src/core/lib/iomgr/lockfree_event.cc
  ${_gRPC_ROOT}/src/core/lib/iomgr/network_status_tracker.cc
  ${_gRPC_ROOT}/src/core/lib/iomgr/polling_entity.cc
  ${_gRPC_ROOT}/src/core/lib/iomgr/pollset.cc
  ${_gRPC_ROOT}/src/core/lib/iomgr/pollset_custom.cc
  ${_gRPC_ROOT}/src/core/lib/iomgr/pollset_set.cc
  ${_gRPC_ROOT}/src/core/lib/iomgr/pollset_set_custom.cc
  ${_gRPC_ROOT}/src/core/lib/iomgr/pollset_set_windows.cc
  ${_gRPC_ROOT}/src/core/lib/iomgr/pollset_uv.cc
  ${_gRPC_ROOT}/src/core/lib/iomgr/pollset_windows.cc
  ${_gRPC_ROOT}/src/core/lib/iomgr/resolve_address.cc
  ${_gRPC_ROOT}/src/core/lib/iomgr/resolve_address_custom.cc
  ${_gRPC_ROOT}/src/core/lib/iomgr/resolve_address_posix.cc
  ${_gRPC_ROOT}/src/core/lib/iomgr/resolve_address_windows.cc
  ${_gRPC_ROOT}/src/core/lib/iomgr/resource_quota.cc
  ${_gRPC_ROOT}/src/core/lib/iomgr/sockaddr_utils.cc
  ${_gRPC_ROOT}/src/core/lib/iomgr/socket_factory_posix.cc
  ${_gRPC_ROOT}/src/core/lib/iomgr/socket_mutator.cc
  ${_gRPC_ROOT}/src/core/lib/iomgr/socket_utils_common_posix.cc
  ${_gRPC_ROOT}/src/core/lib/iomgr/socket_utils_linux.cc
  ${_gRPC_ROOT}/src/core/lib/iomgr/socket_utils_posix.cc
  ${_gRPC_ROOT}/src/core/lib/iomgr/socket_utils_uv.cc
  ${_gRPC_ROOT}/src/core/lib/iomgr/socket_utils_windows.cc
  ${_gRPC_ROOT}/src/core/lib/iomgr/socket_windows.cc
  ${_gRPC_ROOT}/src/core/lib/iomgr/tcp_client.cc
  ${_gRPC_ROOT}/src/core/lib/iomgr/tcp_client_custom.cc
  ${_gRPC_ROOT}/src/core/lib/iomgr/tcp_client_posix.cc
  ${_gRPC_ROOT}/src/core/lib/iomgr/tcp_client_windows.cc
  ${_gRPC_ROOT}/src/core/lib/iomgr/tcp_custom.cc
  ${_gRPC_ROOT}/src/core/lib/iomgr/tcp_posix.cc
  ${_gRPC_ROOT}/src/core/lib/iomgr/tcp_server.cc
  ${_gRPC_ROOT}/src/core/lib/iomgr/tcp_server_custom.cc
  ${_gRPC_ROOT}/src/core/lib/iomgr/tcp_server_posix.cc
  ${_gRPC_ROOT}/src/core/lib/iomgr/tcp_server_utils_posix_common.cc
  ${_gRPC_ROOT}/src/core/lib/iomgr/tcp_server_utils_posix_ifaddrs.cc
  ${_gRPC_ROOT}/src/core/lib/iomgr/tcp_server_utils_posix_noifaddrs.cc
  ${_gRPC_ROOT}/src/core/lib/iomgr/tcp_server_windows.cc
  ${_gRPC_ROOT}/src/core/lib/iomgr/tcp_uv.cc
  ${_gRPC_ROOT}/src/core/lib/iomgr/tcp_windows.cc
  ${_gRPC_ROOT}/src/core/lib/iomgr/time_averaged_stats.cc
  ${_gRPC_ROOT}/src/core/lib/iomgr/timer.cc
  ${_gRPC_ROOT}/src/core/lib/iomgr/timer_custom.cc
  ${_gRPC_ROOT}/src/core/lib/iomgr/timer_generic.cc
  ${_gRPC_ROOT}/src/core/lib/iomgr/timer_heap.cc
  ${_gRPC_ROOT}/src/core/lib/iomgr/timer_manager.cc
  ${_gRPC_ROOT}/src/core/lib/iomgr/timer_uv.cc
  ${_gRPC_ROOT}/src/core/lib/iomgr/udp_server.cc
  ${_gRPC_ROOT}/src/core/lib/iomgr/unix_sockets_posix.cc
  ${_gRPC_ROOT}/src/core/lib/iomgr/unix_sockets_posix_noop.cc
  ${_gRPC_ROOT}/src/core/lib/iomgr/wakeup_fd_cv.cc
  ${_gRPC_ROOT}/src/core/lib/iomgr/wakeup_fd_eventfd.cc
  ${_gRPC_ROOT}/src/core/lib/iomgr/wakeup_fd_nospecial.cc
  ${_gRPC_ROOT}/src/core/lib/iomgr/wakeup_fd_pipe.cc
  ${_gRPC_ROOT}/src/core/lib/iomgr/wakeup_fd_posix.cc
  ${_gRPC_ROOT}/src/core/lib/json/json.cc
  ${_gRPC_ROOT}/src/core/lib/json/json_reader.cc
  ${_gRPC_ROOT}/src/core/lib/json/json_string.cc
  ${_gRPC_ROOT}/src/core/lib/json/json_writer.cc
  ${_gRPC_ROOT}/src/core/lib/slice/b64.cc
  ${_gRPC_ROOT}/src/core/lib/slice/percent_encoding.cc
  ${_gRPC_ROOT}/src/core/lib/slice/slice.cc
  ${_gRPC_ROOT}/src/core/lib/slice/slice_buffer.cc
  ${_gRPC_ROOT}/src/core/lib/slice/slice_intern.cc
  ${_gRPC_ROOT}/src/core/lib/slice/slice_string_helpers.cc
  ${_gRPC_ROOT}/src/core/lib/surface/api_trace.cc
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
  ${_gRPC_ROOT}/src/core/lib/surface/lame_client.cc
  ${_gRPC_ROOT}/src/core/lib/surface/metadata_array.cc
  ${_gRPC_ROOT}/src/core/lib/surface/server.cc
  ${_gRPC_ROOT}/src/core/lib/surface/validate_metadata.cc
  ${_gRPC_ROOT}/src/core/lib/surface/version.cc
  ${_gRPC_ROOT}/src/core/lib/transport/bdp_estimator.cc
  ${_gRPC_ROOT}/src/core/lib/transport/byte_stream.cc
  ${_gRPC_ROOT}/src/core/lib/transport/connectivity_state.cc
  ${_gRPC_ROOT}/src/core/lib/transport/error_utils.cc
  ${_gRPC_ROOT}/src/core/lib/transport/metadata.cc
  ${_gRPC_ROOT}/src/core/lib/transport/metadata_batch.cc
  ${_gRPC_ROOT}/src/core/lib/transport/pid_controller.cc
  ${_gRPC_ROOT}/src/core/lib/transport/service_config.cc
  ${_gRPC_ROOT}/src/core/lib/transport/static_metadata.cc
  ${_gRPC_ROOT}/src/core/lib/transport/status_conversion.cc
  ${_gRPC_ROOT}/src/core/lib/transport/status_metadata.cc
  ${_gRPC_ROOT}/src/core/lib/transport/timeout_encoding.cc
  ${_gRPC_ROOT}/src/core/lib/transport/transport.cc
  ${_gRPC_ROOT}/src/core/lib/transport/transport_op_string.cc
  ${_gRPC_ROOT}/src/core/lib/debug/trace.cc
  ${_gRPC_ROOT}/src/core/ext/transport/chttp2/alpn/alpn.cc
  ${_gRPC_ROOT}/src/core/ext/filters/http/client/http_client_filter.cc
  ${_gRPC_ROOT}/src/core/ext/filters/http/http_filters_plugin.cc
  ${_gRPC_ROOT}/src/core/ext/filters/http/message_compress/message_compress_filter.cc
  ${_gRPC_ROOT}/src/core/ext/filters/http/server/http_server_filter.cc
  ${_gRPC_ROOT}/src/core/ext/filters/client_channel/backup_poller.cc
  ${_gRPC_ROOT}/src/core/ext/filters/client_channel/channel_connectivity.cc
  ${_gRPC_ROOT}/src/core/ext/filters/client_channel/client_channel.cc
  ${_gRPC_ROOT}/src/core/ext/filters/client_channel/client_channel_channelz.cc
  ${_gRPC_ROOT}/src/core/ext/filters/client_channel/client_channel_factory.cc
  ${_gRPC_ROOT}/src/core/ext/filters/client_channel/client_channel_plugin.cc
  ${_gRPC_ROOT}/src/core/ext/filters/client_channel/connector.cc
  ${_gRPC_ROOT}/src/core/ext/filters/client_channel/http_connect_handshaker.cc
  ${_gRPC_ROOT}/src/core/ext/filters/client_channel/http_proxy.cc
  ${_gRPC_ROOT}/src/core/ext/filters/client_channel/lb_policy.cc
  ${_gRPC_ROOT}/src/core/ext/filters/client_channel/lb_policy_factory.cc
  ${_gRPC_ROOT}/src/core/ext/filters/client_channel/lb_policy_registry.cc
  ${_gRPC_ROOT}/src/core/ext/filters/client_channel/method_params.cc
  ${_gRPC_ROOT}/src/core/ext/filters/client_channel/parse_address.cc
  ${_gRPC_ROOT}/src/core/ext/filters/client_channel/proxy_mapper.cc
  ${_gRPC_ROOT}/src/core/ext/filters/client_channel/proxy_mapper_registry.cc
  ${_gRPC_ROOT}/src/core/ext/filters/client_channel/resolver.cc
  ${_gRPC_ROOT}/src/core/ext/filters/client_channel/resolver_registry.cc
  ${_gRPC_ROOT}/src/core/ext/filters/client_channel/retry_throttle.cc
  ${_gRPC_ROOT}/src/core/ext/filters/client_channel/subchannel.cc
  ${_gRPC_ROOT}/src/core/ext/filters/client_channel/subchannel_index.cc
  ${_gRPC_ROOT}/src/core/ext/filters/client_channel/uri_parser.cc
  ${_gRPC_ROOT}/src/core/ext/filters/deadline/deadline_filter.cc
  ${_gRPC_ROOT}/src/core/ext/transport/chttp2/server/insecure/server_chttp2.cc
  ${_gRPC_ROOT}/src/core/ext/transport/chttp2/server/insecure/server_chttp2_posix.cc
  ${_gRPC_ROOT}/src/core/ext/transport/chttp2/server/chttp2_server.cc
  ${_gRPC_ROOT}/src/core/ext/filters/census/grpc_context.cc
)
android_add_library(grpc++_cronet)


target_compile_definitions(grpc++_cronet PRIVATE -DPB_FIELD_16BIT)
target_compile_definitions(grpc++_cronet PUBLIC  -DGRPC_ALLOW_EXCEPTIONS=0)
target_compile_options(grpc++_cronet PRIVATE $<$<COMPILE_LANGUAGE:C>:-std=c11>)
target_include_directories(grpc++_cronet
  PUBLIC  ${_gRPC_ROOT}/include
  PRIVATE ${_gRPC_ROOT}
  PRIVATE ${_gRPC_SSL_INCLUDE_DIR}
  PRIVATE ${_gRPC_BENCHMARK_INCLUDE_DIR}
  PRIVATE ${_gRPC_CARES_INCLUDE_DIR}
  PRIVATE ${_gRPC_GFLAGS_INCLUDE_DIR}
  PRIVATE ${_gRPC_PROTOBUF_INCLUDE_DIR}
  PRIVATE ${_gRPC_NANOPB_INCLUDE_DIR}
  PRIVATE ${_gRPC_ADDRESS_SORTING_INCLUDE_DIR}
  PRIVATE ${_gRPC_PROTO_GENS_DIR}
)

target_link_libraries(grpc++_cronet PRIVATE
  ${_gRPC_BASELIB_LIBRARIES}
  ssl
  crypto
  ${_gRPC_PROTOBUF_LIBRARIES}
  ${_gRPC_ALLTARGETS_LIBRARIES}
  gpr
  grpc_cronet
  grpc
)








set(grpc++_unsecure_src
  ${_gRPC_ROOT}/src/cpp/client/insecure_credentials.cc
  ${_gRPC_ROOT}/src/cpp/common/insecure_create_auth_context.cc
  ${_gRPC_ROOT}/src/cpp/server/insecure_server_credentials.cc
  ${_gRPC_ROOT}/src/cpp/client/channel_cc.cc
  ${_gRPC_ROOT}/src/cpp/client/client_context.cc
  ${_gRPC_ROOT}/src/cpp/client/create_channel.cc
  ${_gRPC_ROOT}/src/cpp/client/create_channel_internal.cc
  ${_gRPC_ROOT}/src/cpp/client/create_channel_posix.cc
  ${_gRPC_ROOT}/src/cpp/client/credentials_cc.cc
  ${_gRPC_ROOT}/src/cpp/client/generic_stub.cc
  ${_gRPC_ROOT}/src/cpp/common/alarm.cc
  ${_gRPC_ROOT}/src/cpp/common/channel_arguments.cc
  ${_gRPC_ROOT}/src/cpp/common/channel_filter.cc
  ${_gRPC_ROOT}/src/cpp/common/completion_queue_cc.cc
  ${_gRPC_ROOT}/src/cpp/common/core_codegen.cc
  ${_gRPC_ROOT}/src/cpp/common/resource_quota_cc.cc
  ${_gRPC_ROOT}/src/cpp/common/rpc_method.cc
  ${_gRPC_ROOT}/src/cpp/common/version_cc.cc
  ${_gRPC_ROOT}/src/cpp/server/async_generic_service.cc
  ${_gRPC_ROOT}/src/cpp/server/channel_argument_option.cc
  ${_gRPC_ROOT}/src/cpp/server/create_default_thread_pool.cc
  ${_gRPC_ROOT}/src/cpp/server/dynamic_thread_pool.cc
  ${_gRPC_ROOT}/src/cpp/server/health/default_health_check_service.cc
  ${_gRPC_ROOT}/src/cpp/server/health/health.pb.c
  ${_gRPC_ROOT}/src/cpp/server/health/health_check_service.cc
  ${_gRPC_ROOT}/src/cpp/server/health/health_check_service_server_builder_option.cc
  ${_gRPC_ROOT}/src/cpp/server/server_builder.cc
  ${_gRPC_ROOT}/src/cpp/server/server_cc.cc
  ${_gRPC_ROOT}/src/cpp/server/server_context.cc
  ${_gRPC_ROOT}/src/cpp/server/server_credentials.cc
  ${_gRPC_ROOT}/src/cpp/server/server_posix.cc
  ${_gRPC_ROOT}/src/cpp/thread_manager/thread_manager.cc
  ${_gRPC_ROOT}/src/cpp/util/byte_buffer_cc.cc
  ${_gRPC_ROOT}/src/cpp/util/status.cc
  ${_gRPC_ROOT}/src/cpp/util/string_ref.cc
  ${_gRPC_ROOT}/src/cpp/util/time_cc.cc
  ${_gRPC_ROOT}/src/cpp/codegen/codegen_init.cc
)
android_add_library(grpc++_unsecure)


target_compile_definitions(grpc++_unsecure PRIVATE -DPB_FIELD_16BIT)
target_compile_definitions(grpc++_unsecure PUBLIC  -DGRPC_ALLOW_EXCEPTIONS=0)
target_compile_options(grpc++_unsecure PRIVATE $<$<COMPILE_LANGUAGE:C>:-std=c11>)
target_include_directories(grpc++_unsecure
  PUBLIC  ${_gRPC_ROOT}/include
  PRIVATE ${_gRPC_ROOT}
  PRIVATE ${_gRPC_SSL_INCLUDE_DIR}
  PRIVATE ${_gRPC_BENCHMARK_INCLUDE_DIR}
  PRIVATE ${_gRPC_CARES_INCLUDE_DIR}
  PRIVATE ${_gRPC_GFLAGS_INCLUDE_DIR}
  PRIVATE ${_gRPC_PROTOBUF_INCLUDE_DIR}
  PRIVATE ${_gRPC_NANOPB_INCLUDE_DIR}
  PRIVATE ${_gRPC_ADDRESS_SORTING_INCLUDE_DIR}
  PRIVATE ${_gRPC_PROTO_GENS_DIR}
)

target_link_libraries(grpc++_unsecure PRIVATE
  ${_gRPC_BASELIB_LIBRARIES}
  ${_gRPC_PROTOBUF_LIBRARIES}
  ${_gRPC_ALLTARGETS_LIBRARIES}
  gpr
  grpc_unsecure
)









if (gRPC_BUILD_TESTS)
  add_subdirectory(tests)
endif (gRPC_BUILD_TESTS)
