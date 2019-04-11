# THIS FILE IS FOR USE BY THE ANDROID EMULATOR CMAKE BUILD
# THIS WILL ONLY BUILD THE TESTS
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

set(gRPC_BUILD_CODEGEN ${gRPC_BUILD_TESTS})

  include(ExternalProject)
  # Get the required test libs from somewhere else
  message(WARNING "Including EXTERNAL project google benchmark & google flags")
  ExternalProject_Add(project_benchmark
          GIT_REPOSITORY https://github.com/google/benchmark.git
          GIT_TAG 5b7683f # Version used by grpc v1.16
          PREFIX ${CMAKE_CURRENT_BINARY_DIR}/external/tmp/benchmark
          INSTALL_DIR ${CMAKE_CURRENT_BINARY_DIR}/external
          BUILD_BYPRODUCTS ${CMAKE_CURRENT_BINARY_DIR}/external/lib/${CMAKE_STATIC_LIBRARY_PREFIX}benchmark${CMAKE_STATIC_LIBRARY_SUFFIX}
          CMAKE_ARGS
          -DHAVE_STD_REGEX=TRUE
          -DCMAKE_INSTALL_PREFIX=${CMAKE_CURRENT_BINARY_DIR}/external
          -DCMAKE_TOOLCHAIN_FILE=${ANDROID_QEMU2_TOP_DIR}/android/build/cmake/toolchain-${ANDROID_HOST_TAG}.cmake
          -DCMAKE_BUILD_TYPE=${CMAKE_BUILD_TYPE}
          )
  ExternalProject_Get_Property(project_benchmark install_dir)
  add_library(google_benchmark STATIC IMPORTED GLOBAL)
  set_property(TARGET google_benchmark PROPERTY IMPORTED_LOCATION ${install_dir}/lib/${CMAKE_STATIC_LIBRARY_PREFIX}benchmark${CMAKE_STATIC_LIBRARY_SUFFIX})

  set(_gRPC_BENCHMARK_LIBRARIES google_benchmark)
  set(_gRPC_BENCHMARK_INCLUDE_DIR ${install_dir}/include)

  ExternalProject_Add(project_gflags
          GIT_REPOSITORY https://github.com/gflags/gflags.git
          GIT_TAG 30dbc81 # Version used by grpc v1.16
          PREFIX ${CMAKE_CURRENT_BINARY_DIR}/external/tmp/gflags
          INSTALL_DIR ${CMAKE_CURRENT_BINARY_DIR}/external
          BUILD_BYPRODUCTS ${CMAKE_CURRENT_BINARY_DIR}/external/lib/${CMAKE_STATIC_LIBRARY_PREFIX}gflags${CMAKE_STATIC_LIBRARY_SUFFIX}
          CMAKE_ARGS
          -DCMAKE_INSTALL_PREFIX=${CMAKE_CURRENT_BINARY_DIR}/external
          -DCMAKE_TOOLCHAIN_FILE=${ANDROID_QEMU2_TOP_DIR}/android/build/cmake/toolchain-${ANDROID_HOST_TAG}.cmake
          -DCMAKE_BUILD_TYPE=${CMAKE_BUILD_TYPE}
          )
  ExternalProject_Get_Property(project_gflags install_dir)
  add_library(google_gflags STATIC IMPORTED GLOBAL)
  set_property(TARGET google_gflags PROPERTY IMPORTED_LOCATION ${install_dir}/lib/${CMAKE_STATIC_LIBRARY_PREFIX}gflags${CMAKE_STATIC_LIBRARY_SUFFIX})

  set(_gRPC_GFLAGS_LIBRARIES google_gflags)
  set(_gRPC_GFLAGS_INCLUDE_DIR ${install_dir}/include)

if(NOT TARGET gmock_main)
  message(STATUS "Including google test")
  add_subdirectory(${ANDROID_QEMU2_TOP_DIR}/../googletest googletest)
  # Okay, google test is not happy under msvc
  android_target_compile_definitions(gmock_main windows_msvc-x86_64 PUBLIC
          -DGTEST_INCLUDE_GTEST_INTERNAL_CUSTOM_GTEST_H_)
  android_target_compile_definitions(gmock windows_msvc-x86_64 PUBLIC -DGTEST_INCLUDE_GTEST_INTERNAL_CUSTOM_GTEST_H_)
  android_target_compile_definitions(gtest windows_msvc-x86_64 PUBLIC -DGTEST_INCLUDE_GTEST_INTERNAL_CUSTOM_GTEST_H_)
  enable_testing()
endif()

set(CMAKE_LIBRARY_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/lib64)
set(CMAKE_RUNTIME_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR})
set(CMAKE_ARCHIVE_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/archives)

set(alts_test_util_src
  ${_gRPC_ROOT}/test/core/tsi/alts/crypt/gsec_test_util.cc
  ${_gRPC_ROOT}/test/core/tsi/alts/handshaker/alts_handshaker_service_api_test_lib.cc
)
android_add_library(alts_test_util)


target_compile_definitions(alts_test_util PRIVATE -DPB_FIELD_16BIT)
target_compile_definitions(alts_test_util PUBLIC  -DGRPC_ALLOW_EXCEPTIONS=0)
target_include_directories(alts_test_util
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

target_link_libraries(alts_test_util PRIVATE
  ssl
  crypto
  ${_gRPC_ALLTARGETS_LIBRARIES}
  grpc
)

add_dependencies(alts_test_util project_benchmark project_gflags)

set(gpr_test_util_src
  ${_gRPC_ROOT}/test/core/util/test_config.cc
)
android_add_library(gpr_test_util)


target_compile_definitions(gpr_test_util PRIVATE -DPB_FIELD_16BIT)
target_compile_definitions(gpr_test_util PUBLIC  -DGRPC_ALLOW_EXCEPTIONS=0)
target_include_directories(gpr_test_util
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

target_link_libraries(gpr_test_util PRIVATE
  ${_gRPC_ALLTARGETS_LIBRARIES}
  gpr
)

add_dependencies(gpr_test_util project_benchmark project_gflags)

set(grpc_test_util_src
  ${_gRPC_ROOT}/test/core/end2end/data/client_certs.cc
  ${_gRPC_ROOT}/test/core/end2end/data/server1_cert.cc
  ${_gRPC_ROOT}/test/core/end2end/data/server1_key.cc
  ${_gRPC_ROOT}/test/core/end2end/data/test_root_cert.cc
  ${_gRPC_ROOT}/test/core/security/oauth2_utils.cc
  ${_gRPC_ROOT}/src/core/ext/filters/client_channel/resolver/fake/fake_resolver.cc
  ${_gRPC_ROOT}/test/core/end2end/cq_verifier.cc
  ${_gRPC_ROOT}/test/core/end2end/fixtures/http_proxy_fixture.cc
  ${_gRPC_ROOT}/test/core/end2end/fixtures/proxy.cc
  ${_gRPC_ROOT}/test/core/iomgr/endpoint_tests.cc
  ${_gRPC_ROOT}/test/core/util/debugger_macros.cc
  ${_gRPC_ROOT}/test/core/util/fuzzer_util.cc
  ${_gRPC_ROOT}/test/core/util/grpc_profiler.cc
  ${_gRPC_ROOT}/test/core/util/histogram.cc
  ${_gRPC_ROOT}/test/core/util/memory_counters.cc
  ${_gRPC_ROOT}/test/core/util/mock_endpoint.cc
  ${_gRPC_ROOT}/test/core/util/parse_hexstring.cc
  ${_gRPC_ROOT}/test/core/util/passthru_endpoint.cc
  ${_gRPC_ROOT}/test/core/util/port.cc
  ${_gRPC_ROOT}/test/core/util/port_isolated_runtime_environment.cc
  ${_gRPC_ROOT}/test/core/util/port_server_client.cc
  ${_gRPC_ROOT}/test/core/util/slice_splitter.cc
  ${_gRPC_ROOT}/test/core/util/subprocess_posix.cc
  ${_gRPC_ROOT}/test/core/util/subprocess_windows.cc
  ${_gRPC_ROOT}/test/core/util/tracer_util.cc
  ${_gRPC_ROOT}/test/core/util/trickle_endpoint.cc
  ${_gRPC_ROOT}/test/core/util/cmdline.cc
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
)
android_add_library(grpc_test_util)


target_compile_definitions(grpc_test_util PRIVATE -DPB_FIELD_16BIT)
target_compile_definitions(grpc_test_util PUBLIC  -DGRPC_ALLOW_EXCEPTIONS=0)
target_include_directories(grpc_test_util
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

target_link_libraries(grpc_test_util PRIVATE
  ${_gRPC_ALLTARGETS_LIBRARIES}
  gpr_test_util
  gpr
  grpc
)

add_dependencies(grpc_test_util project_benchmark project_gflags)

set(grpc_test_util_unsecure_src
  ${_gRPC_ROOT}/src/core/ext/filters/client_channel/resolver/fake/fake_resolver.cc
  ${_gRPC_ROOT}/test/core/end2end/cq_verifier.cc
  ${_gRPC_ROOT}/test/core/end2end/fixtures/http_proxy_fixture.cc
  ${_gRPC_ROOT}/test/core/end2end/fixtures/proxy.cc
  ${_gRPC_ROOT}/test/core/iomgr/endpoint_tests.cc
  ${_gRPC_ROOT}/test/core/util/debugger_macros.cc
  ${_gRPC_ROOT}/test/core/util/fuzzer_util.cc
  ${_gRPC_ROOT}/test/core/util/grpc_profiler.cc
  ${_gRPC_ROOT}/test/core/util/histogram.cc
  ${_gRPC_ROOT}/test/core/util/memory_counters.cc
  ${_gRPC_ROOT}/test/core/util/mock_endpoint.cc
  ${_gRPC_ROOT}/test/core/util/parse_hexstring.cc
  ${_gRPC_ROOT}/test/core/util/passthru_endpoint.cc
  ${_gRPC_ROOT}/test/core/util/port.cc
  ${_gRPC_ROOT}/test/core/util/port_isolated_runtime_environment.cc
  ${_gRPC_ROOT}/test/core/util/port_server_client.cc
  ${_gRPC_ROOT}/test/core/util/slice_splitter.cc
  ${_gRPC_ROOT}/test/core/util/subprocess_posix.cc
  ${_gRPC_ROOT}/test/core/util/subprocess_windows.cc
  ${_gRPC_ROOT}/test/core/util/tracer_util.cc
  ${_gRPC_ROOT}/test/core/util/trickle_endpoint.cc
  ${_gRPC_ROOT}/test/core/util/cmdline.cc
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
)
android_add_library(grpc_test_util_unsecure)


target_compile_definitions(grpc_test_util_unsecure PRIVATE -DPB_FIELD_16BIT)
target_compile_definitions(grpc_test_util_unsecure PUBLIC  -DGRPC_ALLOW_EXCEPTIONS=0)
target_include_directories(grpc_test_util_unsecure
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

target_link_libraries(grpc_test_util_unsecure PRIVATE
  ${_gRPC_ALLTARGETS_LIBRARIES}
  gpr
  gpr_test_util
  grpc_unsecure
)

add_dependencies(grpc_test_util_unsecure project_benchmark project_gflags)

set(reconnect_server_src
  ${_gRPC_ROOT}/test/core/util/reconnect_server.cc
)
android_add_library(reconnect_server)


target_compile_definitions(reconnect_server PRIVATE -DPB_FIELD_16BIT)
target_compile_definitions(reconnect_server PUBLIC  -DGRPC_ALLOW_EXCEPTIONS=0)
target_include_directories(reconnect_server
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

target_link_libraries(reconnect_server PRIVATE
  ${_gRPC_ALLTARGETS_LIBRARIES}
  test_tcp_server
  grpc_test_util
  grpc
  gpr_test_util
  gpr
)

add_dependencies(reconnect_server project_benchmark project_gflags)

set(test_tcp_server_src
  ${_gRPC_ROOT}/test/core/util/test_tcp_server.cc
)
android_add_library(test_tcp_server)


target_compile_definitions(test_tcp_server PRIVATE -DPB_FIELD_16BIT)
target_compile_definitions(test_tcp_server PUBLIC  -DGRPC_ALLOW_EXCEPTIONS=0)
target_include_directories(test_tcp_server
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

target_link_libraries(test_tcp_server PRIVATE
  ${_gRPC_ALLTARGETS_LIBRARIES}
  grpc_test_util
  grpc
  gpr_test_util
  gpr
)

add_dependencies(test_tcp_server project_benchmark project_gflags)

set(grpc++_core_stats_src
  ${_gRPC_PROTO_GENS_DIR}/src/proto/grpc/core/stats.pb.cc
  ${_gRPC_PROTO_GENS_DIR}/src/proto/grpc/core/stats.grpc.pb.cc
  ${_gRPC_PROTO_GENS_DIR}/src/proto/grpc/core/stats.pb.h
  ${_gRPC_PROTO_GENS_DIR}/src/proto/grpc/core/stats.grpc.pb.h
  ${_gRPC_ROOT}/src/cpp/util/core_stats.cc
)
android_add_library(grpc++_core_stats)

protobuf_generate_grpc_cpp(SOURCE_DIR ${_gRPC_ROOT} SOURCES ${_gRPC_ROOT}/src/proto/grpc/core/stats.proto)

target_compile_definitions(grpc++_core_stats PRIVATE -DPB_FIELD_16BIT)
target_compile_definitions(grpc++_core_stats PUBLIC  -DGRPC_ALLOW_EXCEPTIONS=0)
target_include_directories(grpc++_core_stats
  PUBLIC  ${_gRPC_ROOT}/include
  PRIVATE ${_gRPC_ROOT}
  PRIVATE ${_gRPC_SSL_INCLUDE_DIR}
  PRIVATE ${_gRPC_BENCHMARK_INCLUDE_DIR}
  PRIVATE ${_gRPC_CARES_INCLUDE_DIR}
  PRIVATE ${_gRPC_GFLAGS_INCLUDE_DIR}
  PRIVATE ${_gRPC_PROTOBUF_INCLUDE_DIR}
  PRIVATE ${_gRPC_NANOPB_INCLUDE_DIR}
  PRIVATE ${_gRPC_ADDRESS_SORTING_INCLUDE_DIR}
  PRIVATE ${_gRPC_GTEST_INCLUDE_DIR}
  PRIVATE ${_gRPC_PROTO_GENS_DIR}
)

target_link_libraries(grpc++_core_stats PRIVATE
  ${_gRPC_PROTOBUF_LIBRARIES}
  ${_gRPC_ALLTARGETS_LIBRARIES}
  grpc++
)

add_dependencies(grpc++_core_stats project_benchmark project_gflags)

set(grpc++_proto_reflection_desc_db_src
  ${_gRPC_ROOT}/test/cpp/util/proto_reflection_descriptor_database.cc
  ${_gRPC_PROTO_GENS_DIR}/src/proto/grpc/reflection/v1alpha/reflection.pb.cc
  ${_gRPC_PROTO_GENS_DIR}/src/proto/grpc/reflection/v1alpha/reflection.grpc.pb.cc
  ${_gRPC_PROTO_GENS_DIR}/src/proto/grpc/reflection/v1alpha/reflection.pb.h
  ${_gRPC_PROTO_GENS_DIR}/src/proto/grpc/reflection/v1alpha/reflection.grpc.pb.h
)
android_add_library(grpc++_proto_reflection_desc_db)

protobuf_generate_grpc_cpp(SOURCE_DIR ${_gRPC_ROOT} SOURCES ${_gRPC_ROOT}/src/proto/grpc/reflection/v1alpha/reflection.proto)

target_compile_definitions(grpc++_proto_reflection_desc_db PRIVATE -DPB_FIELD_16BIT)
target_compile_definitions(grpc++_proto_reflection_desc_db PUBLIC  -DGRPC_ALLOW_EXCEPTIONS=0)
target_include_directories(grpc++_proto_reflection_desc_db
  PUBLIC  ${_gRPC_ROOT}/include
  PRIVATE ${_gRPC_ROOT}
  PRIVATE ${_gRPC_SSL_INCLUDE_DIR}
  PRIVATE ${_gRPC_BENCHMARK_INCLUDE_DIR}
  PRIVATE ${_gRPC_CARES_INCLUDE_DIR}
  PRIVATE ${_gRPC_GFLAGS_INCLUDE_DIR}
  PRIVATE ${_gRPC_PROTOBUF_INCLUDE_DIR}
  PRIVATE ${_gRPC_NANOPB_INCLUDE_DIR}
  PRIVATE ${_gRPC_ADDRESS_SORTING_INCLUDE_DIR}
  PRIVATE ${_gRPC_GTEST_INCLUDE_DIR}
  PRIVATE ${_gRPC_PROTO_GENS_DIR}
)

target_link_libraries(grpc++_proto_reflection_desc_db PRIVATE
  ${_gRPC_PROTOBUF_LIBRARIES}
  ${_gRPC_ALLTARGETS_LIBRARIES}
  grpc++
  grpc
)

add_dependencies(grpc++_proto_reflection_desc_db project_benchmark project_gflags)

set(grpc++_test_config_src
  ${_gRPC_ROOT}/test/cpp/util/test_config_cc.cc
)
android_add_library(grpc++_test_config)


target_compile_definitions(grpc++_test_config PRIVATE -DPB_FIELD_16BIT)
target_compile_definitions(grpc++_test_config PUBLIC  -DGRPC_ALLOW_EXCEPTIONS=0)
target_include_directories(grpc++_test_config
  PUBLIC  ${_gRPC_ROOT}/include
  PRIVATE ${_gRPC_ROOT}
  PRIVATE ${_gRPC_SSL_INCLUDE_DIR}
  PRIVATE ${_gRPC_BENCHMARK_INCLUDE_DIR}
  PRIVATE ${_gRPC_CARES_INCLUDE_DIR}
  PRIVATE ${_gRPC_GFLAGS_INCLUDE_DIR}
  PRIVATE ${_gRPC_PROTOBUF_INCLUDE_DIR}
  PRIVATE ${_gRPC_NANOPB_INCLUDE_DIR}
  PRIVATE ${_gRPC_ADDRESS_SORTING_INCLUDE_DIR}
  PRIVATE ${_gRPC_GTEST_INCLUDE_DIR}
  PRIVATE ${_gRPC_PROTO_GENS_DIR}
)

target_link_libraries(grpc++_test_config PRIVATE
  ${_gRPC_PROTOBUF_LIBRARIES}
  ${_gRPC_ALLTARGETS_LIBRARIES}
)

add_dependencies(grpc++_test_config project_benchmark project_gflags)

set(grpc++_test_util_src
  ${_gRPC_PROTO_GENS_DIR}/src/proto/grpc/channelz/channelz.pb.cc
  ${_gRPC_PROTO_GENS_DIR}/src/proto/grpc/channelz/channelz.grpc.pb.cc
  ${_gRPC_PROTO_GENS_DIR}/src/proto/grpc/channelz/channelz.pb.h
  ${_gRPC_PROTO_GENS_DIR}/src/proto/grpc/channelz/channelz.grpc.pb.h
  ${_gRPC_PROTO_GENS_DIR}/src/proto/grpc/health/v1/health.pb.cc
  ${_gRPC_PROTO_GENS_DIR}/src/proto/grpc/health/v1/health.grpc.pb.cc
  ${_gRPC_PROTO_GENS_DIR}/src/proto/grpc/health/v1/health.pb.h
  ${_gRPC_PROTO_GENS_DIR}/src/proto/grpc/health/v1/health.grpc.pb.h
  ${_gRPC_PROTO_GENS_DIR}/src/proto/grpc/testing/echo_messages.pb.cc
  ${_gRPC_PROTO_GENS_DIR}/src/proto/grpc/testing/echo_messages.grpc.pb.cc
  ${_gRPC_PROTO_GENS_DIR}/src/proto/grpc/testing/echo_messages.pb.h
  ${_gRPC_PROTO_GENS_DIR}/src/proto/grpc/testing/echo_messages.grpc.pb.h
  ${_gRPC_PROTO_GENS_DIR}/src/proto/grpc/testing/echo.pb.cc
  ${_gRPC_PROTO_GENS_DIR}/src/proto/grpc/testing/echo.grpc.pb.cc
  ${_gRPC_PROTO_GENS_DIR}/src/proto/grpc/testing/echo.pb.h
  ${_gRPC_PROTO_GENS_DIR}/src/proto/grpc/testing/echo.grpc.pb.h
  ${_gRPC_PROTO_GENS_DIR}/src/proto/grpc/testing/echo_mock.grpc.pb.h
  ${_gRPC_PROTO_GENS_DIR}/src/proto/grpc/testing/duplicate/echo_duplicate.pb.cc
  ${_gRPC_PROTO_GENS_DIR}/src/proto/grpc/testing/duplicate/echo_duplicate.grpc.pb.cc
  ${_gRPC_PROTO_GENS_DIR}/src/proto/grpc/testing/duplicate/echo_duplicate.pb.h
  ${_gRPC_PROTO_GENS_DIR}/src/proto/grpc/testing/duplicate/echo_duplicate.grpc.pb.h
  ${_gRPC_ROOT}/test/cpp/end2end/test_service_impl.cc
  ${_gRPC_ROOT}/test/cpp/util/byte_buffer_proto_helper.cc
  ${_gRPC_ROOT}/test/cpp/util/channel_trace_proto_helper.cc
  ${_gRPC_ROOT}/test/cpp/util/create_test_channel.cc
  ${_gRPC_ROOT}/test/cpp/util/string_ref_helper.cc
  ${_gRPC_ROOT}/test/cpp/util/subprocess.cc
  ${_gRPC_ROOT}/test/cpp/util/test_credentials_provider.cc
  ${_gRPC_ROOT}/src/cpp/codegen/codegen_init.cc
)
android_add_library(grpc++_test_util)

protobuf_generate_grpc_cpp(SOURCE_DIR ${_gRPC_ROOT} SOURCES ${_gRPC_ROOT}/src/proto/grpc/channelz/channelz.proto)
protobuf_generate_grpc_cpp(SOURCE_DIR ${_gRPC_ROOT} SOURCES ${_gRPC_ROOT}/src/proto/grpc/health/v1/health.proto)
protobuf_generate_grpc_cpp(SOURCE_DIR ${_gRPC_ROOT} SOURCES ${_gRPC_ROOT}/src/proto/grpc/testing/echo_messages.proto)
protobuf_generate_grpc_cpp(SOURCE_DIR ${_gRPC_ROOT} SOURCES ${_gRPC_ROOT}/src/proto/grpc/testing/echo.proto)
protobuf_generate_grpc_cpp(SOURCE_DIR ${_gRPC_ROOT} SOURCES ${_gRPC_ROOT}/src/proto/grpc/testing/duplicate/echo_duplicate.proto)

target_compile_definitions(grpc++_test_util PRIVATE -DPB_FIELD_16BIT)
target_compile_definitions(grpc++_test_util PUBLIC  -DGRPC_ALLOW_EXCEPTIONS=0)
target_include_directories(grpc++_test_util
  PUBLIC  ${_gRPC_ROOT}/include
  PRIVATE ${_gRPC_ROOT}
  PRIVATE ${_gRPC_SSL_INCLUDE_DIR}
  PRIVATE ${_gRPC_BENCHMARK_INCLUDE_DIR}
  PRIVATE ${_gRPC_CARES_INCLUDE_DIR}
  PRIVATE ${_gRPC_GFLAGS_INCLUDE_DIR}
  PRIVATE ${_gRPC_PROTOBUF_INCLUDE_DIR}
  PRIVATE ${_gRPC_NANOPB_INCLUDE_DIR}
  PRIVATE ${_gRPC_ADDRESS_SORTING_INCLUDE_DIR}
  PRIVATE ${_gRPC_GTEST_INCLUDE_DIR}
  PRIVATE ${_gRPC_PROTO_GENS_DIR}
)

target_link_libraries(grpc++_test_util PRIVATE
  ${_gRPC_PROTOBUF_LIBRARIES}
  ${_gRPC_ALLTARGETS_LIBRARIES}
  grpc++
  grpc_test_util
  grpc
)

add_dependencies(grpc++_test_util project_benchmark project_gflags)

set(grpc++_test_util_unsecure_src
  ${_gRPC_PROTO_GENS_DIR}/src/proto/grpc/health/v1/health.pb.cc
  ${_gRPC_PROTO_GENS_DIR}/src/proto/grpc/health/v1/health.grpc.pb.cc
  ${_gRPC_PROTO_GENS_DIR}/src/proto/grpc/health/v1/health.pb.h
  ${_gRPC_PROTO_GENS_DIR}/src/proto/grpc/health/v1/health.grpc.pb.h
  ${_gRPC_PROTO_GENS_DIR}/src/proto/grpc/testing/echo_messages.pb.cc
  ${_gRPC_PROTO_GENS_DIR}/src/proto/grpc/testing/echo_messages.grpc.pb.cc
  ${_gRPC_PROTO_GENS_DIR}/src/proto/grpc/testing/echo_messages.pb.h
  ${_gRPC_PROTO_GENS_DIR}/src/proto/grpc/testing/echo_messages.grpc.pb.h
  ${_gRPC_PROTO_GENS_DIR}/src/proto/grpc/testing/echo.pb.cc
  ${_gRPC_PROTO_GENS_DIR}/src/proto/grpc/testing/echo.grpc.pb.cc
  ${_gRPC_PROTO_GENS_DIR}/src/proto/grpc/testing/echo.pb.h
  ${_gRPC_PROTO_GENS_DIR}/src/proto/grpc/testing/echo.grpc.pb.h
  ${_gRPC_PROTO_GENS_DIR}/src/proto/grpc/testing/echo_mock.grpc.pb.h
  ${_gRPC_PROTO_GENS_DIR}/src/proto/grpc/testing/duplicate/echo_duplicate.pb.cc
  ${_gRPC_PROTO_GENS_DIR}/src/proto/grpc/testing/duplicate/echo_duplicate.grpc.pb.cc
  ${_gRPC_PROTO_GENS_DIR}/src/proto/grpc/testing/duplicate/echo_duplicate.pb.h
  ${_gRPC_PROTO_GENS_DIR}/src/proto/grpc/testing/duplicate/echo_duplicate.grpc.pb.h
  ${_gRPC_ROOT}/test/cpp/end2end/test_service_impl.cc
  ${_gRPC_ROOT}/test/cpp/util/byte_buffer_proto_helper.cc
  ${_gRPC_ROOT}/test/cpp/util/string_ref_helper.cc
  ${_gRPC_ROOT}/test/cpp/util/subprocess.cc
  ${_gRPC_ROOT}/src/cpp/codegen/codegen_init.cc
)
android_add_library(grpc++_test_util_unsecure)

protobuf_generate_grpc_cpp(SOURCE_DIR ${_gRPC_ROOT} SOURCES ${_gRPC_ROOT}/src/proto/grpc/health/v1/health.proto)
protobuf_generate_grpc_cpp(SOURCE_DIR ${_gRPC_ROOT} SOURCES ${_gRPC_ROOT}/src/proto/grpc/testing/echo_messages.proto)
protobuf_generate_grpc_cpp(SOURCE_DIR ${_gRPC_ROOT} SOURCES ${_gRPC_ROOT}/src/proto/grpc/testing/echo.proto)
protobuf_generate_grpc_cpp(SOURCE_DIR ${_gRPC_ROOT} SOURCES ${_gRPC_ROOT}/src/proto/grpc/testing/duplicate/echo_duplicate.proto)

target_compile_definitions(grpc++_test_util_unsecure PRIVATE -DPB_FIELD_16BIT)
target_compile_definitions(grpc++_test_util_unsecure PUBLIC  -DGRPC_ALLOW_EXCEPTIONS=0)
target_include_directories(grpc++_test_util_unsecure
  PUBLIC  ${_gRPC_ROOT}/include
  PRIVATE ${_gRPC_ROOT}
  PRIVATE ${_gRPC_SSL_INCLUDE_DIR}
  PRIVATE ${_gRPC_BENCHMARK_INCLUDE_DIR}
  PRIVATE ${_gRPC_CARES_INCLUDE_DIR}
  PRIVATE ${_gRPC_GFLAGS_INCLUDE_DIR}
  PRIVATE ${_gRPC_PROTOBUF_INCLUDE_DIR}
  PRIVATE ${_gRPC_NANOPB_INCLUDE_DIR}
  PRIVATE ${_gRPC_ADDRESS_SORTING_INCLUDE_DIR}
  PRIVATE ${_gRPC_GTEST_INCLUDE_DIR}
  PRIVATE ${_gRPC_PROTO_GENS_DIR}
)

target_link_libraries(grpc++_test_util_unsecure PRIVATE
  ${_gRPC_PROTOBUF_LIBRARIES}
  ${_gRPC_ALLTARGETS_LIBRARIES}
  grpc++_unsecure
  grpc_test_util_unsecure
  grpc_unsecure
)

add_dependencies(grpc++_test_util_unsecure project_benchmark project_gflags)

set(grpc_benchmark_src
  ${_gRPC_ROOT}/test/cpp/microbenchmarks/helpers.cc
)
android_add_library(grpc_benchmark)


target_compile_definitions(grpc_benchmark PRIVATE -DPB_FIELD_16BIT)
target_compile_definitions(grpc_benchmark PUBLIC  -DGRPC_ALLOW_EXCEPTIONS=0)
target_include_directories(grpc_benchmark
  PUBLIC  ${_gRPC_ROOT}/include
  PRIVATE ${_gRPC_ROOT}
  PRIVATE ${_gRPC_SSL_INCLUDE_DIR}
  PRIVATE ${_gRPC_BENCHMARK_INCLUDE_DIR}
  PRIVATE ${_gRPC_CARES_INCLUDE_DIR}
  PRIVATE ${_gRPC_GFLAGS_INCLUDE_DIR}
  PRIVATE ${_gRPC_PROTOBUF_INCLUDE_DIR}
  PRIVATE ${_gRPC_NANOPB_INCLUDE_DIR}
  PRIVATE ${_gRPC_ADDRESS_SORTING_INCLUDE_DIR}
  PRIVATE ${_gRPC_GTEST_INCLUDE_DIR}
  PRIVATE ${_gRPC_PROTO_GENS_DIR}
)

target_link_libraries(grpc_benchmark PRIVATE
  ${_gRPC_PROTOBUF_LIBRARIES}
  ${_gRPC_ALLTARGETS_LIBRARIES}
  ${_gRPC_BENCHMARK_LIBRARIES}
  grpc++_unsecure
  grpc_test_util_unsecure
  grpc_unsecure
  ${_gRPC_GFLAGS_LIBRARIES}
)

add_dependencies(grpc_benchmark project_benchmark project_gflags)

set(grpc_cli_libs_src
  ${_gRPC_ROOT}/test/cpp/util/cli_call.cc
  ${_gRPC_ROOT}/test/cpp/util/cli_credentials.cc
  ${_gRPC_ROOT}/test/cpp/util/grpc_tool.cc
  ${_gRPC_ROOT}/test/cpp/util/proto_file_parser.cc
  ${_gRPC_ROOT}/test/cpp/util/service_describer.cc
  ${_gRPC_PROTO_GENS_DIR}/src/proto/grpc/reflection/v1alpha/reflection.pb.cc
  ${_gRPC_PROTO_GENS_DIR}/src/proto/grpc/reflection/v1alpha/reflection.grpc.pb.cc
  ${_gRPC_PROTO_GENS_DIR}/src/proto/grpc/reflection/v1alpha/reflection.pb.h
  ${_gRPC_PROTO_GENS_DIR}/src/proto/grpc/reflection/v1alpha/reflection.grpc.pb.h
)
android_add_library(grpc_cli_libs)

protobuf_generate_grpc_cpp(SOURCE_DIR ${_gRPC_ROOT} SOURCES ${_gRPC_ROOT}/src/proto/grpc/reflection/v1alpha/reflection.proto)

target_compile_definitions(grpc_cli_libs PRIVATE -DPB_FIELD_16BIT)
target_compile_definitions(grpc_cli_libs PUBLIC  -DGRPC_ALLOW_EXCEPTIONS=0)
target_include_directories(grpc_cli_libs
  PUBLIC  ${_gRPC_ROOT}/include
  PRIVATE ${_gRPC_ROOT}
  PRIVATE ${_gRPC_SSL_INCLUDE_DIR}
  PRIVATE ${_gRPC_BENCHMARK_INCLUDE_DIR}
  PRIVATE ${_gRPC_CARES_INCLUDE_DIR}
  PRIVATE ${_gRPC_GFLAGS_INCLUDE_DIR}
  PRIVATE ${_gRPC_PROTOBUF_INCLUDE_DIR}
  PRIVATE ${_gRPC_NANOPB_INCLUDE_DIR}
  PRIVATE ${_gRPC_ADDRESS_SORTING_INCLUDE_DIR}
  PRIVATE ${_gRPC_GTEST_INCLUDE_DIR}
  PRIVATE ${_gRPC_PROTO_GENS_DIR}
)

target_link_libraries(grpc_cli_libs PRIVATE
  ${_gRPC_PROTOBUF_LIBRARIES}
  ${_gRPC_ALLTARGETS_LIBRARIES}
  grpc++_proto_reflection_desc_db
  grpc++
  grpc
)

add_dependencies(grpc_cli_libs project_benchmark project_gflags)

set(http2_client_main_src
  ${_gRPC_PROTO_GENS_DIR}/src/proto/grpc/testing/empty.pb.cc
  ${_gRPC_PROTO_GENS_DIR}/src/proto/grpc/testing/empty.grpc.pb.cc
  ${_gRPC_PROTO_GENS_DIR}/src/proto/grpc/testing/empty.pb.h
  ${_gRPC_PROTO_GENS_DIR}/src/proto/grpc/testing/empty.grpc.pb.h
  ${_gRPC_PROTO_GENS_DIR}/src/proto/grpc/testing/messages.pb.cc
  ${_gRPC_PROTO_GENS_DIR}/src/proto/grpc/testing/messages.grpc.pb.cc
  ${_gRPC_PROTO_GENS_DIR}/src/proto/grpc/testing/messages.pb.h
  ${_gRPC_PROTO_GENS_DIR}/src/proto/grpc/testing/messages.grpc.pb.h
  ${_gRPC_PROTO_GENS_DIR}/src/proto/grpc/testing/test.pb.cc
  ${_gRPC_PROTO_GENS_DIR}/src/proto/grpc/testing/test.grpc.pb.cc
  ${_gRPC_PROTO_GENS_DIR}/src/proto/grpc/testing/test.pb.h
  ${_gRPC_PROTO_GENS_DIR}/src/proto/grpc/testing/test.grpc.pb.h
  ${_gRPC_ROOT}/test/cpp/interop/http2_client.cc
)
android_add_library(http2_client_main)

protobuf_generate_grpc_cpp(SOURCE_DIR ${_gRPC_ROOT} SOURCES ${_gRPC_ROOT}/src/proto/grpc/testing/empty.proto)
protobuf_generate_grpc_cpp(SOURCE_DIR ${_gRPC_ROOT} SOURCES ${_gRPC_ROOT}/src/proto/grpc/testing/messages.proto)
protobuf_generate_grpc_cpp(SOURCE_DIR ${_gRPC_ROOT} SOURCES ${_gRPC_ROOT}/src/proto/grpc/testing/test.proto)

target_compile_definitions(http2_client_main PRIVATE -DPB_FIELD_16BIT)
target_compile_definitions(http2_client_main PUBLIC  -DGRPC_ALLOW_EXCEPTIONS=0)
target_include_directories(http2_client_main
  PUBLIC  ${_gRPC_ROOT}/include
  PRIVATE ${_gRPC_ROOT}
  PRIVATE ${_gRPC_SSL_INCLUDE_DIR}
  PRIVATE ${_gRPC_BENCHMARK_INCLUDE_DIR}
  PRIVATE ${_gRPC_CARES_INCLUDE_DIR}
  PRIVATE ${_gRPC_GFLAGS_INCLUDE_DIR}
  PRIVATE ${_gRPC_PROTOBUF_INCLUDE_DIR}
  PRIVATE ${_gRPC_NANOPB_INCLUDE_DIR}
  PRIVATE ${_gRPC_ADDRESS_SORTING_INCLUDE_DIR}
  PRIVATE ${_gRPC_GTEST_INCLUDE_DIR}
  PRIVATE ${_gRPC_PROTO_GENS_DIR}
)

target_link_libraries(http2_client_main PRIVATE
  ${_gRPC_PROTOBUF_LIBRARIES}
  ${_gRPC_ALLTARGETS_LIBRARIES}
  grpc++_test_util
  grpc_test_util
  grpc++
  grpc
  grpc++_test_config
)

add_dependencies(http2_client_main project_benchmark project_gflags)

set(interop_client_helper_src
  ${_gRPC_PROTO_GENS_DIR}/src/proto/grpc/testing/messages.pb.cc
  ${_gRPC_PROTO_GENS_DIR}/src/proto/grpc/testing/messages.grpc.pb.cc
  ${_gRPC_PROTO_GENS_DIR}/src/proto/grpc/testing/messages.pb.h
  ${_gRPC_PROTO_GENS_DIR}/src/proto/grpc/testing/messages.grpc.pb.h
  ${_gRPC_ROOT}/test/cpp/interop/client_helper.cc
)
android_add_library(interop_client_helper)

protobuf_generate_grpc_cpp(SOURCE_DIR ${_gRPC_ROOT} SOURCES ${_gRPC_ROOT}/src/proto/grpc/testing/messages.proto)

target_compile_options(interop_client_helper PRIVATE -frtti)
target_compile_definitions(interop_client_helper PRIVATE -DPB_FIELD_16BIT)
target_compile_definitions(interop_client_helper PUBLIC  -DGRPC_ALLOW_EXCEPTIONS=0)
target_include_directories(interop_client_helper
  PUBLIC  ${_gRPC_ROOT}/include
  PRIVATE ${_gRPC_ROOT}
  PRIVATE ${_gRPC_SSL_INCLUDE_DIR}
  PRIVATE ${_gRPC_BENCHMARK_INCLUDE_DIR}
  PRIVATE ${_gRPC_CARES_INCLUDE_DIR}
  PRIVATE ${_gRPC_GFLAGS_INCLUDE_DIR}
  PRIVATE ${_gRPC_PROTOBUF_INCLUDE_DIR}
  PRIVATE ${_gRPC_NANOPB_INCLUDE_DIR}
  PRIVATE ${_gRPC_ADDRESS_SORTING_INCLUDE_DIR}
  PRIVATE ${_gRPC_GTEST_INCLUDE_DIR}
  PRIVATE ${_gRPC_PROTO_GENS_DIR}
)

target_link_libraries(interop_client_helper PRIVATE
  ${_gRPC_PROTOBUF_LIBRARIES}
  ${_gRPC_ALLTARGETS_LIBRARIES}
  grpc++_test_util
  grpc_test_util
  grpc++
  grpc
  gpr
)

add_dependencies(interop_client_helper project_benchmark project_gflags)

set(interop_client_main_src
  ${_gRPC_PROTO_GENS_DIR}/src/proto/grpc/testing/empty.pb.cc
  ${_gRPC_PROTO_GENS_DIR}/src/proto/grpc/testing/empty.grpc.pb.cc
  ${_gRPC_PROTO_GENS_DIR}/src/proto/grpc/testing/empty.pb.h
  ${_gRPC_PROTO_GENS_DIR}/src/proto/grpc/testing/empty.grpc.pb.h
  ${_gRPC_PROTO_GENS_DIR}/src/proto/grpc/testing/messages.pb.cc
  ${_gRPC_PROTO_GENS_DIR}/src/proto/grpc/testing/messages.grpc.pb.cc
  ${_gRPC_PROTO_GENS_DIR}/src/proto/grpc/testing/messages.pb.h
  ${_gRPC_PROTO_GENS_DIR}/src/proto/grpc/testing/messages.grpc.pb.h
  ${_gRPC_PROTO_GENS_DIR}/src/proto/grpc/testing/test.pb.cc
  ${_gRPC_PROTO_GENS_DIR}/src/proto/grpc/testing/test.grpc.pb.cc
  ${_gRPC_PROTO_GENS_DIR}/src/proto/grpc/testing/test.pb.h
  ${_gRPC_PROTO_GENS_DIR}/src/proto/grpc/testing/test.grpc.pb.h
  ${_gRPC_ROOT}/test/cpp/interop/client.cc
  ${_gRPC_ROOT}/test/cpp/interop/interop_client.cc
)
android_add_library(interop_client_main)

protobuf_generate_grpc_cpp(SOURCE_DIR ${_gRPC_ROOT} SOURCES ${_gRPC_ROOT}/src/proto/grpc/testing/empty.proto)
protobuf_generate_grpc_cpp(SOURCE_DIR ${_gRPC_ROOT} SOURCES ${_gRPC_ROOT}/src/proto/grpc/testing/messages.proto)
protobuf_generate_grpc_cpp(SOURCE_DIR ${_gRPC_ROOT} SOURCES ${_gRPC_ROOT}/src/proto/grpc/testing/test.proto)

target_compile_definitions(interop_client_main PRIVATE -DPB_FIELD_16BIT)
target_compile_definitions(interop_client_main PUBLIC  -DGRPC_ALLOW_EXCEPTIONS=0)
target_include_directories(interop_client_main
  PUBLIC  ${_gRPC_ROOT}/include
  PRIVATE ${_gRPC_ROOT}
  PRIVATE ${_gRPC_SSL_INCLUDE_DIR}
  PRIVATE ${_gRPC_BENCHMARK_INCLUDE_DIR}
  PRIVATE ${_gRPC_CARES_INCLUDE_DIR}
  PRIVATE ${_gRPC_GFLAGS_INCLUDE_DIR}
  PRIVATE ${_gRPC_PROTOBUF_INCLUDE_DIR}
  PRIVATE ${_gRPC_NANOPB_INCLUDE_DIR}
  PRIVATE ${_gRPC_ADDRESS_SORTING_INCLUDE_DIR}
  PRIVATE ${_gRPC_GTEST_INCLUDE_DIR}
  PRIVATE ${_gRPC_PROTO_GENS_DIR}
)

target_link_libraries(interop_client_main PRIVATE
  ${_gRPC_PROTOBUF_LIBRARIES}
  ${_gRPC_ALLTARGETS_LIBRARIES}
  interop_client_helper
  grpc++_test_util
  grpc_test_util
  grpc++
  grpc
  gpr_test_util
  gpr
  grpc++_test_config
)

add_dependencies(interop_client_main project_benchmark project_gflags)

set(interop_server_helper_src
  ${_gRPC_ROOT}/test/cpp/interop/server_helper.cc
)
android_add_library(interop_server_helper)


target_compile_definitions(interop_server_helper PRIVATE -DPB_FIELD_16BIT)
target_compile_definitions(interop_server_helper PUBLIC  -DGRPC_ALLOW_EXCEPTIONS=0)
target_include_directories(interop_server_helper
  PUBLIC  ${_gRPC_ROOT}/include
  PRIVATE ${_gRPC_ROOT}
  PRIVATE ${_gRPC_SSL_INCLUDE_DIR}
  PRIVATE ${_gRPC_BENCHMARK_INCLUDE_DIR}
  PRIVATE ${_gRPC_CARES_INCLUDE_DIR}
  PRIVATE ${_gRPC_GFLAGS_INCLUDE_DIR}
  PRIVATE ${_gRPC_PROTOBUF_INCLUDE_DIR}
  PRIVATE ${_gRPC_NANOPB_INCLUDE_DIR}
  PRIVATE ${_gRPC_ADDRESS_SORTING_INCLUDE_DIR}
  PRIVATE ${_gRPC_GTEST_INCLUDE_DIR}
  PRIVATE ${_gRPC_PROTO_GENS_DIR}
)

target_link_libraries(interop_server_helper PRIVATE
  ${_gRPC_PROTOBUF_LIBRARIES}
  ${_gRPC_ALLTARGETS_LIBRARIES}
  grpc++_test_util
  grpc_test_util
  grpc++
  grpc
  gpr
)

add_dependencies(interop_server_helper project_benchmark project_gflags)

set(interop_server_lib_src
  ${_gRPC_PROTO_GENS_DIR}/src/proto/grpc/testing/empty.pb.cc
  ${_gRPC_PROTO_GENS_DIR}/src/proto/grpc/testing/empty.grpc.pb.cc
  ${_gRPC_PROTO_GENS_DIR}/src/proto/grpc/testing/empty.pb.h
  ${_gRPC_PROTO_GENS_DIR}/src/proto/grpc/testing/empty.grpc.pb.h
  ${_gRPC_PROTO_GENS_DIR}/src/proto/grpc/testing/messages.pb.cc
  ${_gRPC_PROTO_GENS_DIR}/src/proto/grpc/testing/messages.grpc.pb.cc
  ${_gRPC_PROTO_GENS_DIR}/src/proto/grpc/testing/messages.pb.h
  ${_gRPC_PROTO_GENS_DIR}/src/proto/grpc/testing/messages.grpc.pb.h
  ${_gRPC_PROTO_GENS_DIR}/src/proto/grpc/testing/test.pb.cc
  ${_gRPC_PROTO_GENS_DIR}/src/proto/grpc/testing/test.grpc.pb.cc
  ${_gRPC_PROTO_GENS_DIR}/src/proto/grpc/testing/test.pb.h
  ${_gRPC_PROTO_GENS_DIR}/src/proto/grpc/testing/test.grpc.pb.h
  ${_gRPC_ROOT}/test/cpp/interop/interop_server.cc
)
android_add_library(interop_server_lib)

protobuf_generate_grpc_cpp(SOURCE_DIR ${_gRPC_ROOT} SOURCES ${_gRPC_ROOT}/src/proto/grpc/testing/empty.proto)
protobuf_generate_grpc_cpp(SOURCE_DIR ${_gRPC_ROOT} SOURCES ${_gRPC_ROOT}/src/proto/grpc/testing/messages.proto)
protobuf_generate_grpc_cpp(SOURCE_DIR ${_gRPC_ROOT} SOURCES ${_gRPC_ROOT}/src/proto/grpc/testing/test.proto)

target_compile_definitions(interop_server_lib PRIVATE -DPB_FIELD_16BIT)
target_compile_definitions(interop_server_lib PUBLIC  -DGRPC_ALLOW_EXCEPTIONS=0)
target_include_directories(interop_server_lib
  PUBLIC  ${_gRPC_ROOT}/include
  PRIVATE ${_gRPC_ROOT}
  PRIVATE ${_gRPC_SSL_INCLUDE_DIR}
  PRIVATE ${_gRPC_BENCHMARK_INCLUDE_DIR}
  PRIVATE ${_gRPC_CARES_INCLUDE_DIR}
  PRIVATE ${_gRPC_GFLAGS_INCLUDE_DIR}
  PRIVATE ${_gRPC_PROTOBUF_INCLUDE_DIR}
  PRIVATE ${_gRPC_NANOPB_INCLUDE_DIR}
  PRIVATE ${_gRPC_ADDRESS_SORTING_INCLUDE_DIR}
  PRIVATE ${_gRPC_GTEST_INCLUDE_DIR}
  PRIVATE ${_gRPC_PROTO_GENS_DIR}
)

target_link_libraries(interop_server_lib PRIVATE
  ${_gRPC_PROTOBUF_LIBRARIES}
  ${_gRPC_ALLTARGETS_LIBRARIES}
  interop_server_helper
  grpc++_test_util
  grpc_test_util
  grpc++
  grpc
  gpr_test_util
  gpr
  grpc++_test_config
)

add_dependencies(interop_server_lib project_benchmark project_gflags)

set(interop_server_main_src
  ${_gRPC_ROOT}/test/cpp/interop/interop_server_bootstrap.cc
)
android_add_library(interop_server_main)


target_compile_definitions(interop_server_main PRIVATE -DPB_FIELD_16BIT)
target_compile_definitions(interop_server_main PUBLIC  -DGRPC_ALLOW_EXCEPTIONS=0)
target_include_directories(interop_server_main
  PUBLIC  ${_gRPC_ROOT}/include
  PRIVATE ${_gRPC_ROOT}
  PRIVATE ${_gRPC_SSL_INCLUDE_DIR}
  PRIVATE ${_gRPC_BENCHMARK_INCLUDE_DIR}
  PRIVATE ${_gRPC_CARES_INCLUDE_DIR}
  PRIVATE ${_gRPC_GFLAGS_INCLUDE_DIR}
  PRIVATE ${_gRPC_PROTOBUF_INCLUDE_DIR}
  PRIVATE ${_gRPC_NANOPB_INCLUDE_DIR}
  PRIVATE ${_gRPC_ADDRESS_SORTING_INCLUDE_DIR}
  PRIVATE ${_gRPC_GTEST_INCLUDE_DIR}
  PRIVATE ${_gRPC_PROTO_GENS_DIR}
)

target_link_libraries(interop_server_main PRIVATE
  ${_gRPC_PROTOBUF_LIBRARIES}
  ${_gRPC_ALLTARGETS_LIBRARIES}
  interop_server_lib
)

add_dependencies(interop_server_main project_benchmark project_gflags)

set(qps_src
  ${_gRPC_PROTO_GENS_DIR}/src/proto/grpc/testing/messages.pb.cc
  ${_gRPC_PROTO_GENS_DIR}/src/proto/grpc/testing/messages.grpc.pb.cc
  ${_gRPC_PROTO_GENS_DIR}/src/proto/grpc/testing/messages.pb.h
  ${_gRPC_PROTO_GENS_DIR}/src/proto/grpc/testing/messages.grpc.pb.h
  ${_gRPC_PROTO_GENS_DIR}/src/proto/grpc/testing/payloads.pb.cc
  ${_gRPC_PROTO_GENS_DIR}/src/proto/grpc/testing/payloads.grpc.pb.cc
  ${_gRPC_PROTO_GENS_DIR}/src/proto/grpc/testing/payloads.pb.h
  ${_gRPC_PROTO_GENS_DIR}/src/proto/grpc/testing/payloads.grpc.pb.h
  ${_gRPC_PROTO_GENS_DIR}/src/proto/grpc/testing/stats.pb.cc
  ${_gRPC_PROTO_GENS_DIR}/src/proto/grpc/testing/stats.grpc.pb.cc
  ${_gRPC_PROTO_GENS_DIR}/src/proto/grpc/testing/stats.pb.h
  ${_gRPC_PROTO_GENS_DIR}/src/proto/grpc/testing/stats.grpc.pb.h
  ${_gRPC_PROTO_GENS_DIR}/src/proto/grpc/testing/control.pb.cc
  ${_gRPC_PROTO_GENS_DIR}/src/proto/grpc/testing/control.grpc.pb.cc
  ${_gRPC_PROTO_GENS_DIR}/src/proto/grpc/testing/control.pb.h
  ${_gRPC_PROTO_GENS_DIR}/src/proto/grpc/testing/control.grpc.pb.h
  ${_gRPC_PROTO_GENS_DIR}/src/proto/grpc/testing/benchmark_service.pb.cc
  ${_gRPC_PROTO_GENS_DIR}/src/proto/grpc/testing/benchmark_service.grpc.pb.cc
  ${_gRPC_PROTO_GENS_DIR}/src/proto/grpc/testing/benchmark_service.pb.h
  ${_gRPC_PROTO_GENS_DIR}/src/proto/grpc/testing/benchmark_service.grpc.pb.h
  ${_gRPC_PROTO_GENS_DIR}/src/proto/grpc/testing/report_qps_scenario_service.pb.cc
  ${_gRPC_PROTO_GENS_DIR}/src/proto/grpc/testing/report_qps_scenario_service.grpc.pb.cc
  ${_gRPC_PROTO_GENS_DIR}/src/proto/grpc/testing/report_qps_scenario_service.pb.h
  ${_gRPC_PROTO_GENS_DIR}/src/proto/grpc/testing/report_qps_scenario_service.grpc.pb.h
  ${_gRPC_PROTO_GENS_DIR}/src/proto/grpc/testing/worker_service.pb.cc
  ${_gRPC_PROTO_GENS_DIR}/src/proto/grpc/testing/worker_service.grpc.pb.cc
  ${_gRPC_PROTO_GENS_DIR}/src/proto/grpc/testing/worker_service.pb.h
  ${_gRPC_PROTO_GENS_DIR}/src/proto/grpc/testing/worker_service.grpc.pb.h
  ${_gRPC_ROOT}/test/cpp/qps/benchmark_config.cc
  ${_gRPC_ROOT}/test/cpp/qps/client_async.cc
  ${_gRPC_ROOT}/test/cpp/qps/client_sync.cc
  ${_gRPC_ROOT}/test/cpp/qps/driver.cc
  ${_gRPC_ROOT}/test/cpp/qps/parse_json.cc
  ${_gRPC_ROOT}/test/cpp/qps/qps_server_builder.cc
  ${_gRPC_ROOT}/test/cpp/qps/qps_worker.cc
  ${_gRPC_ROOT}/test/cpp/qps/report.cc
  ${_gRPC_ROOT}/test/cpp/qps/server_async.cc
  ${_gRPC_ROOT}/test/cpp/qps/server_sync.cc
  ${_gRPC_ROOT}/test/cpp/qps/usage_timer.cc
)
android_add_library(qps)

protobuf_generate_grpc_cpp(SOURCE_DIR ${_gRPC_ROOT} SOURCES ${_gRPC_ROOT}/src/proto/grpc/testing/messages.proto)
protobuf_generate_grpc_cpp(SOURCE_DIR ${_gRPC_ROOT} SOURCES ${_gRPC_ROOT}/src/proto/grpc/testing/payloads.proto)
protobuf_generate_grpc_cpp(SOURCE_DIR ${_gRPC_ROOT} SOURCES ${_gRPC_ROOT}/src/proto/grpc/testing/stats.proto)
protobuf_generate_grpc_cpp(SOURCE_DIR ${_gRPC_ROOT} SOURCES ${_gRPC_ROOT}/src/proto/grpc/testing/control.proto)
protobuf_generate_grpc_cpp(SOURCE_DIR ${_gRPC_ROOT} SOURCES ${_gRPC_ROOT}/src/proto/grpc/testing/benchmark_service.proto)
protobuf_generate_grpc_cpp(SOURCE_DIR ${_gRPC_ROOT} SOURCES ${_gRPC_ROOT}/src/proto/grpc/testing/report_qps_scenario_service.proto)
protobuf_generate_grpc_cpp(SOURCE_DIR ${_gRPC_ROOT} SOURCES ${_gRPC_ROOT}/src/proto/grpc/testing/worker_service.proto)

target_compile_definitions(qps PRIVATE -DPB_FIELD_16BIT)
target_compile_definitions(qps PUBLIC  -DGRPC_ALLOW_EXCEPTIONS=0)
target_include_directories(qps
  PUBLIC  ${_gRPC_ROOT}/include
  PRIVATE ${_gRPC_ROOT}
  PRIVATE ${_gRPC_SSL_INCLUDE_DIR}
  PRIVATE ${_gRPC_BENCHMARK_INCLUDE_DIR}
  PRIVATE ${_gRPC_CARES_INCLUDE_DIR}
  PRIVATE ${_gRPC_GFLAGS_INCLUDE_DIR}
  PRIVATE ${_gRPC_PROTOBUF_INCLUDE_DIR}
  PRIVATE ${_gRPC_NANOPB_INCLUDE_DIR}
  PRIVATE ${_gRPC_ADDRESS_SORTING_INCLUDE_DIR}
  PRIVATE ${_gRPC_GTEST_INCLUDE_DIR}
  PRIVATE ${_gRPC_PROTO_GENS_DIR}
)

target_link_libraries(qps PRIVATE
  ${_gRPC_PROTOBUF_LIBRARIES}
  ${_gRPC_ALLTARGETS_LIBRARIES}
  grpc_test_util
  grpc++_test_util
  grpc++_core_stats
  grpc++
  grpc
)

add_dependencies(qps project_benchmark project_gflags)

set(bad_client_test_src
  ${_gRPC_ROOT}/test/core/bad_client/bad_client.cc
)
android_add_library(bad_client_test)


target_compile_definitions(bad_client_test PRIVATE -DPB_FIELD_16BIT)
target_compile_definitions(bad_client_test PUBLIC  -DGRPC_ALLOW_EXCEPTIONS=0)
target_include_directories(bad_client_test
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

target_link_libraries(bad_client_test PRIVATE
  ${_gRPC_ALLTARGETS_LIBRARIES}
  grpc_test_util_unsecure
  grpc_unsecure
  gpr_test_util
  gpr
)

add_dependencies(bad_client_test project_benchmark project_gflags)

set(bad_ssl_test_server_src
  ${_gRPC_ROOT}/test/core/bad_ssl/server_common.cc
)
android_add_library(bad_ssl_test_server)


target_compile_definitions(bad_ssl_test_server PRIVATE -DPB_FIELD_16BIT)
target_compile_definitions(bad_ssl_test_server PUBLIC  -DGRPC_ALLOW_EXCEPTIONS=0)
target_include_directories(bad_ssl_test_server
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

target_link_libraries(bad_ssl_test_server PRIVATE
  ${_gRPC_ALLTARGETS_LIBRARIES}
  grpc_test_util
  grpc
  gpr_test_util
  gpr
)

add_dependencies(bad_ssl_test_server project_benchmark project_gflags)

set(end2end_tests_src
  ${_gRPC_ROOT}/test/core/end2end/end2end_tests.cc
  ${_gRPC_ROOT}/test/core/end2end/end2end_test_utils.cc
  ${_gRPC_ROOT}/test/core/end2end/tests/authority_not_supported.cc
  ${_gRPC_ROOT}/test/core/end2end/tests/bad_hostname.cc
  ${_gRPC_ROOT}/test/core/end2end/tests/bad_ping.cc
  ${_gRPC_ROOT}/test/core/end2end/tests/binary_metadata.cc
  ${_gRPC_ROOT}/test/core/end2end/tests/call_creds.cc
  ${_gRPC_ROOT}/test/core/end2end/tests/call_host_override.cc
  ${_gRPC_ROOT}/test/core/end2end/tests/cancel_after_accept.cc
  ${_gRPC_ROOT}/test/core/end2end/tests/cancel_after_client_done.cc
  ${_gRPC_ROOT}/test/core/end2end/tests/cancel_after_invoke.cc
  ${_gRPC_ROOT}/test/core/end2end/tests/cancel_after_round_trip.cc
  ${_gRPC_ROOT}/test/core/end2end/tests/cancel_before_invoke.cc
  ${_gRPC_ROOT}/test/core/end2end/tests/cancel_in_a_vacuum.cc
  ${_gRPC_ROOT}/test/core/end2end/tests/cancel_with_status.cc
  ${_gRPC_ROOT}/test/core/end2end/tests/channelz.cc
  ${_gRPC_ROOT}/test/core/end2end/tests/compressed_payload.cc
  ${_gRPC_ROOT}/test/core/end2end/tests/connectivity.cc
  ${_gRPC_ROOT}/test/core/end2end/tests/default_host.cc
  ${_gRPC_ROOT}/test/core/end2end/tests/disappearing_server.cc
  ${_gRPC_ROOT}/test/core/end2end/tests/empty_batch.cc
  ${_gRPC_ROOT}/test/core/end2end/tests/filter_call_init_fails.cc
  ${_gRPC_ROOT}/test/core/end2end/tests/filter_causes_close.cc
  ${_gRPC_ROOT}/test/core/end2end/tests/filter_latency.cc
  ${_gRPC_ROOT}/test/core/end2end/tests/filter_status_code.cc
  ${_gRPC_ROOT}/test/core/end2end/tests/graceful_server_shutdown.cc
  ${_gRPC_ROOT}/test/core/end2end/tests/high_initial_seqno.cc
  ${_gRPC_ROOT}/test/core/end2end/tests/hpack_size.cc
  ${_gRPC_ROOT}/test/core/end2end/tests/idempotent_request.cc
  ${_gRPC_ROOT}/test/core/end2end/tests/invoke_large_request.cc
  ${_gRPC_ROOT}/test/core/end2end/tests/keepalive_timeout.cc
  ${_gRPC_ROOT}/test/core/end2end/tests/large_metadata.cc
  ${_gRPC_ROOT}/test/core/end2end/tests/max_concurrent_streams.cc
  ${_gRPC_ROOT}/test/core/end2end/tests/max_connection_age.cc
  ${_gRPC_ROOT}/test/core/end2end/tests/max_connection_idle.cc
  ${_gRPC_ROOT}/test/core/end2end/tests/max_message_length.cc
  ${_gRPC_ROOT}/test/core/end2end/tests/negative_deadline.cc
  ${_gRPC_ROOT}/test/core/end2end/tests/network_status_change.cc
  ${_gRPC_ROOT}/test/core/end2end/tests/no_error_on_hotpath.cc
  ${_gRPC_ROOT}/test/core/end2end/tests/no_logging.cc
  ${_gRPC_ROOT}/test/core/end2end/tests/no_op.cc
  ${_gRPC_ROOT}/test/core/end2end/tests/payload.cc
  ${_gRPC_ROOT}/test/core/end2end/tests/ping.cc
  ${_gRPC_ROOT}/test/core/end2end/tests/ping_pong_streaming.cc
  ${_gRPC_ROOT}/test/core/end2end/tests/proxy_auth.cc
  ${_gRPC_ROOT}/test/core/end2end/tests/registered_call.cc
  ${_gRPC_ROOT}/test/core/end2end/tests/request_with_flags.cc
  ${_gRPC_ROOT}/test/core/end2end/tests/request_with_payload.cc
  ${_gRPC_ROOT}/test/core/end2end/tests/resource_quota_server.cc
  ${_gRPC_ROOT}/test/core/end2end/tests/retry.cc
  ${_gRPC_ROOT}/test/core/end2end/tests/retry_cancellation.cc
  ${_gRPC_ROOT}/test/core/end2end/tests/retry_disabled.cc
  ${_gRPC_ROOT}/test/core/end2end/tests/retry_exceeds_buffer_size_in_initial_batch.cc
  ${_gRPC_ROOT}/test/core/end2end/tests/retry_exceeds_buffer_size_in_subsequent_batch.cc
  ${_gRPC_ROOT}/test/core/end2end/tests/retry_non_retriable_status.cc
  ${_gRPC_ROOT}/test/core/end2end/tests/retry_non_retriable_status_before_recv_trailing_metadata_started.cc
  ${_gRPC_ROOT}/test/core/end2end/tests/retry_recv_initial_metadata.cc
  ${_gRPC_ROOT}/test/core/end2end/tests/retry_recv_message.cc
  ${_gRPC_ROOT}/test/core/end2end/tests/retry_server_pushback_delay.cc
  ${_gRPC_ROOT}/test/core/end2end/tests/retry_server_pushback_disabled.cc
  ${_gRPC_ROOT}/test/core/end2end/tests/retry_streaming.cc
  ${_gRPC_ROOT}/test/core/end2end/tests/retry_streaming_after_commit.cc
  ${_gRPC_ROOT}/test/core/end2end/tests/retry_streaming_succeeds_before_replay_finished.cc
  ${_gRPC_ROOT}/test/core/end2end/tests/retry_throttled.cc
  ${_gRPC_ROOT}/test/core/end2end/tests/retry_too_many_attempts.cc
  ${_gRPC_ROOT}/test/core/end2end/tests/server_finishes_request.cc
  ${_gRPC_ROOT}/test/core/end2end/tests/shutdown_finishes_calls.cc
  ${_gRPC_ROOT}/test/core/end2end/tests/shutdown_finishes_tags.cc
  ${_gRPC_ROOT}/test/core/end2end/tests/simple_cacheable_request.cc
  ${_gRPC_ROOT}/test/core/end2end/tests/simple_delayed_request.cc
  ${_gRPC_ROOT}/test/core/end2end/tests/simple_metadata.cc
  ${_gRPC_ROOT}/test/core/end2end/tests/simple_request.cc
  ${_gRPC_ROOT}/test/core/end2end/tests/stream_compression_compressed_payload.cc
  ${_gRPC_ROOT}/test/core/end2end/tests/stream_compression_payload.cc
  ${_gRPC_ROOT}/test/core/end2end/tests/stream_compression_ping_pong_streaming.cc
  ${_gRPC_ROOT}/test/core/end2end/tests/streaming_error_response.cc
  ${_gRPC_ROOT}/test/core/end2end/tests/trailing_metadata.cc
  ${_gRPC_ROOT}/test/core/end2end/tests/workaround_cronet_compression.cc
  ${_gRPC_ROOT}/test/core/end2end/tests/write_buffering.cc
  ${_gRPC_ROOT}/test/core/end2end/tests/write_buffering_at_end.cc
)
android_add_library(end2end_tests)


target_compile_definitions(end2end_tests PRIVATE -DPB_FIELD_16BIT)
target_compile_definitions(end2end_tests PUBLIC  -DGRPC_ALLOW_EXCEPTIONS=0)
target_include_directories(end2end_tests
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

target_link_libraries(end2end_tests PRIVATE
  ssl
  crypto
  ${_gRPC_ALLTARGETS_LIBRARIES}
  grpc_test_util
  grpc
  gpr_test_util
  gpr
)

add_dependencies(end2end_tests project_benchmark project_gflags)

set(end2end_nosec_tests_src
  ${_gRPC_ROOT}/test/core/end2end/end2end_nosec_tests.cc
  ${_gRPC_ROOT}/test/core/end2end/end2end_test_utils.cc
  ${_gRPC_ROOT}/test/core/end2end/tests/authority_not_supported.cc
  ${_gRPC_ROOT}/test/core/end2end/tests/bad_hostname.cc
  ${_gRPC_ROOT}/test/core/end2end/tests/bad_ping.cc
  ${_gRPC_ROOT}/test/core/end2end/tests/binary_metadata.cc
  ${_gRPC_ROOT}/test/core/end2end/tests/call_host_override.cc
  ${_gRPC_ROOT}/test/core/end2end/tests/cancel_after_accept.cc
  ${_gRPC_ROOT}/test/core/end2end/tests/cancel_after_client_done.cc
  ${_gRPC_ROOT}/test/core/end2end/tests/cancel_after_invoke.cc
  ${_gRPC_ROOT}/test/core/end2end/tests/cancel_after_round_trip.cc
  ${_gRPC_ROOT}/test/core/end2end/tests/cancel_before_invoke.cc
  ${_gRPC_ROOT}/test/core/end2end/tests/cancel_in_a_vacuum.cc
  ${_gRPC_ROOT}/test/core/end2end/tests/cancel_with_status.cc
  ${_gRPC_ROOT}/test/core/end2end/tests/channelz.cc
  ${_gRPC_ROOT}/test/core/end2end/tests/compressed_payload.cc
  ${_gRPC_ROOT}/test/core/end2end/tests/connectivity.cc
  ${_gRPC_ROOT}/test/core/end2end/tests/default_host.cc
  ${_gRPC_ROOT}/test/core/end2end/tests/disappearing_server.cc
  ${_gRPC_ROOT}/test/core/end2end/tests/empty_batch.cc
  ${_gRPC_ROOT}/test/core/end2end/tests/filter_call_init_fails.cc
  ${_gRPC_ROOT}/test/core/end2end/tests/filter_causes_close.cc
  ${_gRPC_ROOT}/test/core/end2end/tests/filter_latency.cc
  ${_gRPC_ROOT}/test/core/end2end/tests/filter_status_code.cc
  ${_gRPC_ROOT}/test/core/end2end/tests/graceful_server_shutdown.cc
  ${_gRPC_ROOT}/test/core/end2end/tests/high_initial_seqno.cc
  ${_gRPC_ROOT}/test/core/end2end/tests/hpack_size.cc
  ${_gRPC_ROOT}/test/core/end2end/tests/idempotent_request.cc
  ${_gRPC_ROOT}/test/core/end2end/tests/invoke_large_request.cc
  ${_gRPC_ROOT}/test/core/end2end/tests/keepalive_timeout.cc
  ${_gRPC_ROOT}/test/core/end2end/tests/large_metadata.cc
  ${_gRPC_ROOT}/test/core/end2end/tests/max_concurrent_streams.cc
  ${_gRPC_ROOT}/test/core/end2end/tests/max_connection_age.cc
  ${_gRPC_ROOT}/test/core/end2end/tests/max_connection_idle.cc
  ${_gRPC_ROOT}/test/core/end2end/tests/max_message_length.cc
  ${_gRPC_ROOT}/test/core/end2end/tests/negative_deadline.cc
  ${_gRPC_ROOT}/test/core/end2end/tests/network_status_change.cc
  ${_gRPC_ROOT}/test/core/end2end/tests/no_error_on_hotpath.cc
  ${_gRPC_ROOT}/test/core/end2end/tests/no_logging.cc
  ${_gRPC_ROOT}/test/core/end2end/tests/no_op.cc
  ${_gRPC_ROOT}/test/core/end2end/tests/payload.cc
  ${_gRPC_ROOT}/test/core/end2end/tests/ping.cc
  ${_gRPC_ROOT}/test/core/end2end/tests/ping_pong_streaming.cc
  ${_gRPC_ROOT}/test/core/end2end/tests/proxy_auth.cc
  ${_gRPC_ROOT}/test/core/end2end/tests/registered_call.cc
  ${_gRPC_ROOT}/test/core/end2end/tests/request_with_flags.cc
  ${_gRPC_ROOT}/test/core/end2end/tests/request_with_payload.cc
  ${_gRPC_ROOT}/test/core/end2end/tests/resource_quota_server.cc
  ${_gRPC_ROOT}/test/core/end2end/tests/retry.cc
  ${_gRPC_ROOT}/test/core/end2end/tests/retry_cancellation.cc
  ${_gRPC_ROOT}/test/core/end2end/tests/retry_disabled.cc
  ${_gRPC_ROOT}/test/core/end2end/tests/retry_exceeds_buffer_size_in_initial_batch.cc
  ${_gRPC_ROOT}/test/core/end2end/tests/retry_exceeds_buffer_size_in_subsequent_batch.cc
  ${_gRPC_ROOT}/test/core/end2end/tests/retry_non_retriable_status.cc
  ${_gRPC_ROOT}/test/core/end2end/tests/retry_non_retriable_status_before_recv_trailing_metadata_started.cc
  ${_gRPC_ROOT}/test/core/end2end/tests/retry_recv_initial_metadata.cc
  ${_gRPC_ROOT}/test/core/end2end/tests/retry_recv_message.cc
  ${_gRPC_ROOT}/test/core/end2end/tests/retry_server_pushback_delay.cc
  ${_gRPC_ROOT}/test/core/end2end/tests/retry_server_pushback_disabled.cc
  ${_gRPC_ROOT}/test/core/end2end/tests/retry_streaming.cc
  ${_gRPC_ROOT}/test/core/end2end/tests/retry_streaming_after_commit.cc
  ${_gRPC_ROOT}/test/core/end2end/tests/retry_streaming_succeeds_before_replay_finished.cc
  ${_gRPC_ROOT}/test/core/end2end/tests/retry_throttled.cc
  ${_gRPC_ROOT}/test/core/end2end/tests/retry_too_many_attempts.cc
  ${_gRPC_ROOT}/test/core/end2end/tests/server_finishes_request.cc
  ${_gRPC_ROOT}/test/core/end2end/tests/shutdown_finishes_calls.cc
  ${_gRPC_ROOT}/test/core/end2end/tests/shutdown_finishes_tags.cc
  ${_gRPC_ROOT}/test/core/end2end/tests/simple_cacheable_request.cc
  ${_gRPC_ROOT}/test/core/end2end/tests/simple_delayed_request.cc
  ${_gRPC_ROOT}/test/core/end2end/tests/simple_metadata.cc
  ${_gRPC_ROOT}/test/core/end2end/tests/simple_request.cc
  ${_gRPC_ROOT}/test/core/end2end/tests/stream_compression_compressed_payload.cc
  ${_gRPC_ROOT}/test/core/end2end/tests/stream_compression_payload.cc
  ${_gRPC_ROOT}/test/core/end2end/tests/stream_compression_ping_pong_streaming.cc
  ${_gRPC_ROOT}/test/core/end2end/tests/streaming_error_response.cc
  ${_gRPC_ROOT}/test/core/end2end/tests/trailing_metadata.cc
  ${_gRPC_ROOT}/test/core/end2end/tests/workaround_cronet_compression.cc
  ${_gRPC_ROOT}/test/core/end2end/tests/write_buffering.cc
  ${_gRPC_ROOT}/test/core/end2end/tests/write_buffering_at_end.cc
)
android_add_library(end2end_nosec_tests)


target_compile_definitions(end2end_nosec_tests PRIVATE -DPB_FIELD_16BIT)
target_compile_definitions(end2end_nosec_tests PUBLIC  -DGRPC_ALLOW_EXCEPTIONS=0)
target_include_directories(end2end_nosec_tests
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

target_link_libraries(end2end_nosec_tests PRIVATE
  ${_gRPC_ALLTARGETS_LIBRARIES}
  grpc_test_util_unsecure
  grpc_unsecure
  gpr_test_util
  gpr
)

add_dependencies(end2end_nosec_tests project_benchmark project_gflags)


  set(algorithm_test_src
   ${_gRPC_ROOT}/test/core/compression/algorithm_test.cc
)
  android_add_executable(algorithm_test)

  target_compile_definitions(algorithm_test PRIVATE -DPB_FIELD_16BIT)
  target_compile_definitions(algorithm_test PUBLIC  -DGRPC_ALLOW_EXCEPTIONS=0)

  target_include_directories(algorithm_test
  PRIVATE ${_gRPC_ROOT}
  PRIVATE ${_gRPC_ROOT}/include
  PRIVATE ${_gRPC_SSL_INCLUDE_DIR}
  PRIVATE ${_gRPC_BENCHMARK_INCLUDE_DIR}
  PRIVATE ${_gRPC_GFLAGS_INCLUDE_DIR}
  PRIVATE ${_gRPC_PROTOBUF_INCLUDE_DIR}
  PRIVATE ${_gRPC_NANOPB_INCLUDE_DIR}
  PRIVATE ${_gRPC_ADDRESS_SORTING_INCLUDE_DIR}
)

  target_link_libraries(algorithm_test PRIVATE
  ${_gRPC_ALLTARGETS_LIBRARIES}
  grpc_test_util
  grpc
  gpr_test_util
  gpr
)

    add_dependencies(algorithm_test project_benchmark project_gflags)

  set(alloc_test_src
   ${_gRPC_ROOT}/test/core/gpr/alloc_test.cc
)
  android_add_executable(alloc_test)

  target_compile_definitions(alloc_test PRIVATE -DPB_FIELD_16BIT)
  target_compile_definitions(alloc_test PUBLIC  -DGRPC_ALLOW_EXCEPTIONS=0)

  target_include_directories(alloc_test
  PRIVATE ${_gRPC_ROOT}
  PRIVATE ${_gRPC_ROOT}/include
  PRIVATE ${_gRPC_SSL_INCLUDE_DIR}
  PRIVATE ${_gRPC_BENCHMARK_INCLUDE_DIR}
  PRIVATE ${_gRPC_GFLAGS_INCLUDE_DIR}
  PRIVATE ${_gRPC_PROTOBUF_INCLUDE_DIR}
  PRIVATE ${_gRPC_NANOPB_INCLUDE_DIR}
  PRIVATE ${_gRPC_ADDRESS_SORTING_INCLUDE_DIR}
)

  target_link_libraries(alloc_test PRIVATE
  ${_gRPC_ALLTARGETS_LIBRARIES}
  gpr_test_util
  gpr
)

    add_dependencies(alloc_test project_benchmark project_gflags)

  set(alpn_test_src
   ${_gRPC_ROOT}/test/core/transport/chttp2/alpn_test.cc
)
  android_add_executable(alpn_test)

  target_compile_definitions(alpn_test PRIVATE -DPB_FIELD_16BIT)
  target_compile_definitions(alpn_test PUBLIC  -DGRPC_ALLOW_EXCEPTIONS=0)

  target_include_directories(alpn_test
  PRIVATE ${_gRPC_ROOT}
  PRIVATE ${_gRPC_ROOT}/include
  PRIVATE ${_gRPC_SSL_INCLUDE_DIR}
  PRIVATE ${_gRPC_BENCHMARK_INCLUDE_DIR}
  PRIVATE ${_gRPC_GFLAGS_INCLUDE_DIR}
  PRIVATE ${_gRPC_PROTOBUF_INCLUDE_DIR}
  PRIVATE ${_gRPC_NANOPB_INCLUDE_DIR}
  PRIVATE ${_gRPC_ADDRESS_SORTING_INCLUDE_DIR}
)

  target_link_libraries(alpn_test PRIVATE
  ${_gRPC_ALLTARGETS_LIBRARIES}
  grpc_test_util
  grpc
  gpr_test_util
  gpr
)

    add_dependencies(alpn_test project_benchmark project_gflags)

  set(arena_test_src
   ${_gRPC_ROOT}/test/core/gpr/arena_test.cc
)
  android_add_executable(arena_test)

  target_compile_definitions(arena_test PRIVATE -DPB_FIELD_16BIT)
  target_compile_definitions(arena_test PUBLIC  -DGRPC_ALLOW_EXCEPTIONS=0)

  target_include_directories(arena_test
  PRIVATE ${_gRPC_ROOT}
  PRIVATE ${_gRPC_ROOT}/include
  PRIVATE ${_gRPC_SSL_INCLUDE_DIR}
  PRIVATE ${_gRPC_BENCHMARK_INCLUDE_DIR}
  PRIVATE ${_gRPC_GFLAGS_INCLUDE_DIR}
  PRIVATE ${_gRPC_PROTOBUF_INCLUDE_DIR}
  PRIVATE ${_gRPC_NANOPB_INCLUDE_DIR}
  PRIVATE ${_gRPC_ADDRESS_SORTING_INCLUDE_DIR}
)

  target_link_libraries(arena_test PRIVATE
  ${_gRPC_ALLTARGETS_LIBRARIES}
  gpr_test_util
  gpr
)

    add_dependencies(arena_test project_benchmark project_gflags)

  set(avl_test_src
   ${_gRPC_ROOT}/test/core/avl/avl_test.cc
)
  android_add_executable(avl_test)

  target_compile_definitions(avl_test PRIVATE -DPB_FIELD_16BIT)
  target_compile_definitions(avl_test PUBLIC  -DGRPC_ALLOW_EXCEPTIONS=0)

  target_include_directories(avl_test
  PRIVATE ${_gRPC_ROOT}
  PRIVATE ${_gRPC_ROOT}/include
  PRIVATE ${_gRPC_SSL_INCLUDE_DIR}
  PRIVATE ${_gRPC_BENCHMARK_INCLUDE_DIR}
  PRIVATE ${_gRPC_GFLAGS_INCLUDE_DIR}
  PRIVATE ${_gRPC_PROTOBUF_INCLUDE_DIR}
  PRIVATE ${_gRPC_NANOPB_INCLUDE_DIR}
  PRIVATE ${_gRPC_ADDRESS_SORTING_INCLUDE_DIR}
)

  target_link_libraries(avl_test PRIVATE
  ${_gRPC_ALLTARGETS_LIBRARIES}
  gpr_test_util
  gpr
  grpc
)

    add_dependencies(avl_test project_benchmark project_gflags)

  set(bad_server_response_test_src
   ${_gRPC_ROOT}/test/core/end2end/bad_server_response_test.cc
)
  android_add_executable(bad_server_response_test)

  target_compile_definitions(bad_server_response_test PRIVATE -DPB_FIELD_16BIT)
  target_compile_definitions(bad_server_response_test PUBLIC  -DGRPC_ALLOW_EXCEPTIONS=0)

  target_include_directories(bad_server_response_test
  PRIVATE ${_gRPC_ROOT}
  PRIVATE ${_gRPC_ROOT}/include
  PRIVATE ${_gRPC_SSL_INCLUDE_DIR}
  PRIVATE ${_gRPC_BENCHMARK_INCLUDE_DIR}
  PRIVATE ${_gRPC_GFLAGS_INCLUDE_DIR}
  PRIVATE ${_gRPC_PROTOBUF_INCLUDE_DIR}
  PRIVATE ${_gRPC_NANOPB_INCLUDE_DIR}
  PRIVATE ${_gRPC_ADDRESS_SORTING_INCLUDE_DIR}
)

  target_link_libraries(bad_server_response_test PRIVATE
  ${_gRPC_ALLTARGETS_LIBRARIES}
  test_tcp_server
  grpc_test_util
  grpc
  gpr_test_util
  gpr
)

    add_dependencies(bad_server_response_test project_benchmark project_gflags)

  set(bin_decoder_test_src
   ${_gRPC_ROOT}/test/core/transport/chttp2/bin_decoder_test.cc
)
  android_add_executable(bin_decoder_test)

  target_compile_definitions(bin_decoder_test PRIVATE -DPB_FIELD_16BIT)
  target_compile_definitions(bin_decoder_test PUBLIC  -DGRPC_ALLOW_EXCEPTIONS=0)

  target_include_directories(bin_decoder_test
  PRIVATE ${_gRPC_ROOT}
  PRIVATE ${_gRPC_ROOT}/include
  PRIVATE ${_gRPC_SSL_INCLUDE_DIR}
  PRIVATE ${_gRPC_BENCHMARK_INCLUDE_DIR}
  PRIVATE ${_gRPC_GFLAGS_INCLUDE_DIR}
  PRIVATE ${_gRPC_PROTOBUF_INCLUDE_DIR}
  PRIVATE ${_gRPC_NANOPB_INCLUDE_DIR}
  PRIVATE ${_gRPC_ADDRESS_SORTING_INCLUDE_DIR}
)

  target_link_libraries(bin_decoder_test PRIVATE
  ${_gRPC_ALLTARGETS_LIBRARIES}
  grpc_test_util
  grpc
)

    add_dependencies(bin_decoder_test project_benchmark project_gflags)

  set(bin_encoder_test_src
   ${_gRPC_ROOT}/test/core/transport/chttp2/bin_encoder_test.cc
)
  android_add_executable(bin_encoder_test)

  target_compile_definitions(bin_encoder_test PRIVATE -DPB_FIELD_16BIT)
  target_compile_definitions(bin_encoder_test PUBLIC  -DGRPC_ALLOW_EXCEPTIONS=0)

  target_include_directories(bin_encoder_test
  PRIVATE ${_gRPC_ROOT}
  PRIVATE ${_gRPC_ROOT}/include
  PRIVATE ${_gRPC_SSL_INCLUDE_DIR}
  PRIVATE ${_gRPC_BENCHMARK_INCLUDE_DIR}
  PRIVATE ${_gRPC_GFLAGS_INCLUDE_DIR}
  PRIVATE ${_gRPC_PROTOBUF_INCLUDE_DIR}
  PRIVATE ${_gRPC_NANOPB_INCLUDE_DIR}
  PRIVATE ${_gRPC_ADDRESS_SORTING_INCLUDE_DIR}
)

  target_link_libraries(bin_encoder_test PRIVATE
  ${_gRPC_ALLTARGETS_LIBRARIES}
  grpc_test_util
  grpc
)

    add_dependencies(bin_encoder_test project_benchmark project_gflags)
if(_gRPC_PLATFORM_LINUX)

  set(buffer_list_test_src
   ${_gRPC_ROOT}/test/core/iomgr/buffer_list_test.cc
)
  android_add_executable(buffer_list_test)

  target_compile_definitions(buffer_list_test PRIVATE -DPB_FIELD_16BIT)
  target_compile_definitions(buffer_list_test PUBLIC  -DGRPC_ALLOW_EXCEPTIONS=0)

  target_include_directories(buffer_list_test
  PRIVATE ${_gRPC_ROOT}
  PRIVATE ${_gRPC_ROOT}/include
  PRIVATE ${_gRPC_SSL_INCLUDE_DIR}
  PRIVATE ${_gRPC_BENCHMARK_INCLUDE_DIR}
  PRIVATE ${_gRPC_GFLAGS_INCLUDE_DIR}
  PRIVATE ${_gRPC_PROTOBUF_INCLUDE_DIR}
  PRIVATE ${_gRPC_NANOPB_INCLUDE_DIR}
  PRIVATE ${_gRPC_ADDRESS_SORTING_INCLUDE_DIR}
)

  target_link_libraries(buffer_list_test PRIVATE
  ${_gRPC_ALLTARGETS_LIBRARIES}
  grpc_test_util
  grpc
  gpr_test_util
  gpr
)

    add_dependencies(buffer_list_test project_benchmark project_gflags)
endif()

  set(channel_create_test_src
   ${_gRPC_ROOT}/test/core/surface/channel_create_test.cc
)
  android_add_executable(channel_create_test)

  target_compile_definitions(channel_create_test PRIVATE -DPB_FIELD_16BIT)
  target_compile_definitions(channel_create_test PUBLIC  -DGRPC_ALLOW_EXCEPTIONS=0)

  target_include_directories(channel_create_test
  PRIVATE ${_gRPC_ROOT}
  PRIVATE ${_gRPC_ROOT}/include
  PRIVATE ${_gRPC_SSL_INCLUDE_DIR}
  PRIVATE ${_gRPC_BENCHMARK_INCLUDE_DIR}
  PRIVATE ${_gRPC_GFLAGS_INCLUDE_DIR}
  PRIVATE ${_gRPC_PROTOBUF_INCLUDE_DIR}
  PRIVATE ${_gRPC_NANOPB_INCLUDE_DIR}
  PRIVATE ${_gRPC_ADDRESS_SORTING_INCLUDE_DIR}
)

  target_link_libraries(channel_create_test PRIVATE
  ${_gRPC_ALLTARGETS_LIBRARIES}
  grpc_test_util
  grpc
  gpr_test_util
  gpr
)

    add_dependencies(channel_create_test project_benchmark project_gflags)

  set(chttp2_hpack_encoder_test_src
   ${_gRPC_ROOT}/test/core/transport/chttp2/hpack_encoder_test.cc
)
  android_add_executable(chttp2_hpack_encoder_test)

  target_compile_definitions(chttp2_hpack_encoder_test PRIVATE -DPB_FIELD_16BIT)
  target_compile_definitions(chttp2_hpack_encoder_test PUBLIC  -DGRPC_ALLOW_EXCEPTIONS=0)

  target_include_directories(chttp2_hpack_encoder_test
  PRIVATE ${_gRPC_ROOT}
  PRIVATE ${_gRPC_ROOT}/include
  PRIVATE ${_gRPC_SSL_INCLUDE_DIR}
  PRIVATE ${_gRPC_BENCHMARK_INCLUDE_DIR}
  PRIVATE ${_gRPC_GFLAGS_INCLUDE_DIR}
  PRIVATE ${_gRPC_PROTOBUF_INCLUDE_DIR}
  PRIVATE ${_gRPC_NANOPB_INCLUDE_DIR}
  PRIVATE ${_gRPC_ADDRESS_SORTING_INCLUDE_DIR}
)

  target_link_libraries(chttp2_hpack_encoder_test PRIVATE
  ${_gRPC_ALLTARGETS_LIBRARIES}
  grpc_test_util
  grpc
  gpr_test_util
  gpr
)

    add_dependencies(chttp2_hpack_encoder_test project_benchmark project_gflags)

  set(chttp2_stream_map_test_src
   ${_gRPC_ROOT}/test/core/transport/chttp2/stream_map_test.cc
)
  android_add_executable(chttp2_stream_map_test)

  target_compile_definitions(chttp2_stream_map_test PRIVATE -DPB_FIELD_16BIT)
  target_compile_definitions(chttp2_stream_map_test PUBLIC  -DGRPC_ALLOW_EXCEPTIONS=0)

  target_include_directories(chttp2_stream_map_test
  PRIVATE ${_gRPC_ROOT}
  PRIVATE ${_gRPC_ROOT}/include
  PRIVATE ${_gRPC_SSL_INCLUDE_DIR}
  PRIVATE ${_gRPC_BENCHMARK_INCLUDE_DIR}
  PRIVATE ${_gRPC_GFLAGS_INCLUDE_DIR}
  PRIVATE ${_gRPC_PROTOBUF_INCLUDE_DIR}
  PRIVATE ${_gRPC_NANOPB_INCLUDE_DIR}
  PRIVATE ${_gRPC_ADDRESS_SORTING_INCLUDE_DIR}
)

  target_link_libraries(chttp2_stream_map_test PRIVATE
  ${_gRPC_ALLTARGETS_LIBRARIES}
  grpc_test_util
  grpc
  gpr_test_util
  gpr
)

    add_dependencies(chttp2_stream_map_test project_benchmark project_gflags)

  set(chttp2_varint_test_src
   ${_gRPC_ROOT}/test/core/transport/chttp2/varint_test.cc
)
  android_add_executable(chttp2_varint_test)

  target_compile_definitions(chttp2_varint_test PRIVATE -DPB_FIELD_16BIT)
  target_compile_definitions(chttp2_varint_test PUBLIC  -DGRPC_ALLOW_EXCEPTIONS=0)

  target_include_directories(chttp2_varint_test
  PRIVATE ${_gRPC_ROOT}
  PRIVATE ${_gRPC_ROOT}/include
  PRIVATE ${_gRPC_SSL_INCLUDE_DIR}
  PRIVATE ${_gRPC_BENCHMARK_INCLUDE_DIR}
  PRIVATE ${_gRPC_GFLAGS_INCLUDE_DIR}
  PRIVATE ${_gRPC_PROTOBUF_INCLUDE_DIR}
  PRIVATE ${_gRPC_NANOPB_INCLUDE_DIR}
  PRIVATE ${_gRPC_ADDRESS_SORTING_INCLUDE_DIR}
)

  target_link_libraries(chttp2_varint_test PRIVATE
  ${_gRPC_ALLTARGETS_LIBRARIES}
  grpc_test_util
  grpc
  gpr_test_util
  gpr
)

    add_dependencies(chttp2_varint_test project_benchmark project_gflags)

  set(cmdline_test_src
   ${_gRPC_ROOT}/test/core/util/cmdline_test.cc
)
  android_add_executable(cmdline_test)

  target_compile_definitions(cmdline_test PRIVATE -DPB_FIELD_16BIT)
  target_compile_definitions(cmdline_test PUBLIC  -DGRPC_ALLOW_EXCEPTIONS=0)

  target_include_directories(cmdline_test
  PRIVATE ${_gRPC_ROOT}
  PRIVATE ${_gRPC_ROOT}/include
  PRIVATE ${_gRPC_SSL_INCLUDE_DIR}
  PRIVATE ${_gRPC_BENCHMARK_INCLUDE_DIR}
  PRIVATE ${_gRPC_GFLAGS_INCLUDE_DIR}
  PRIVATE ${_gRPC_PROTOBUF_INCLUDE_DIR}
  PRIVATE ${_gRPC_NANOPB_INCLUDE_DIR}
  PRIVATE ${_gRPC_ADDRESS_SORTING_INCLUDE_DIR}
)

  target_link_libraries(cmdline_test PRIVATE
  ${_gRPC_ALLTARGETS_LIBRARIES}
  gpr
  gpr_test_util
  grpc_test_util
)

    add_dependencies(cmdline_test project_benchmark project_gflags)

  set(combiner_test_src
   ${_gRPC_ROOT}/test/core/iomgr/combiner_test.cc
)
  android_add_executable(combiner_test)

  target_compile_definitions(combiner_test PRIVATE -DPB_FIELD_16BIT)
  target_compile_definitions(combiner_test PUBLIC  -DGRPC_ALLOW_EXCEPTIONS=0)

  target_include_directories(combiner_test
  PRIVATE ${_gRPC_ROOT}
  PRIVATE ${_gRPC_ROOT}/include
  PRIVATE ${_gRPC_SSL_INCLUDE_DIR}
  PRIVATE ${_gRPC_BENCHMARK_INCLUDE_DIR}
  PRIVATE ${_gRPC_GFLAGS_INCLUDE_DIR}
  PRIVATE ${_gRPC_PROTOBUF_INCLUDE_DIR}
  PRIVATE ${_gRPC_NANOPB_INCLUDE_DIR}
  PRIVATE ${_gRPC_ADDRESS_SORTING_INCLUDE_DIR}
)

  target_link_libraries(combiner_test PRIVATE
  ${_gRPC_ALLTARGETS_LIBRARIES}
  grpc_test_util
  grpc
  gpr_test_util
  gpr
)

    add_dependencies(combiner_test project_benchmark project_gflags)

  set(compression_test_src
   ${_gRPC_ROOT}/test/core/compression/compression_test.cc
)
  android_add_executable(compression_test)

  target_compile_definitions(compression_test PRIVATE -DPB_FIELD_16BIT)
  target_compile_definitions(compression_test PUBLIC  -DGRPC_ALLOW_EXCEPTIONS=0)

  target_include_directories(compression_test
  PRIVATE ${_gRPC_ROOT}
  PRIVATE ${_gRPC_ROOT}/include
  PRIVATE ${_gRPC_SSL_INCLUDE_DIR}
  PRIVATE ${_gRPC_BENCHMARK_INCLUDE_DIR}
  PRIVATE ${_gRPC_GFLAGS_INCLUDE_DIR}
  PRIVATE ${_gRPC_PROTOBUF_INCLUDE_DIR}
  PRIVATE ${_gRPC_NANOPB_INCLUDE_DIR}
  PRIVATE ${_gRPC_ADDRESS_SORTING_INCLUDE_DIR}
)

  target_link_libraries(compression_test PRIVATE
  ${_gRPC_ALLTARGETS_LIBRARIES}
  grpc_test_util
  grpc
  gpr_test_util
  gpr
)

    add_dependencies(compression_test project_benchmark project_gflags)

  set(concurrent_connectivity_test_src
   ${_gRPC_ROOT}/test/core/surface/concurrent_connectivity_test.cc
)
  android_add_executable(concurrent_connectivity_test)

  target_compile_definitions(concurrent_connectivity_test PRIVATE -DPB_FIELD_16BIT)
  target_compile_definitions(concurrent_connectivity_test PUBLIC  -DGRPC_ALLOW_EXCEPTIONS=0)

  target_include_directories(concurrent_connectivity_test
  PRIVATE ${_gRPC_ROOT}
  PRIVATE ${_gRPC_ROOT}/include
  PRIVATE ${_gRPC_SSL_INCLUDE_DIR}
  PRIVATE ${_gRPC_BENCHMARK_INCLUDE_DIR}
  PRIVATE ${_gRPC_GFLAGS_INCLUDE_DIR}
  PRIVATE ${_gRPC_PROTOBUF_INCLUDE_DIR}
  PRIVATE ${_gRPC_NANOPB_INCLUDE_DIR}
  PRIVATE ${_gRPC_ADDRESS_SORTING_INCLUDE_DIR}
)

  target_link_libraries(concurrent_connectivity_test PRIVATE
  ${_gRPC_ALLTARGETS_LIBRARIES}
  grpc_test_util
  grpc
  gpr_test_util
  gpr
)

    add_dependencies(concurrent_connectivity_test project_benchmark project_gflags)

  set(connection_refused_test_src
   ${_gRPC_ROOT}/test/core/end2end/connection_refused_test.cc
)
  android_add_executable(connection_refused_test)

  target_compile_definitions(connection_refused_test PRIVATE -DPB_FIELD_16BIT)
  target_compile_definitions(connection_refused_test PUBLIC  -DGRPC_ALLOW_EXCEPTIONS=0)

  target_include_directories(connection_refused_test
  PRIVATE ${_gRPC_ROOT}
  PRIVATE ${_gRPC_ROOT}/include
  PRIVATE ${_gRPC_SSL_INCLUDE_DIR}
  PRIVATE ${_gRPC_BENCHMARK_INCLUDE_DIR}
  PRIVATE ${_gRPC_GFLAGS_INCLUDE_DIR}
  PRIVATE ${_gRPC_PROTOBUF_INCLUDE_DIR}
  PRIVATE ${_gRPC_NANOPB_INCLUDE_DIR}
  PRIVATE ${_gRPC_ADDRESS_SORTING_INCLUDE_DIR}
)

  target_link_libraries(connection_refused_test PRIVATE
  ${_gRPC_ALLTARGETS_LIBRARIES}
  grpc_test_util
  grpc
  gpr_test_util
  gpr
)

    add_dependencies(connection_refused_test project_benchmark project_gflags)

  set(dns_resolver_connectivity_test_src
   ${_gRPC_ROOT}/test/core/client_channel/resolvers/dns_resolver_connectivity_test.cc
)
  android_add_executable(dns_resolver_connectivity_test)

  target_compile_definitions(dns_resolver_connectivity_test PRIVATE -DPB_FIELD_16BIT)
  target_compile_definitions(dns_resolver_connectivity_test PUBLIC  -DGRPC_ALLOW_EXCEPTIONS=0)

  target_include_directories(dns_resolver_connectivity_test
  PRIVATE ${_gRPC_ROOT}
  PRIVATE ${_gRPC_ROOT}/include
  PRIVATE ${_gRPC_SSL_INCLUDE_DIR}
  PRIVATE ${_gRPC_BENCHMARK_INCLUDE_DIR}
  PRIVATE ${_gRPC_GFLAGS_INCLUDE_DIR}
  PRIVATE ${_gRPC_PROTOBUF_INCLUDE_DIR}
  PRIVATE ${_gRPC_NANOPB_INCLUDE_DIR}
  PRIVATE ${_gRPC_ADDRESS_SORTING_INCLUDE_DIR}
)

  target_link_libraries(dns_resolver_connectivity_test PRIVATE
  ${_gRPC_ALLTARGETS_LIBRARIES}
  grpc_test_util
  grpc
  gpr_test_util
  gpr
)

    add_dependencies(dns_resolver_connectivity_test project_benchmark project_gflags)

  set(dns_resolver_cooldown_test_src
   ${_gRPC_ROOT}/test/core/client_channel/resolvers/dns_resolver_cooldown_test.cc
)
  android_add_executable(dns_resolver_cooldown_test)

  target_compile_definitions(dns_resolver_cooldown_test PRIVATE -DPB_FIELD_16BIT)
  target_compile_definitions(dns_resolver_cooldown_test PUBLIC  -DGRPC_ALLOW_EXCEPTIONS=0)

  target_include_directories(dns_resolver_cooldown_test
  PRIVATE ${_gRPC_ROOT}
  PRIVATE ${_gRPC_ROOT}/include
  PRIVATE ${_gRPC_SSL_INCLUDE_DIR}
  PRIVATE ${_gRPC_BENCHMARK_INCLUDE_DIR}
  PRIVATE ${_gRPC_GFLAGS_INCLUDE_DIR}
  PRIVATE ${_gRPC_PROTOBUF_INCLUDE_DIR}
  PRIVATE ${_gRPC_NANOPB_INCLUDE_DIR}
  PRIVATE ${_gRPC_ADDRESS_SORTING_INCLUDE_DIR}
)

  target_link_libraries(dns_resolver_cooldown_test PRIVATE
  ${_gRPC_ALLTARGETS_LIBRARIES}
  grpc_test_util
  grpc
  gpr_test_util
  gpr
)

    add_dependencies(dns_resolver_cooldown_test project_benchmark project_gflags)

  set(dns_resolver_test_src
   ${_gRPC_ROOT}/test/core/client_channel/resolvers/dns_resolver_test.cc
)
  android_add_executable(dns_resolver_test)

  target_compile_definitions(dns_resolver_test PRIVATE -DPB_FIELD_16BIT)
  target_compile_definitions(dns_resolver_test PUBLIC  -DGRPC_ALLOW_EXCEPTIONS=0)

  target_include_directories(dns_resolver_test
  PRIVATE ${_gRPC_ROOT}
  PRIVATE ${_gRPC_ROOT}/include
  PRIVATE ${_gRPC_SSL_INCLUDE_DIR}
  PRIVATE ${_gRPC_BENCHMARK_INCLUDE_DIR}
  PRIVATE ${_gRPC_GFLAGS_INCLUDE_DIR}
  PRIVATE ${_gRPC_PROTOBUF_INCLUDE_DIR}
  PRIVATE ${_gRPC_NANOPB_INCLUDE_DIR}
  PRIVATE ${_gRPC_ADDRESS_SORTING_INCLUDE_DIR}
)

  target_link_libraries(dns_resolver_test PRIVATE
  ${_gRPC_ALLTARGETS_LIBRARIES}
  grpc_test_util
  grpc
  gpr_test_util
  gpr
)

    add_dependencies(dns_resolver_test project_benchmark project_gflags)
if(_gRPC_PLATFORM_LINUX OR _gRPC_PLATFORM_MAC OR _gRPC_PLATFORM_POSIX)

  set(dualstack_socket_test_src
   ${_gRPC_ROOT}/test/core/end2end/dualstack_socket_test.cc
)
  android_add_executable(dualstack_socket_test)

  target_compile_definitions(dualstack_socket_test PRIVATE -DPB_FIELD_16BIT)
  target_compile_definitions(dualstack_socket_test PUBLIC  -DGRPC_ALLOW_EXCEPTIONS=0)

  target_include_directories(dualstack_socket_test
  PRIVATE ${_gRPC_ROOT}
  PRIVATE ${_gRPC_ROOT}/include
  PRIVATE ${_gRPC_SSL_INCLUDE_DIR}
  PRIVATE ${_gRPC_BENCHMARK_INCLUDE_DIR}
  PRIVATE ${_gRPC_GFLAGS_INCLUDE_DIR}
  PRIVATE ${_gRPC_PROTOBUF_INCLUDE_DIR}
  PRIVATE ${_gRPC_NANOPB_INCLUDE_DIR}
  PRIVATE ${_gRPC_ADDRESS_SORTING_INCLUDE_DIR}
)

  target_link_libraries(dualstack_socket_test PRIVATE
  ${_gRPC_ALLTARGETS_LIBRARIES}
  grpc_test_util
  grpc
  gpr_test_util
  gpr
)

    add_dependencies(dualstack_socket_test project_benchmark project_gflags)
endif()

  set(endpoint_pair_test_src
   ${_gRPC_ROOT}/test/core/iomgr/endpoint_pair_test.cc
)
  android_add_executable(endpoint_pair_test)

  target_compile_definitions(endpoint_pair_test PRIVATE -DPB_FIELD_16BIT)
  target_compile_definitions(endpoint_pair_test PUBLIC  -DGRPC_ALLOW_EXCEPTIONS=0)

  target_include_directories(endpoint_pair_test
  PRIVATE ${_gRPC_ROOT}
  PRIVATE ${_gRPC_ROOT}/include
  PRIVATE ${_gRPC_SSL_INCLUDE_DIR}
  PRIVATE ${_gRPC_BENCHMARK_INCLUDE_DIR}
  PRIVATE ${_gRPC_GFLAGS_INCLUDE_DIR}
  PRIVATE ${_gRPC_PROTOBUF_INCLUDE_DIR}
  PRIVATE ${_gRPC_NANOPB_INCLUDE_DIR}
  PRIVATE ${_gRPC_ADDRESS_SORTING_INCLUDE_DIR}
)

  target_link_libraries(endpoint_pair_test PRIVATE
  ${_gRPC_ALLTARGETS_LIBRARIES}
  grpc_test_util
  grpc
  gpr_test_util
  gpr
)

    add_dependencies(endpoint_pair_test project_benchmark project_gflags)

  set(error_test_src
   ${_gRPC_ROOT}/test/core/iomgr/error_test.cc
)
  android_add_executable(error_test)

  target_compile_definitions(error_test PRIVATE -DPB_FIELD_16BIT)
  target_compile_definitions(error_test PUBLIC  -DGRPC_ALLOW_EXCEPTIONS=0)

  target_include_directories(error_test
  PRIVATE ${_gRPC_ROOT}
  PRIVATE ${_gRPC_ROOT}/include
  PRIVATE ${_gRPC_SSL_INCLUDE_DIR}
  PRIVATE ${_gRPC_BENCHMARK_INCLUDE_DIR}
  PRIVATE ${_gRPC_GFLAGS_INCLUDE_DIR}
  PRIVATE ${_gRPC_PROTOBUF_INCLUDE_DIR}
  PRIVATE ${_gRPC_NANOPB_INCLUDE_DIR}
  PRIVATE ${_gRPC_ADDRESS_SORTING_INCLUDE_DIR}
)

  target_link_libraries(error_test PRIVATE
  ${_gRPC_ALLTARGETS_LIBRARIES}
  grpc_test_util
  grpc
  gpr_test_util
  gpr
)

    add_dependencies(error_test project_benchmark project_gflags)
if(_gRPC_PLATFORM_LINUX)

  set(ev_epollex_linux_test_src
   ${_gRPC_ROOT}/test/core/iomgr/ev_epollex_linux_test.cc
)
  android_add_executable(ev_epollex_linux_test)

  target_compile_definitions(ev_epollex_linux_test PRIVATE -DPB_FIELD_16BIT)
  target_compile_definitions(ev_epollex_linux_test PUBLIC  -DGRPC_ALLOW_EXCEPTIONS=0)

  target_include_directories(ev_epollex_linux_test
  PRIVATE ${_gRPC_ROOT}
  PRIVATE ${_gRPC_ROOT}/include
  PRIVATE ${_gRPC_SSL_INCLUDE_DIR}
  PRIVATE ${_gRPC_BENCHMARK_INCLUDE_DIR}
  PRIVATE ${_gRPC_GFLAGS_INCLUDE_DIR}
  PRIVATE ${_gRPC_PROTOBUF_INCLUDE_DIR}
  PRIVATE ${_gRPC_NANOPB_INCLUDE_DIR}
  PRIVATE ${_gRPC_ADDRESS_SORTING_INCLUDE_DIR}
)

  target_link_libraries(ev_epollex_linux_test PRIVATE
  ${_gRPC_ALLTARGETS_LIBRARIES}
  grpc_test_util
  grpc
  gpr_test_util
  gpr
)

    add_dependencies(ev_epollex_linux_test project_benchmark project_gflags)
endif()
if(_gRPC_PLATFORM_LINUX)

  set(ev_epollsig_linux_test_src
   ${_gRPC_ROOT}/test/core/iomgr/ev_epollsig_linux_test.cc
)
  android_add_executable(ev_epollsig_linux_test)

  target_compile_definitions(ev_epollsig_linux_test PRIVATE -DPB_FIELD_16BIT)
  target_compile_definitions(ev_epollsig_linux_test PUBLIC  -DGRPC_ALLOW_EXCEPTIONS=0)

  target_include_directories(ev_epollsig_linux_test
  PRIVATE ${_gRPC_ROOT}
  PRIVATE ${_gRPC_ROOT}/include
  PRIVATE ${_gRPC_SSL_INCLUDE_DIR}
  PRIVATE ${_gRPC_BENCHMARK_INCLUDE_DIR}
  PRIVATE ${_gRPC_GFLAGS_INCLUDE_DIR}
  PRIVATE ${_gRPC_PROTOBUF_INCLUDE_DIR}
  PRIVATE ${_gRPC_NANOPB_INCLUDE_DIR}
  PRIVATE ${_gRPC_ADDRESS_SORTING_INCLUDE_DIR}
)

  target_link_libraries(ev_epollsig_linux_test PRIVATE
  ${_gRPC_ALLTARGETS_LIBRARIES}
  grpc_test_util
  grpc
  gpr_test_util
  gpr
)

    add_dependencies(ev_epollsig_linux_test project_benchmark project_gflags)
endif()

  set(fake_resolver_test_src
   ${_gRPC_ROOT}/test/core/client_channel/resolvers/fake_resolver_test.cc
)
  android_add_executable(fake_resolver_test)

  target_compile_definitions(fake_resolver_test PRIVATE -DPB_FIELD_16BIT)
  target_compile_definitions(fake_resolver_test PUBLIC  -DGRPC_ALLOW_EXCEPTIONS=0)

  target_include_directories(fake_resolver_test
  PRIVATE ${_gRPC_ROOT}
  PRIVATE ${_gRPC_ROOT}/include
  PRIVATE ${_gRPC_SSL_INCLUDE_DIR}
  PRIVATE ${_gRPC_BENCHMARK_INCLUDE_DIR}
  PRIVATE ${_gRPC_GFLAGS_INCLUDE_DIR}
  PRIVATE ${_gRPC_PROTOBUF_INCLUDE_DIR}
  PRIVATE ${_gRPC_NANOPB_INCLUDE_DIR}
  PRIVATE ${_gRPC_ADDRESS_SORTING_INCLUDE_DIR}
)

  target_link_libraries(fake_resolver_test PRIVATE
  ${_gRPC_ALLTARGETS_LIBRARIES}
  grpc_test_util
  grpc
  gpr_test_util
  gpr
)

    add_dependencies(fake_resolver_test project_benchmark project_gflags)
if(_gRPC_PLATFORM_LINUX OR _gRPC_PLATFORM_MAC OR _gRPC_PLATFORM_POSIX)

  set(fake_transport_security_test_src
   ${_gRPC_ROOT}/test/core/tsi/fake_transport_security_test.cc
   ${_gRPC_ROOT}/test/core/tsi/transport_security_test_lib.cc
)
  android_add_executable(fake_transport_security_test)

  target_compile_definitions(fake_transport_security_test PRIVATE -DPB_FIELD_16BIT)
  target_compile_definitions(fake_transport_security_test PUBLIC  -DGRPC_ALLOW_EXCEPTIONS=0)

  target_include_directories(fake_transport_security_test
  PRIVATE ${_gRPC_ROOT}
  PRIVATE ${_gRPC_ROOT}/include
  PRIVATE ${_gRPC_SSL_INCLUDE_DIR}
  PRIVATE ${_gRPC_BENCHMARK_INCLUDE_DIR}
  PRIVATE ${_gRPC_GFLAGS_INCLUDE_DIR}
  PRIVATE ${_gRPC_PROTOBUF_INCLUDE_DIR}
  PRIVATE ${_gRPC_NANOPB_INCLUDE_DIR}
  PRIVATE ${_gRPC_ADDRESS_SORTING_INCLUDE_DIR}
)

  target_link_libraries(fake_transport_security_test PRIVATE
  ${_gRPC_ALLTARGETS_LIBRARIES}
  gpr_test_util
  gpr
  grpc
)

    add_dependencies(fake_transport_security_test project_benchmark project_gflags)
endif()
if(_gRPC_PLATFORM_LINUX OR _gRPC_PLATFORM_MAC OR _gRPC_PLATFORM_POSIX)

  set(fd_conservation_posix_test_src
   ${_gRPC_ROOT}/test/core/iomgr/fd_conservation_posix_test.cc
)
  android_add_executable(fd_conservation_posix_test)

  target_compile_definitions(fd_conservation_posix_test PRIVATE -DPB_FIELD_16BIT)
  target_compile_definitions(fd_conservation_posix_test PUBLIC  -DGRPC_ALLOW_EXCEPTIONS=0)

  target_include_directories(fd_conservation_posix_test
  PRIVATE ${_gRPC_ROOT}
  PRIVATE ${_gRPC_ROOT}/include
  PRIVATE ${_gRPC_SSL_INCLUDE_DIR}
  PRIVATE ${_gRPC_BENCHMARK_INCLUDE_DIR}
  PRIVATE ${_gRPC_GFLAGS_INCLUDE_DIR}
  PRIVATE ${_gRPC_PROTOBUF_INCLUDE_DIR}
  PRIVATE ${_gRPC_NANOPB_INCLUDE_DIR}
  PRIVATE ${_gRPC_ADDRESS_SORTING_INCLUDE_DIR}
)

  target_link_libraries(fd_conservation_posix_test PRIVATE
  ${_gRPC_ALLTARGETS_LIBRARIES}
  grpc_test_util
  grpc
  gpr_test_util
  gpr
)

    add_dependencies(fd_conservation_posix_test project_benchmark project_gflags)
endif()
if(_gRPC_PLATFORM_LINUX OR _gRPC_PLATFORM_MAC OR _gRPC_PLATFORM_POSIX)

  set(fd_posix_test_src
   ${_gRPC_ROOT}/test/core/iomgr/fd_posix_test.cc
)
  android_add_executable(fd_posix_test)

  target_compile_definitions(fd_posix_test PRIVATE -DPB_FIELD_16BIT)
  target_compile_definitions(fd_posix_test PUBLIC  -DGRPC_ALLOW_EXCEPTIONS=0)

  target_include_directories(fd_posix_test
  PRIVATE ${_gRPC_ROOT}
  PRIVATE ${_gRPC_ROOT}/include
  PRIVATE ${_gRPC_SSL_INCLUDE_DIR}
  PRIVATE ${_gRPC_BENCHMARK_INCLUDE_DIR}
  PRIVATE ${_gRPC_GFLAGS_INCLUDE_DIR}
  PRIVATE ${_gRPC_PROTOBUF_INCLUDE_DIR}
  PRIVATE ${_gRPC_NANOPB_INCLUDE_DIR}
  PRIVATE ${_gRPC_ADDRESS_SORTING_INCLUDE_DIR}
)

  target_link_libraries(fd_posix_test PRIVATE
  ${_gRPC_ALLTARGETS_LIBRARIES}
  grpc_test_util
  grpc
  gpr_test_util
  gpr
)

    add_dependencies(fd_posix_test project_benchmark project_gflags)
endif()

  set(fling_client_src
   ${_gRPC_ROOT}/test/core/fling/client.cc
)
  android_add_executable(fling_client)

  target_compile_definitions(fling_client PRIVATE -DPB_FIELD_16BIT)
  target_compile_definitions(fling_client PUBLIC  -DGRPC_ALLOW_EXCEPTIONS=0)

  target_include_directories(fling_client
  PRIVATE ${_gRPC_ROOT}
  PRIVATE ${_gRPC_ROOT}/include
  PRIVATE ${_gRPC_SSL_INCLUDE_DIR}
  PRIVATE ${_gRPC_BENCHMARK_INCLUDE_DIR}
  PRIVATE ${_gRPC_GFLAGS_INCLUDE_DIR}
  PRIVATE ${_gRPC_PROTOBUF_INCLUDE_DIR}
  PRIVATE ${_gRPC_NANOPB_INCLUDE_DIR}
  PRIVATE ${_gRPC_ADDRESS_SORTING_INCLUDE_DIR}
)

  target_link_libraries(fling_client PRIVATE
  ${_gRPC_ALLTARGETS_LIBRARIES}
  grpc_test_util
  grpc
  gpr_test_util
  gpr
)

    add_dependencies(fling_client project_benchmark project_gflags)

  set(fling_server_src
   ${_gRPC_ROOT}/test/core/fling/server.cc
)
  android_add_executable(fling_server)

  target_compile_definitions(fling_server PRIVATE -DPB_FIELD_16BIT)
  target_compile_definitions(fling_server PUBLIC  -DGRPC_ALLOW_EXCEPTIONS=0)

  target_include_directories(fling_server
  PRIVATE ${_gRPC_ROOT}
  PRIVATE ${_gRPC_ROOT}/include
  PRIVATE ${_gRPC_SSL_INCLUDE_DIR}
  PRIVATE ${_gRPC_BENCHMARK_INCLUDE_DIR}
  PRIVATE ${_gRPC_GFLAGS_INCLUDE_DIR}
  PRIVATE ${_gRPC_PROTOBUF_INCLUDE_DIR}
  PRIVATE ${_gRPC_NANOPB_INCLUDE_DIR}
  PRIVATE ${_gRPC_ADDRESS_SORTING_INCLUDE_DIR}
)

  target_link_libraries(fling_server PRIVATE
  ${_gRPC_ALLTARGETS_LIBRARIES}
  grpc_test_util
  grpc
  gpr_test_util
  gpr
)

    add_dependencies(fling_server project_benchmark project_gflags)
if(_gRPC_PLATFORM_LINUX OR _gRPC_PLATFORM_MAC OR _gRPC_PLATFORM_POSIX)

  set(fling_stream_test_src
   ${_gRPC_ROOT}/test/core/fling/fling_stream_test.cc
)
  android_add_executable(fling_stream_test)

  target_compile_definitions(fling_stream_test PRIVATE -DPB_FIELD_16BIT)
  target_compile_definitions(fling_stream_test PUBLIC  -DGRPC_ALLOW_EXCEPTIONS=0)

  target_include_directories(fling_stream_test
  PRIVATE ${_gRPC_ROOT}
  PRIVATE ${_gRPC_ROOT}/include
  PRIVATE ${_gRPC_SSL_INCLUDE_DIR}
  PRIVATE ${_gRPC_BENCHMARK_INCLUDE_DIR}
  PRIVATE ${_gRPC_GFLAGS_INCLUDE_DIR}
  PRIVATE ${_gRPC_PROTOBUF_INCLUDE_DIR}
  PRIVATE ${_gRPC_NANOPB_INCLUDE_DIR}
  PRIVATE ${_gRPC_ADDRESS_SORTING_INCLUDE_DIR}
)

  target_link_libraries(fling_stream_test PRIVATE
  ${_gRPC_ALLTARGETS_LIBRARIES}
  grpc_test_util
  grpc
  gpr_test_util
  gpr
)

    add_dependencies(fling_stream_test project_benchmark project_gflags)
endif()
if(_gRPC_PLATFORM_LINUX OR _gRPC_PLATFORM_MAC OR _gRPC_PLATFORM_POSIX)

  set(fling_test_src
   ${_gRPC_ROOT}/test/core/fling/fling_test.cc
)
  android_add_executable(fling_test)

  target_compile_definitions(fling_test PRIVATE -DPB_FIELD_16BIT)
  target_compile_definitions(fling_test PUBLIC  -DGRPC_ALLOW_EXCEPTIONS=0)

  target_include_directories(fling_test
  PRIVATE ${_gRPC_ROOT}
  PRIVATE ${_gRPC_ROOT}/include
  PRIVATE ${_gRPC_SSL_INCLUDE_DIR}
  PRIVATE ${_gRPC_BENCHMARK_INCLUDE_DIR}
  PRIVATE ${_gRPC_GFLAGS_INCLUDE_DIR}
  PRIVATE ${_gRPC_PROTOBUF_INCLUDE_DIR}
  PRIVATE ${_gRPC_NANOPB_INCLUDE_DIR}
  PRIVATE ${_gRPC_ADDRESS_SORTING_INCLUDE_DIR}
)

  target_link_libraries(fling_test PRIVATE
  ${_gRPC_ALLTARGETS_LIBRARIES}
  grpc_test_util
  grpc
  gpr_test_util
  gpr
)

    add_dependencies(fling_test project_benchmark project_gflags)
endif()
if(_gRPC_PLATFORM_LINUX OR _gRPC_PLATFORM_MAC)

  set(fork_test_src
   ${_gRPC_ROOT}/test/core/gprpp/fork_test.cc
)
  android_add_executable(fork_test)

  target_compile_definitions(fork_test PRIVATE -DPB_FIELD_16BIT)
  target_compile_definitions(fork_test PUBLIC  -DGRPC_ALLOW_EXCEPTIONS=0)

  target_include_directories(fork_test
  PRIVATE ${_gRPC_ROOT}
  PRIVATE ${_gRPC_ROOT}/include
  PRIVATE ${_gRPC_SSL_INCLUDE_DIR}
  PRIVATE ${_gRPC_BENCHMARK_INCLUDE_DIR}
  PRIVATE ${_gRPC_GFLAGS_INCLUDE_DIR}
  PRIVATE ${_gRPC_PROTOBUF_INCLUDE_DIR}
  PRIVATE ${_gRPC_NANOPB_INCLUDE_DIR}
  PRIVATE ${_gRPC_ADDRESS_SORTING_INCLUDE_DIR}
)

  target_link_libraries(fork_test PRIVATE
  ${_gRPC_ALLTARGETS_LIBRARIES}
  gpr_test_util
  gpr
)

    add_dependencies(fork_test project_benchmark project_gflags)
endif()
if(_gRPC_PLATFORM_LINUX OR _gRPC_PLATFORM_MAC OR _gRPC_PLATFORM_POSIX)

  set(goaway_server_test_src
   ${_gRPC_ROOT}/test/core/end2end/goaway_server_test.cc
)
  android_add_executable(goaway_server_test)

  target_compile_definitions(goaway_server_test PRIVATE -DPB_FIELD_16BIT)
  target_compile_definitions(goaway_server_test PUBLIC  -DGRPC_ALLOW_EXCEPTIONS=0)

  target_include_directories(goaway_server_test
  PRIVATE ${_gRPC_ROOT}
  PRIVATE ${_gRPC_ROOT}/include
  PRIVATE ${_gRPC_SSL_INCLUDE_DIR}
  PRIVATE ${_gRPC_BENCHMARK_INCLUDE_DIR}
  PRIVATE ${_gRPC_GFLAGS_INCLUDE_DIR}
  PRIVATE ${_gRPC_PROTOBUF_INCLUDE_DIR}
  PRIVATE ${_gRPC_NANOPB_INCLUDE_DIR}
  PRIVATE ${_gRPC_ADDRESS_SORTING_INCLUDE_DIR}
)

  target_link_libraries(goaway_server_test PRIVATE
  ${_gRPC_ALLTARGETS_LIBRARIES}
  grpc_test_util
  grpc
  gpr_test_util
  gpr
)

    add_dependencies(goaway_server_test project_benchmark project_gflags)
endif()

  set(gpr_cpu_test_src
   ${_gRPC_ROOT}/test/core/gpr/cpu_test.cc
)
  android_add_executable(gpr_cpu_test)

  target_compile_definitions(gpr_cpu_test PRIVATE -DPB_FIELD_16BIT)
  target_compile_definitions(gpr_cpu_test PUBLIC  -DGRPC_ALLOW_EXCEPTIONS=0)

  target_include_directories(gpr_cpu_test
  PRIVATE ${_gRPC_ROOT}
  PRIVATE ${_gRPC_ROOT}/include
  PRIVATE ${_gRPC_SSL_INCLUDE_DIR}
  PRIVATE ${_gRPC_BENCHMARK_INCLUDE_DIR}
  PRIVATE ${_gRPC_GFLAGS_INCLUDE_DIR}
  PRIVATE ${_gRPC_PROTOBUF_INCLUDE_DIR}
  PRIVATE ${_gRPC_NANOPB_INCLUDE_DIR}
  PRIVATE ${_gRPC_ADDRESS_SORTING_INCLUDE_DIR}
)

  target_link_libraries(gpr_cpu_test PRIVATE
  ${_gRPC_ALLTARGETS_LIBRARIES}
  gpr_test_util
  gpr
)

    add_dependencies(gpr_cpu_test project_benchmark project_gflags)

  set(gpr_env_test_src
   ${_gRPC_ROOT}/test/core/gpr/env_test.cc
)
  android_add_executable(gpr_env_test)

  target_compile_definitions(gpr_env_test PRIVATE -DPB_FIELD_16BIT)
  target_compile_definitions(gpr_env_test PUBLIC  -DGRPC_ALLOW_EXCEPTIONS=0)

  target_include_directories(gpr_env_test
  PRIVATE ${_gRPC_ROOT}
  PRIVATE ${_gRPC_ROOT}/include
  PRIVATE ${_gRPC_SSL_INCLUDE_DIR}
  PRIVATE ${_gRPC_BENCHMARK_INCLUDE_DIR}
  PRIVATE ${_gRPC_GFLAGS_INCLUDE_DIR}
  PRIVATE ${_gRPC_PROTOBUF_INCLUDE_DIR}
  PRIVATE ${_gRPC_NANOPB_INCLUDE_DIR}
  PRIVATE ${_gRPC_ADDRESS_SORTING_INCLUDE_DIR}
)

  target_link_libraries(gpr_env_test PRIVATE
  ${_gRPC_ALLTARGETS_LIBRARIES}
  gpr_test_util
  gpr
)

    add_dependencies(gpr_env_test project_benchmark project_gflags)

  set(gpr_host_port_test_src
   ${_gRPC_ROOT}/test/core/gpr/host_port_test.cc
)
  android_add_executable(gpr_host_port_test)

  target_compile_definitions(gpr_host_port_test PRIVATE -DPB_FIELD_16BIT)
  target_compile_definitions(gpr_host_port_test PUBLIC  -DGRPC_ALLOW_EXCEPTIONS=0)

  target_include_directories(gpr_host_port_test
  PRIVATE ${_gRPC_ROOT}
  PRIVATE ${_gRPC_ROOT}/include
  PRIVATE ${_gRPC_SSL_INCLUDE_DIR}
  PRIVATE ${_gRPC_BENCHMARK_INCLUDE_DIR}
  PRIVATE ${_gRPC_GFLAGS_INCLUDE_DIR}
  PRIVATE ${_gRPC_PROTOBUF_INCLUDE_DIR}
  PRIVATE ${_gRPC_NANOPB_INCLUDE_DIR}
  PRIVATE ${_gRPC_ADDRESS_SORTING_INCLUDE_DIR}
)

  target_link_libraries(gpr_host_port_test PRIVATE
  ${_gRPC_ALLTARGETS_LIBRARIES}
  gpr_test_util
  gpr
)

    add_dependencies(gpr_host_port_test project_benchmark project_gflags)

  set(gpr_log_test_src
   ${_gRPC_ROOT}/test/core/gpr/log_test.cc
)
  android_add_executable(gpr_log_test)

  target_compile_definitions(gpr_log_test PRIVATE -DPB_FIELD_16BIT)
  target_compile_definitions(gpr_log_test PUBLIC  -DGRPC_ALLOW_EXCEPTIONS=0)

  target_include_directories(gpr_log_test
  PRIVATE ${_gRPC_ROOT}
  PRIVATE ${_gRPC_ROOT}/include
  PRIVATE ${_gRPC_SSL_INCLUDE_DIR}
  PRIVATE ${_gRPC_BENCHMARK_INCLUDE_DIR}
  PRIVATE ${_gRPC_GFLAGS_INCLUDE_DIR}
  PRIVATE ${_gRPC_PROTOBUF_INCLUDE_DIR}
  PRIVATE ${_gRPC_NANOPB_INCLUDE_DIR}
  PRIVATE ${_gRPC_ADDRESS_SORTING_INCLUDE_DIR}
)

  target_link_libraries(gpr_log_test PRIVATE
  ${_gRPC_ALLTARGETS_LIBRARIES}
  gpr_test_util
  gpr
)

    add_dependencies(gpr_log_test project_benchmark project_gflags)

  set(gpr_manual_constructor_test_src
   ${_gRPC_ROOT}/test/core/gprpp/manual_constructor_test.cc
)
  android_add_executable(gpr_manual_constructor_test)

  target_compile_definitions(gpr_manual_constructor_test PRIVATE -DPB_FIELD_16BIT)
  target_compile_definitions(gpr_manual_constructor_test PUBLIC  -DGRPC_ALLOW_EXCEPTIONS=0)

  target_include_directories(gpr_manual_constructor_test
  PRIVATE ${_gRPC_ROOT}
  PRIVATE ${_gRPC_ROOT}/include
  PRIVATE ${_gRPC_SSL_INCLUDE_DIR}
  PRIVATE ${_gRPC_BENCHMARK_INCLUDE_DIR}
  PRIVATE ${_gRPC_GFLAGS_INCLUDE_DIR}
  PRIVATE ${_gRPC_PROTOBUF_INCLUDE_DIR}
  PRIVATE ${_gRPC_NANOPB_INCLUDE_DIR}
  PRIVATE ${_gRPC_ADDRESS_SORTING_INCLUDE_DIR}
)

  target_link_libraries(gpr_manual_constructor_test PRIVATE
  ${_gRPC_ALLTARGETS_LIBRARIES}
  gpr_test_util
  gpr
)

    add_dependencies(gpr_manual_constructor_test project_benchmark project_gflags)

  set(gpr_mpscq_test_src
   ${_gRPC_ROOT}/test/core/gpr/mpscq_test.cc
)
  android_add_executable(gpr_mpscq_test)

  target_compile_definitions(gpr_mpscq_test PRIVATE -DPB_FIELD_16BIT)
  target_compile_definitions(gpr_mpscq_test PUBLIC  -DGRPC_ALLOW_EXCEPTIONS=0)

  target_include_directories(gpr_mpscq_test
  PRIVATE ${_gRPC_ROOT}
  PRIVATE ${_gRPC_ROOT}/include
  PRIVATE ${_gRPC_SSL_INCLUDE_DIR}
  PRIVATE ${_gRPC_BENCHMARK_INCLUDE_DIR}
  PRIVATE ${_gRPC_GFLAGS_INCLUDE_DIR}
  PRIVATE ${_gRPC_PROTOBUF_INCLUDE_DIR}
  PRIVATE ${_gRPC_NANOPB_INCLUDE_DIR}
  PRIVATE ${_gRPC_ADDRESS_SORTING_INCLUDE_DIR}
)

  target_link_libraries(gpr_mpscq_test PRIVATE
  ${_gRPC_ALLTARGETS_LIBRARIES}
  gpr_test_util
  gpr
)

    add_dependencies(gpr_mpscq_test project_benchmark project_gflags)

  set(gpr_spinlock_test_src
   ${_gRPC_ROOT}/test/core/gpr/spinlock_test.cc
)
  android_add_executable(gpr_spinlock_test)

  target_compile_definitions(gpr_spinlock_test PRIVATE -DPB_FIELD_16BIT)
  target_compile_definitions(gpr_spinlock_test PUBLIC  -DGRPC_ALLOW_EXCEPTIONS=0)

  target_include_directories(gpr_spinlock_test
  PRIVATE ${_gRPC_ROOT}
  PRIVATE ${_gRPC_ROOT}/include
  PRIVATE ${_gRPC_SSL_INCLUDE_DIR}
  PRIVATE ${_gRPC_BENCHMARK_INCLUDE_DIR}
  PRIVATE ${_gRPC_GFLAGS_INCLUDE_DIR}
  PRIVATE ${_gRPC_PROTOBUF_INCLUDE_DIR}
  PRIVATE ${_gRPC_NANOPB_INCLUDE_DIR}
  PRIVATE ${_gRPC_ADDRESS_SORTING_INCLUDE_DIR}
)

  target_link_libraries(gpr_spinlock_test PRIVATE
  ${_gRPC_ALLTARGETS_LIBRARIES}
  gpr_test_util
  gpr
)

    add_dependencies(gpr_spinlock_test project_benchmark project_gflags)

  set(gpr_string_test_src
   ${_gRPC_ROOT}/test/core/gpr/string_test.cc
)
  android_add_executable(gpr_string_test)

  target_compile_definitions(gpr_string_test PRIVATE -DPB_FIELD_16BIT)
  target_compile_definitions(gpr_string_test PUBLIC  -DGRPC_ALLOW_EXCEPTIONS=0)

  target_include_directories(gpr_string_test
  PRIVATE ${_gRPC_ROOT}
  PRIVATE ${_gRPC_ROOT}/include
  PRIVATE ${_gRPC_SSL_INCLUDE_DIR}
  PRIVATE ${_gRPC_BENCHMARK_INCLUDE_DIR}
  PRIVATE ${_gRPC_GFLAGS_INCLUDE_DIR}
  PRIVATE ${_gRPC_PROTOBUF_INCLUDE_DIR}
  PRIVATE ${_gRPC_NANOPB_INCLUDE_DIR}
  PRIVATE ${_gRPC_ADDRESS_SORTING_INCLUDE_DIR}
)

  target_link_libraries(gpr_string_test PRIVATE
  ${_gRPC_ALLTARGETS_LIBRARIES}
  gpr_test_util
  gpr
)

    add_dependencies(gpr_string_test project_benchmark project_gflags)

  set(gpr_sync_test_src
   ${_gRPC_ROOT}/test/core/gpr/sync_test.cc
)
  android_add_executable(gpr_sync_test)

  target_compile_definitions(gpr_sync_test PRIVATE -DPB_FIELD_16BIT)
  target_compile_definitions(gpr_sync_test PUBLIC  -DGRPC_ALLOW_EXCEPTIONS=0)

  target_include_directories(gpr_sync_test
  PRIVATE ${_gRPC_ROOT}
  PRIVATE ${_gRPC_ROOT}/include
  PRIVATE ${_gRPC_SSL_INCLUDE_DIR}
  PRIVATE ${_gRPC_BENCHMARK_INCLUDE_DIR}
  PRIVATE ${_gRPC_GFLAGS_INCLUDE_DIR}
  PRIVATE ${_gRPC_PROTOBUF_INCLUDE_DIR}
  PRIVATE ${_gRPC_NANOPB_INCLUDE_DIR}
  PRIVATE ${_gRPC_ADDRESS_SORTING_INCLUDE_DIR}
)

  target_link_libraries(gpr_sync_test PRIVATE
  ${_gRPC_ALLTARGETS_LIBRARIES}
  gpr_test_util
  gpr
)

    add_dependencies(gpr_sync_test project_benchmark project_gflags)

  set(gpr_thd_test_src
   ${_gRPC_ROOT}/test/core/gprpp/thd_test.cc
)
  android_add_executable(gpr_thd_test)

  target_compile_definitions(gpr_thd_test PRIVATE -DPB_FIELD_16BIT)
  target_compile_definitions(gpr_thd_test PUBLIC  -DGRPC_ALLOW_EXCEPTIONS=0)

  target_include_directories(gpr_thd_test
  PRIVATE ${_gRPC_ROOT}
  PRIVATE ${_gRPC_ROOT}/include
  PRIVATE ${_gRPC_SSL_INCLUDE_DIR}
  PRIVATE ${_gRPC_BENCHMARK_INCLUDE_DIR}
  PRIVATE ${_gRPC_GFLAGS_INCLUDE_DIR}
  PRIVATE ${_gRPC_PROTOBUF_INCLUDE_DIR}
  PRIVATE ${_gRPC_NANOPB_INCLUDE_DIR}
  PRIVATE ${_gRPC_ADDRESS_SORTING_INCLUDE_DIR}
)

  target_link_libraries(gpr_thd_test PRIVATE
  ${_gRPC_ALLTARGETS_LIBRARIES}
  gpr_test_util
  gpr
)

    add_dependencies(gpr_thd_test project_benchmark project_gflags)

  set(gpr_time_test_src
   ${_gRPC_ROOT}/test/core/gpr/time_test.cc
)
  android_add_executable(gpr_time_test)

  target_compile_definitions(gpr_time_test PRIVATE -DPB_FIELD_16BIT)
  target_compile_definitions(gpr_time_test PUBLIC  -DGRPC_ALLOW_EXCEPTIONS=0)

  target_include_directories(gpr_time_test
  PRIVATE ${_gRPC_ROOT}
  PRIVATE ${_gRPC_ROOT}/include
  PRIVATE ${_gRPC_SSL_INCLUDE_DIR}
  PRIVATE ${_gRPC_BENCHMARK_INCLUDE_DIR}
  PRIVATE ${_gRPC_GFLAGS_INCLUDE_DIR}
  PRIVATE ${_gRPC_PROTOBUF_INCLUDE_DIR}
  PRIVATE ${_gRPC_NANOPB_INCLUDE_DIR}
  PRIVATE ${_gRPC_ADDRESS_SORTING_INCLUDE_DIR}
)

  target_link_libraries(gpr_time_test PRIVATE
  ${_gRPC_ALLTARGETS_LIBRARIES}
  gpr_test_util
  gpr
)

    add_dependencies(gpr_time_test project_benchmark project_gflags)

  set(gpr_tls_test_src
   ${_gRPC_ROOT}/test/core/gpr/tls_test.cc
)
  android_add_executable(gpr_tls_test)

  target_compile_definitions(gpr_tls_test PRIVATE -DPB_FIELD_16BIT)
  target_compile_definitions(gpr_tls_test PUBLIC  -DGRPC_ALLOW_EXCEPTIONS=0)

  target_include_directories(gpr_tls_test
  PRIVATE ${_gRPC_ROOT}
  PRIVATE ${_gRPC_ROOT}/include
  PRIVATE ${_gRPC_SSL_INCLUDE_DIR}
  PRIVATE ${_gRPC_BENCHMARK_INCLUDE_DIR}
  PRIVATE ${_gRPC_GFLAGS_INCLUDE_DIR}
  PRIVATE ${_gRPC_PROTOBUF_INCLUDE_DIR}
  PRIVATE ${_gRPC_NANOPB_INCLUDE_DIR}
  PRIVATE ${_gRPC_ADDRESS_SORTING_INCLUDE_DIR}
)

  target_link_libraries(gpr_tls_test PRIVATE
  ${_gRPC_ALLTARGETS_LIBRARIES}
  gpr_test_util
  gpr
)

    add_dependencies(gpr_tls_test project_benchmark project_gflags)

  set(gpr_useful_test_src
   ${_gRPC_ROOT}/test/core/gpr/useful_test.cc
)
  android_add_executable(gpr_useful_test)

  target_compile_definitions(gpr_useful_test PRIVATE -DPB_FIELD_16BIT)
  target_compile_definitions(gpr_useful_test PUBLIC  -DGRPC_ALLOW_EXCEPTIONS=0)

  target_include_directories(gpr_useful_test
  PRIVATE ${_gRPC_ROOT}
  PRIVATE ${_gRPC_ROOT}/include
  PRIVATE ${_gRPC_SSL_INCLUDE_DIR}
  PRIVATE ${_gRPC_BENCHMARK_INCLUDE_DIR}
  PRIVATE ${_gRPC_GFLAGS_INCLUDE_DIR}
  PRIVATE ${_gRPC_PROTOBUF_INCLUDE_DIR}
  PRIVATE ${_gRPC_NANOPB_INCLUDE_DIR}
  PRIVATE ${_gRPC_ADDRESS_SORTING_INCLUDE_DIR}
)

  target_link_libraries(gpr_useful_test PRIVATE
  ${_gRPC_ALLTARGETS_LIBRARIES}
  gpr_test_util
  gpr
)

    add_dependencies(gpr_useful_test project_benchmark project_gflags)

  set(grpc_auth_context_test_src
   ${_gRPC_ROOT}/test/core/security/auth_context_test.cc
)
  android_add_executable(grpc_auth_context_test)

  target_compile_definitions(grpc_auth_context_test PRIVATE -DPB_FIELD_16BIT)
  target_compile_definitions(grpc_auth_context_test PUBLIC  -DGRPC_ALLOW_EXCEPTIONS=0)

  target_include_directories(grpc_auth_context_test
  PRIVATE ${_gRPC_ROOT}
  PRIVATE ${_gRPC_ROOT}/include
  PRIVATE ${_gRPC_SSL_INCLUDE_DIR}
  PRIVATE ${_gRPC_BENCHMARK_INCLUDE_DIR}
  PRIVATE ${_gRPC_GFLAGS_INCLUDE_DIR}
  PRIVATE ${_gRPC_PROTOBUF_INCLUDE_DIR}
  PRIVATE ${_gRPC_NANOPB_INCLUDE_DIR}
  PRIVATE ${_gRPC_ADDRESS_SORTING_INCLUDE_DIR}
)

  target_link_libraries(grpc_auth_context_test PRIVATE
  ${_gRPC_ALLTARGETS_LIBRARIES}
  grpc_test_util
  grpc
  gpr_test_util
  gpr
)

    add_dependencies(grpc_auth_context_test project_benchmark project_gflags)

  set(grpc_b64_test_src
   ${_gRPC_ROOT}/test/core/slice/b64_test.cc
)
  android_add_executable(grpc_b64_test)

  target_compile_definitions(grpc_b64_test PRIVATE -DPB_FIELD_16BIT)
  target_compile_definitions(grpc_b64_test PUBLIC  -DGRPC_ALLOW_EXCEPTIONS=0)

  target_include_directories(grpc_b64_test
  PRIVATE ${_gRPC_ROOT}
  PRIVATE ${_gRPC_ROOT}/include
  PRIVATE ${_gRPC_SSL_INCLUDE_DIR}
  PRIVATE ${_gRPC_BENCHMARK_INCLUDE_DIR}
  PRIVATE ${_gRPC_GFLAGS_INCLUDE_DIR}
  PRIVATE ${_gRPC_PROTOBUF_INCLUDE_DIR}
  PRIVATE ${_gRPC_NANOPB_INCLUDE_DIR}
  PRIVATE ${_gRPC_ADDRESS_SORTING_INCLUDE_DIR}
)

  target_link_libraries(grpc_b64_test PRIVATE
  ${_gRPC_ALLTARGETS_LIBRARIES}
  grpc_test_util
  grpc
  gpr_test_util
  gpr
)

    add_dependencies(grpc_b64_test project_benchmark project_gflags)

  set(grpc_byte_buffer_reader_test_src
   ${_gRPC_ROOT}/test/core/surface/byte_buffer_reader_test.cc
)
  android_add_executable(grpc_byte_buffer_reader_test)

  target_compile_definitions(grpc_byte_buffer_reader_test PRIVATE -DPB_FIELD_16BIT)
  target_compile_definitions(grpc_byte_buffer_reader_test PUBLIC  -DGRPC_ALLOW_EXCEPTIONS=0)

  target_include_directories(grpc_byte_buffer_reader_test
  PRIVATE ${_gRPC_ROOT}
  PRIVATE ${_gRPC_ROOT}/include
  PRIVATE ${_gRPC_SSL_INCLUDE_DIR}
  PRIVATE ${_gRPC_BENCHMARK_INCLUDE_DIR}
  PRIVATE ${_gRPC_GFLAGS_INCLUDE_DIR}
  PRIVATE ${_gRPC_PROTOBUF_INCLUDE_DIR}
  PRIVATE ${_gRPC_NANOPB_INCLUDE_DIR}
  PRIVATE ${_gRPC_ADDRESS_SORTING_INCLUDE_DIR}
)

  target_link_libraries(grpc_byte_buffer_reader_test PRIVATE
  ${_gRPC_ALLTARGETS_LIBRARIES}
  grpc_test_util
  grpc
  gpr_test_util
  gpr
)

    add_dependencies(grpc_byte_buffer_reader_test project_benchmark project_gflags)

  set(grpc_channel_args_test_src
   ${_gRPC_ROOT}/test/core/channel/channel_args_test.cc
)
  android_add_executable(grpc_channel_args_test)

  target_compile_definitions(grpc_channel_args_test PRIVATE -DPB_FIELD_16BIT)
  target_compile_definitions(grpc_channel_args_test PUBLIC  -DGRPC_ALLOW_EXCEPTIONS=0)

  target_include_directories(grpc_channel_args_test
  PRIVATE ${_gRPC_ROOT}
  PRIVATE ${_gRPC_ROOT}/include
  PRIVATE ${_gRPC_SSL_INCLUDE_DIR}
  PRIVATE ${_gRPC_BENCHMARK_INCLUDE_DIR}
  PRIVATE ${_gRPC_GFLAGS_INCLUDE_DIR}
  PRIVATE ${_gRPC_PROTOBUF_INCLUDE_DIR}
  PRIVATE ${_gRPC_NANOPB_INCLUDE_DIR}
  PRIVATE ${_gRPC_ADDRESS_SORTING_INCLUDE_DIR}
)

  target_link_libraries(grpc_channel_args_test PRIVATE
  ${_gRPC_ALLTARGETS_LIBRARIES}
  grpc_test_util
  grpc
  gpr_test_util
  gpr
)

    add_dependencies(grpc_channel_args_test project_benchmark project_gflags)

  set(grpc_channel_stack_builder_test_src
   ${_gRPC_ROOT}/test/core/channel/channel_stack_builder_test.cc
)
  android_add_executable(grpc_channel_stack_builder_test)

  target_compile_definitions(grpc_channel_stack_builder_test PRIVATE -DPB_FIELD_16BIT)
  target_compile_definitions(grpc_channel_stack_builder_test PUBLIC  -DGRPC_ALLOW_EXCEPTIONS=0)

  target_include_directories(grpc_channel_stack_builder_test
  PRIVATE ${_gRPC_ROOT}
  PRIVATE ${_gRPC_ROOT}/include
  PRIVATE ${_gRPC_SSL_INCLUDE_DIR}
  PRIVATE ${_gRPC_BENCHMARK_INCLUDE_DIR}
  PRIVATE ${_gRPC_GFLAGS_INCLUDE_DIR}
  PRIVATE ${_gRPC_PROTOBUF_INCLUDE_DIR}
  PRIVATE ${_gRPC_NANOPB_INCLUDE_DIR}
  PRIVATE ${_gRPC_ADDRESS_SORTING_INCLUDE_DIR}
)

  target_link_libraries(grpc_channel_stack_builder_test PRIVATE
  ${_gRPC_ALLTARGETS_LIBRARIES}
  grpc_test_util
  grpc
  gpr_test_util
  gpr
)

    add_dependencies(grpc_channel_stack_builder_test project_benchmark project_gflags)

  set(grpc_channel_stack_test_src
   ${_gRPC_ROOT}/test/core/channel/channel_stack_test.cc
)
  android_add_executable(grpc_channel_stack_test)

  target_compile_definitions(grpc_channel_stack_test PRIVATE -DPB_FIELD_16BIT)
  target_compile_definitions(grpc_channel_stack_test PUBLIC  -DGRPC_ALLOW_EXCEPTIONS=0)

  target_include_directories(grpc_channel_stack_test
  PRIVATE ${_gRPC_ROOT}
  PRIVATE ${_gRPC_ROOT}/include
  PRIVATE ${_gRPC_SSL_INCLUDE_DIR}
  PRIVATE ${_gRPC_BENCHMARK_INCLUDE_DIR}
  PRIVATE ${_gRPC_GFLAGS_INCLUDE_DIR}
  PRIVATE ${_gRPC_PROTOBUF_INCLUDE_DIR}
  PRIVATE ${_gRPC_NANOPB_INCLUDE_DIR}
  PRIVATE ${_gRPC_ADDRESS_SORTING_INCLUDE_DIR}
)

  target_link_libraries(grpc_channel_stack_test PRIVATE
  ${_gRPC_ALLTARGETS_LIBRARIES}
  grpc_test_util
  grpc
  gpr_test_util
  gpr
)

    add_dependencies(grpc_channel_stack_test project_benchmark project_gflags)

  set(grpc_completion_queue_test_src
   ${_gRPC_ROOT}/test/core/surface/completion_queue_test.cc
)
  android_add_executable(grpc_completion_queue_test)

  target_compile_definitions(grpc_completion_queue_test PRIVATE -DPB_FIELD_16BIT)
  target_compile_definitions(grpc_completion_queue_test PUBLIC  -DGRPC_ALLOW_EXCEPTIONS=0)

  target_include_directories(grpc_completion_queue_test
  PRIVATE ${_gRPC_ROOT}
  PRIVATE ${_gRPC_ROOT}/include
  PRIVATE ${_gRPC_SSL_INCLUDE_DIR}
  PRIVATE ${_gRPC_BENCHMARK_INCLUDE_DIR}
  PRIVATE ${_gRPC_GFLAGS_INCLUDE_DIR}
  PRIVATE ${_gRPC_PROTOBUF_INCLUDE_DIR}
  PRIVATE ${_gRPC_NANOPB_INCLUDE_DIR}
  PRIVATE ${_gRPC_ADDRESS_SORTING_INCLUDE_DIR}
)

  target_link_libraries(grpc_completion_queue_test PRIVATE
  ${_gRPC_ALLTARGETS_LIBRARIES}
  grpc_test_util
  grpc
  gpr_test_util
  gpr
)

    add_dependencies(grpc_completion_queue_test project_benchmark project_gflags)

  set(grpc_completion_queue_threading_test_src
   ${_gRPC_ROOT}/test/core/surface/completion_queue_threading_test.cc
)
  android_add_executable(grpc_completion_queue_threading_test)

  target_compile_definitions(grpc_completion_queue_threading_test PRIVATE -DPB_FIELD_16BIT)
  target_compile_definitions(grpc_completion_queue_threading_test PUBLIC  -DGRPC_ALLOW_EXCEPTIONS=0)

  target_include_directories(grpc_completion_queue_threading_test
  PRIVATE ${_gRPC_ROOT}
  PRIVATE ${_gRPC_ROOT}/include
  PRIVATE ${_gRPC_SSL_INCLUDE_DIR}
  PRIVATE ${_gRPC_BENCHMARK_INCLUDE_DIR}
  PRIVATE ${_gRPC_GFLAGS_INCLUDE_DIR}
  PRIVATE ${_gRPC_PROTOBUF_INCLUDE_DIR}
  PRIVATE ${_gRPC_NANOPB_INCLUDE_DIR}
  PRIVATE ${_gRPC_ADDRESS_SORTING_INCLUDE_DIR}
)

  target_link_libraries(grpc_completion_queue_threading_test PRIVATE
  ${_gRPC_ALLTARGETS_LIBRARIES}
  grpc_test_util
  grpc
  gpr_test_util
  gpr
)

    add_dependencies(grpc_completion_queue_threading_test project_benchmark project_gflags)

  set(grpc_credentials_test_src
   ${_gRPC_ROOT}/test/core/security/credentials_test.cc
)
  android_add_executable(grpc_credentials_test)

  target_compile_definitions(grpc_credentials_test PRIVATE -DPB_FIELD_16BIT)
  target_compile_definitions(grpc_credentials_test PUBLIC  -DGRPC_ALLOW_EXCEPTIONS=0)

  target_include_directories(grpc_credentials_test
  PRIVATE ${_gRPC_ROOT}
  PRIVATE ${_gRPC_ROOT}/include
  PRIVATE ${_gRPC_SSL_INCLUDE_DIR}
  PRIVATE ${_gRPC_BENCHMARK_INCLUDE_DIR}
  PRIVATE ${_gRPC_GFLAGS_INCLUDE_DIR}
  PRIVATE ${_gRPC_PROTOBUF_INCLUDE_DIR}
  PRIVATE ${_gRPC_NANOPB_INCLUDE_DIR}
  PRIVATE ${_gRPC_ADDRESS_SORTING_INCLUDE_DIR}
)

  target_link_libraries(grpc_credentials_test PRIVATE
  ${_gRPC_ALLTARGETS_LIBRARIES}
  grpc_test_util
  grpc
  gpr_test_util
  gpr
)

    add_dependencies(grpc_credentials_test project_benchmark project_gflags)

  set(grpc_fetch_oauth2_src
   ${_gRPC_ROOT}/test/core/security/fetch_oauth2.cc
)
  android_add_executable(grpc_fetch_oauth2)

  target_compile_definitions(grpc_fetch_oauth2 PRIVATE -DPB_FIELD_16BIT)
  target_compile_definitions(grpc_fetch_oauth2 PUBLIC  -DGRPC_ALLOW_EXCEPTIONS=0)

  target_include_directories(grpc_fetch_oauth2
  PRIVATE ${_gRPC_ROOT}
  PRIVATE ${_gRPC_ROOT}/include
  PRIVATE ${_gRPC_SSL_INCLUDE_DIR}
  PRIVATE ${_gRPC_BENCHMARK_INCLUDE_DIR}
  PRIVATE ${_gRPC_GFLAGS_INCLUDE_DIR}
  PRIVATE ${_gRPC_PROTOBUF_INCLUDE_DIR}
  PRIVATE ${_gRPC_NANOPB_INCLUDE_DIR}
  PRIVATE ${_gRPC_ADDRESS_SORTING_INCLUDE_DIR}
)

  target_link_libraries(grpc_fetch_oauth2 PRIVATE
  ${_gRPC_ALLTARGETS_LIBRARIES}
  grpc_test_util
  grpc
  gpr_test_util
  gpr
)

    add_dependencies(grpc_fetch_oauth2 project_benchmark project_gflags)

  set(grpc_ipv6_loopback_available_test_src
   ${_gRPC_ROOT}/test/core/iomgr/grpc_ipv6_loopback_available_test.cc
)
  android_add_executable(grpc_ipv6_loopback_available_test)

  target_compile_definitions(grpc_ipv6_loopback_available_test PRIVATE -DPB_FIELD_16BIT)
  target_compile_definitions(grpc_ipv6_loopback_available_test PUBLIC  -DGRPC_ALLOW_EXCEPTIONS=0)

  target_include_directories(grpc_ipv6_loopback_available_test
  PRIVATE ${_gRPC_ROOT}
  PRIVATE ${_gRPC_ROOT}/include
  PRIVATE ${_gRPC_SSL_INCLUDE_DIR}
  PRIVATE ${_gRPC_BENCHMARK_INCLUDE_DIR}
  PRIVATE ${_gRPC_GFLAGS_INCLUDE_DIR}
  PRIVATE ${_gRPC_PROTOBUF_INCLUDE_DIR}
  PRIVATE ${_gRPC_NANOPB_INCLUDE_DIR}
  PRIVATE ${_gRPC_ADDRESS_SORTING_INCLUDE_DIR}
)

  target_link_libraries(grpc_ipv6_loopback_available_test PRIVATE
  ${_gRPC_ALLTARGETS_LIBRARIES}
  grpc_test_util
  grpc
  gpr_test_util
  gpr
)

    add_dependencies(grpc_ipv6_loopback_available_test project_benchmark project_gflags)
if(_gRPC_PLATFORM_LINUX OR _gRPC_PLATFORM_MAC OR _gRPC_PLATFORM_POSIX)

  set(grpc_json_token_test_src
   ${_gRPC_ROOT}/test/core/security/json_token_test.cc
)
  android_add_executable(grpc_json_token_test)

  target_compile_definitions(grpc_json_token_test PRIVATE -DPB_FIELD_16BIT)
  target_compile_definitions(grpc_json_token_test PUBLIC  -DGRPC_ALLOW_EXCEPTIONS=0)

  target_include_directories(grpc_json_token_test
  PRIVATE ${_gRPC_ROOT}
  PRIVATE ${_gRPC_ROOT}/include
  PRIVATE ${_gRPC_SSL_INCLUDE_DIR}
  PRIVATE ${_gRPC_BENCHMARK_INCLUDE_DIR}
  PRIVATE ${_gRPC_GFLAGS_INCLUDE_DIR}
  PRIVATE ${_gRPC_PROTOBUF_INCLUDE_DIR}
  PRIVATE ${_gRPC_NANOPB_INCLUDE_DIR}
  PRIVATE ${_gRPC_ADDRESS_SORTING_INCLUDE_DIR}
)

  target_link_libraries(grpc_json_token_test PRIVATE
  ${_gRPC_ALLTARGETS_LIBRARIES}
  grpc_test_util
  grpc
  gpr_test_util
  gpr
)

    add_dependencies(grpc_json_token_test project_benchmark project_gflags)
endif()

  set(grpc_jwt_verifier_test_src
   ${_gRPC_ROOT}/test/core/security/jwt_verifier_test.cc
)
  android_add_executable(grpc_jwt_verifier_test)

  target_compile_definitions(grpc_jwt_verifier_test PRIVATE -DPB_FIELD_16BIT)
  target_compile_definitions(grpc_jwt_verifier_test PUBLIC  -DGRPC_ALLOW_EXCEPTIONS=0)

  target_include_directories(grpc_jwt_verifier_test
  PRIVATE ${_gRPC_ROOT}
  PRIVATE ${_gRPC_ROOT}/include
  PRIVATE ${_gRPC_SSL_INCLUDE_DIR}
  PRIVATE ${_gRPC_BENCHMARK_INCLUDE_DIR}
  PRIVATE ${_gRPC_GFLAGS_INCLUDE_DIR}
  PRIVATE ${_gRPC_PROTOBUF_INCLUDE_DIR}
  PRIVATE ${_gRPC_NANOPB_INCLUDE_DIR}
  PRIVATE ${_gRPC_ADDRESS_SORTING_INCLUDE_DIR}
)

  target_link_libraries(grpc_jwt_verifier_test PRIVATE
  ${_gRPC_ALLTARGETS_LIBRARIES}
  grpc_test_util
  grpc
  gpr_test_util
  gpr
)

    add_dependencies(grpc_jwt_verifier_test project_benchmark project_gflags)

  set(grpc_security_connector_test_src
   ${_gRPC_ROOT}/test/core/security/security_connector_test.cc
)
  android_add_executable(grpc_security_connector_test)

  target_compile_definitions(grpc_security_connector_test PRIVATE -DPB_FIELD_16BIT)
  target_compile_definitions(grpc_security_connector_test PUBLIC  -DGRPC_ALLOW_EXCEPTIONS=0)

  target_include_directories(grpc_security_connector_test
  PRIVATE ${_gRPC_ROOT}
  PRIVATE ${_gRPC_ROOT}/include
  PRIVATE ${_gRPC_SSL_INCLUDE_DIR}
  PRIVATE ${_gRPC_BENCHMARK_INCLUDE_DIR}
  PRIVATE ${_gRPC_GFLAGS_INCLUDE_DIR}
  PRIVATE ${_gRPC_PROTOBUF_INCLUDE_DIR}
  PRIVATE ${_gRPC_NANOPB_INCLUDE_DIR}
  PRIVATE ${_gRPC_ADDRESS_SORTING_INCLUDE_DIR}
)

  target_link_libraries(grpc_security_connector_test PRIVATE
  ${_gRPC_ALLTARGETS_LIBRARIES}
  grpc_test_util
  grpc
  gpr_test_util
  gpr
)

    add_dependencies(grpc_security_connector_test project_benchmark project_gflags)

  set(grpc_ssl_credentials_test_src
   ${_gRPC_ROOT}/test/core/security/ssl_credentials_test.cc
)
  android_add_executable(grpc_ssl_credentials_test)

  target_compile_definitions(grpc_ssl_credentials_test PRIVATE -DPB_FIELD_16BIT)
  target_compile_definitions(grpc_ssl_credentials_test PUBLIC  -DGRPC_ALLOW_EXCEPTIONS=0)

  target_include_directories(grpc_ssl_credentials_test
  PRIVATE ${_gRPC_ROOT}
  PRIVATE ${_gRPC_ROOT}/include
  PRIVATE ${_gRPC_SSL_INCLUDE_DIR}
  PRIVATE ${_gRPC_BENCHMARK_INCLUDE_DIR}
  PRIVATE ${_gRPC_GFLAGS_INCLUDE_DIR}
  PRIVATE ${_gRPC_PROTOBUF_INCLUDE_DIR}
  PRIVATE ${_gRPC_NANOPB_INCLUDE_DIR}
  PRIVATE ${_gRPC_ADDRESS_SORTING_INCLUDE_DIR}
)

  target_link_libraries(grpc_ssl_credentials_test PRIVATE
  ${_gRPC_ALLTARGETS_LIBRARIES}
  grpc_test_util
  grpc
  gpr_test_util
  gpr
)

    add_dependencies(grpc_ssl_credentials_test project_benchmark project_gflags)
if(_gRPC_PLATFORM_LINUX)

  set(handshake_client_src
   ${_gRPC_ROOT}/test/core/handshake/client_ssl.cc
)
  android_add_executable(handshake_client)

  target_compile_definitions(handshake_client PRIVATE -DPB_FIELD_16BIT)
  target_compile_definitions(handshake_client PUBLIC  -DGRPC_ALLOW_EXCEPTIONS=0)

  target_include_directories(handshake_client
  PRIVATE ${_gRPC_ROOT}
  PRIVATE ${_gRPC_ROOT}/include
  PRIVATE ${_gRPC_SSL_INCLUDE_DIR}
  PRIVATE ${_gRPC_BENCHMARK_INCLUDE_DIR}
  PRIVATE ${_gRPC_GFLAGS_INCLUDE_DIR}
  PRIVATE ${_gRPC_PROTOBUF_INCLUDE_DIR}
  PRIVATE ${_gRPC_NANOPB_INCLUDE_DIR}
  PRIVATE ${_gRPC_ADDRESS_SORTING_INCLUDE_DIR}
)

  target_link_libraries(handshake_client PRIVATE
  ssl
  crypto
  ${_gRPC_ALLTARGETS_LIBRARIES}
  grpc_test_util
  grpc
  gpr_test_util
  gpr
)

    add_dependencies(handshake_client project_benchmark project_gflags)
endif()
if(_gRPC_PLATFORM_LINUX)

  set(handshake_server_src
   ${_gRPC_ROOT}/test/core/handshake/server_ssl.cc
   ${_gRPC_ROOT}/test/core/handshake/server_ssl_common.cc
)
  android_add_executable(handshake_server)

  target_compile_definitions(handshake_server PRIVATE -DPB_FIELD_16BIT)
  target_compile_definitions(handshake_server PUBLIC  -DGRPC_ALLOW_EXCEPTIONS=0)

  target_include_directories(handshake_server
  PRIVATE ${_gRPC_ROOT}
  PRIVATE ${_gRPC_ROOT}/include
  PRIVATE ${_gRPC_SSL_INCLUDE_DIR}
  PRIVATE ${_gRPC_BENCHMARK_INCLUDE_DIR}
  PRIVATE ${_gRPC_GFLAGS_INCLUDE_DIR}
  PRIVATE ${_gRPC_PROTOBUF_INCLUDE_DIR}
  PRIVATE ${_gRPC_NANOPB_INCLUDE_DIR}
  PRIVATE ${_gRPC_ADDRESS_SORTING_INCLUDE_DIR}
)

  target_link_libraries(handshake_server PRIVATE
  ssl
  crypto
  ${_gRPC_ALLTARGETS_LIBRARIES}
  grpc_test_util
  grpc
  gpr_test_util
  gpr
)

    add_dependencies(handshake_server project_benchmark project_gflags)
endif()
if(_gRPC_PLATFORM_LINUX)

  set(handshake_server_with_readahead_handshaker_src
   ${_gRPC_ROOT}/test/core/handshake/readahead_handshaker_server_ssl.cc
   ${_gRPC_ROOT}/test/core/handshake/server_ssl_common.cc
)
  android_add_executable(handshake_server_with_readahead_handshaker)

  target_compile_definitions(handshake_server_with_readahead_handshaker PRIVATE -DPB_FIELD_16BIT)
  target_compile_definitions(handshake_server_with_readahead_handshaker PUBLIC  -DGRPC_ALLOW_EXCEPTIONS=0)

  target_include_directories(handshake_server_with_readahead_handshaker
  PRIVATE ${_gRPC_ROOT}
  PRIVATE ${_gRPC_ROOT}/include
  PRIVATE ${_gRPC_SSL_INCLUDE_DIR}
  PRIVATE ${_gRPC_BENCHMARK_INCLUDE_DIR}
  PRIVATE ${_gRPC_GFLAGS_INCLUDE_DIR}
  PRIVATE ${_gRPC_PROTOBUF_INCLUDE_DIR}
  PRIVATE ${_gRPC_NANOPB_INCLUDE_DIR}
  PRIVATE ${_gRPC_ADDRESS_SORTING_INCLUDE_DIR}
)

  target_link_libraries(handshake_server_with_readahead_handshaker PRIVATE
  ssl
  crypto
  ${_gRPC_ALLTARGETS_LIBRARIES}
  grpc_test_util
  grpc
  gpr_test_util
  gpr
)

    add_dependencies(handshake_server_with_readahead_handshaker project_benchmark project_gflags)
endif()
if(_gRPC_PLATFORM_LINUX)

  set(handshake_verify_peer_options_src
   ${_gRPC_ROOT}/test/core/handshake/verify_peer_options.cc
)
  android_add_executable(handshake_verify_peer_options)

  target_compile_definitions(handshake_verify_peer_options PRIVATE -DPB_FIELD_16BIT)
  target_compile_definitions(handshake_verify_peer_options PUBLIC  -DGRPC_ALLOW_EXCEPTIONS=0)

  target_include_directories(handshake_verify_peer_options
  PRIVATE ${_gRPC_ROOT}
  PRIVATE ${_gRPC_ROOT}/include
  PRIVATE ${_gRPC_SSL_INCLUDE_DIR}
  PRIVATE ${_gRPC_BENCHMARK_INCLUDE_DIR}
  PRIVATE ${_gRPC_GFLAGS_INCLUDE_DIR}
  PRIVATE ${_gRPC_PROTOBUF_INCLUDE_DIR}
  PRIVATE ${_gRPC_NANOPB_INCLUDE_DIR}
  PRIVATE ${_gRPC_ADDRESS_SORTING_INCLUDE_DIR}
)

  target_link_libraries(handshake_verify_peer_options PRIVATE
  ssl
  crypto
  ${_gRPC_ALLTARGETS_LIBRARIES}
  grpc_test_util
  grpc
  gpr_test_util
  gpr
)

    add_dependencies(handshake_verify_peer_options project_benchmark project_gflags)
endif()

  set(histogram_test_src
   ${_gRPC_ROOT}/test/core/util/histogram_test.cc
)
  android_add_executable(histogram_test)

  target_compile_definitions(histogram_test PRIVATE -DPB_FIELD_16BIT)
  target_compile_definitions(histogram_test PUBLIC  -DGRPC_ALLOW_EXCEPTIONS=0)

  target_include_directories(histogram_test
  PRIVATE ${_gRPC_ROOT}
  PRIVATE ${_gRPC_ROOT}/include
  PRIVATE ${_gRPC_SSL_INCLUDE_DIR}
  PRIVATE ${_gRPC_BENCHMARK_INCLUDE_DIR}
  PRIVATE ${_gRPC_GFLAGS_INCLUDE_DIR}
  PRIVATE ${_gRPC_PROTOBUF_INCLUDE_DIR}
  PRIVATE ${_gRPC_NANOPB_INCLUDE_DIR}
  PRIVATE ${_gRPC_ADDRESS_SORTING_INCLUDE_DIR}
)

  target_link_libraries(histogram_test PRIVATE
  ${_gRPC_ALLTARGETS_LIBRARIES}
  grpc_test_util
  gpr
)

    add_dependencies(histogram_test project_benchmark project_gflags)

  set(hpack_parser_test_src
   ${_gRPC_ROOT}/test/core/transport/chttp2/hpack_parser_test.cc
)
  android_add_executable(hpack_parser_test)

  target_compile_definitions(hpack_parser_test PRIVATE -DPB_FIELD_16BIT)
  target_compile_definitions(hpack_parser_test PUBLIC  -DGRPC_ALLOW_EXCEPTIONS=0)

  target_include_directories(hpack_parser_test
  PRIVATE ${_gRPC_ROOT}
  PRIVATE ${_gRPC_ROOT}/include
  PRIVATE ${_gRPC_SSL_INCLUDE_DIR}
  PRIVATE ${_gRPC_BENCHMARK_INCLUDE_DIR}
  PRIVATE ${_gRPC_GFLAGS_INCLUDE_DIR}
  PRIVATE ${_gRPC_PROTOBUF_INCLUDE_DIR}
  PRIVATE ${_gRPC_NANOPB_INCLUDE_DIR}
  PRIVATE ${_gRPC_ADDRESS_SORTING_INCLUDE_DIR}
)

  target_link_libraries(hpack_parser_test PRIVATE
  ${_gRPC_ALLTARGETS_LIBRARIES}
  grpc_test_util
  grpc
  gpr_test_util
  gpr
)

    add_dependencies(hpack_parser_test project_benchmark project_gflags)

  set(hpack_table_test_src
   ${_gRPC_ROOT}/test/core/transport/chttp2/hpack_table_test.cc
)
  android_add_executable(hpack_table_test)

  target_compile_definitions(hpack_table_test PRIVATE -DPB_FIELD_16BIT)
  target_compile_definitions(hpack_table_test PUBLIC  -DGRPC_ALLOW_EXCEPTIONS=0)

  target_include_directories(hpack_table_test
  PRIVATE ${_gRPC_ROOT}
  PRIVATE ${_gRPC_ROOT}/include
  PRIVATE ${_gRPC_SSL_INCLUDE_DIR}
  PRIVATE ${_gRPC_BENCHMARK_INCLUDE_DIR}
  PRIVATE ${_gRPC_GFLAGS_INCLUDE_DIR}
  PRIVATE ${_gRPC_PROTOBUF_INCLUDE_DIR}
  PRIVATE ${_gRPC_NANOPB_INCLUDE_DIR}
  PRIVATE ${_gRPC_ADDRESS_SORTING_INCLUDE_DIR}
)

  target_link_libraries(hpack_table_test PRIVATE
  ${_gRPC_ALLTARGETS_LIBRARIES}
  grpc_test_util
  grpc
  gpr_test_util
  gpr
)

    add_dependencies(hpack_table_test project_benchmark project_gflags)

  set(http_parser_test_src
   ${_gRPC_ROOT}/test/core/http/parser_test.cc
)
  android_add_executable(http_parser_test)

  target_compile_definitions(http_parser_test PRIVATE -DPB_FIELD_16BIT)
  target_compile_definitions(http_parser_test PUBLIC  -DGRPC_ALLOW_EXCEPTIONS=0)

  target_include_directories(http_parser_test
  PRIVATE ${_gRPC_ROOT}
  PRIVATE ${_gRPC_ROOT}/include
  PRIVATE ${_gRPC_SSL_INCLUDE_DIR}
  PRIVATE ${_gRPC_BENCHMARK_INCLUDE_DIR}
  PRIVATE ${_gRPC_GFLAGS_INCLUDE_DIR}
  PRIVATE ${_gRPC_PROTOBUF_INCLUDE_DIR}
  PRIVATE ${_gRPC_NANOPB_INCLUDE_DIR}
  PRIVATE ${_gRPC_ADDRESS_SORTING_INCLUDE_DIR}
)

  target_link_libraries(http_parser_test PRIVATE
  ${_gRPC_ALLTARGETS_LIBRARIES}
  grpc_test_util
  grpc
  gpr_test_util
  gpr
)

    add_dependencies(http_parser_test project_benchmark project_gflags)

  set(httpcli_format_request_test_src
   ${_gRPC_ROOT}/test/core/http/format_request_test.cc
)
  android_add_executable(httpcli_format_request_test)

  target_compile_definitions(httpcli_format_request_test PRIVATE -DPB_FIELD_16BIT)
  target_compile_definitions(httpcli_format_request_test PUBLIC  -DGRPC_ALLOW_EXCEPTIONS=0)

  target_include_directories(httpcli_format_request_test
  PRIVATE ${_gRPC_ROOT}
  PRIVATE ${_gRPC_ROOT}/include
  PRIVATE ${_gRPC_SSL_INCLUDE_DIR}
  PRIVATE ${_gRPC_BENCHMARK_INCLUDE_DIR}
  PRIVATE ${_gRPC_GFLAGS_INCLUDE_DIR}
  PRIVATE ${_gRPC_PROTOBUF_INCLUDE_DIR}
  PRIVATE ${_gRPC_NANOPB_INCLUDE_DIR}
  PRIVATE ${_gRPC_ADDRESS_SORTING_INCLUDE_DIR}
)

  target_link_libraries(httpcli_format_request_test PRIVATE
  ${_gRPC_ALLTARGETS_LIBRARIES}
  grpc_test_util
  grpc
  gpr_test_util
  gpr
)

    add_dependencies(httpcli_format_request_test project_benchmark project_gflags)
if(_gRPC_PLATFORM_LINUX OR _gRPC_PLATFORM_MAC OR _gRPC_PLATFORM_POSIX)

  set(httpcli_test_src
   ${_gRPC_ROOT}/test/core/http/httpcli_test.cc
)
  android_add_executable(httpcli_test)

  target_compile_definitions(httpcli_test PRIVATE -DPB_FIELD_16BIT)
  target_compile_definitions(httpcli_test PUBLIC  -DGRPC_ALLOW_EXCEPTIONS=0)

  target_include_directories(httpcli_test
  PRIVATE ${_gRPC_ROOT}
  PRIVATE ${_gRPC_ROOT}/include
  PRIVATE ${_gRPC_SSL_INCLUDE_DIR}
  PRIVATE ${_gRPC_BENCHMARK_INCLUDE_DIR}
  PRIVATE ${_gRPC_GFLAGS_INCLUDE_DIR}
  PRIVATE ${_gRPC_PROTOBUF_INCLUDE_DIR}
  PRIVATE ${_gRPC_NANOPB_INCLUDE_DIR}
  PRIVATE ${_gRPC_ADDRESS_SORTING_INCLUDE_DIR}
)

  target_link_libraries(httpcli_test PRIVATE
  ${_gRPC_ALLTARGETS_LIBRARIES}
  grpc_test_util
  grpc
  gpr_test_util
  gpr
)

    add_dependencies(httpcli_test project_benchmark project_gflags)
endif()
if(_gRPC_PLATFORM_LINUX)

  set(httpscli_test_src
   ${_gRPC_ROOT}/test/core/http/httpscli_test.cc
)
  android_add_executable(httpscli_test)

  target_compile_definitions(httpscli_test PRIVATE -DPB_FIELD_16BIT)
  target_compile_definitions(httpscli_test PUBLIC  -DGRPC_ALLOW_EXCEPTIONS=0)

  target_include_directories(httpscli_test
  PRIVATE ${_gRPC_ROOT}
  PRIVATE ${_gRPC_ROOT}/include
  PRIVATE ${_gRPC_SSL_INCLUDE_DIR}
  PRIVATE ${_gRPC_BENCHMARK_INCLUDE_DIR}
  PRIVATE ${_gRPC_GFLAGS_INCLUDE_DIR}
  PRIVATE ${_gRPC_PROTOBUF_INCLUDE_DIR}
  PRIVATE ${_gRPC_NANOPB_INCLUDE_DIR}
  PRIVATE ${_gRPC_ADDRESS_SORTING_INCLUDE_DIR}
)

  target_link_libraries(httpscli_test PRIVATE
  ${_gRPC_ALLTARGETS_LIBRARIES}
  grpc_test_util
  grpc
  gpr_test_util
  gpr
)

    add_dependencies(httpscli_test project_benchmark project_gflags)
endif()

  set(init_test_src
   ${_gRPC_ROOT}/test/core/surface/init_test.cc
)
  android_add_executable(init_test)

  target_compile_definitions(init_test PRIVATE -DPB_FIELD_16BIT)
  target_compile_definitions(init_test PUBLIC  -DGRPC_ALLOW_EXCEPTIONS=0)

  target_include_directories(init_test
  PRIVATE ${_gRPC_ROOT}
  PRIVATE ${_gRPC_ROOT}/include
  PRIVATE ${_gRPC_SSL_INCLUDE_DIR}
  PRIVATE ${_gRPC_BENCHMARK_INCLUDE_DIR}
  PRIVATE ${_gRPC_GFLAGS_INCLUDE_DIR}
  PRIVATE ${_gRPC_PROTOBUF_INCLUDE_DIR}
  PRIVATE ${_gRPC_NANOPB_INCLUDE_DIR}
  PRIVATE ${_gRPC_ADDRESS_SORTING_INCLUDE_DIR}
)

  target_link_libraries(init_test PRIVATE
  ${_gRPC_ALLTARGETS_LIBRARIES}
  grpc_test_util
  grpc
  gpr_test_util
  gpr
)

    add_dependencies(init_test project_benchmark project_gflags)

  set(inproc_callback_test_src
   ${_gRPC_ROOT}/test/core/end2end/inproc_callback_test.cc
)
  android_add_executable(inproc_callback_test)

  target_compile_definitions(inproc_callback_test PRIVATE -DPB_FIELD_16BIT)
  target_compile_definitions(inproc_callback_test PUBLIC  -DGRPC_ALLOW_EXCEPTIONS=0)

  target_include_directories(inproc_callback_test
  PRIVATE ${_gRPC_ROOT}
  PRIVATE ${_gRPC_ROOT}/include
  PRIVATE ${_gRPC_SSL_INCLUDE_DIR}
  PRIVATE ${_gRPC_BENCHMARK_INCLUDE_DIR}
  PRIVATE ${_gRPC_GFLAGS_INCLUDE_DIR}
  PRIVATE ${_gRPC_PROTOBUF_INCLUDE_DIR}
  PRIVATE ${_gRPC_NANOPB_INCLUDE_DIR}
  PRIVATE ${_gRPC_ADDRESS_SORTING_INCLUDE_DIR}
)

  target_link_libraries(inproc_callback_test PRIVATE
  ${_gRPC_ALLTARGETS_LIBRARIES}
  grpc_test_util
  grpc
  gpr_test_util
  gpr
)

    add_dependencies(inproc_callback_test project_benchmark project_gflags)

  set(invalid_call_argument_test_src
   ${_gRPC_ROOT}/test/core/end2end/invalid_call_argument_test.cc
)
  android_add_executable(invalid_call_argument_test)

  target_compile_definitions(invalid_call_argument_test PRIVATE -DPB_FIELD_16BIT)
  target_compile_definitions(invalid_call_argument_test PUBLIC  -DGRPC_ALLOW_EXCEPTIONS=0)

  target_include_directories(invalid_call_argument_test
  PRIVATE ${_gRPC_ROOT}
  PRIVATE ${_gRPC_ROOT}/include
  PRIVATE ${_gRPC_SSL_INCLUDE_DIR}
  PRIVATE ${_gRPC_BENCHMARK_INCLUDE_DIR}
  PRIVATE ${_gRPC_GFLAGS_INCLUDE_DIR}
  PRIVATE ${_gRPC_PROTOBUF_INCLUDE_DIR}
  PRIVATE ${_gRPC_NANOPB_INCLUDE_DIR}
  PRIVATE ${_gRPC_ADDRESS_SORTING_INCLUDE_DIR}
)

  target_link_libraries(invalid_call_argument_test PRIVATE
  ${_gRPC_ALLTARGETS_LIBRARIES}
  grpc_test_util
  grpc
  gpr_test_util
  gpr
)

    add_dependencies(invalid_call_argument_test project_benchmark project_gflags)

  set(json_rewrite_src
   ${_gRPC_ROOT}/test/core/json/json_rewrite.cc
)
  android_add_executable(json_rewrite)

  target_compile_definitions(json_rewrite PRIVATE -DPB_FIELD_16BIT)
  target_compile_definitions(json_rewrite PUBLIC  -DGRPC_ALLOW_EXCEPTIONS=0)

  target_include_directories(json_rewrite
  PRIVATE ${_gRPC_ROOT}
  PRIVATE ${_gRPC_ROOT}/include
  PRIVATE ${_gRPC_SSL_INCLUDE_DIR}
  PRIVATE ${_gRPC_BENCHMARK_INCLUDE_DIR}
  PRIVATE ${_gRPC_GFLAGS_INCLUDE_DIR}
  PRIVATE ${_gRPC_PROTOBUF_INCLUDE_DIR}
  PRIVATE ${_gRPC_NANOPB_INCLUDE_DIR}
  PRIVATE ${_gRPC_ADDRESS_SORTING_INCLUDE_DIR}
)

  target_link_libraries(json_rewrite PRIVATE
  ${_gRPC_ALLTARGETS_LIBRARIES}
  grpc_test_util
  grpc
  gpr_test_util
  gpr
)

    add_dependencies(json_rewrite project_benchmark project_gflags)

  set(json_rewrite_test_src
   ${_gRPC_ROOT}/test/core/json/json_rewrite_test.cc
)
  android_add_executable(json_rewrite_test)

  target_compile_definitions(json_rewrite_test PRIVATE -DPB_FIELD_16BIT)
  target_compile_definitions(json_rewrite_test PUBLIC  -DGRPC_ALLOW_EXCEPTIONS=0)

  target_include_directories(json_rewrite_test
  PRIVATE ${_gRPC_ROOT}
  PRIVATE ${_gRPC_ROOT}/include
  PRIVATE ${_gRPC_SSL_INCLUDE_DIR}
  PRIVATE ${_gRPC_BENCHMARK_INCLUDE_DIR}
  PRIVATE ${_gRPC_GFLAGS_INCLUDE_DIR}
  PRIVATE ${_gRPC_PROTOBUF_INCLUDE_DIR}
  PRIVATE ${_gRPC_NANOPB_INCLUDE_DIR}
  PRIVATE ${_gRPC_ADDRESS_SORTING_INCLUDE_DIR}
)

  target_link_libraries(json_rewrite_test PRIVATE
  ${_gRPC_ALLTARGETS_LIBRARIES}
  grpc_test_util
  grpc
  gpr_test_util
  gpr
)

    add_dependencies(json_rewrite_test project_benchmark project_gflags)

  set(json_stream_error_test_src
   ${_gRPC_ROOT}/test/core/json/json_stream_error_test.cc
)
  android_add_executable(json_stream_error_test)

  target_compile_definitions(json_stream_error_test PRIVATE -DPB_FIELD_16BIT)
  target_compile_definitions(json_stream_error_test PUBLIC  -DGRPC_ALLOW_EXCEPTIONS=0)

  target_include_directories(json_stream_error_test
  PRIVATE ${_gRPC_ROOT}
  PRIVATE ${_gRPC_ROOT}/include
  PRIVATE ${_gRPC_SSL_INCLUDE_DIR}
  PRIVATE ${_gRPC_BENCHMARK_INCLUDE_DIR}
  PRIVATE ${_gRPC_GFLAGS_INCLUDE_DIR}
  PRIVATE ${_gRPC_PROTOBUF_INCLUDE_DIR}
  PRIVATE ${_gRPC_NANOPB_INCLUDE_DIR}
  PRIVATE ${_gRPC_ADDRESS_SORTING_INCLUDE_DIR}
)

  target_link_libraries(json_stream_error_test PRIVATE
  ${_gRPC_ALLTARGETS_LIBRARIES}
  grpc_test_util
  grpc
  gpr_test_util
  gpr
)

    add_dependencies(json_stream_error_test project_benchmark project_gflags)

  set(json_test_src
   ${_gRPC_ROOT}/test/core/json/json_test.cc
)
  android_add_executable(json_test)

  target_compile_definitions(json_test PRIVATE -DPB_FIELD_16BIT)
  target_compile_definitions(json_test PUBLIC  -DGRPC_ALLOW_EXCEPTIONS=0)

  target_include_directories(json_test
  PRIVATE ${_gRPC_ROOT}
  PRIVATE ${_gRPC_ROOT}/include
  PRIVATE ${_gRPC_SSL_INCLUDE_DIR}
  PRIVATE ${_gRPC_BENCHMARK_INCLUDE_DIR}
  PRIVATE ${_gRPC_GFLAGS_INCLUDE_DIR}
  PRIVATE ${_gRPC_PROTOBUF_INCLUDE_DIR}
  PRIVATE ${_gRPC_NANOPB_INCLUDE_DIR}
  PRIVATE ${_gRPC_ADDRESS_SORTING_INCLUDE_DIR}
)

  target_link_libraries(json_test PRIVATE
  ${_gRPC_ALLTARGETS_LIBRARIES}
  grpc_test_util
  grpc
  gpr_test_util
  gpr
)

    add_dependencies(json_test project_benchmark project_gflags)

  set(lame_client_test_src
   ${_gRPC_ROOT}/test/core/surface/lame_client_test.cc
)
  android_add_executable(lame_client_test)

  target_compile_definitions(lame_client_test PRIVATE -DPB_FIELD_16BIT)
  target_compile_definitions(lame_client_test PUBLIC  -DGRPC_ALLOW_EXCEPTIONS=0)

  target_include_directories(lame_client_test
  PRIVATE ${_gRPC_ROOT}
  PRIVATE ${_gRPC_ROOT}/include
  PRIVATE ${_gRPC_SSL_INCLUDE_DIR}
  PRIVATE ${_gRPC_BENCHMARK_INCLUDE_DIR}
  PRIVATE ${_gRPC_GFLAGS_INCLUDE_DIR}
  PRIVATE ${_gRPC_PROTOBUF_INCLUDE_DIR}
  PRIVATE ${_gRPC_NANOPB_INCLUDE_DIR}
  PRIVATE ${_gRPC_ADDRESS_SORTING_INCLUDE_DIR}
)

  target_link_libraries(lame_client_test PRIVATE
  ${_gRPC_ALLTARGETS_LIBRARIES}
  grpc_test_util
  grpc
  gpr_test_util
  gpr
)

    add_dependencies(lame_client_test project_benchmark project_gflags)

  set(load_file_test_src
   ${_gRPC_ROOT}/test/core/iomgr/load_file_test.cc
)
  android_add_executable(load_file_test)

  target_compile_definitions(load_file_test PRIVATE -DPB_FIELD_16BIT)
  target_compile_definitions(load_file_test PUBLIC  -DGRPC_ALLOW_EXCEPTIONS=0)

  target_include_directories(load_file_test
  PRIVATE ${_gRPC_ROOT}
  PRIVATE ${_gRPC_ROOT}/include
  PRIVATE ${_gRPC_SSL_INCLUDE_DIR}
  PRIVATE ${_gRPC_BENCHMARK_INCLUDE_DIR}
  PRIVATE ${_gRPC_GFLAGS_INCLUDE_DIR}
  PRIVATE ${_gRPC_PROTOBUF_INCLUDE_DIR}
  PRIVATE ${_gRPC_NANOPB_INCLUDE_DIR}
  PRIVATE ${_gRPC_ADDRESS_SORTING_INCLUDE_DIR}
)

  target_link_libraries(load_file_test PRIVATE
  ${_gRPC_ALLTARGETS_LIBRARIES}
  grpc_test_util
  grpc
  gpr_test_util
  gpr
)

    add_dependencies(load_file_test project_benchmark project_gflags)

  set(memory_profile_client_src
   ${_gRPC_ROOT}/test/core/memory_usage/client.cc
)
  android_add_executable(memory_profile_client)

  target_compile_definitions(memory_profile_client PRIVATE -DPB_FIELD_16BIT)
  target_compile_definitions(memory_profile_client PUBLIC  -DGRPC_ALLOW_EXCEPTIONS=0)

  target_include_directories(memory_profile_client
  PRIVATE ${_gRPC_ROOT}
  PRIVATE ${_gRPC_ROOT}/include
  PRIVATE ${_gRPC_SSL_INCLUDE_DIR}
  PRIVATE ${_gRPC_BENCHMARK_INCLUDE_DIR}
  PRIVATE ${_gRPC_GFLAGS_INCLUDE_DIR}
  PRIVATE ${_gRPC_PROTOBUF_INCLUDE_DIR}
  PRIVATE ${_gRPC_NANOPB_INCLUDE_DIR}
  PRIVATE ${_gRPC_ADDRESS_SORTING_INCLUDE_DIR}
)

  target_link_libraries(memory_profile_client PRIVATE
  ${_gRPC_ALLTARGETS_LIBRARIES}
  grpc_test_util
  grpc
  gpr_test_util
  gpr
)

    add_dependencies(memory_profile_client project_benchmark project_gflags)

  set(memory_profile_server_src
   ${_gRPC_ROOT}/test/core/memory_usage/server.cc
)
  android_add_executable(memory_profile_server)

  target_compile_definitions(memory_profile_server PRIVATE -DPB_FIELD_16BIT)
  target_compile_definitions(memory_profile_server PUBLIC  -DGRPC_ALLOW_EXCEPTIONS=0)

  target_include_directories(memory_profile_server
  PRIVATE ${_gRPC_ROOT}
  PRIVATE ${_gRPC_ROOT}/include
  PRIVATE ${_gRPC_SSL_INCLUDE_DIR}
  PRIVATE ${_gRPC_BENCHMARK_INCLUDE_DIR}
  PRIVATE ${_gRPC_GFLAGS_INCLUDE_DIR}
  PRIVATE ${_gRPC_PROTOBUF_INCLUDE_DIR}
  PRIVATE ${_gRPC_NANOPB_INCLUDE_DIR}
  PRIVATE ${_gRPC_ADDRESS_SORTING_INCLUDE_DIR}
)

  target_link_libraries(memory_profile_server PRIVATE
  ${_gRPC_ALLTARGETS_LIBRARIES}
  grpc_test_util
  grpc
  gpr_test_util
  gpr
)

    add_dependencies(memory_profile_server project_benchmark project_gflags)
if(_gRPC_PLATFORM_LINUX OR _gRPC_PLATFORM_MAC OR _gRPC_PLATFORM_POSIX)

  set(memory_profile_test_src
   ${_gRPC_ROOT}/test/core/memory_usage/memory_usage_test.cc
)
  android_add_executable(memory_profile_test)

  target_compile_definitions(memory_profile_test PRIVATE -DPB_FIELD_16BIT)
  target_compile_definitions(memory_profile_test PUBLIC  -DGRPC_ALLOW_EXCEPTIONS=0)

  target_include_directories(memory_profile_test
  PRIVATE ${_gRPC_ROOT}
  PRIVATE ${_gRPC_ROOT}/include
  PRIVATE ${_gRPC_SSL_INCLUDE_DIR}
  PRIVATE ${_gRPC_BENCHMARK_INCLUDE_DIR}
  PRIVATE ${_gRPC_GFLAGS_INCLUDE_DIR}
  PRIVATE ${_gRPC_PROTOBUF_INCLUDE_DIR}
  PRIVATE ${_gRPC_NANOPB_INCLUDE_DIR}
  PRIVATE ${_gRPC_ADDRESS_SORTING_INCLUDE_DIR}
)

  target_link_libraries(memory_profile_test PRIVATE
  ${_gRPC_ALLTARGETS_LIBRARIES}
  grpc_test_util
  grpc
  gpr_test_util
  gpr
)

    add_dependencies(memory_profile_test project_benchmark project_gflags)
endif()

  set(message_compress_test_src
   ${_gRPC_ROOT}/test/core/compression/message_compress_test.cc
)
  android_add_executable(message_compress_test)

  target_compile_definitions(message_compress_test PRIVATE -DPB_FIELD_16BIT)
  target_compile_definitions(message_compress_test PUBLIC  -DGRPC_ALLOW_EXCEPTIONS=0)

  target_include_directories(message_compress_test
  PRIVATE ${_gRPC_ROOT}
  PRIVATE ${_gRPC_ROOT}/include
  PRIVATE ${_gRPC_SSL_INCLUDE_DIR}
  PRIVATE ${_gRPC_BENCHMARK_INCLUDE_DIR}
  PRIVATE ${_gRPC_GFLAGS_INCLUDE_DIR}
  PRIVATE ${_gRPC_PROTOBUF_INCLUDE_DIR}
  PRIVATE ${_gRPC_NANOPB_INCLUDE_DIR}
  PRIVATE ${_gRPC_ADDRESS_SORTING_INCLUDE_DIR}
)

  target_link_libraries(message_compress_test PRIVATE
  ${_gRPC_ALLTARGETS_LIBRARIES}
  grpc_test_util
  grpc
  gpr_test_util
  gpr
)

    add_dependencies(message_compress_test project_benchmark project_gflags)

  set(minimal_stack_is_minimal_test_src
   ${_gRPC_ROOT}/test/core/channel/minimal_stack_is_minimal_test.cc
)
  android_add_executable(minimal_stack_is_minimal_test)

  target_compile_definitions(minimal_stack_is_minimal_test PRIVATE -DPB_FIELD_16BIT)
  target_compile_definitions(minimal_stack_is_minimal_test PUBLIC  -DGRPC_ALLOW_EXCEPTIONS=0)

  target_include_directories(minimal_stack_is_minimal_test
  PRIVATE ${_gRPC_ROOT}
  PRIVATE ${_gRPC_ROOT}/include
  PRIVATE ${_gRPC_SSL_INCLUDE_DIR}
  PRIVATE ${_gRPC_BENCHMARK_INCLUDE_DIR}
  PRIVATE ${_gRPC_GFLAGS_INCLUDE_DIR}
  PRIVATE ${_gRPC_PROTOBUF_INCLUDE_DIR}
  PRIVATE ${_gRPC_NANOPB_INCLUDE_DIR}
  PRIVATE ${_gRPC_ADDRESS_SORTING_INCLUDE_DIR}
)

  target_link_libraries(minimal_stack_is_minimal_test PRIVATE
  ${_gRPC_ALLTARGETS_LIBRARIES}
  grpc_test_util
  grpc
  gpr_test_util
  gpr
)

    add_dependencies(minimal_stack_is_minimal_test project_benchmark project_gflags)

  set(multiple_server_queues_test_src
   ${_gRPC_ROOT}/test/core/end2end/multiple_server_queues_test.cc
)
  android_add_executable(multiple_server_queues_test)

  target_compile_definitions(multiple_server_queues_test PRIVATE -DPB_FIELD_16BIT)
  target_compile_definitions(multiple_server_queues_test PUBLIC  -DGRPC_ALLOW_EXCEPTIONS=0)

  target_include_directories(multiple_server_queues_test
  PRIVATE ${_gRPC_ROOT}
  PRIVATE ${_gRPC_ROOT}/include
  PRIVATE ${_gRPC_SSL_INCLUDE_DIR}
  PRIVATE ${_gRPC_BENCHMARK_INCLUDE_DIR}
  PRIVATE ${_gRPC_GFLAGS_INCLUDE_DIR}
  PRIVATE ${_gRPC_PROTOBUF_INCLUDE_DIR}
  PRIVATE ${_gRPC_NANOPB_INCLUDE_DIR}
  PRIVATE ${_gRPC_ADDRESS_SORTING_INCLUDE_DIR}
)

  target_link_libraries(multiple_server_queues_test PRIVATE
  ${_gRPC_ALLTARGETS_LIBRARIES}
  grpc_test_util
  grpc
  gpr_test_util
  gpr
)

    add_dependencies(multiple_server_queues_test project_benchmark project_gflags)

  set(murmur_hash_test_src
   ${_gRPC_ROOT}/test/core/gpr/murmur_hash_test.cc
)
  android_add_executable(murmur_hash_test)

  target_compile_definitions(murmur_hash_test PRIVATE -DPB_FIELD_16BIT)
  target_compile_definitions(murmur_hash_test PUBLIC  -DGRPC_ALLOW_EXCEPTIONS=0)

  target_include_directories(murmur_hash_test
  PRIVATE ${_gRPC_ROOT}
  PRIVATE ${_gRPC_ROOT}/include
  PRIVATE ${_gRPC_SSL_INCLUDE_DIR}
  PRIVATE ${_gRPC_BENCHMARK_INCLUDE_DIR}
  PRIVATE ${_gRPC_GFLAGS_INCLUDE_DIR}
  PRIVATE ${_gRPC_PROTOBUF_INCLUDE_DIR}
  PRIVATE ${_gRPC_NANOPB_INCLUDE_DIR}
  PRIVATE ${_gRPC_ADDRESS_SORTING_INCLUDE_DIR}
)

  target_link_libraries(murmur_hash_test PRIVATE
  ${_gRPC_ALLTARGETS_LIBRARIES}
  gpr_test_util
  gpr
)

    add_dependencies(murmur_hash_test project_benchmark project_gflags)

  set(no_server_test_src
   ${_gRPC_ROOT}/test/core/end2end/no_server_test.cc
)
  android_add_executable(no_server_test)

  target_compile_definitions(no_server_test PRIVATE -DPB_FIELD_16BIT)
  target_compile_definitions(no_server_test PUBLIC  -DGRPC_ALLOW_EXCEPTIONS=0)

  target_include_directories(no_server_test
  PRIVATE ${_gRPC_ROOT}
  PRIVATE ${_gRPC_ROOT}/include
  PRIVATE ${_gRPC_SSL_INCLUDE_DIR}
  PRIVATE ${_gRPC_BENCHMARK_INCLUDE_DIR}
  PRIVATE ${_gRPC_GFLAGS_INCLUDE_DIR}
  PRIVATE ${_gRPC_PROTOBUF_INCLUDE_DIR}
  PRIVATE ${_gRPC_NANOPB_INCLUDE_DIR}
  PRIVATE ${_gRPC_ADDRESS_SORTING_INCLUDE_DIR}
)

  target_link_libraries(no_server_test PRIVATE
  ${_gRPC_ALLTARGETS_LIBRARIES}
  grpc_test_util
  grpc
  gpr_test_util
  gpr
)

    add_dependencies(no_server_test project_benchmark project_gflags)

  set(num_external_connectivity_watchers_test_src
   ${_gRPC_ROOT}/test/core/surface/num_external_connectivity_watchers_test.cc
)
  android_add_executable(num_external_connectivity_watchers_test)

  target_compile_definitions(num_external_connectivity_watchers_test PRIVATE -DPB_FIELD_16BIT)
  target_compile_definitions(num_external_connectivity_watchers_test PUBLIC  -DGRPC_ALLOW_EXCEPTIONS=0)

  target_include_directories(num_external_connectivity_watchers_test
  PRIVATE ${_gRPC_ROOT}
  PRIVATE ${_gRPC_ROOT}/include
  PRIVATE ${_gRPC_SSL_INCLUDE_DIR}
  PRIVATE ${_gRPC_BENCHMARK_INCLUDE_DIR}
  PRIVATE ${_gRPC_GFLAGS_INCLUDE_DIR}
  PRIVATE ${_gRPC_PROTOBUF_INCLUDE_DIR}
  PRIVATE ${_gRPC_NANOPB_INCLUDE_DIR}
  PRIVATE ${_gRPC_ADDRESS_SORTING_INCLUDE_DIR}
)

  target_link_libraries(num_external_connectivity_watchers_test PRIVATE
  ${_gRPC_ALLTARGETS_LIBRARIES}
  grpc_test_util
  grpc
  gpr_test_util
  gpr
)

    add_dependencies(num_external_connectivity_watchers_test project_benchmark project_gflags)

  set(parse_address_test_src
   ${_gRPC_ROOT}/test/core/client_channel/parse_address_test.cc
)
  android_add_executable(parse_address_test)

  target_compile_definitions(parse_address_test PRIVATE -DPB_FIELD_16BIT)
  target_compile_definitions(parse_address_test PUBLIC  -DGRPC_ALLOW_EXCEPTIONS=0)

  target_include_directories(parse_address_test
  PRIVATE ${_gRPC_ROOT}
  PRIVATE ${_gRPC_ROOT}/include
  PRIVATE ${_gRPC_SSL_INCLUDE_DIR}
  PRIVATE ${_gRPC_BENCHMARK_INCLUDE_DIR}
  PRIVATE ${_gRPC_GFLAGS_INCLUDE_DIR}
  PRIVATE ${_gRPC_PROTOBUF_INCLUDE_DIR}
  PRIVATE ${_gRPC_NANOPB_INCLUDE_DIR}
  PRIVATE ${_gRPC_ADDRESS_SORTING_INCLUDE_DIR}
)

  target_link_libraries(parse_address_test PRIVATE
  ${_gRPC_ALLTARGETS_LIBRARIES}
  grpc_test_util
  grpc
  gpr_test_util
  gpr
)

    add_dependencies(parse_address_test project_benchmark project_gflags)

  set(percent_encoding_test_src
   ${_gRPC_ROOT}/test/core/slice/percent_encoding_test.cc
)
  android_add_executable(percent_encoding_test)

  target_compile_definitions(percent_encoding_test PRIVATE -DPB_FIELD_16BIT)
  target_compile_definitions(percent_encoding_test PUBLIC  -DGRPC_ALLOW_EXCEPTIONS=0)

  target_include_directories(percent_encoding_test
  PRIVATE ${_gRPC_ROOT}
  PRIVATE ${_gRPC_ROOT}/include
  PRIVATE ${_gRPC_SSL_INCLUDE_DIR}
  PRIVATE ${_gRPC_BENCHMARK_INCLUDE_DIR}
  PRIVATE ${_gRPC_GFLAGS_INCLUDE_DIR}
  PRIVATE ${_gRPC_PROTOBUF_INCLUDE_DIR}
  PRIVATE ${_gRPC_NANOPB_INCLUDE_DIR}
  PRIVATE ${_gRPC_ADDRESS_SORTING_INCLUDE_DIR}
)

  target_link_libraries(percent_encoding_test PRIVATE
  ${_gRPC_ALLTARGETS_LIBRARIES}
  grpc_test_util
  grpc
  gpr_test_util
  gpr
)

    add_dependencies(percent_encoding_test project_benchmark project_gflags)
if(_gRPC_PLATFORM_LINUX)

  set(pollset_set_test_src
   ${_gRPC_ROOT}/test/core/iomgr/pollset_set_test.cc
)
  android_add_executable(pollset_set_test)

  target_compile_definitions(pollset_set_test PRIVATE -DPB_FIELD_16BIT)
  target_compile_definitions(pollset_set_test PUBLIC  -DGRPC_ALLOW_EXCEPTIONS=0)

  target_include_directories(pollset_set_test
  PRIVATE ${_gRPC_ROOT}
  PRIVATE ${_gRPC_ROOT}/include
  PRIVATE ${_gRPC_SSL_INCLUDE_DIR}
  PRIVATE ${_gRPC_BENCHMARK_INCLUDE_DIR}
  PRIVATE ${_gRPC_GFLAGS_INCLUDE_DIR}
  PRIVATE ${_gRPC_PROTOBUF_INCLUDE_DIR}
  PRIVATE ${_gRPC_NANOPB_INCLUDE_DIR}
  PRIVATE ${_gRPC_ADDRESS_SORTING_INCLUDE_DIR}
)

  target_link_libraries(pollset_set_test PRIVATE
  ${_gRPC_ALLTARGETS_LIBRARIES}
  grpc_test_util
  grpc
  gpr_test_util
  gpr
)

    add_dependencies(pollset_set_test project_benchmark project_gflags)
endif()
if(_gRPC_PLATFORM_LINUX OR _gRPC_PLATFORM_MAC OR _gRPC_PLATFORM_POSIX)

  set(resolve_address_posix_test_src
   ${_gRPC_ROOT}/test/core/iomgr/resolve_address_posix_test.cc
)
  android_add_executable(resolve_address_posix_test)

  target_compile_definitions(resolve_address_posix_test PRIVATE -DPB_FIELD_16BIT)
  target_compile_definitions(resolve_address_posix_test PUBLIC  -DGRPC_ALLOW_EXCEPTIONS=0)

  target_include_directories(resolve_address_posix_test
  PRIVATE ${_gRPC_ROOT}
  PRIVATE ${_gRPC_ROOT}/include
  PRIVATE ${_gRPC_SSL_INCLUDE_DIR}
  PRIVATE ${_gRPC_BENCHMARK_INCLUDE_DIR}
  PRIVATE ${_gRPC_GFLAGS_INCLUDE_DIR}
  PRIVATE ${_gRPC_PROTOBUF_INCLUDE_DIR}
  PRIVATE ${_gRPC_NANOPB_INCLUDE_DIR}
  PRIVATE ${_gRPC_ADDRESS_SORTING_INCLUDE_DIR}
)

  target_link_libraries(resolve_address_posix_test PRIVATE
  ${_gRPC_ALLTARGETS_LIBRARIES}
  grpc_test_util
  grpc
  gpr_test_util
  gpr
)

    add_dependencies(resolve_address_posix_test project_benchmark project_gflags)
endif()

  set(resolve_address_using_ares_resolver_test_src
   ${_gRPC_ROOT}/test/core/iomgr/resolve_address_test.cc
)
  android_add_executable(resolve_address_using_ares_resolver_test)

  target_compile_definitions(resolve_address_using_ares_resolver_test PRIVATE -DPB_FIELD_16BIT)
  target_compile_definitions(resolve_address_using_ares_resolver_test PUBLIC  -DGRPC_ALLOW_EXCEPTIONS=0)

  target_include_directories(resolve_address_using_ares_resolver_test
  PRIVATE ${_gRPC_ROOT}
  PRIVATE ${_gRPC_ROOT}/include
  PRIVATE ${_gRPC_SSL_INCLUDE_DIR}
  PRIVATE ${_gRPC_BENCHMARK_INCLUDE_DIR}
  PRIVATE ${_gRPC_GFLAGS_INCLUDE_DIR}
  PRIVATE ${_gRPC_PROTOBUF_INCLUDE_DIR}
  PRIVATE ${_gRPC_NANOPB_INCLUDE_DIR}
  PRIVATE ${_gRPC_ADDRESS_SORTING_INCLUDE_DIR}
)

  target_link_libraries(resolve_address_using_ares_resolver_test PRIVATE
  ${_gRPC_ALLTARGETS_LIBRARIES}
  grpc_test_util
  grpc
  gpr_test_util
  gpr
)

    add_dependencies(resolve_address_using_ares_resolver_test project_benchmark project_gflags)

  set(resolve_address_using_native_resolver_test_src
   ${_gRPC_ROOT}/test/core/iomgr/resolve_address_test.cc
)
  android_add_executable(resolve_address_using_native_resolver_test)

  target_compile_definitions(resolve_address_using_native_resolver_test PRIVATE -DPB_FIELD_16BIT)
  target_compile_definitions(resolve_address_using_native_resolver_test PUBLIC  -DGRPC_ALLOW_EXCEPTIONS=0)

  target_include_directories(resolve_address_using_native_resolver_test
  PRIVATE ${_gRPC_ROOT}
  PRIVATE ${_gRPC_ROOT}/include
  PRIVATE ${_gRPC_SSL_INCLUDE_DIR}
  PRIVATE ${_gRPC_BENCHMARK_INCLUDE_DIR}
  PRIVATE ${_gRPC_GFLAGS_INCLUDE_DIR}
  PRIVATE ${_gRPC_PROTOBUF_INCLUDE_DIR}
  PRIVATE ${_gRPC_NANOPB_INCLUDE_DIR}
  PRIVATE ${_gRPC_ADDRESS_SORTING_INCLUDE_DIR}
)

  target_link_libraries(resolve_address_using_native_resolver_test PRIVATE
  ${_gRPC_ALLTARGETS_LIBRARIES}
  grpc_test_util
  grpc
  gpr_test_util
  gpr
)

    add_dependencies(resolve_address_using_native_resolver_test project_benchmark project_gflags)

  set(resource_quota_test_src
   ${_gRPC_ROOT}/test/core/iomgr/resource_quota_test.cc
)
  android_add_executable(resource_quota_test)

  target_compile_definitions(resource_quota_test PRIVATE -DPB_FIELD_16BIT)
  target_compile_definitions(resource_quota_test PUBLIC  -DGRPC_ALLOW_EXCEPTIONS=0)

  target_include_directories(resource_quota_test
  PRIVATE ${_gRPC_ROOT}
  PRIVATE ${_gRPC_ROOT}/include
  PRIVATE ${_gRPC_SSL_INCLUDE_DIR}
  PRIVATE ${_gRPC_BENCHMARK_INCLUDE_DIR}
  PRIVATE ${_gRPC_GFLAGS_INCLUDE_DIR}
  PRIVATE ${_gRPC_PROTOBUF_INCLUDE_DIR}
  PRIVATE ${_gRPC_NANOPB_INCLUDE_DIR}
  PRIVATE ${_gRPC_ADDRESS_SORTING_INCLUDE_DIR}
)

  target_link_libraries(resource_quota_test PRIVATE
  ${_gRPC_ALLTARGETS_LIBRARIES}
  grpc_test_util
  grpc
  gpr_test_util
  gpr
)

    add_dependencies(resource_quota_test project_benchmark project_gflags)

  set(secure_channel_create_test_src
   ${_gRPC_ROOT}/test/core/surface/secure_channel_create_test.cc
)
  android_add_executable(secure_channel_create_test)

  target_compile_definitions(secure_channel_create_test PRIVATE -DPB_FIELD_16BIT)
  target_compile_definitions(secure_channel_create_test PUBLIC  -DGRPC_ALLOW_EXCEPTIONS=0)

  target_include_directories(secure_channel_create_test
  PRIVATE ${_gRPC_ROOT}
  PRIVATE ${_gRPC_ROOT}/include
  PRIVATE ${_gRPC_SSL_INCLUDE_DIR}
  PRIVATE ${_gRPC_BENCHMARK_INCLUDE_DIR}
  PRIVATE ${_gRPC_GFLAGS_INCLUDE_DIR}
  PRIVATE ${_gRPC_PROTOBUF_INCLUDE_DIR}
  PRIVATE ${_gRPC_NANOPB_INCLUDE_DIR}
  PRIVATE ${_gRPC_ADDRESS_SORTING_INCLUDE_DIR}
)

  target_link_libraries(secure_channel_create_test PRIVATE
  ${_gRPC_ALLTARGETS_LIBRARIES}
  grpc_test_util
  grpc
  gpr_test_util
  gpr
)

    add_dependencies(secure_channel_create_test project_benchmark project_gflags)

  set(secure_endpoint_test_src
   ${_gRPC_ROOT}/test/core/security/secure_endpoint_test.cc
)
  android_add_executable(secure_endpoint_test)

  target_compile_definitions(secure_endpoint_test PRIVATE -DPB_FIELD_16BIT)
  target_compile_definitions(secure_endpoint_test PUBLIC  -DGRPC_ALLOW_EXCEPTIONS=0)

  target_include_directories(secure_endpoint_test
  PRIVATE ${_gRPC_ROOT}
  PRIVATE ${_gRPC_ROOT}/include
  PRIVATE ${_gRPC_SSL_INCLUDE_DIR}
  PRIVATE ${_gRPC_BENCHMARK_INCLUDE_DIR}
  PRIVATE ${_gRPC_GFLAGS_INCLUDE_DIR}
  PRIVATE ${_gRPC_PROTOBUF_INCLUDE_DIR}
  PRIVATE ${_gRPC_NANOPB_INCLUDE_DIR}
  PRIVATE ${_gRPC_ADDRESS_SORTING_INCLUDE_DIR}
)

  target_link_libraries(secure_endpoint_test PRIVATE
  ${_gRPC_ALLTARGETS_LIBRARIES}
  grpc_test_util
  grpc
  gpr_test_util
  gpr
)

    add_dependencies(secure_endpoint_test project_benchmark project_gflags)

  set(sequential_connectivity_test_src
   ${_gRPC_ROOT}/test/core/surface/sequential_connectivity_test.cc
)
  android_add_executable(sequential_connectivity_test)

  target_compile_definitions(sequential_connectivity_test PRIVATE -DPB_FIELD_16BIT)
  target_compile_definitions(sequential_connectivity_test PUBLIC  -DGRPC_ALLOW_EXCEPTIONS=0)

  target_include_directories(sequential_connectivity_test
  PRIVATE ${_gRPC_ROOT}
  PRIVATE ${_gRPC_ROOT}/include
  PRIVATE ${_gRPC_SSL_INCLUDE_DIR}
  PRIVATE ${_gRPC_BENCHMARK_INCLUDE_DIR}
  PRIVATE ${_gRPC_GFLAGS_INCLUDE_DIR}
  PRIVATE ${_gRPC_PROTOBUF_INCLUDE_DIR}
  PRIVATE ${_gRPC_NANOPB_INCLUDE_DIR}
  PRIVATE ${_gRPC_ADDRESS_SORTING_INCLUDE_DIR}
)

  target_link_libraries(sequential_connectivity_test PRIVATE
  ${_gRPC_ALLTARGETS_LIBRARIES}
  grpc_test_util
  grpc
  gpr_test_util
  gpr
)

    add_dependencies(sequential_connectivity_test project_benchmark project_gflags)

  set(server_chttp2_test_src
   ${_gRPC_ROOT}/test/core/surface/server_chttp2_test.cc
)
  android_add_executable(server_chttp2_test)

  target_compile_definitions(server_chttp2_test PRIVATE -DPB_FIELD_16BIT)
  target_compile_definitions(server_chttp2_test PUBLIC  -DGRPC_ALLOW_EXCEPTIONS=0)

  target_include_directories(server_chttp2_test
  PRIVATE ${_gRPC_ROOT}
  PRIVATE ${_gRPC_ROOT}/include
  PRIVATE ${_gRPC_SSL_INCLUDE_DIR}
  PRIVATE ${_gRPC_BENCHMARK_INCLUDE_DIR}
  PRIVATE ${_gRPC_GFLAGS_INCLUDE_DIR}
  PRIVATE ${_gRPC_PROTOBUF_INCLUDE_DIR}
  PRIVATE ${_gRPC_NANOPB_INCLUDE_DIR}
  PRIVATE ${_gRPC_ADDRESS_SORTING_INCLUDE_DIR}
)

  target_link_libraries(server_chttp2_test PRIVATE
  ${_gRPC_ALLTARGETS_LIBRARIES}
  grpc_test_util
  grpc
  gpr_test_util
  gpr
)

    add_dependencies(server_chttp2_test project_benchmark project_gflags)

  set(server_test_src
   ${_gRPC_ROOT}/test/core/surface/server_test.cc
)
  android_add_executable(server_test)

  target_compile_definitions(server_test PRIVATE -DPB_FIELD_16BIT)
  target_compile_definitions(server_test PUBLIC  -DGRPC_ALLOW_EXCEPTIONS=0)

  target_include_directories(server_test
  PRIVATE ${_gRPC_ROOT}
  PRIVATE ${_gRPC_ROOT}/include
  PRIVATE ${_gRPC_SSL_INCLUDE_DIR}
  PRIVATE ${_gRPC_BENCHMARK_INCLUDE_DIR}
  PRIVATE ${_gRPC_GFLAGS_INCLUDE_DIR}
  PRIVATE ${_gRPC_PROTOBUF_INCLUDE_DIR}
  PRIVATE ${_gRPC_NANOPB_INCLUDE_DIR}
  PRIVATE ${_gRPC_ADDRESS_SORTING_INCLUDE_DIR}
)

  target_link_libraries(server_test PRIVATE
  ${_gRPC_ALLTARGETS_LIBRARIES}
  grpc_test_util
  grpc
  gpr_test_util
  gpr
)

    add_dependencies(server_test project_benchmark project_gflags)

  set(slice_buffer_test_src
   ${_gRPC_ROOT}/test/core/slice/slice_buffer_test.cc
)
  android_add_executable(slice_buffer_test)

  target_compile_definitions(slice_buffer_test PRIVATE -DPB_FIELD_16BIT)
  target_compile_definitions(slice_buffer_test PUBLIC  -DGRPC_ALLOW_EXCEPTIONS=0)

  target_include_directories(slice_buffer_test
  PRIVATE ${_gRPC_ROOT}
  PRIVATE ${_gRPC_ROOT}/include
  PRIVATE ${_gRPC_SSL_INCLUDE_DIR}
  PRIVATE ${_gRPC_BENCHMARK_INCLUDE_DIR}
  PRIVATE ${_gRPC_GFLAGS_INCLUDE_DIR}
  PRIVATE ${_gRPC_PROTOBUF_INCLUDE_DIR}
  PRIVATE ${_gRPC_NANOPB_INCLUDE_DIR}
  PRIVATE ${_gRPC_ADDRESS_SORTING_INCLUDE_DIR}
)

  target_link_libraries(slice_buffer_test PRIVATE
  ${_gRPC_ALLTARGETS_LIBRARIES}
  grpc_test_util
  grpc
  gpr_test_util
  gpr
)

    add_dependencies(slice_buffer_test project_benchmark project_gflags)

  set(slice_string_helpers_test_src
   ${_gRPC_ROOT}/test/core/slice/slice_string_helpers_test.cc
)
  android_add_executable(slice_string_helpers_test)

  target_compile_definitions(slice_string_helpers_test PRIVATE -DPB_FIELD_16BIT)
  target_compile_definitions(slice_string_helpers_test PUBLIC  -DGRPC_ALLOW_EXCEPTIONS=0)

  target_include_directories(slice_string_helpers_test
  PRIVATE ${_gRPC_ROOT}
  PRIVATE ${_gRPC_ROOT}/include
  PRIVATE ${_gRPC_SSL_INCLUDE_DIR}
  PRIVATE ${_gRPC_BENCHMARK_INCLUDE_DIR}
  PRIVATE ${_gRPC_GFLAGS_INCLUDE_DIR}
  PRIVATE ${_gRPC_PROTOBUF_INCLUDE_DIR}
  PRIVATE ${_gRPC_NANOPB_INCLUDE_DIR}
  PRIVATE ${_gRPC_ADDRESS_SORTING_INCLUDE_DIR}
)

  target_link_libraries(slice_string_helpers_test PRIVATE
  ${_gRPC_ALLTARGETS_LIBRARIES}
  grpc_test_util
  grpc
  gpr_test_util
  gpr
)

    add_dependencies(slice_string_helpers_test project_benchmark project_gflags)

  set(slice_test_src
   ${_gRPC_ROOT}/test/core/slice/slice_test.cc
)
  android_add_executable(slice_test)

  target_compile_definitions(slice_test PRIVATE -DPB_FIELD_16BIT)
  target_compile_definitions(slice_test PUBLIC  -DGRPC_ALLOW_EXCEPTIONS=0)

  target_include_directories(slice_test
  PRIVATE ${_gRPC_ROOT}
  PRIVATE ${_gRPC_ROOT}/include
  PRIVATE ${_gRPC_SSL_INCLUDE_DIR}
  PRIVATE ${_gRPC_BENCHMARK_INCLUDE_DIR}
  PRIVATE ${_gRPC_GFLAGS_INCLUDE_DIR}
  PRIVATE ${_gRPC_PROTOBUF_INCLUDE_DIR}
  PRIVATE ${_gRPC_NANOPB_INCLUDE_DIR}
  PRIVATE ${_gRPC_ADDRESS_SORTING_INCLUDE_DIR}
)

  target_link_libraries(slice_test PRIVATE
  ${_gRPC_ALLTARGETS_LIBRARIES}
  grpc_test_util
  grpc
  gpr_test_util
  gpr
)

    add_dependencies(slice_test project_benchmark project_gflags)

  set(sockaddr_resolver_test_src
   ${_gRPC_ROOT}/test/core/client_channel/resolvers/sockaddr_resolver_test.cc
)
  android_add_executable(sockaddr_resolver_test)

  target_compile_definitions(sockaddr_resolver_test PRIVATE -DPB_FIELD_16BIT)
  target_compile_definitions(sockaddr_resolver_test PUBLIC  -DGRPC_ALLOW_EXCEPTIONS=0)

  target_include_directories(sockaddr_resolver_test
  PRIVATE ${_gRPC_ROOT}
  PRIVATE ${_gRPC_ROOT}/include
  PRIVATE ${_gRPC_SSL_INCLUDE_DIR}
  PRIVATE ${_gRPC_BENCHMARK_INCLUDE_DIR}
  PRIVATE ${_gRPC_GFLAGS_INCLUDE_DIR}
  PRIVATE ${_gRPC_PROTOBUF_INCLUDE_DIR}
  PRIVATE ${_gRPC_NANOPB_INCLUDE_DIR}
  PRIVATE ${_gRPC_ADDRESS_SORTING_INCLUDE_DIR}
)

  target_link_libraries(sockaddr_resolver_test PRIVATE
  ${_gRPC_ALLTARGETS_LIBRARIES}
  grpc_test_util
  grpc
  gpr_test_util
  gpr
)

    add_dependencies(sockaddr_resolver_test project_benchmark project_gflags)

  set(sockaddr_utils_test_src
   ${_gRPC_ROOT}/test/core/iomgr/sockaddr_utils_test.cc
)
  android_add_executable(sockaddr_utils_test)

  target_compile_definitions(sockaddr_utils_test PRIVATE -DPB_FIELD_16BIT)
  target_compile_definitions(sockaddr_utils_test PUBLIC  -DGRPC_ALLOW_EXCEPTIONS=0)

  target_include_directories(sockaddr_utils_test
  PRIVATE ${_gRPC_ROOT}
  PRIVATE ${_gRPC_ROOT}/include
  PRIVATE ${_gRPC_SSL_INCLUDE_DIR}
  PRIVATE ${_gRPC_BENCHMARK_INCLUDE_DIR}
  PRIVATE ${_gRPC_GFLAGS_INCLUDE_DIR}
  PRIVATE ${_gRPC_PROTOBUF_INCLUDE_DIR}
  PRIVATE ${_gRPC_NANOPB_INCLUDE_DIR}
  PRIVATE ${_gRPC_ADDRESS_SORTING_INCLUDE_DIR}
)

  target_link_libraries(sockaddr_utils_test PRIVATE
  ${_gRPC_ALLTARGETS_LIBRARIES}
  grpc_test_util
  grpc
  gpr_test_util
  gpr
)

    add_dependencies(sockaddr_utils_test project_benchmark project_gflags)
if(_gRPC_PLATFORM_LINUX OR _gRPC_PLATFORM_MAC OR _gRPC_PLATFORM_POSIX)

  set(socket_utils_test_src
   ${_gRPC_ROOT}/test/core/iomgr/socket_utils_test.cc
)
  android_add_executable(socket_utils_test)

  target_compile_definitions(socket_utils_test PRIVATE -DPB_FIELD_16BIT)
  target_compile_definitions(socket_utils_test PUBLIC  -DGRPC_ALLOW_EXCEPTIONS=0)

  target_include_directories(socket_utils_test
  PRIVATE ${_gRPC_ROOT}
  PRIVATE ${_gRPC_ROOT}/include
  PRIVATE ${_gRPC_SSL_INCLUDE_DIR}
  PRIVATE ${_gRPC_BENCHMARK_INCLUDE_DIR}
  PRIVATE ${_gRPC_GFLAGS_INCLUDE_DIR}
  PRIVATE ${_gRPC_PROTOBUF_INCLUDE_DIR}
  PRIVATE ${_gRPC_NANOPB_INCLUDE_DIR}
  PRIVATE ${_gRPC_ADDRESS_SORTING_INCLUDE_DIR}
)

  target_link_libraries(socket_utils_test PRIVATE
  ${_gRPC_ALLTARGETS_LIBRARIES}
  grpc_test_util
  grpc
  gpr_test_util
  gpr
)

    add_dependencies(socket_utils_test project_benchmark project_gflags)
endif()
if(_gRPC_PLATFORM_LINUX OR _gRPC_PLATFORM_MAC OR _gRPC_PLATFORM_POSIX)

  set(ssl_transport_security_test_src
   ${_gRPC_ROOT}/test/core/tsi/ssl_transport_security_test.cc
   ${_gRPC_ROOT}/test/core/tsi/transport_security_test_lib.cc
)
  android_add_executable(ssl_transport_security_test)

  target_compile_definitions(ssl_transport_security_test PRIVATE -DPB_FIELD_16BIT)
  target_compile_definitions(ssl_transport_security_test PUBLIC  -DGRPC_ALLOW_EXCEPTIONS=0)

  target_include_directories(ssl_transport_security_test
  PRIVATE ${_gRPC_ROOT}
  PRIVATE ${_gRPC_ROOT}/include
  PRIVATE ${_gRPC_SSL_INCLUDE_DIR}
  PRIVATE ${_gRPC_BENCHMARK_INCLUDE_DIR}
  PRIVATE ${_gRPC_GFLAGS_INCLUDE_DIR}
  PRIVATE ${_gRPC_PROTOBUF_INCLUDE_DIR}
  PRIVATE ${_gRPC_NANOPB_INCLUDE_DIR}
  PRIVATE ${_gRPC_ADDRESS_SORTING_INCLUDE_DIR}
)

  target_link_libraries(ssl_transport_security_test PRIVATE
  ${_gRPC_ALLTARGETS_LIBRARIES}
  gpr_test_util
  gpr
  grpc
)

    add_dependencies(ssl_transport_security_test project_benchmark project_gflags)
endif()

  set(status_conversion_test_src
   ${_gRPC_ROOT}/test/core/transport/status_conversion_test.cc
)
  android_add_executable(status_conversion_test)

  target_compile_definitions(status_conversion_test PRIVATE -DPB_FIELD_16BIT)
  target_compile_definitions(status_conversion_test PUBLIC  -DGRPC_ALLOW_EXCEPTIONS=0)

  target_include_directories(status_conversion_test
  PRIVATE ${_gRPC_ROOT}
  PRIVATE ${_gRPC_ROOT}/include
  PRIVATE ${_gRPC_SSL_INCLUDE_DIR}
  PRIVATE ${_gRPC_BENCHMARK_INCLUDE_DIR}
  PRIVATE ${_gRPC_GFLAGS_INCLUDE_DIR}
  PRIVATE ${_gRPC_PROTOBUF_INCLUDE_DIR}
  PRIVATE ${_gRPC_NANOPB_INCLUDE_DIR}
  PRIVATE ${_gRPC_ADDRESS_SORTING_INCLUDE_DIR}
)

  target_link_libraries(status_conversion_test PRIVATE
  ${_gRPC_ALLTARGETS_LIBRARIES}
  grpc_test_util
  grpc
  gpr_test_util
  gpr
)

    add_dependencies(status_conversion_test project_benchmark project_gflags)

  set(stream_compression_test_src
   ${_gRPC_ROOT}/test/core/compression/stream_compression_test.cc
)
  android_add_executable(stream_compression_test)

  target_compile_definitions(stream_compression_test PRIVATE -DPB_FIELD_16BIT)
  target_compile_definitions(stream_compression_test PUBLIC  -DGRPC_ALLOW_EXCEPTIONS=0)

  target_include_directories(stream_compression_test
  PRIVATE ${_gRPC_ROOT}
  PRIVATE ${_gRPC_ROOT}/include
  PRIVATE ${_gRPC_SSL_INCLUDE_DIR}
  PRIVATE ${_gRPC_BENCHMARK_INCLUDE_DIR}
  PRIVATE ${_gRPC_GFLAGS_INCLUDE_DIR}
  PRIVATE ${_gRPC_PROTOBUF_INCLUDE_DIR}
  PRIVATE ${_gRPC_NANOPB_INCLUDE_DIR}
  PRIVATE ${_gRPC_ADDRESS_SORTING_INCLUDE_DIR}
)

  target_link_libraries(stream_compression_test PRIVATE
  ${_gRPC_ALLTARGETS_LIBRARIES}
  grpc_test_util
  grpc
  gpr_test_util
  gpr
)

    add_dependencies(stream_compression_test project_benchmark project_gflags)

  set(stream_owned_slice_test_src
   ${_gRPC_ROOT}/test/core/transport/stream_owned_slice_test.cc
)
  android_add_executable(stream_owned_slice_test)

  target_compile_definitions(stream_owned_slice_test PRIVATE -DPB_FIELD_16BIT)
  target_compile_definitions(stream_owned_slice_test PUBLIC  -DGRPC_ALLOW_EXCEPTIONS=0)

  target_include_directories(stream_owned_slice_test
  PRIVATE ${_gRPC_ROOT}
  PRIVATE ${_gRPC_ROOT}/include
  PRIVATE ${_gRPC_SSL_INCLUDE_DIR}
  PRIVATE ${_gRPC_BENCHMARK_INCLUDE_DIR}
  PRIVATE ${_gRPC_GFLAGS_INCLUDE_DIR}
  PRIVATE ${_gRPC_PROTOBUF_INCLUDE_DIR}
  PRIVATE ${_gRPC_NANOPB_INCLUDE_DIR}
  PRIVATE ${_gRPC_ADDRESS_SORTING_INCLUDE_DIR}
)

  target_link_libraries(stream_owned_slice_test PRIVATE
  ${_gRPC_ALLTARGETS_LIBRARIES}
  grpc_test_util
  grpc
  gpr_test_util
  gpr
)

    add_dependencies(stream_owned_slice_test project_benchmark project_gflags)
if(_gRPC_PLATFORM_LINUX OR _gRPC_PLATFORM_MAC OR _gRPC_PLATFORM_POSIX)

  set(tcp_client_posix_test_src
   ${_gRPC_ROOT}/test/core/iomgr/tcp_client_posix_test.cc
)
  android_add_executable(tcp_client_posix_test)

  target_compile_definitions(tcp_client_posix_test PRIVATE -DPB_FIELD_16BIT)
  target_compile_definitions(tcp_client_posix_test PUBLIC  -DGRPC_ALLOW_EXCEPTIONS=0)

  target_include_directories(tcp_client_posix_test
  PRIVATE ${_gRPC_ROOT}
  PRIVATE ${_gRPC_ROOT}/include
  PRIVATE ${_gRPC_SSL_INCLUDE_DIR}
  PRIVATE ${_gRPC_BENCHMARK_INCLUDE_DIR}
  PRIVATE ${_gRPC_GFLAGS_INCLUDE_DIR}
  PRIVATE ${_gRPC_PROTOBUF_INCLUDE_DIR}
  PRIVATE ${_gRPC_NANOPB_INCLUDE_DIR}
  PRIVATE ${_gRPC_ADDRESS_SORTING_INCLUDE_DIR}
)

  target_link_libraries(tcp_client_posix_test PRIVATE
  ${_gRPC_ALLTARGETS_LIBRARIES}
  grpc_test_util
  grpc
  gpr_test_util
  gpr
)

    add_dependencies(tcp_client_posix_test project_benchmark project_gflags)
endif()

  set(tcp_client_uv_test_src
   ${_gRPC_ROOT}/test/core/iomgr/tcp_client_uv_test.cc
)
  android_add_executable(tcp_client_uv_test)

  target_compile_definitions(tcp_client_uv_test PRIVATE -DPB_FIELD_16BIT)
  target_compile_definitions(tcp_client_uv_test PUBLIC  -DGRPC_ALLOW_EXCEPTIONS=0)

  target_include_directories(tcp_client_uv_test
  PRIVATE ${_gRPC_ROOT}
  PRIVATE ${_gRPC_ROOT}/include
  PRIVATE ${_gRPC_SSL_INCLUDE_DIR}
  PRIVATE ${_gRPC_BENCHMARK_INCLUDE_DIR}
  PRIVATE ${_gRPC_GFLAGS_INCLUDE_DIR}
  PRIVATE ${_gRPC_PROTOBUF_INCLUDE_DIR}
  PRIVATE ${_gRPC_NANOPB_INCLUDE_DIR}
  PRIVATE ${_gRPC_ADDRESS_SORTING_INCLUDE_DIR}
)

  target_link_libraries(tcp_client_uv_test PRIVATE
  ${_gRPC_ALLTARGETS_LIBRARIES}
  grpc_test_util
  grpc
  gpr_test_util
  gpr
)

    add_dependencies(tcp_client_uv_test project_benchmark project_gflags)
if(_gRPC_PLATFORM_LINUX OR _gRPC_PLATFORM_MAC OR _gRPC_PLATFORM_POSIX)

  set(tcp_posix_test_src
   ${_gRPC_ROOT}/test/core/iomgr/tcp_posix_test.cc
)
  android_add_executable(tcp_posix_test)

  target_compile_definitions(tcp_posix_test PRIVATE -DPB_FIELD_16BIT)
  target_compile_definitions(tcp_posix_test PUBLIC  -DGRPC_ALLOW_EXCEPTIONS=0)

  target_include_directories(tcp_posix_test
  PRIVATE ${_gRPC_ROOT}
  PRIVATE ${_gRPC_ROOT}/include
  PRIVATE ${_gRPC_SSL_INCLUDE_DIR}
  PRIVATE ${_gRPC_BENCHMARK_INCLUDE_DIR}
  PRIVATE ${_gRPC_GFLAGS_INCLUDE_DIR}
  PRIVATE ${_gRPC_PROTOBUF_INCLUDE_DIR}
  PRIVATE ${_gRPC_NANOPB_INCLUDE_DIR}
  PRIVATE ${_gRPC_ADDRESS_SORTING_INCLUDE_DIR}
)

  target_link_libraries(tcp_posix_test PRIVATE
  ${_gRPC_ALLTARGETS_LIBRARIES}
  grpc_test_util
  grpc
  gpr_test_util
  gpr
)

    add_dependencies(tcp_posix_test project_benchmark project_gflags)
endif()
if(_gRPC_PLATFORM_LINUX OR _gRPC_PLATFORM_MAC OR _gRPC_PLATFORM_POSIX)

  set(tcp_server_posix_test_src
   ${_gRPC_ROOT}/test/core/iomgr/tcp_server_posix_test.cc
)
  android_add_executable(tcp_server_posix_test)

  target_compile_definitions(tcp_server_posix_test PRIVATE -DPB_FIELD_16BIT)
  target_compile_definitions(tcp_server_posix_test PUBLIC  -DGRPC_ALLOW_EXCEPTIONS=0)

  target_include_directories(tcp_server_posix_test
  PRIVATE ${_gRPC_ROOT}
  PRIVATE ${_gRPC_ROOT}/include
  PRIVATE ${_gRPC_SSL_INCLUDE_DIR}
  PRIVATE ${_gRPC_BENCHMARK_INCLUDE_DIR}
  PRIVATE ${_gRPC_GFLAGS_INCLUDE_DIR}
  PRIVATE ${_gRPC_PROTOBUF_INCLUDE_DIR}
  PRIVATE ${_gRPC_NANOPB_INCLUDE_DIR}
  PRIVATE ${_gRPC_ADDRESS_SORTING_INCLUDE_DIR}
)

  target_link_libraries(tcp_server_posix_test PRIVATE
  ${_gRPC_ALLTARGETS_LIBRARIES}
  grpc_test_util
  grpc
  gpr_test_util
  gpr
)

    add_dependencies(tcp_server_posix_test project_benchmark project_gflags)
endif()

  set(tcp_server_uv_test_src
   ${_gRPC_ROOT}/test/core/iomgr/tcp_server_uv_test.cc
)
  android_add_executable(tcp_server_uv_test)

  target_compile_definitions(tcp_server_uv_test PRIVATE -DPB_FIELD_16BIT)
  target_compile_definitions(tcp_server_uv_test PUBLIC  -DGRPC_ALLOW_EXCEPTIONS=0)

  target_include_directories(tcp_server_uv_test
  PRIVATE ${_gRPC_ROOT}
  PRIVATE ${_gRPC_ROOT}/include
  PRIVATE ${_gRPC_SSL_INCLUDE_DIR}
  PRIVATE ${_gRPC_BENCHMARK_INCLUDE_DIR}
  PRIVATE ${_gRPC_GFLAGS_INCLUDE_DIR}
  PRIVATE ${_gRPC_PROTOBUF_INCLUDE_DIR}
  PRIVATE ${_gRPC_NANOPB_INCLUDE_DIR}
  PRIVATE ${_gRPC_ADDRESS_SORTING_INCLUDE_DIR}
)

  target_link_libraries(tcp_server_uv_test PRIVATE
  ${_gRPC_ALLTARGETS_LIBRARIES}
  grpc_test_util
  grpc
  gpr_test_util
  gpr
)

    add_dependencies(tcp_server_uv_test project_benchmark project_gflags)

  set(time_averaged_stats_test_src
   ${_gRPC_ROOT}/test/core/iomgr/time_averaged_stats_test.cc
)
  android_add_executable(time_averaged_stats_test)

  target_compile_definitions(time_averaged_stats_test PRIVATE -DPB_FIELD_16BIT)
  target_compile_definitions(time_averaged_stats_test PUBLIC  -DGRPC_ALLOW_EXCEPTIONS=0)

  target_include_directories(time_averaged_stats_test
  PRIVATE ${_gRPC_ROOT}
  PRIVATE ${_gRPC_ROOT}/include
  PRIVATE ${_gRPC_SSL_INCLUDE_DIR}
  PRIVATE ${_gRPC_BENCHMARK_INCLUDE_DIR}
  PRIVATE ${_gRPC_GFLAGS_INCLUDE_DIR}
  PRIVATE ${_gRPC_PROTOBUF_INCLUDE_DIR}
  PRIVATE ${_gRPC_NANOPB_INCLUDE_DIR}
  PRIVATE ${_gRPC_ADDRESS_SORTING_INCLUDE_DIR}
)

  target_link_libraries(time_averaged_stats_test PRIVATE
  ${_gRPC_ALLTARGETS_LIBRARIES}
  grpc_test_util
  grpc
  gpr_test_util
  gpr
)

    add_dependencies(time_averaged_stats_test project_benchmark project_gflags)

  set(timeout_encoding_test_src
   ${_gRPC_ROOT}/test/core/transport/timeout_encoding_test.cc
)
  android_add_executable(timeout_encoding_test)

  target_compile_definitions(timeout_encoding_test PRIVATE -DPB_FIELD_16BIT)
  target_compile_definitions(timeout_encoding_test PUBLIC  -DGRPC_ALLOW_EXCEPTIONS=0)

  target_include_directories(timeout_encoding_test
  PRIVATE ${_gRPC_ROOT}
  PRIVATE ${_gRPC_ROOT}/include
  PRIVATE ${_gRPC_SSL_INCLUDE_DIR}
  PRIVATE ${_gRPC_BENCHMARK_INCLUDE_DIR}
  PRIVATE ${_gRPC_GFLAGS_INCLUDE_DIR}
  PRIVATE ${_gRPC_PROTOBUF_INCLUDE_DIR}
  PRIVATE ${_gRPC_NANOPB_INCLUDE_DIR}
  PRIVATE ${_gRPC_ADDRESS_SORTING_INCLUDE_DIR}
)

  target_link_libraries(timeout_encoding_test PRIVATE
  ${_gRPC_ALLTARGETS_LIBRARIES}
  grpc_test_util
  grpc
  gpr_test_util
  gpr
)

    add_dependencies(timeout_encoding_test project_benchmark project_gflags)

  set(timer_heap_test_src
   ${_gRPC_ROOT}/test/core/iomgr/timer_heap_test.cc
)
  android_add_executable(timer_heap_test)

  target_compile_definitions(timer_heap_test PRIVATE -DPB_FIELD_16BIT)
  target_compile_definitions(timer_heap_test PUBLIC  -DGRPC_ALLOW_EXCEPTIONS=0)

  target_include_directories(timer_heap_test
  PRIVATE ${_gRPC_ROOT}
  PRIVATE ${_gRPC_ROOT}/include
  PRIVATE ${_gRPC_SSL_INCLUDE_DIR}
  PRIVATE ${_gRPC_BENCHMARK_INCLUDE_DIR}
  PRIVATE ${_gRPC_GFLAGS_INCLUDE_DIR}
  PRIVATE ${_gRPC_PROTOBUF_INCLUDE_DIR}
  PRIVATE ${_gRPC_NANOPB_INCLUDE_DIR}
  PRIVATE ${_gRPC_ADDRESS_SORTING_INCLUDE_DIR}
)

  target_link_libraries(timer_heap_test PRIVATE
  ${_gRPC_ALLTARGETS_LIBRARIES}
  grpc_test_util
  grpc
  gpr_test_util
  gpr
)

    add_dependencies(timer_heap_test project_benchmark project_gflags)

  set(timer_list_test_src
   ${_gRPC_ROOT}/test/core/iomgr/timer_list_test.cc
)
  android_add_executable(timer_list_test)

  target_compile_definitions(timer_list_test PRIVATE -DPB_FIELD_16BIT)
  target_compile_definitions(timer_list_test PUBLIC  -DGRPC_ALLOW_EXCEPTIONS=0)

  target_include_directories(timer_list_test
  PRIVATE ${_gRPC_ROOT}
  PRIVATE ${_gRPC_ROOT}/include
  PRIVATE ${_gRPC_SSL_INCLUDE_DIR}
  PRIVATE ${_gRPC_BENCHMARK_INCLUDE_DIR}
  PRIVATE ${_gRPC_GFLAGS_INCLUDE_DIR}
  PRIVATE ${_gRPC_PROTOBUF_INCLUDE_DIR}
  PRIVATE ${_gRPC_NANOPB_INCLUDE_DIR}
  PRIVATE ${_gRPC_ADDRESS_SORTING_INCLUDE_DIR}
)

  target_link_libraries(timer_list_test PRIVATE
  ${_gRPC_ALLTARGETS_LIBRARIES}
  grpc_test_util
  grpc
  gpr_test_util
  gpr
)

    add_dependencies(timer_list_test project_benchmark project_gflags)

  set(transport_connectivity_state_test_src
   ${_gRPC_ROOT}/test/core/transport/connectivity_state_test.cc
)
  android_add_executable(transport_connectivity_state_test)

  target_compile_definitions(transport_connectivity_state_test PRIVATE -DPB_FIELD_16BIT)
  target_compile_definitions(transport_connectivity_state_test PUBLIC  -DGRPC_ALLOW_EXCEPTIONS=0)

  target_include_directories(transport_connectivity_state_test
  PRIVATE ${_gRPC_ROOT}
  PRIVATE ${_gRPC_ROOT}/include
  PRIVATE ${_gRPC_SSL_INCLUDE_DIR}
  PRIVATE ${_gRPC_BENCHMARK_INCLUDE_DIR}
  PRIVATE ${_gRPC_GFLAGS_INCLUDE_DIR}
  PRIVATE ${_gRPC_PROTOBUF_INCLUDE_DIR}
  PRIVATE ${_gRPC_NANOPB_INCLUDE_DIR}
  PRIVATE ${_gRPC_ADDRESS_SORTING_INCLUDE_DIR}
)

  target_link_libraries(transport_connectivity_state_test PRIVATE
  ${_gRPC_ALLTARGETS_LIBRARIES}
  grpc_test_util
  grpc
  gpr_test_util
  gpr
)

    add_dependencies(transport_connectivity_state_test project_benchmark project_gflags)

  set(transport_metadata_test_src
   ${_gRPC_ROOT}/test/core/transport/metadata_test.cc
)
  android_add_executable(transport_metadata_test)

  target_compile_definitions(transport_metadata_test PRIVATE -DPB_FIELD_16BIT)
  target_compile_definitions(transport_metadata_test PUBLIC  -DGRPC_ALLOW_EXCEPTIONS=0)

  target_include_directories(transport_metadata_test
  PRIVATE ${_gRPC_ROOT}
  PRIVATE ${_gRPC_ROOT}/include
  PRIVATE ${_gRPC_SSL_INCLUDE_DIR}
  PRIVATE ${_gRPC_BENCHMARK_INCLUDE_DIR}
  PRIVATE ${_gRPC_GFLAGS_INCLUDE_DIR}
  PRIVATE ${_gRPC_PROTOBUF_INCLUDE_DIR}
  PRIVATE ${_gRPC_NANOPB_INCLUDE_DIR}
  PRIVATE ${_gRPC_ADDRESS_SORTING_INCLUDE_DIR}
)

  target_link_libraries(transport_metadata_test PRIVATE
  ${_gRPC_ALLTARGETS_LIBRARIES}
  grpc_test_util
  grpc
  gpr_test_util
  gpr
)

    add_dependencies(transport_metadata_test project_benchmark project_gflags)
if(_gRPC_PLATFORM_LINUX OR _gRPC_PLATFORM_MAC OR _gRPC_PLATFORM_POSIX)

  set(transport_security_test_src
   ${_gRPC_ROOT}/test/core/tsi/transport_security_test.cc
)
  android_add_executable(transport_security_test)

  target_compile_definitions(transport_security_test PRIVATE -DPB_FIELD_16BIT)
  target_compile_definitions(transport_security_test PUBLIC  -DGRPC_ALLOW_EXCEPTIONS=0)

  target_include_directories(transport_security_test
  PRIVATE ${_gRPC_ROOT}
  PRIVATE ${_gRPC_ROOT}/include
  PRIVATE ${_gRPC_SSL_INCLUDE_DIR}
  PRIVATE ${_gRPC_BENCHMARK_INCLUDE_DIR}
  PRIVATE ${_gRPC_GFLAGS_INCLUDE_DIR}
  PRIVATE ${_gRPC_PROTOBUF_INCLUDE_DIR}
  PRIVATE ${_gRPC_NANOPB_INCLUDE_DIR}
  PRIVATE ${_gRPC_ADDRESS_SORTING_INCLUDE_DIR}
)

  target_link_libraries(transport_security_test PRIVATE
  ${_gRPC_ALLTARGETS_LIBRARIES}
  grpc_test_util
  grpc
  gpr_test_util
  gpr
)

    add_dependencies(transport_security_test project_benchmark project_gflags)
endif()
if(_gRPC_PLATFORM_LINUX OR _gRPC_PLATFORM_MAC OR _gRPC_PLATFORM_POSIX)

  set(udp_server_test_src
   ${_gRPC_ROOT}/test/core/iomgr/udp_server_test.cc
)
  android_add_executable(udp_server_test)

  target_compile_definitions(udp_server_test PRIVATE -DPB_FIELD_16BIT)
  target_compile_definitions(udp_server_test PUBLIC  -DGRPC_ALLOW_EXCEPTIONS=0)

  target_include_directories(udp_server_test
  PRIVATE ${_gRPC_ROOT}
  PRIVATE ${_gRPC_ROOT}/include
  PRIVATE ${_gRPC_SSL_INCLUDE_DIR}
  PRIVATE ${_gRPC_BENCHMARK_INCLUDE_DIR}
  PRIVATE ${_gRPC_GFLAGS_INCLUDE_DIR}
  PRIVATE ${_gRPC_PROTOBUF_INCLUDE_DIR}
  PRIVATE ${_gRPC_NANOPB_INCLUDE_DIR}
  PRIVATE ${_gRPC_ADDRESS_SORTING_INCLUDE_DIR}
)

  target_link_libraries(udp_server_test PRIVATE
  ${_gRPC_ALLTARGETS_LIBRARIES}
  grpc_test_util
  grpc
  gpr_test_util
  gpr
)

    add_dependencies(udp_server_test project_benchmark project_gflags)
endif()

  set(uri_parser_test_src
   ${_gRPC_ROOT}/test/core/client_channel/uri_parser_test.cc
)
  android_add_executable(uri_parser_test)

  target_compile_definitions(uri_parser_test PRIVATE -DPB_FIELD_16BIT)
  target_compile_definitions(uri_parser_test PUBLIC  -DGRPC_ALLOW_EXCEPTIONS=0)

  target_include_directories(uri_parser_test
  PRIVATE ${_gRPC_ROOT}
  PRIVATE ${_gRPC_ROOT}/include
  PRIVATE ${_gRPC_SSL_INCLUDE_DIR}
  PRIVATE ${_gRPC_BENCHMARK_INCLUDE_DIR}
  PRIVATE ${_gRPC_GFLAGS_INCLUDE_DIR}
  PRIVATE ${_gRPC_PROTOBUF_INCLUDE_DIR}
  PRIVATE ${_gRPC_NANOPB_INCLUDE_DIR}
  PRIVATE ${_gRPC_ADDRESS_SORTING_INCLUDE_DIR}
)

  target_link_libraries(uri_parser_test PRIVATE
  ${_gRPC_ALLTARGETS_LIBRARIES}
  grpc_test_util
  grpc
  gpr_test_util
  gpr
)

    add_dependencies(uri_parser_test project_benchmark project_gflags)
if(_gRPC_PLATFORM_LINUX OR _gRPC_PLATFORM_MAC OR _gRPC_PLATFORM_POSIX)

  set(wakeup_fd_cv_test_src
   ${_gRPC_ROOT}/test/core/iomgr/wakeup_fd_cv_test.cc
)
  android_add_executable(wakeup_fd_cv_test)

  target_compile_definitions(wakeup_fd_cv_test PRIVATE -DPB_FIELD_16BIT)
  target_compile_definitions(wakeup_fd_cv_test PUBLIC  -DGRPC_ALLOW_EXCEPTIONS=0)

  target_include_directories(wakeup_fd_cv_test
  PRIVATE ${_gRPC_ROOT}
  PRIVATE ${_gRPC_ROOT}/include
  PRIVATE ${_gRPC_SSL_INCLUDE_DIR}
  PRIVATE ${_gRPC_BENCHMARK_INCLUDE_DIR}
  PRIVATE ${_gRPC_GFLAGS_INCLUDE_DIR}
  PRIVATE ${_gRPC_PROTOBUF_INCLUDE_DIR}
  PRIVATE ${_gRPC_NANOPB_INCLUDE_DIR}
  PRIVATE ${_gRPC_ADDRESS_SORTING_INCLUDE_DIR}
)

  target_link_libraries(wakeup_fd_cv_test PRIVATE
  ${_gRPC_ALLTARGETS_LIBRARIES}
  grpc_test_util
  grpc
  gpr_test_util
  gpr
)

    add_dependencies(wakeup_fd_cv_test project_benchmark project_gflags)
endif()

  set(alarm_test_src
   ${_gRPC_ROOT}/test/cpp/common/alarm_test.cc
)
  android_add_test(alarm_test)
  target_link_libraries(alarm_test PRIVATE gmock_main ssl crypto)
  target_include_directories(alarm_test PRIVATE ${_gRPC_ROOT})

  target_compile_definitions(alarm_test PRIVATE -DPB_FIELD_16BIT)
  target_compile_definitions(alarm_test PUBLIC  -DGRPC_ALLOW_EXCEPTIONS=0)

  target_include_directories(alarm_test
  PRIVATE ${_gRPC_ROOT}
  PRIVATE ${_gRPC_ROOT}/include
  PRIVATE ${_gRPC_SSL_INCLUDE_DIR}
  PRIVATE ${_gRPC_BENCHMARK_INCLUDE_DIR}
  PRIVATE ${_gRPC_GFLAGS_INCLUDE_DIR}
  PRIVATE ${_gRPC_PROTOBUF_INCLUDE_DIR}
  PRIVATE ${_gRPC_NANOPB_INCLUDE_DIR}
  PRIVATE ${_gRPC_ADDRESS_SORTING_INCLUDE_DIR}
  PRIVATE ${_gRPC_GTEST_INCLUDE_DIR}
  PRIVATE ${_gRPC_PROTO_GENS_DIR}
)

  target_link_libraries(alarm_test PRIVATE
  ${_gRPC_PROTOBUF_LIBRARIES}
  ${_gRPC_ALLTARGETS_LIBRARIES}
  grpc++_test_util_unsecure
  grpc_test_util_unsecure
  grpc++_unsecure
  grpc_unsecure
  gpr_test_util
  gpr
  ${_gRPC_GFLAGS_LIBRARIES}
)

    add_dependencies(alarm_test project_benchmark project_gflags)

  set(alts_counter_test_src
   ${_gRPC_ROOT}/test/core/tsi/alts/frame_protector/alts_counter_test.cc
)
  android_add_test(alts_counter_test)
  target_link_libraries(alts_counter_test PRIVATE gmock_main ssl crypto)
  target_include_directories(alts_counter_test PRIVATE ${_gRPC_ROOT})

  target_compile_definitions(alts_counter_test PRIVATE -DPB_FIELD_16BIT)
  target_compile_definitions(alts_counter_test PUBLIC  -DGRPC_ALLOW_EXCEPTIONS=0)

  target_include_directories(alts_counter_test
  PRIVATE ${_gRPC_ROOT}
  PRIVATE ${_gRPC_ROOT}/include
  PRIVATE ${_gRPC_SSL_INCLUDE_DIR}
  PRIVATE ${_gRPC_BENCHMARK_INCLUDE_DIR}
  PRIVATE ${_gRPC_GFLAGS_INCLUDE_DIR}
  PRIVATE ${_gRPC_PROTOBUF_INCLUDE_DIR}
  PRIVATE ${_gRPC_NANOPB_INCLUDE_DIR}
  PRIVATE ${_gRPC_ADDRESS_SORTING_INCLUDE_DIR}
  PRIVATE ${_gRPC_GTEST_INCLUDE_DIR}
  PRIVATE ${_gRPC_PROTO_GENS_DIR}
)

  target_link_libraries(alts_counter_test PRIVATE
  ${_gRPC_PROTOBUF_LIBRARIES}
  ${_gRPC_ALLTARGETS_LIBRARIES}
  alts_test_util
  gpr
  grpc
  ${_gRPC_GFLAGS_LIBRARIES}
)

    add_dependencies(alts_counter_test project_benchmark project_gflags)

  set(alts_crypt_test_src
   ${_gRPC_ROOT}/test/core/tsi/alts/crypt/aes_gcm_test.cc
)
  android_add_test(alts_crypt_test)
  target_link_libraries(alts_crypt_test PRIVATE gmock_main ssl crypto)
  target_include_directories(alts_crypt_test PRIVATE ${_gRPC_ROOT})

  target_compile_definitions(alts_crypt_test PRIVATE -DPB_FIELD_16BIT)
  target_compile_definitions(alts_crypt_test PUBLIC  -DGRPC_ALLOW_EXCEPTIONS=0)

  target_include_directories(alts_crypt_test
  PRIVATE ${_gRPC_ROOT}
  PRIVATE ${_gRPC_ROOT}/include
  PRIVATE ${_gRPC_SSL_INCLUDE_DIR}
  PRIVATE ${_gRPC_BENCHMARK_INCLUDE_DIR}
  PRIVATE ${_gRPC_GFLAGS_INCLUDE_DIR}
  PRIVATE ${_gRPC_PROTOBUF_INCLUDE_DIR}
  PRIVATE ${_gRPC_NANOPB_INCLUDE_DIR}
  PRIVATE ${_gRPC_ADDRESS_SORTING_INCLUDE_DIR}
  PRIVATE ${_gRPC_GTEST_INCLUDE_DIR}
  PRIVATE ${_gRPC_PROTO_GENS_DIR}
)

  target_link_libraries(alts_crypt_test PRIVATE
  ${_gRPC_PROTOBUF_LIBRARIES}
  ${_gRPC_ALLTARGETS_LIBRARIES}
  alts_test_util
  gpr_test_util
  gpr
  grpc
  ${_gRPC_GFLAGS_LIBRARIES}
)

    add_dependencies(alts_crypt_test project_benchmark project_gflags)

  set(alts_crypter_test_src
   ${_gRPC_ROOT}/test/core/tsi/alts/frame_protector/alts_crypter_test.cc
)
  android_add_test(alts_crypter_test)
  target_link_libraries(alts_crypter_test PRIVATE gmock_main ssl crypto)
  target_include_directories(alts_crypter_test PRIVATE ${_gRPC_ROOT})

  target_compile_definitions(alts_crypter_test PRIVATE -DPB_FIELD_16BIT)
  target_compile_definitions(alts_crypter_test PUBLIC  -DGRPC_ALLOW_EXCEPTIONS=0)

  target_include_directories(alts_crypter_test
  PRIVATE ${_gRPC_ROOT}
  PRIVATE ${_gRPC_ROOT}/include
  PRIVATE ${_gRPC_SSL_INCLUDE_DIR}
  PRIVATE ${_gRPC_BENCHMARK_INCLUDE_DIR}
  PRIVATE ${_gRPC_GFLAGS_INCLUDE_DIR}
  PRIVATE ${_gRPC_PROTOBUF_INCLUDE_DIR}
  PRIVATE ${_gRPC_NANOPB_INCLUDE_DIR}
  PRIVATE ${_gRPC_ADDRESS_SORTING_INCLUDE_DIR}
  PRIVATE ${_gRPC_GTEST_INCLUDE_DIR}
  PRIVATE ${_gRPC_PROTO_GENS_DIR}
)

  target_link_libraries(alts_crypter_test PRIVATE
  ${_gRPC_PROTOBUF_LIBRARIES}
  ${_gRPC_ALLTARGETS_LIBRARIES}
  alts_test_util
  gpr
  grpc
  ${_gRPC_GFLAGS_LIBRARIES}
)

    add_dependencies(alts_crypter_test project_benchmark project_gflags)

  set(alts_frame_handler_test_src
   ${_gRPC_ROOT}/test/core/tsi/alts/frame_protector/frame_handler_test.cc
)
  android_add_test(alts_frame_handler_test)
  target_link_libraries(alts_frame_handler_test PRIVATE gmock_main ssl crypto)
  target_include_directories(alts_frame_handler_test PRIVATE ${_gRPC_ROOT})

  target_compile_definitions(alts_frame_handler_test PRIVATE -DPB_FIELD_16BIT)
  target_compile_definitions(alts_frame_handler_test PUBLIC  -DGRPC_ALLOW_EXCEPTIONS=0)

  target_include_directories(alts_frame_handler_test
  PRIVATE ${_gRPC_ROOT}
  PRIVATE ${_gRPC_ROOT}/include
  PRIVATE ${_gRPC_SSL_INCLUDE_DIR}
  PRIVATE ${_gRPC_BENCHMARK_INCLUDE_DIR}
  PRIVATE ${_gRPC_GFLAGS_INCLUDE_DIR}
  PRIVATE ${_gRPC_PROTOBUF_INCLUDE_DIR}
  PRIVATE ${_gRPC_NANOPB_INCLUDE_DIR}
  PRIVATE ${_gRPC_ADDRESS_SORTING_INCLUDE_DIR}
  PRIVATE ${_gRPC_GTEST_INCLUDE_DIR}
  PRIVATE ${_gRPC_PROTO_GENS_DIR}
)

  target_link_libraries(alts_frame_handler_test PRIVATE
  ${_gRPC_PROTOBUF_LIBRARIES}
  ${_gRPC_ALLTARGETS_LIBRARIES}
  alts_test_util
  gpr
  grpc
  ${_gRPC_GFLAGS_LIBRARIES}
)

    add_dependencies(alts_frame_handler_test project_benchmark project_gflags)

  set(alts_frame_protector_test_src
   ${_gRPC_ROOT}/test/core/tsi/alts/frame_protector/alts_frame_protector_test.cc
   ${_gRPC_ROOT}/test/core/tsi/transport_security_test_lib.cc
)
  android_add_test(alts_frame_protector_test)
  target_link_libraries(alts_frame_protector_test PRIVATE gmock_main ssl crypto)
  target_include_directories(alts_frame_protector_test PRIVATE ${_gRPC_ROOT})

  target_compile_definitions(alts_frame_protector_test PRIVATE -DPB_FIELD_16BIT)
  target_compile_definitions(alts_frame_protector_test PUBLIC  -DGRPC_ALLOW_EXCEPTIONS=0)

  target_include_directories(alts_frame_protector_test
  PRIVATE ${_gRPC_ROOT}
  PRIVATE ${_gRPC_ROOT}/include
  PRIVATE ${_gRPC_SSL_INCLUDE_DIR}
  PRIVATE ${_gRPC_BENCHMARK_INCLUDE_DIR}
  PRIVATE ${_gRPC_GFLAGS_INCLUDE_DIR}
  PRIVATE ${_gRPC_PROTOBUF_INCLUDE_DIR}
  PRIVATE ${_gRPC_NANOPB_INCLUDE_DIR}
  PRIVATE ${_gRPC_ADDRESS_SORTING_INCLUDE_DIR}
  PRIVATE ${_gRPC_GTEST_INCLUDE_DIR}
  PRIVATE ${_gRPC_PROTO_GENS_DIR}
)

  target_link_libraries(alts_frame_protector_test PRIVATE
  ${_gRPC_PROTOBUF_LIBRARIES}
  ${_gRPC_ALLTARGETS_LIBRARIES}
  alts_test_util
  gpr
  grpc
  ${_gRPC_GFLAGS_LIBRARIES}
)

    add_dependencies(alts_frame_protector_test project_benchmark project_gflags)

  set(alts_grpc_record_protocol_test_src
   ${_gRPC_ROOT}/test/core/tsi/alts/zero_copy_frame_protector/alts_grpc_record_protocol_test.cc
)
  android_add_test(alts_grpc_record_protocol_test)
  target_link_libraries(alts_grpc_record_protocol_test PRIVATE gmock_main ssl crypto)
  target_include_directories(alts_grpc_record_protocol_test PRIVATE ${_gRPC_ROOT})

  target_compile_definitions(alts_grpc_record_protocol_test PRIVATE -DPB_FIELD_16BIT)
  target_compile_definitions(alts_grpc_record_protocol_test PUBLIC  -DGRPC_ALLOW_EXCEPTIONS=0)

  target_include_directories(alts_grpc_record_protocol_test
  PRIVATE ${_gRPC_ROOT}
  PRIVATE ${_gRPC_ROOT}/include
  PRIVATE ${_gRPC_SSL_INCLUDE_DIR}
  PRIVATE ${_gRPC_BENCHMARK_INCLUDE_DIR}
  PRIVATE ${_gRPC_GFLAGS_INCLUDE_DIR}
  PRIVATE ${_gRPC_PROTOBUF_INCLUDE_DIR}
  PRIVATE ${_gRPC_NANOPB_INCLUDE_DIR}
  PRIVATE ${_gRPC_ADDRESS_SORTING_INCLUDE_DIR}
  PRIVATE ${_gRPC_GTEST_INCLUDE_DIR}
  PRIVATE ${_gRPC_PROTO_GENS_DIR}
)

  target_link_libraries(alts_grpc_record_protocol_test PRIVATE
  ${_gRPC_PROTOBUF_LIBRARIES}
  ${_gRPC_ALLTARGETS_LIBRARIES}
  alts_test_util
  gpr
  grpc
  ${_gRPC_GFLAGS_LIBRARIES}
)

    add_dependencies(alts_grpc_record_protocol_test project_benchmark project_gflags)

  set(alts_handshaker_client_test_src
   ${_gRPC_ROOT}/test/core/tsi/alts/handshaker/alts_handshaker_client_test.cc
)
  android_add_test(alts_handshaker_client_test)
  target_link_libraries(alts_handshaker_client_test PRIVATE gmock_main ssl crypto)
  target_include_directories(alts_handshaker_client_test PRIVATE ${_gRPC_ROOT})

  target_compile_definitions(alts_handshaker_client_test PRIVATE -DPB_FIELD_16BIT)
  target_compile_definitions(alts_handshaker_client_test PUBLIC  -DGRPC_ALLOW_EXCEPTIONS=0)

  target_include_directories(alts_handshaker_client_test
  PRIVATE ${_gRPC_ROOT}
  PRIVATE ${_gRPC_ROOT}/include
  PRIVATE ${_gRPC_SSL_INCLUDE_DIR}
  PRIVATE ${_gRPC_BENCHMARK_INCLUDE_DIR}
  PRIVATE ${_gRPC_GFLAGS_INCLUDE_DIR}
  PRIVATE ${_gRPC_PROTOBUF_INCLUDE_DIR}
  PRIVATE ${_gRPC_NANOPB_INCLUDE_DIR}
  PRIVATE ${_gRPC_ADDRESS_SORTING_INCLUDE_DIR}
  PRIVATE ${_gRPC_GTEST_INCLUDE_DIR}
  PRIVATE ${_gRPC_PROTO_GENS_DIR}
)

  target_link_libraries(alts_handshaker_client_test PRIVATE
  ${_gRPC_PROTOBUF_LIBRARIES}
  ${_gRPC_ALLTARGETS_LIBRARIES}
  alts_test_util
  gpr
  grpc
  ${_gRPC_GFLAGS_LIBRARIES}
)

    add_dependencies(alts_handshaker_client_test project_benchmark project_gflags)

  set(alts_handshaker_service_api_test_src
   ${_gRPC_ROOT}/test/core/tsi/alts/handshaker/alts_handshaker_service_api_test.cc
)
  android_add_test(alts_handshaker_service_api_test)
  target_link_libraries(alts_handshaker_service_api_test PRIVATE gmock_main ssl crypto)
  target_include_directories(alts_handshaker_service_api_test PRIVATE ${_gRPC_ROOT})

  target_compile_definitions(alts_handshaker_service_api_test PRIVATE -DPB_FIELD_16BIT)
  target_compile_definitions(alts_handshaker_service_api_test PUBLIC  -DGRPC_ALLOW_EXCEPTIONS=0)

  target_include_directories(alts_handshaker_service_api_test
  PRIVATE ${_gRPC_ROOT}
  PRIVATE ${_gRPC_ROOT}/include
  PRIVATE ${_gRPC_SSL_INCLUDE_DIR}
  PRIVATE ${_gRPC_BENCHMARK_INCLUDE_DIR}
  PRIVATE ${_gRPC_GFLAGS_INCLUDE_DIR}
  PRIVATE ${_gRPC_PROTOBUF_INCLUDE_DIR}
  PRIVATE ${_gRPC_NANOPB_INCLUDE_DIR}
  PRIVATE ${_gRPC_ADDRESS_SORTING_INCLUDE_DIR}
  PRIVATE ${_gRPC_GTEST_INCLUDE_DIR}
  PRIVATE ${_gRPC_PROTO_GENS_DIR}
)

  target_link_libraries(alts_handshaker_service_api_test PRIVATE
  ${_gRPC_PROTOBUF_LIBRARIES}
  ${_gRPC_ALLTARGETS_LIBRARIES}
  alts_test_util
  gpr
  grpc
  ${_gRPC_GFLAGS_LIBRARIES}
)

    add_dependencies(alts_handshaker_service_api_test project_benchmark project_gflags)

  set(alts_iovec_record_protocol_test_src
   ${_gRPC_ROOT}/test/core/tsi/alts/zero_copy_frame_protector/alts_iovec_record_protocol_test.cc
)
  android_add_test(alts_iovec_record_protocol_test)
  target_link_libraries(alts_iovec_record_protocol_test PRIVATE gmock_main ssl crypto)
  target_include_directories(alts_iovec_record_protocol_test PRIVATE ${_gRPC_ROOT})

  target_compile_definitions(alts_iovec_record_protocol_test PRIVATE -DPB_FIELD_16BIT)
  target_compile_definitions(alts_iovec_record_protocol_test PUBLIC  -DGRPC_ALLOW_EXCEPTIONS=0)

  target_include_directories(alts_iovec_record_protocol_test
  PRIVATE ${_gRPC_ROOT}
  PRIVATE ${_gRPC_ROOT}/include
  PRIVATE ${_gRPC_SSL_INCLUDE_DIR}
  PRIVATE ${_gRPC_BENCHMARK_INCLUDE_DIR}
  PRIVATE ${_gRPC_GFLAGS_INCLUDE_DIR}
  PRIVATE ${_gRPC_PROTOBUF_INCLUDE_DIR}
  PRIVATE ${_gRPC_NANOPB_INCLUDE_DIR}
  PRIVATE ${_gRPC_ADDRESS_SORTING_INCLUDE_DIR}
  PRIVATE ${_gRPC_GTEST_INCLUDE_DIR}
  PRIVATE ${_gRPC_PROTO_GENS_DIR}
)

  target_link_libraries(alts_iovec_record_protocol_test PRIVATE
  ${_gRPC_PROTOBUF_LIBRARIES}
  ${_gRPC_ALLTARGETS_LIBRARIES}
  alts_test_util
  gpr
  grpc
  ${_gRPC_GFLAGS_LIBRARIES}
)

    add_dependencies(alts_iovec_record_protocol_test project_benchmark project_gflags)

  set(alts_security_connector_test_src
   ${_gRPC_ROOT}/test/core/security/alts_security_connector_test.cc
)
  android_add_test(alts_security_connector_test)
  target_link_libraries(alts_security_connector_test PRIVATE gmock_main ssl crypto)
  target_include_directories(alts_security_connector_test PRIVATE ${_gRPC_ROOT})

  target_compile_definitions(alts_security_connector_test PRIVATE -DPB_FIELD_16BIT)
  target_compile_definitions(alts_security_connector_test PUBLIC  -DGRPC_ALLOW_EXCEPTIONS=0)

  target_include_directories(alts_security_connector_test
  PRIVATE ${_gRPC_ROOT}
  PRIVATE ${_gRPC_ROOT}/include
  PRIVATE ${_gRPC_SSL_INCLUDE_DIR}
  PRIVATE ${_gRPC_BENCHMARK_INCLUDE_DIR}
  PRIVATE ${_gRPC_GFLAGS_INCLUDE_DIR}
  PRIVATE ${_gRPC_PROTOBUF_INCLUDE_DIR}
  PRIVATE ${_gRPC_NANOPB_INCLUDE_DIR}
  PRIVATE ${_gRPC_ADDRESS_SORTING_INCLUDE_DIR}
  PRIVATE ${_gRPC_GTEST_INCLUDE_DIR}
  PRIVATE ${_gRPC_PROTO_GENS_DIR}
)

  target_link_libraries(alts_security_connector_test PRIVATE
  ${_gRPC_PROTOBUF_LIBRARIES}
  ${_gRPC_ALLTARGETS_LIBRARIES}
  gpr
  grpc
  ${_gRPC_GFLAGS_LIBRARIES}
)

    add_dependencies(alts_security_connector_test project_benchmark project_gflags)

  set(alts_tsi_handshaker_test_src
   ${_gRPC_ROOT}/test/core/tsi/alts/handshaker/alts_tsi_handshaker_test.cc
)
  android_add_test(alts_tsi_handshaker_test)
  target_link_libraries(alts_tsi_handshaker_test PRIVATE gmock_main ssl crypto)
  target_include_directories(alts_tsi_handshaker_test PRIVATE ${_gRPC_ROOT})

  target_compile_definitions(alts_tsi_handshaker_test PRIVATE -DPB_FIELD_16BIT)
  target_compile_definitions(alts_tsi_handshaker_test PUBLIC  -DGRPC_ALLOW_EXCEPTIONS=0)

  target_include_directories(alts_tsi_handshaker_test
  PRIVATE ${_gRPC_ROOT}
  PRIVATE ${_gRPC_ROOT}/include
  PRIVATE ${_gRPC_SSL_INCLUDE_DIR}
  PRIVATE ${_gRPC_BENCHMARK_INCLUDE_DIR}
  PRIVATE ${_gRPC_GFLAGS_INCLUDE_DIR}
  PRIVATE ${_gRPC_PROTOBUF_INCLUDE_DIR}
  PRIVATE ${_gRPC_NANOPB_INCLUDE_DIR}
  PRIVATE ${_gRPC_ADDRESS_SORTING_INCLUDE_DIR}
  PRIVATE ${_gRPC_GTEST_INCLUDE_DIR}
  PRIVATE ${_gRPC_PROTO_GENS_DIR}
)

  target_link_libraries(alts_tsi_handshaker_test PRIVATE
  ${_gRPC_PROTOBUF_LIBRARIES}
  ${_gRPC_ALLTARGETS_LIBRARIES}
  alts_test_util
  gpr
  grpc
  ${_gRPC_GFLAGS_LIBRARIES}
)

    add_dependencies(alts_tsi_handshaker_test project_benchmark project_gflags)

  set(alts_tsi_utils_test_src
   ${_gRPC_ROOT}/test/core/tsi/alts/handshaker/alts_tsi_utils_test.cc
)
  android_add_test(alts_tsi_utils_test)
  target_link_libraries(alts_tsi_utils_test PRIVATE gmock_main ssl crypto)
  target_include_directories(alts_tsi_utils_test PRIVATE ${_gRPC_ROOT})

  target_compile_definitions(alts_tsi_utils_test PRIVATE -DPB_FIELD_16BIT)
  target_compile_definitions(alts_tsi_utils_test PUBLIC  -DGRPC_ALLOW_EXCEPTIONS=0)

  target_include_directories(alts_tsi_utils_test
  PRIVATE ${_gRPC_ROOT}
  PRIVATE ${_gRPC_ROOT}/include
  PRIVATE ${_gRPC_SSL_INCLUDE_DIR}
  PRIVATE ${_gRPC_BENCHMARK_INCLUDE_DIR}
  PRIVATE ${_gRPC_GFLAGS_INCLUDE_DIR}
  PRIVATE ${_gRPC_PROTOBUF_INCLUDE_DIR}
  PRIVATE ${_gRPC_NANOPB_INCLUDE_DIR}
  PRIVATE ${_gRPC_ADDRESS_SORTING_INCLUDE_DIR}
  PRIVATE ${_gRPC_GTEST_INCLUDE_DIR}
  PRIVATE ${_gRPC_PROTO_GENS_DIR}
)

  target_link_libraries(alts_tsi_utils_test PRIVATE
  ${_gRPC_PROTOBUF_LIBRARIES}
  ${_gRPC_ALLTARGETS_LIBRARIES}
  alts_test_util
  gpr
  grpc
  ${_gRPC_GFLAGS_LIBRARIES}
)

    add_dependencies(alts_tsi_utils_test project_benchmark project_gflags)

  set(alts_zero_copy_grpc_protector_test_src
   ${_gRPC_ROOT}/test/core/tsi/alts/zero_copy_frame_protector/alts_zero_copy_grpc_protector_test.cc
)
  android_add_test(alts_zero_copy_grpc_protector_test)
  target_link_libraries(alts_zero_copy_grpc_protector_test PRIVATE gmock_main ssl crypto)
  target_include_directories(alts_zero_copy_grpc_protector_test PRIVATE ${_gRPC_ROOT})

  target_compile_definitions(alts_zero_copy_grpc_protector_test PRIVATE -DPB_FIELD_16BIT)
  target_compile_definitions(alts_zero_copy_grpc_protector_test PUBLIC  -DGRPC_ALLOW_EXCEPTIONS=0)

  target_include_directories(alts_zero_copy_grpc_protector_test
  PRIVATE ${_gRPC_ROOT}
  PRIVATE ${_gRPC_ROOT}/include
  PRIVATE ${_gRPC_SSL_INCLUDE_DIR}
  PRIVATE ${_gRPC_BENCHMARK_INCLUDE_DIR}
  PRIVATE ${_gRPC_GFLAGS_INCLUDE_DIR}
  PRIVATE ${_gRPC_PROTOBUF_INCLUDE_DIR}
  PRIVATE ${_gRPC_NANOPB_INCLUDE_DIR}
  PRIVATE ${_gRPC_ADDRESS_SORTING_INCLUDE_DIR}
  PRIVATE ${_gRPC_GTEST_INCLUDE_DIR}
  PRIVATE ${_gRPC_PROTO_GENS_DIR}
)

  target_link_libraries(alts_zero_copy_grpc_protector_test PRIVATE
  ${_gRPC_PROTOBUF_LIBRARIES}
  ${_gRPC_ALLTARGETS_LIBRARIES}
  alts_test_util
  gpr
  grpc
  ${_gRPC_GFLAGS_LIBRARIES}
)

    add_dependencies(alts_zero_copy_grpc_protector_test project_benchmark project_gflags)

  set(async_end2end_test_src
   ${_gRPC_ROOT}/test/cpp/end2end/async_end2end_test.cc
)
  android_add_test(async_end2end_test)
  target_link_libraries(async_end2end_test PRIVATE gmock_main ssl crypto)
  target_include_directories(async_end2end_test PRIVATE ${_gRPC_ROOT})

  target_compile_definitions(async_end2end_test PRIVATE -DPB_FIELD_16BIT)
  target_compile_definitions(async_end2end_test PUBLIC  -DGRPC_ALLOW_EXCEPTIONS=0)

  target_include_directories(async_end2end_test
  PRIVATE ${_gRPC_ROOT}
  PRIVATE ${_gRPC_ROOT}/include
  PRIVATE ${_gRPC_SSL_INCLUDE_DIR}
  PRIVATE ${_gRPC_BENCHMARK_INCLUDE_DIR}
  PRIVATE ${_gRPC_GFLAGS_INCLUDE_DIR}
  PRIVATE ${_gRPC_PROTOBUF_INCLUDE_DIR}
  PRIVATE ${_gRPC_NANOPB_INCLUDE_DIR}
  PRIVATE ${_gRPC_ADDRESS_SORTING_INCLUDE_DIR}
  PRIVATE ${_gRPC_GTEST_INCLUDE_DIR}
  PRIVATE ${_gRPC_PROTO_GENS_DIR}
)

  target_link_libraries(async_end2end_test PRIVATE
  ${_gRPC_PROTOBUF_LIBRARIES}
  ${_gRPC_ALLTARGETS_LIBRARIES}
  grpc++_test_util
  grpc_test_util
  grpc++
  grpc
  gpr_test_util
  gpr
  ${_gRPC_GFLAGS_LIBRARIES}
)

    add_dependencies(async_end2end_test project_benchmark project_gflags)

  set(auth_property_iterator_test_src
   ${_gRPC_ROOT}/test/cpp/common/auth_property_iterator_test.cc
)
  android_add_test(auth_property_iterator_test)
  target_link_libraries(auth_property_iterator_test PRIVATE gmock_main ssl crypto)
  target_include_directories(auth_property_iterator_test PRIVATE ${_gRPC_ROOT})

  target_compile_definitions(auth_property_iterator_test PRIVATE -DPB_FIELD_16BIT)
  target_compile_definitions(auth_property_iterator_test PUBLIC  -DGRPC_ALLOW_EXCEPTIONS=0)

  target_include_directories(auth_property_iterator_test
  PRIVATE ${_gRPC_ROOT}
  PRIVATE ${_gRPC_ROOT}/include
  PRIVATE ${_gRPC_SSL_INCLUDE_DIR}
  PRIVATE ${_gRPC_BENCHMARK_INCLUDE_DIR}
  PRIVATE ${_gRPC_GFLAGS_INCLUDE_DIR}
  PRIVATE ${_gRPC_PROTOBUF_INCLUDE_DIR}
  PRIVATE ${_gRPC_NANOPB_INCLUDE_DIR}
  PRIVATE ${_gRPC_ADDRESS_SORTING_INCLUDE_DIR}
  PRIVATE ${_gRPC_GTEST_INCLUDE_DIR}
  PRIVATE ${_gRPC_PROTO_GENS_DIR}
)

  target_link_libraries(auth_property_iterator_test PRIVATE
  ${_gRPC_PROTOBUF_LIBRARIES}
  ${_gRPC_ALLTARGETS_LIBRARIES}
  grpc++_test_util
  grpc_test_util
  grpc++
  grpc
  gpr_test_util
  gpr
  ${_gRPC_GFLAGS_LIBRARIES}
)

    add_dependencies(auth_property_iterator_test project_benchmark project_gflags)

  set(backoff_test_src
   ${_gRPC_ROOT}/test/core/backoff/backoff_test.cc
)
  android_add_test(backoff_test)
  target_link_libraries(backoff_test PRIVATE gmock_main ssl crypto)
  target_include_directories(backoff_test PRIVATE ${_gRPC_ROOT})

  target_compile_definitions(backoff_test PRIVATE -DPB_FIELD_16BIT)
  target_compile_definitions(backoff_test PUBLIC  -DGRPC_ALLOW_EXCEPTIONS=0)

  target_include_directories(backoff_test
  PRIVATE ${_gRPC_ROOT}
  PRIVATE ${_gRPC_ROOT}/include
  PRIVATE ${_gRPC_SSL_INCLUDE_DIR}
  PRIVATE ${_gRPC_BENCHMARK_INCLUDE_DIR}
  PRIVATE ${_gRPC_GFLAGS_INCLUDE_DIR}
  PRIVATE ${_gRPC_PROTOBUF_INCLUDE_DIR}
  PRIVATE ${_gRPC_NANOPB_INCLUDE_DIR}
  PRIVATE ${_gRPC_ADDRESS_SORTING_INCLUDE_DIR}
  PRIVATE ${_gRPC_GTEST_INCLUDE_DIR}
  PRIVATE ${_gRPC_PROTO_GENS_DIR}
)

  target_link_libraries(backoff_test PRIVATE
  ${_gRPC_PROTOBUF_LIBRARIES}
  ${_gRPC_ALLTARGETS_LIBRARIES}
  grpc_test_util
  grpc
  gpr_test_util
  gpr
  ${_gRPC_GFLAGS_LIBRARIES}
)

    add_dependencies(backoff_test project_benchmark project_gflags)

  set(bdp_estimator_test_src
   ${_gRPC_ROOT}/test/core/transport/bdp_estimator_test.cc
)
  android_add_test(bdp_estimator_test)
  target_link_libraries(bdp_estimator_test PRIVATE gmock_main ssl crypto)
  target_include_directories(bdp_estimator_test PRIVATE ${_gRPC_ROOT})

  target_compile_definitions(bdp_estimator_test PRIVATE -DPB_FIELD_16BIT)
  target_compile_definitions(bdp_estimator_test PUBLIC  -DGRPC_ALLOW_EXCEPTIONS=0)

  target_include_directories(bdp_estimator_test
  PRIVATE ${_gRPC_ROOT}
  PRIVATE ${_gRPC_ROOT}/include
  PRIVATE ${_gRPC_SSL_INCLUDE_DIR}
  PRIVATE ${_gRPC_BENCHMARK_INCLUDE_DIR}
  PRIVATE ${_gRPC_GFLAGS_INCLUDE_DIR}
  PRIVATE ${_gRPC_PROTOBUF_INCLUDE_DIR}
  PRIVATE ${_gRPC_NANOPB_INCLUDE_DIR}
  PRIVATE ${_gRPC_ADDRESS_SORTING_INCLUDE_DIR}
  PRIVATE ${_gRPC_GTEST_INCLUDE_DIR}
  PRIVATE ${_gRPC_PROTO_GENS_DIR}
)

  target_link_libraries(bdp_estimator_test PRIVATE
  ${_gRPC_PROTOBUF_LIBRARIES}
  ${_gRPC_ALLTARGETS_LIBRARIES}
  grpc++_test_util
  grpc++
  grpc_test_util
  grpc
  gpr_test_util
  gpr
  ${_gRPC_GFLAGS_LIBRARIES}
)

    add_dependencies(bdp_estimator_test project_benchmark project_gflags)
if(_gRPC_PLATFORM_LINUX OR _gRPC_PLATFORM_MAC OR _gRPC_PLATFORM_POSIX)

  set(bm_arena_src
   ${_gRPC_ROOT}/test/cpp/microbenchmarks/bm_arena.cc
)
  android_add_test(bm_arena)
  target_link_libraries(bm_arena PRIVATE gmock_main ssl crypto)
  target_include_directories(bm_arena PRIVATE ${_gRPC_ROOT})

  target_compile_definitions(bm_arena PRIVATE -DPB_FIELD_16BIT)
  target_compile_definitions(bm_arena PUBLIC  -DGRPC_ALLOW_EXCEPTIONS=0)

  target_include_directories(bm_arena
  PRIVATE ${_gRPC_ROOT}
  PRIVATE ${_gRPC_ROOT}/include
  PRIVATE ${_gRPC_SSL_INCLUDE_DIR}
  PRIVATE ${_gRPC_BENCHMARK_INCLUDE_DIR}
  PRIVATE ${_gRPC_GFLAGS_INCLUDE_DIR}
  PRIVATE ${_gRPC_PROTOBUF_INCLUDE_DIR}
  PRIVATE ${_gRPC_NANOPB_INCLUDE_DIR}
  PRIVATE ${_gRPC_ADDRESS_SORTING_INCLUDE_DIR}
  PRIVATE ${_gRPC_GTEST_INCLUDE_DIR}
  PRIVATE ${_gRPC_PROTO_GENS_DIR}
)

  target_link_libraries(bm_arena PRIVATE
  ${_gRPC_PROTOBUF_LIBRARIES}
  ${_gRPC_ALLTARGETS_LIBRARIES}
  grpc_benchmark
  ${_gRPC_BENCHMARK_LIBRARIES}
  grpc++_test_util_unsecure
  grpc_test_util_unsecure
  grpc++_unsecure
  grpc_unsecure
  gpr_test_util
  gpr
  grpc++_test_config
  ${_gRPC_GFLAGS_LIBRARIES}
)

    add_dependencies(bm_arena project_benchmark project_gflags)
endif()
if(_gRPC_PLATFORM_LINUX OR _gRPC_PLATFORM_MAC OR _gRPC_PLATFORM_POSIX)

  set(bm_call_create_src
   ${_gRPC_ROOT}/test/cpp/microbenchmarks/bm_call_create.cc
)
  android_add_test(bm_call_create)
  target_link_libraries(bm_call_create PRIVATE gmock_main ssl crypto)
  target_include_directories(bm_call_create PRIVATE ${_gRPC_ROOT})

  target_compile_definitions(bm_call_create PRIVATE -DPB_FIELD_16BIT)
  target_compile_definitions(bm_call_create PUBLIC  -DGRPC_ALLOW_EXCEPTIONS=0)

  target_include_directories(bm_call_create
  PRIVATE ${_gRPC_ROOT}
  PRIVATE ${_gRPC_ROOT}/include
  PRIVATE ${_gRPC_SSL_INCLUDE_DIR}
  PRIVATE ${_gRPC_BENCHMARK_INCLUDE_DIR}
  PRIVATE ${_gRPC_GFLAGS_INCLUDE_DIR}
  PRIVATE ${_gRPC_PROTOBUF_INCLUDE_DIR}
  PRIVATE ${_gRPC_NANOPB_INCLUDE_DIR}
  PRIVATE ${_gRPC_ADDRESS_SORTING_INCLUDE_DIR}
  PRIVATE ${_gRPC_GTEST_INCLUDE_DIR}
  PRIVATE ${_gRPC_PROTO_GENS_DIR}
)

  target_link_libraries(bm_call_create PRIVATE
  ${_gRPC_PROTOBUF_LIBRARIES}
  ${_gRPC_ALLTARGETS_LIBRARIES}
  grpc_benchmark
  ${_gRPC_BENCHMARK_LIBRARIES}
  grpc++_test_util_unsecure
  grpc_test_util_unsecure
  grpc++_unsecure
  grpc_unsecure
  gpr_test_util
  gpr
  grpc++_test_config
  ${_gRPC_GFLAGS_LIBRARIES}
)

    add_dependencies(bm_call_create project_benchmark project_gflags)
endif()
if(_gRPC_PLATFORM_LINUX OR _gRPC_PLATFORM_MAC OR _gRPC_PLATFORM_POSIX)

  set(bm_channel_src
   ${_gRPC_ROOT}/test/cpp/microbenchmarks/bm_channel.cc
)
  android_add_test(bm_channel)
  target_link_libraries(bm_channel PRIVATE gmock_main ssl crypto)
  target_include_directories(bm_channel PRIVATE ${_gRPC_ROOT})

  target_compile_definitions(bm_channel PRIVATE -DPB_FIELD_16BIT)
  target_compile_definitions(bm_channel PUBLIC  -DGRPC_ALLOW_EXCEPTIONS=0)

  target_include_directories(bm_channel
  PRIVATE ${_gRPC_ROOT}
  PRIVATE ${_gRPC_ROOT}/include
  PRIVATE ${_gRPC_SSL_INCLUDE_DIR}
  PRIVATE ${_gRPC_BENCHMARK_INCLUDE_DIR}
  PRIVATE ${_gRPC_GFLAGS_INCLUDE_DIR}
  PRIVATE ${_gRPC_PROTOBUF_INCLUDE_DIR}
  PRIVATE ${_gRPC_NANOPB_INCLUDE_DIR}
  PRIVATE ${_gRPC_ADDRESS_SORTING_INCLUDE_DIR}
  PRIVATE ${_gRPC_GTEST_INCLUDE_DIR}
  PRIVATE ${_gRPC_PROTO_GENS_DIR}
)

  target_link_libraries(bm_channel PRIVATE
  ${_gRPC_PROTOBUF_LIBRARIES}
  ${_gRPC_ALLTARGETS_LIBRARIES}
  grpc_benchmark
  ${_gRPC_BENCHMARK_LIBRARIES}
  grpc++_test_util_unsecure
  grpc_test_util_unsecure
  grpc++_unsecure
  grpc_unsecure
  gpr_test_util
  gpr
  grpc++_test_config
  ${_gRPC_GFLAGS_LIBRARIES}
)

    add_dependencies(bm_channel project_benchmark project_gflags)
endif()
if(_gRPC_PLATFORM_LINUX OR _gRPC_PLATFORM_MAC OR _gRPC_PLATFORM_POSIX)

  set(bm_chttp2_hpack_src
   ${_gRPC_ROOT}/test/cpp/microbenchmarks/bm_chttp2_hpack.cc
)
  android_add_test(bm_chttp2_hpack)
  target_link_libraries(bm_chttp2_hpack PRIVATE gmock_main ssl crypto)
  target_include_directories(bm_chttp2_hpack PRIVATE ${_gRPC_ROOT})

  target_compile_definitions(bm_chttp2_hpack PRIVATE -DPB_FIELD_16BIT)
  target_compile_definitions(bm_chttp2_hpack PUBLIC  -DGRPC_ALLOW_EXCEPTIONS=0)

  target_include_directories(bm_chttp2_hpack
  PRIVATE ${_gRPC_ROOT}
  PRIVATE ${_gRPC_ROOT}/include
  PRIVATE ${_gRPC_SSL_INCLUDE_DIR}
  PRIVATE ${_gRPC_BENCHMARK_INCLUDE_DIR}
  PRIVATE ${_gRPC_GFLAGS_INCLUDE_DIR}
  PRIVATE ${_gRPC_PROTOBUF_INCLUDE_DIR}
  PRIVATE ${_gRPC_NANOPB_INCLUDE_DIR}
  PRIVATE ${_gRPC_ADDRESS_SORTING_INCLUDE_DIR}
  PRIVATE ${_gRPC_GTEST_INCLUDE_DIR}
  PRIVATE ${_gRPC_PROTO_GENS_DIR}
)

  target_link_libraries(bm_chttp2_hpack PRIVATE
  ${_gRPC_PROTOBUF_LIBRARIES}
  ${_gRPC_ALLTARGETS_LIBRARIES}
  grpc_benchmark
  ${_gRPC_BENCHMARK_LIBRARIES}
  grpc++_test_util_unsecure
  grpc_test_util_unsecure
  grpc++_unsecure
  grpc_unsecure
  gpr_test_util
  gpr
  grpc++_test_config
  ${_gRPC_GFLAGS_LIBRARIES}
)

    add_dependencies(bm_chttp2_hpack project_benchmark project_gflags)
endif()
if(_gRPC_PLATFORM_LINUX OR _gRPC_PLATFORM_MAC OR _gRPC_PLATFORM_POSIX)

  set(bm_chttp2_transport_src
   ${_gRPC_ROOT}/test/cpp/microbenchmarks/bm_chttp2_transport.cc
)
  android_add_test(bm_chttp2_transport)
  target_link_libraries(bm_chttp2_transport PRIVATE gmock_main ssl crypto)
  target_include_directories(bm_chttp2_transport PRIVATE ${_gRPC_ROOT})

  target_compile_definitions(bm_chttp2_transport PRIVATE -DPB_FIELD_16BIT)
  target_compile_definitions(bm_chttp2_transport PUBLIC  -DGRPC_ALLOW_EXCEPTIONS=0)

  target_include_directories(bm_chttp2_transport
  PRIVATE ${_gRPC_ROOT}
  PRIVATE ${_gRPC_ROOT}/include
  PRIVATE ${_gRPC_SSL_INCLUDE_DIR}
  PRIVATE ${_gRPC_BENCHMARK_INCLUDE_DIR}
  PRIVATE ${_gRPC_GFLAGS_INCLUDE_DIR}
  PRIVATE ${_gRPC_PROTOBUF_INCLUDE_DIR}
  PRIVATE ${_gRPC_NANOPB_INCLUDE_DIR}
  PRIVATE ${_gRPC_ADDRESS_SORTING_INCLUDE_DIR}
  PRIVATE ${_gRPC_GTEST_INCLUDE_DIR}
  PRIVATE ${_gRPC_PROTO_GENS_DIR}
)

  target_link_libraries(bm_chttp2_transport PRIVATE
  ${_gRPC_PROTOBUF_LIBRARIES}
  ${_gRPC_ALLTARGETS_LIBRARIES}
  grpc_benchmark
  ${_gRPC_BENCHMARK_LIBRARIES}
  grpc++_test_util_unsecure
  grpc_test_util_unsecure
  grpc++_unsecure
  grpc_unsecure
  gpr_test_util
  gpr
  grpc++_test_config
  ${_gRPC_GFLAGS_LIBRARIES}
)

    add_dependencies(bm_chttp2_transport project_benchmark project_gflags)
endif()
if(_gRPC_PLATFORM_LINUX OR _gRPC_PLATFORM_MAC OR _gRPC_PLATFORM_POSIX)

  set(bm_closure_src
   ${_gRPC_ROOT}/test/cpp/microbenchmarks/bm_closure.cc
)
  android_add_test(bm_closure)
  target_link_libraries(bm_closure PRIVATE gmock_main ssl crypto)
  target_include_directories(bm_closure PRIVATE ${_gRPC_ROOT})

  target_compile_definitions(bm_closure PRIVATE -DPB_FIELD_16BIT)
  target_compile_definitions(bm_closure PUBLIC  -DGRPC_ALLOW_EXCEPTIONS=0)

  target_include_directories(bm_closure
  PRIVATE ${_gRPC_ROOT}
  PRIVATE ${_gRPC_ROOT}/include
  PRIVATE ${_gRPC_SSL_INCLUDE_DIR}
  PRIVATE ${_gRPC_BENCHMARK_INCLUDE_DIR}
  PRIVATE ${_gRPC_GFLAGS_INCLUDE_DIR}
  PRIVATE ${_gRPC_PROTOBUF_INCLUDE_DIR}
  PRIVATE ${_gRPC_NANOPB_INCLUDE_DIR}
  PRIVATE ${_gRPC_ADDRESS_SORTING_INCLUDE_DIR}
  PRIVATE ${_gRPC_GTEST_INCLUDE_DIR}
  PRIVATE ${_gRPC_PROTO_GENS_DIR}
)

  target_link_libraries(bm_closure PRIVATE
  ${_gRPC_PROTOBUF_LIBRARIES}
  ${_gRPC_ALLTARGETS_LIBRARIES}
  grpc_benchmark
  ${_gRPC_BENCHMARK_LIBRARIES}
  grpc++_test_util_unsecure
  grpc_test_util_unsecure
  grpc++_unsecure
  grpc_unsecure
  gpr_test_util
  gpr
  grpc++_test_config
  ${_gRPC_GFLAGS_LIBRARIES}
)

    add_dependencies(bm_closure project_benchmark project_gflags)
endif()
if(_gRPC_PLATFORM_LINUX OR _gRPC_PLATFORM_MAC OR _gRPC_PLATFORM_POSIX)

  set(bm_cq_src
   ${_gRPC_ROOT}/test/cpp/microbenchmarks/bm_cq.cc
)
  android_add_test(bm_cq)
  target_link_libraries(bm_cq PRIVATE gmock_main ssl crypto)
  target_include_directories(bm_cq PRIVATE ${_gRPC_ROOT})

  target_compile_definitions(bm_cq PRIVATE -DPB_FIELD_16BIT)
  target_compile_definitions(bm_cq PUBLIC  -DGRPC_ALLOW_EXCEPTIONS=0)

  target_include_directories(bm_cq
  PRIVATE ${_gRPC_ROOT}
  PRIVATE ${_gRPC_ROOT}/include
  PRIVATE ${_gRPC_SSL_INCLUDE_DIR}
  PRIVATE ${_gRPC_BENCHMARK_INCLUDE_DIR}
  PRIVATE ${_gRPC_GFLAGS_INCLUDE_DIR}
  PRIVATE ${_gRPC_PROTOBUF_INCLUDE_DIR}
  PRIVATE ${_gRPC_NANOPB_INCLUDE_DIR}
  PRIVATE ${_gRPC_ADDRESS_SORTING_INCLUDE_DIR}
  PRIVATE ${_gRPC_GTEST_INCLUDE_DIR}
  PRIVATE ${_gRPC_PROTO_GENS_DIR}
)

  target_link_libraries(bm_cq PRIVATE
  ${_gRPC_PROTOBUF_LIBRARIES}
  ${_gRPC_ALLTARGETS_LIBRARIES}
  grpc_benchmark
  ${_gRPC_BENCHMARK_LIBRARIES}
  grpc++_test_util_unsecure
  grpc_test_util_unsecure
  grpc++_unsecure
  grpc_unsecure
  gpr_test_util
  gpr
  grpc++_test_config
  ${_gRPC_GFLAGS_LIBRARIES}
)

    add_dependencies(bm_cq project_benchmark project_gflags)
endif()
if(_gRPC_PLATFORM_LINUX OR _gRPC_PLATFORM_MAC OR _gRPC_PLATFORM_POSIX)

  set(bm_cq_multiple_threads_src
   ${_gRPC_ROOT}/test/cpp/microbenchmarks/bm_cq_multiple_threads.cc
)
  android_add_test(bm_cq_multiple_threads)
  target_link_libraries(bm_cq_multiple_threads PRIVATE gmock_main ssl crypto)
  target_include_directories(bm_cq_multiple_threads PRIVATE ${_gRPC_ROOT})

  target_compile_definitions(bm_cq_multiple_threads PRIVATE -DPB_FIELD_16BIT)
  target_compile_definitions(bm_cq_multiple_threads PUBLIC  -DGRPC_ALLOW_EXCEPTIONS=0)

  target_include_directories(bm_cq_multiple_threads
  PRIVATE ${_gRPC_ROOT}
  PRIVATE ${_gRPC_ROOT}/include
  PRIVATE ${_gRPC_SSL_INCLUDE_DIR}
  PRIVATE ${_gRPC_BENCHMARK_INCLUDE_DIR}
  PRIVATE ${_gRPC_GFLAGS_INCLUDE_DIR}
  PRIVATE ${_gRPC_PROTOBUF_INCLUDE_DIR}
  PRIVATE ${_gRPC_NANOPB_INCLUDE_DIR}
  PRIVATE ${_gRPC_ADDRESS_SORTING_INCLUDE_DIR}
  PRIVATE ${_gRPC_GTEST_INCLUDE_DIR}
  PRIVATE ${_gRPC_PROTO_GENS_DIR}
)

  target_link_libraries(bm_cq_multiple_threads PRIVATE
  ${_gRPC_PROTOBUF_LIBRARIES}
  ${_gRPC_ALLTARGETS_LIBRARIES}
  grpc_benchmark
  ${_gRPC_BENCHMARK_LIBRARIES}
  grpc++_test_util_unsecure
  grpc_test_util_unsecure
  grpc++_unsecure
  grpc_unsecure
  gpr_test_util
  gpr
  grpc++_test_config
  ${_gRPC_GFLAGS_LIBRARIES}
)

    add_dependencies(bm_cq_multiple_threads project_benchmark project_gflags)
endif()
if(_gRPC_PLATFORM_LINUX OR _gRPC_PLATFORM_MAC OR _gRPC_PLATFORM_POSIX)

  set(bm_error_src
   ${_gRPC_ROOT}/test/cpp/microbenchmarks/bm_error.cc
)
  android_add_test(bm_error)
  target_link_libraries(bm_error PRIVATE gmock_main ssl crypto)
  target_include_directories(bm_error PRIVATE ${_gRPC_ROOT})

  target_compile_definitions(bm_error PRIVATE -DPB_FIELD_16BIT)
  target_compile_definitions(bm_error PUBLIC  -DGRPC_ALLOW_EXCEPTIONS=0)

  target_include_directories(bm_error
  PRIVATE ${_gRPC_ROOT}
  PRIVATE ${_gRPC_ROOT}/include
  PRIVATE ${_gRPC_SSL_INCLUDE_DIR}
  PRIVATE ${_gRPC_BENCHMARK_INCLUDE_DIR}
  PRIVATE ${_gRPC_GFLAGS_INCLUDE_DIR}
  PRIVATE ${_gRPC_PROTOBUF_INCLUDE_DIR}
  PRIVATE ${_gRPC_NANOPB_INCLUDE_DIR}
  PRIVATE ${_gRPC_ADDRESS_SORTING_INCLUDE_DIR}
  PRIVATE ${_gRPC_GTEST_INCLUDE_DIR}
  PRIVATE ${_gRPC_PROTO_GENS_DIR}
)

  target_link_libraries(bm_error PRIVATE
  ${_gRPC_PROTOBUF_LIBRARIES}
  ${_gRPC_ALLTARGETS_LIBRARIES}
  grpc_benchmark
  ${_gRPC_BENCHMARK_LIBRARIES}
  grpc++_test_util_unsecure
  grpc_test_util_unsecure
  grpc++_unsecure
  grpc_unsecure
  gpr_test_util
  gpr
  grpc++_test_config
  ${_gRPC_GFLAGS_LIBRARIES}
)

    add_dependencies(bm_error project_benchmark project_gflags)
endif()
if(_gRPC_PLATFORM_LINUX OR _gRPC_PLATFORM_MAC OR _gRPC_PLATFORM_POSIX)

  set(bm_fullstack_streaming_ping_pong_src
   ${_gRPC_ROOT}/test/cpp/microbenchmarks/bm_fullstack_streaming_ping_pong.cc
)
  android_add_test(bm_fullstack_streaming_ping_pong)
  target_link_libraries(bm_fullstack_streaming_ping_pong PRIVATE gmock_main ssl crypto)
  target_include_directories(bm_fullstack_streaming_ping_pong PRIVATE ${_gRPC_ROOT})

  target_compile_definitions(bm_fullstack_streaming_ping_pong PRIVATE -DPB_FIELD_16BIT)
  target_compile_definitions(bm_fullstack_streaming_ping_pong PUBLIC  -DGRPC_ALLOW_EXCEPTIONS=0)

  target_include_directories(bm_fullstack_streaming_ping_pong
  PRIVATE ${_gRPC_ROOT}
  PRIVATE ${_gRPC_ROOT}/include
  PRIVATE ${_gRPC_SSL_INCLUDE_DIR}
  PRIVATE ${_gRPC_BENCHMARK_INCLUDE_DIR}
  PRIVATE ${_gRPC_GFLAGS_INCLUDE_DIR}
  PRIVATE ${_gRPC_PROTOBUF_INCLUDE_DIR}
  PRIVATE ${_gRPC_NANOPB_INCLUDE_DIR}
  PRIVATE ${_gRPC_ADDRESS_SORTING_INCLUDE_DIR}
  PRIVATE ${_gRPC_GTEST_INCLUDE_DIR}
  PRIVATE ${_gRPC_PROTO_GENS_DIR}
)

  target_link_libraries(bm_fullstack_streaming_ping_pong PRIVATE
  ${_gRPC_PROTOBUF_LIBRARIES}
  ${_gRPC_ALLTARGETS_LIBRARIES}
  grpc_benchmark
  ${_gRPC_BENCHMARK_LIBRARIES}
  grpc++_test_util_unsecure
  grpc_test_util_unsecure
  grpc++_unsecure
  grpc_unsecure
  gpr_test_util
  gpr
  grpc++_test_config
  ${_gRPC_GFLAGS_LIBRARIES}
)

    add_dependencies(bm_fullstack_streaming_ping_pong project_benchmark project_gflags)
endif()
if(_gRPC_PLATFORM_LINUX OR _gRPC_PLATFORM_MAC OR _gRPC_PLATFORM_POSIX)

  set(bm_fullstack_streaming_pump_src
   ${_gRPC_ROOT}/test/cpp/microbenchmarks/bm_fullstack_streaming_pump.cc
)
  android_add_test(bm_fullstack_streaming_pump)
  target_link_libraries(bm_fullstack_streaming_pump PRIVATE gmock_main ssl crypto)
  target_include_directories(bm_fullstack_streaming_pump PRIVATE ${_gRPC_ROOT})

  target_compile_definitions(bm_fullstack_streaming_pump PRIVATE -DPB_FIELD_16BIT)
  target_compile_definitions(bm_fullstack_streaming_pump PUBLIC  -DGRPC_ALLOW_EXCEPTIONS=0)

  target_include_directories(bm_fullstack_streaming_pump
  PRIVATE ${_gRPC_ROOT}
  PRIVATE ${_gRPC_ROOT}/include
  PRIVATE ${_gRPC_SSL_INCLUDE_DIR}
  PRIVATE ${_gRPC_BENCHMARK_INCLUDE_DIR}
  PRIVATE ${_gRPC_GFLAGS_INCLUDE_DIR}
  PRIVATE ${_gRPC_PROTOBUF_INCLUDE_DIR}
  PRIVATE ${_gRPC_NANOPB_INCLUDE_DIR}
  PRIVATE ${_gRPC_ADDRESS_SORTING_INCLUDE_DIR}
  PRIVATE ${_gRPC_GTEST_INCLUDE_DIR}
  PRIVATE ${_gRPC_PROTO_GENS_DIR}
)

  target_link_libraries(bm_fullstack_streaming_pump PRIVATE
  ${_gRPC_PROTOBUF_LIBRARIES}
  ${_gRPC_ALLTARGETS_LIBRARIES}
  grpc_benchmark
  ${_gRPC_BENCHMARK_LIBRARIES}
  grpc++_test_util_unsecure
  grpc_test_util_unsecure
  grpc++_unsecure
  grpc_unsecure
  gpr_test_util
  gpr
  grpc++_test_config
  ${_gRPC_GFLAGS_LIBRARIES}
)

    add_dependencies(bm_fullstack_streaming_pump project_benchmark project_gflags)
endif()
if(_gRPC_PLATFORM_LINUX OR _gRPC_PLATFORM_MAC OR _gRPC_PLATFORM_POSIX)

  set(bm_fullstack_trickle_src
   ${_gRPC_ROOT}/test/cpp/microbenchmarks/bm_fullstack_trickle.cc
)
  android_add_test(bm_fullstack_trickle)
  target_link_libraries(bm_fullstack_trickle PRIVATE gmock_main ssl crypto)
  target_include_directories(bm_fullstack_trickle PRIVATE ${_gRPC_ROOT})

  target_compile_definitions(bm_fullstack_trickle PRIVATE -DPB_FIELD_16BIT)
  target_compile_definitions(bm_fullstack_trickle PUBLIC  -DGRPC_ALLOW_EXCEPTIONS=0)

  target_include_directories(bm_fullstack_trickle
  PRIVATE ${_gRPC_ROOT}
  PRIVATE ${_gRPC_ROOT}/include
  PRIVATE ${_gRPC_SSL_INCLUDE_DIR}
  PRIVATE ${_gRPC_BENCHMARK_INCLUDE_DIR}
  PRIVATE ${_gRPC_GFLAGS_INCLUDE_DIR}
  PRIVATE ${_gRPC_PROTOBUF_INCLUDE_DIR}
  PRIVATE ${_gRPC_NANOPB_INCLUDE_DIR}
  PRIVATE ${_gRPC_ADDRESS_SORTING_INCLUDE_DIR}
  PRIVATE ${_gRPC_GTEST_INCLUDE_DIR}
  PRIVATE ${_gRPC_PROTO_GENS_DIR}
)

  target_link_libraries(bm_fullstack_trickle PRIVATE
  ${_gRPC_PROTOBUF_LIBRARIES}
  ${_gRPC_ALLTARGETS_LIBRARIES}
  grpc_benchmark
  ${_gRPC_BENCHMARK_LIBRARIES}
  grpc++_test_util_unsecure
  grpc_test_util_unsecure
  grpc++_unsecure
  grpc_unsecure
  gpr_test_util
  gpr
  grpc++_test_config
  ${_gRPC_GFLAGS_LIBRARIES}
)

    add_dependencies(bm_fullstack_trickle project_benchmark project_gflags)
endif()
if(_gRPC_PLATFORM_LINUX OR _gRPC_PLATFORM_MAC OR _gRPC_PLATFORM_POSIX)

  set(bm_fullstack_unary_ping_pong_src
   ${_gRPC_ROOT}/test/cpp/microbenchmarks/bm_fullstack_unary_ping_pong.cc
)
  android_add_test(bm_fullstack_unary_ping_pong)
  target_link_libraries(bm_fullstack_unary_ping_pong PRIVATE gmock_main ssl crypto)
  target_include_directories(bm_fullstack_unary_ping_pong PRIVATE ${_gRPC_ROOT})

  target_compile_definitions(bm_fullstack_unary_ping_pong PRIVATE -DPB_FIELD_16BIT)
  target_compile_definitions(bm_fullstack_unary_ping_pong PUBLIC  -DGRPC_ALLOW_EXCEPTIONS=0)

  target_include_directories(bm_fullstack_unary_ping_pong
  PRIVATE ${_gRPC_ROOT}
  PRIVATE ${_gRPC_ROOT}/include
  PRIVATE ${_gRPC_SSL_INCLUDE_DIR}
  PRIVATE ${_gRPC_BENCHMARK_INCLUDE_DIR}
  PRIVATE ${_gRPC_GFLAGS_INCLUDE_DIR}
  PRIVATE ${_gRPC_PROTOBUF_INCLUDE_DIR}
  PRIVATE ${_gRPC_NANOPB_INCLUDE_DIR}
  PRIVATE ${_gRPC_ADDRESS_SORTING_INCLUDE_DIR}
  PRIVATE ${_gRPC_GTEST_INCLUDE_DIR}
  PRIVATE ${_gRPC_PROTO_GENS_DIR}
)

  target_link_libraries(bm_fullstack_unary_ping_pong PRIVATE
  ${_gRPC_PROTOBUF_LIBRARIES}
  ${_gRPC_ALLTARGETS_LIBRARIES}
  grpc_benchmark
  ${_gRPC_BENCHMARK_LIBRARIES}
  grpc++_test_util_unsecure
  grpc_test_util_unsecure
  grpc++_unsecure
  grpc_unsecure
  gpr_test_util
  gpr
  grpc++_test_config
  ${_gRPC_GFLAGS_LIBRARIES}
)

    add_dependencies(bm_fullstack_unary_ping_pong project_benchmark project_gflags)
endif()
if(_gRPC_PLATFORM_LINUX OR _gRPC_PLATFORM_MAC OR _gRPC_PLATFORM_POSIX)

  set(bm_metadata_src
   ${_gRPC_ROOT}/test/cpp/microbenchmarks/bm_metadata.cc
)
  android_add_test(bm_metadata)
  target_link_libraries(bm_metadata PRIVATE gmock_main ssl crypto)
  target_include_directories(bm_metadata PRIVATE ${_gRPC_ROOT})

  target_compile_definitions(bm_metadata PRIVATE -DPB_FIELD_16BIT)
  target_compile_definitions(bm_metadata PUBLIC  -DGRPC_ALLOW_EXCEPTIONS=0)

  target_include_directories(bm_metadata
  PRIVATE ${_gRPC_ROOT}
  PRIVATE ${_gRPC_ROOT}/include
  PRIVATE ${_gRPC_SSL_INCLUDE_DIR}
  PRIVATE ${_gRPC_BENCHMARK_INCLUDE_DIR}
  PRIVATE ${_gRPC_GFLAGS_INCLUDE_DIR}
  PRIVATE ${_gRPC_PROTOBUF_INCLUDE_DIR}
  PRIVATE ${_gRPC_NANOPB_INCLUDE_DIR}
  PRIVATE ${_gRPC_ADDRESS_SORTING_INCLUDE_DIR}
  PRIVATE ${_gRPC_GTEST_INCLUDE_DIR}
  PRIVATE ${_gRPC_PROTO_GENS_DIR}
)

  target_link_libraries(bm_metadata PRIVATE
  ${_gRPC_PROTOBUF_LIBRARIES}
  ${_gRPC_ALLTARGETS_LIBRARIES}
  grpc_benchmark
  ${_gRPC_BENCHMARK_LIBRARIES}
  grpc++_test_util_unsecure
  grpc_test_util_unsecure
  grpc++_unsecure
  grpc_unsecure
  gpr_test_util
  gpr
  grpc++_test_config
  ${_gRPC_GFLAGS_LIBRARIES}
)

    add_dependencies(bm_metadata project_benchmark project_gflags)
endif()
if(_gRPC_PLATFORM_LINUX OR _gRPC_PLATFORM_MAC OR _gRPC_PLATFORM_POSIX)

  set(bm_pollset_src
   ${_gRPC_ROOT}/test/cpp/microbenchmarks/bm_pollset.cc
)
  android_add_test(bm_pollset)
  target_link_libraries(bm_pollset PRIVATE gmock_main ssl crypto)
  target_include_directories(bm_pollset PRIVATE ${_gRPC_ROOT})

  target_compile_definitions(bm_pollset PRIVATE -DPB_FIELD_16BIT)
  target_compile_definitions(bm_pollset PUBLIC  -DGRPC_ALLOW_EXCEPTIONS=0)

  target_include_directories(bm_pollset
  PRIVATE ${_gRPC_ROOT}
  PRIVATE ${_gRPC_ROOT}/include
  PRIVATE ${_gRPC_SSL_INCLUDE_DIR}
  PRIVATE ${_gRPC_BENCHMARK_INCLUDE_DIR}
  PRIVATE ${_gRPC_GFLAGS_INCLUDE_DIR}
  PRIVATE ${_gRPC_PROTOBUF_INCLUDE_DIR}
  PRIVATE ${_gRPC_NANOPB_INCLUDE_DIR}
  PRIVATE ${_gRPC_ADDRESS_SORTING_INCLUDE_DIR}
  PRIVATE ${_gRPC_GTEST_INCLUDE_DIR}
  PRIVATE ${_gRPC_PROTO_GENS_DIR}
)

  target_link_libraries(bm_pollset PRIVATE
  ${_gRPC_PROTOBUF_LIBRARIES}
  ${_gRPC_ALLTARGETS_LIBRARIES}
  grpc_benchmark
  ${_gRPC_BENCHMARK_LIBRARIES}
  grpc++_test_util_unsecure
  grpc_test_util_unsecure
  grpc++_unsecure
  grpc_unsecure
  gpr_test_util
  gpr
  grpc++_test_config
  ${_gRPC_GFLAGS_LIBRARIES}
)

    add_dependencies(bm_pollset project_benchmark project_gflags)
endif()

  set(byte_stream_test_src
   ${_gRPC_ROOT}/test/core/transport/byte_stream_test.cc
)
  android_add_test(byte_stream_test)
  target_link_libraries(byte_stream_test PRIVATE gmock_main ssl crypto)
  target_include_directories(byte_stream_test PRIVATE ${_gRPC_ROOT})

  target_compile_definitions(byte_stream_test PRIVATE -DPB_FIELD_16BIT)
  target_compile_definitions(byte_stream_test PUBLIC  -DGRPC_ALLOW_EXCEPTIONS=0)

  target_include_directories(byte_stream_test
  PRIVATE ${_gRPC_ROOT}
  PRIVATE ${_gRPC_ROOT}/include
  PRIVATE ${_gRPC_SSL_INCLUDE_DIR}
  PRIVATE ${_gRPC_BENCHMARK_INCLUDE_DIR}
  PRIVATE ${_gRPC_GFLAGS_INCLUDE_DIR}
  PRIVATE ${_gRPC_PROTOBUF_INCLUDE_DIR}
  PRIVATE ${_gRPC_NANOPB_INCLUDE_DIR}
  PRIVATE ${_gRPC_ADDRESS_SORTING_INCLUDE_DIR}
  PRIVATE ${_gRPC_GTEST_INCLUDE_DIR}
  PRIVATE ${_gRPC_PROTO_GENS_DIR}
)

  target_link_libraries(byte_stream_test PRIVATE
  ${_gRPC_PROTOBUF_LIBRARIES}
  ${_gRPC_ALLTARGETS_LIBRARIES}
  grpc_test_util
  grpc
  gpr_test_util
  gpr
  ${_gRPC_GFLAGS_LIBRARIES}
)

    add_dependencies(byte_stream_test project_benchmark project_gflags)

  set(channel_arguments_test_src
   ${_gRPC_ROOT}/test/cpp/common/channel_arguments_test.cc
)
  android_add_test(channel_arguments_test)
  target_link_libraries(channel_arguments_test PRIVATE gmock_main ssl crypto)
  target_include_directories(channel_arguments_test PRIVATE ${_gRPC_ROOT})

  target_compile_definitions(channel_arguments_test PRIVATE -DPB_FIELD_16BIT)
  target_compile_definitions(channel_arguments_test PUBLIC  -DGRPC_ALLOW_EXCEPTIONS=0)

  target_include_directories(channel_arguments_test
  PRIVATE ${_gRPC_ROOT}
  PRIVATE ${_gRPC_ROOT}/include
  PRIVATE ${_gRPC_SSL_INCLUDE_DIR}
  PRIVATE ${_gRPC_BENCHMARK_INCLUDE_DIR}
  PRIVATE ${_gRPC_GFLAGS_INCLUDE_DIR}
  PRIVATE ${_gRPC_PROTOBUF_INCLUDE_DIR}
  PRIVATE ${_gRPC_NANOPB_INCLUDE_DIR}
  PRIVATE ${_gRPC_ADDRESS_SORTING_INCLUDE_DIR}
  PRIVATE ${_gRPC_GTEST_INCLUDE_DIR}
  PRIVATE ${_gRPC_PROTO_GENS_DIR}
)

  target_link_libraries(channel_arguments_test PRIVATE
  ${_gRPC_PROTOBUF_LIBRARIES}
  ${_gRPC_ALLTARGETS_LIBRARIES}
  grpc++
  grpc
  gpr
  ${_gRPC_GFLAGS_LIBRARIES}
)

    add_dependencies(channel_arguments_test project_benchmark project_gflags)

  set(channel_filter_test_src
   ${_gRPC_ROOT}/test/cpp/common/channel_filter_test.cc
)
  android_add_test(channel_filter_test)
  target_link_libraries(channel_filter_test PRIVATE gmock_main ssl crypto)
  target_include_directories(channel_filter_test PRIVATE ${_gRPC_ROOT})

  target_compile_definitions(channel_filter_test PRIVATE -DPB_FIELD_16BIT)
  target_compile_definitions(channel_filter_test PUBLIC  -DGRPC_ALLOW_EXCEPTIONS=0)

  target_include_directories(channel_filter_test
  PRIVATE ${_gRPC_ROOT}
  PRIVATE ${_gRPC_ROOT}/include
  PRIVATE ${_gRPC_SSL_INCLUDE_DIR}
  PRIVATE ${_gRPC_BENCHMARK_INCLUDE_DIR}
  PRIVATE ${_gRPC_GFLAGS_INCLUDE_DIR}
  PRIVATE ${_gRPC_PROTOBUF_INCLUDE_DIR}
  PRIVATE ${_gRPC_NANOPB_INCLUDE_DIR}
  PRIVATE ${_gRPC_ADDRESS_SORTING_INCLUDE_DIR}
  PRIVATE ${_gRPC_GTEST_INCLUDE_DIR}
  PRIVATE ${_gRPC_PROTO_GENS_DIR}
)

  target_link_libraries(channel_filter_test PRIVATE
  ${_gRPC_PROTOBUF_LIBRARIES}
  ${_gRPC_ALLTARGETS_LIBRARIES}
  grpc++
  grpc
  gpr
  ${_gRPC_GFLAGS_LIBRARIES}
)

    add_dependencies(channel_filter_test project_benchmark project_gflags)

  set(channel_trace_test_src
   ${_gRPC_ROOT}/test/core/channel/channel_trace_test.cc
          ${_gRPC_PROTO_GENS_DIR}/src/proto/grpc/channelz/channelz.pb.cc
          ${_gRPC_PROTO_GENS_DIR}/src/proto/grpc/channelz/channelz.grpc.pb.cc
          ${_gRPC_PROTO_GENS_DIR}/src/proto/grpc/channelz/channelz.pb.h
          ${_gRPC_PROTO_GENS_DIR}/src/proto/grpc/channelz/channelz.grpc.pb.h
)
  android_add_test(channel_trace_test)
  target_link_libraries(channel_trace_test PRIVATE gmock_main ssl crypto)
  target_include_directories(channel_trace_test PRIVATE ${_gRPC_ROOT})

  target_compile_definitions(channel_trace_test PRIVATE -DPB_FIELD_16BIT)
  target_compile_definitions(channel_trace_test PUBLIC  -DGRPC_ALLOW_EXCEPTIONS=0)
protobuf_generate_grpc_cpp(
  SOURCE_DIR ${_gRPC_ROOT}
  SOURCES ${_gRPC_ROOT}/src/proto/grpc/channelz/channelz.proto
)

  target_include_directories(channel_trace_test
  PRIVATE ${_gRPC_ROOT}
  PRIVATE ${_gRPC_ROOT}/include
  PRIVATE ${_gRPC_SSL_INCLUDE_DIR}
  PRIVATE ${_gRPC_BENCHMARK_INCLUDE_DIR}
  PRIVATE ${_gRPC_GFLAGS_INCLUDE_DIR}
  PRIVATE ${_gRPC_PROTOBUF_INCLUDE_DIR}
  PRIVATE ${_gRPC_NANOPB_INCLUDE_DIR}
  PRIVATE ${_gRPC_ADDRESS_SORTING_INCLUDE_DIR}
  PRIVATE ${_gRPC_GTEST_INCLUDE_DIR}
  PRIVATE ${_gRPC_PROTO_GENS_DIR}
)

  target_link_libraries(channel_trace_test PRIVATE
  ${_gRPC_PROTOBUF_LIBRARIES}
  ${_gRPC_ALLTARGETS_LIBRARIES}
  grpc_test_util
  grpc++_test_util
  grpc++
  grpc
  gpr_test_util
  gpr
  ${_gRPC_GFLAGS_LIBRARIES}
)

    add_dependencies(channel_trace_test project_benchmark project_gflags)

  set(channelz_registry_test_src
   ${_gRPC_ROOT}/test/core/channel/channelz_registry_test.cc
)
  android_add_test(channelz_registry_test)
  target_link_libraries(channelz_registry_test PRIVATE gmock_main ssl crypto)
  target_include_directories(channelz_registry_test PRIVATE ${_gRPC_ROOT})

  target_compile_definitions(channelz_registry_test PRIVATE -DPB_FIELD_16BIT)
  target_compile_definitions(channelz_registry_test PUBLIC  -DGRPC_ALLOW_EXCEPTIONS=0)

  target_include_directories(channelz_registry_test
  PRIVATE ${_gRPC_ROOT}
  PRIVATE ${_gRPC_ROOT}/include
  PRIVATE ${_gRPC_SSL_INCLUDE_DIR}
  PRIVATE ${_gRPC_BENCHMARK_INCLUDE_DIR}
  PRIVATE ${_gRPC_GFLAGS_INCLUDE_DIR}
  PRIVATE ${_gRPC_PROTOBUF_INCLUDE_DIR}
  PRIVATE ${_gRPC_NANOPB_INCLUDE_DIR}
  PRIVATE ${_gRPC_ADDRESS_SORTING_INCLUDE_DIR}
  PRIVATE ${_gRPC_GTEST_INCLUDE_DIR}
  PRIVATE ${_gRPC_PROTO_GENS_DIR}
)

  target_link_libraries(channelz_registry_test PRIVATE
  ${_gRPC_PROTOBUF_LIBRARIES}
  ${_gRPC_ALLTARGETS_LIBRARIES}
  grpc_test_util
  grpc++_test_util
  grpc++
  grpc
  gpr_test_util
  gpr
  ${_gRPC_GFLAGS_LIBRARIES}
)

    add_dependencies(channelz_registry_test project_benchmark project_gflags)

  set(channelz_test_src
   ${_gRPC_ROOT}/test/core/channel/channelz_test.cc
          ${_gRPC_PROTO_GENS_DIR}/src/proto/grpc/channelz/channelz.pb.cc
          ${_gRPC_PROTO_GENS_DIR}/src/proto/grpc/channelz/channelz.grpc.pb.cc
          ${_gRPC_PROTO_GENS_DIR}/src/proto/grpc/channelz/channelz.pb.h
          ${_gRPC_PROTO_GENS_DIR}/src/proto/grpc/channelz/channelz.grpc.pb.h
)
  android_add_test(channelz_test)
  target_link_libraries(channelz_test PRIVATE gmock_main ssl crypto)
  target_include_directories(channelz_test PRIVATE ${_gRPC_ROOT})

  target_compile_definitions(channelz_test PRIVATE -DPB_FIELD_16BIT)
  target_compile_definitions(channelz_test PUBLIC  -DGRPC_ALLOW_EXCEPTIONS=0)
protobuf_generate_grpc_cpp(
  SOURCE_DIR ${_gRPC_ROOT}
  SOURCES ${_gRPC_ROOT}/src/proto/grpc/channelz/channelz.proto
)

  target_include_directories(channelz_test
  PRIVATE ${_gRPC_ROOT}
  PRIVATE ${_gRPC_ROOT}/include
  PRIVATE ${_gRPC_SSL_INCLUDE_DIR}
  PRIVATE ${_gRPC_BENCHMARK_INCLUDE_DIR}
  PRIVATE ${_gRPC_GFLAGS_INCLUDE_DIR}
  PRIVATE ${_gRPC_PROTOBUF_INCLUDE_DIR}
  PRIVATE ${_gRPC_NANOPB_INCLUDE_DIR}
  PRIVATE ${_gRPC_ADDRESS_SORTING_INCLUDE_DIR}
  PRIVATE ${_gRPC_GTEST_INCLUDE_DIR}
  PRIVATE ${_gRPC_PROTO_GENS_DIR}
)

  target_link_libraries(channelz_test PRIVATE
  ${_gRPC_PROTOBUF_LIBRARIES}
  ${_gRPC_ALLTARGETS_LIBRARIES}
  grpc_test_util
  grpc++_test_util
  grpc++
  grpc
  gpr_test_util
  gpr
  ${_gRPC_GFLAGS_LIBRARIES}
)

    add_dependencies(channelz_test project_benchmark project_gflags)

  set(check_gcp_environment_linux_test_src
   ${_gRPC_ROOT}/test/core/security/check_gcp_environment_linux_test.cc
)
  android_add_test(check_gcp_environment_linux_test)
  target_link_libraries(check_gcp_environment_linux_test PRIVATE gmock_main ssl crypto)
  target_include_directories(check_gcp_environment_linux_test PRIVATE ${_gRPC_ROOT})

  target_compile_definitions(check_gcp_environment_linux_test PRIVATE -DPB_FIELD_16BIT)
  target_compile_definitions(check_gcp_environment_linux_test PUBLIC  -DGRPC_ALLOW_EXCEPTIONS=0)

  target_include_directories(check_gcp_environment_linux_test
  PRIVATE ${_gRPC_ROOT}
  PRIVATE ${_gRPC_ROOT}/include
  PRIVATE ${_gRPC_SSL_INCLUDE_DIR}
  PRIVATE ${_gRPC_BENCHMARK_INCLUDE_DIR}
  PRIVATE ${_gRPC_GFLAGS_INCLUDE_DIR}
  PRIVATE ${_gRPC_PROTOBUF_INCLUDE_DIR}
  PRIVATE ${_gRPC_NANOPB_INCLUDE_DIR}
  PRIVATE ${_gRPC_ADDRESS_SORTING_INCLUDE_DIR}
  PRIVATE ${_gRPC_GTEST_INCLUDE_DIR}
  PRIVATE ${_gRPC_PROTO_GENS_DIR}
)

  target_link_libraries(check_gcp_environment_linux_test PRIVATE
  ${_gRPC_PROTOBUF_LIBRARIES}
  ${_gRPC_ALLTARGETS_LIBRARIES}
  grpc
  gpr
  ${_gRPC_GFLAGS_LIBRARIES}
)

    add_dependencies(check_gcp_environment_linux_test project_benchmark project_gflags)

  set(check_gcp_environment_windows_test_src
   ${_gRPC_ROOT}/test/core/security/check_gcp_environment_windows_test.cc
)
  android_add_test(check_gcp_environment_windows_test)
  target_link_libraries(check_gcp_environment_windows_test PRIVATE gmock_main ssl crypto)
  target_include_directories(check_gcp_environment_windows_test PRIVATE ${_gRPC_ROOT})

  target_compile_definitions(check_gcp_environment_windows_test PRIVATE -DPB_FIELD_16BIT)
  target_compile_definitions(check_gcp_environment_windows_test PUBLIC  -DGRPC_ALLOW_EXCEPTIONS=0)

  target_include_directories(check_gcp_environment_windows_test
  PRIVATE ${_gRPC_ROOT}
  PRIVATE ${_gRPC_ROOT}/include
  PRIVATE ${_gRPC_SSL_INCLUDE_DIR}
  PRIVATE ${_gRPC_BENCHMARK_INCLUDE_DIR}
  PRIVATE ${_gRPC_GFLAGS_INCLUDE_DIR}
  PRIVATE ${_gRPC_PROTOBUF_INCLUDE_DIR}
  PRIVATE ${_gRPC_NANOPB_INCLUDE_DIR}
  PRIVATE ${_gRPC_ADDRESS_SORTING_INCLUDE_DIR}
  PRIVATE ${_gRPC_GTEST_INCLUDE_DIR}
  PRIVATE ${_gRPC_PROTO_GENS_DIR}
)

  target_link_libraries(check_gcp_environment_windows_test PRIVATE
  ${_gRPC_PROTOBUF_LIBRARIES}
  ${_gRPC_ALLTARGETS_LIBRARIES}
  grpc
  gpr
  ${_gRPC_GFLAGS_LIBRARIES}
)

    add_dependencies(check_gcp_environment_windows_test project_benchmark project_gflags)

  set(chttp2_settings_timeout_test_src
   ${_gRPC_ROOT}/test/core/transport/chttp2/settings_timeout_test.cc
)
  android_add_test(chttp2_settings_timeout_test)
  target_link_libraries(chttp2_settings_timeout_test PRIVATE gmock_main ssl crypto)
  target_include_directories(chttp2_settings_timeout_test PRIVATE ${_gRPC_ROOT})

  target_compile_definitions(chttp2_settings_timeout_test PRIVATE -DPB_FIELD_16BIT)
  target_compile_definitions(chttp2_settings_timeout_test PUBLIC  -DGRPC_ALLOW_EXCEPTIONS=0)

  target_include_directories(chttp2_settings_timeout_test
  PRIVATE ${_gRPC_ROOT}
  PRIVATE ${_gRPC_ROOT}/include
  PRIVATE ${_gRPC_SSL_INCLUDE_DIR}
  PRIVATE ${_gRPC_BENCHMARK_INCLUDE_DIR}
  PRIVATE ${_gRPC_GFLAGS_INCLUDE_DIR}
  PRIVATE ${_gRPC_PROTOBUF_INCLUDE_DIR}
  PRIVATE ${_gRPC_NANOPB_INCLUDE_DIR}
  PRIVATE ${_gRPC_ADDRESS_SORTING_INCLUDE_DIR}
  PRIVATE ${_gRPC_GTEST_INCLUDE_DIR}
  PRIVATE ${_gRPC_PROTO_GENS_DIR}
)

  target_link_libraries(chttp2_settings_timeout_test PRIVATE
  ${_gRPC_PROTOBUF_LIBRARIES}
  ${_gRPC_ALLTARGETS_LIBRARIES}
  grpc_test_util
  grpc
  gpr_test_util
  gpr
  ${_gRPC_GFLAGS_LIBRARIES}
)

    add_dependencies(chttp2_settings_timeout_test project_benchmark project_gflags)

  set(cli_call_test_src
   ${_gRPC_ROOT}/test/cpp/util/cli_call_test.cc
)
  android_add_test(cli_call_test)
  target_link_libraries(cli_call_test PRIVATE gmock_main ssl crypto)
  target_include_directories(cli_call_test PRIVATE ${_gRPC_ROOT})

  target_compile_definitions(cli_call_test PRIVATE -DPB_FIELD_16BIT)
  target_compile_definitions(cli_call_test PUBLIC  -DGRPC_ALLOW_EXCEPTIONS=0)

  target_include_directories(cli_call_test
  PRIVATE ${_gRPC_ROOT}
  PRIVATE ${_gRPC_ROOT}/include
  PRIVATE ${_gRPC_SSL_INCLUDE_DIR}
  PRIVATE ${_gRPC_BENCHMARK_INCLUDE_DIR}
  PRIVATE ${_gRPC_GFLAGS_INCLUDE_DIR}
  PRIVATE ${_gRPC_PROTOBUF_INCLUDE_DIR}
  PRIVATE ${_gRPC_NANOPB_INCLUDE_DIR}
  PRIVATE ${_gRPC_ADDRESS_SORTING_INCLUDE_DIR}
  PRIVATE ${_gRPC_GTEST_INCLUDE_DIR}
  PRIVATE ${_gRPC_PROTO_GENS_DIR}
)

  target_link_libraries(cli_call_test PRIVATE
  ${_gRPC_PROTOBUF_LIBRARIES}
  ${_gRPC_ALLTARGETS_LIBRARIES}
  grpc_cli_libs
  grpc++_test_util
  grpc_test_util
  grpc++
  grpc
  gpr_test_util
  gpr
  ${_gRPC_GFLAGS_LIBRARIES}
)

    add_dependencies(cli_call_test project_benchmark project_gflags)

  set(client_callback_end2end_test_src
   ${_gRPC_ROOT}/test/cpp/end2end/client_callback_end2end_test.cc
)
  android_add_test(client_callback_end2end_test)
  target_link_libraries(client_callback_end2end_test PRIVATE gmock_main ssl crypto)
  target_include_directories(client_callback_end2end_test PRIVATE ${_gRPC_ROOT})

  target_compile_definitions(client_callback_end2end_test PRIVATE -DPB_FIELD_16BIT)
  target_compile_definitions(client_callback_end2end_test PUBLIC  -DGRPC_ALLOW_EXCEPTIONS=0)

  target_include_directories(client_callback_end2end_test
  PRIVATE ${_gRPC_ROOT}
  PRIVATE ${_gRPC_ROOT}/include
  PRIVATE ${_gRPC_SSL_INCLUDE_DIR}
  PRIVATE ${_gRPC_BENCHMARK_INCLUDE_DIR}
  PRIVATE ${_gRPC_GFLAGS_INCLUDE_DIR}
  PRIVATE ${_gRPC_PROTOBUF_INCLUDE_DIR}
  PRIVATE ${_gRPC_NANOPB_INCLUDE_DIR}
  PRIVATE ${_gRPC_ADDRESS_SORTING_INCLUDE_DIR}
  PRIVATE ${_gRPC_GTEST_INCLUDE_DIR}
  PRIVATE ${_gRPC_PROTO_GENS_DIR}
)

  target_link_libraries(client_callback_end2end_test PRIVATE
  ${_gRPC_PROTOBUF_LIBRARIES}
  ${_gRPC_ALLTARGETS_LIBRARIES}
  grpc++_test_util
  grpc_test_util
  grpc++
  grpc
  gpr_test_util
  gpr
  ${_gRPC_GFLAGS_LIBRARIES}
)

    add_dependencies(client_callback_end2end_test project_benchmark project_gflags)

  set(client_channel_stress_test_src
          ${_gRPC_PROTO_GENS_DIR}/src/proto/grpc/lb/v1/load_balancer.pb.cc
          ${_gRPC_PROTO_GENS_DIR}/src/proto/grpc/lb/v1/load_balancer.grpc.pb.cc
          ${_gRPC_PROTO_GENS_DIR}/src/proto/grpc/lb/v1/load_balancer.pb.h
          ${_gRPC_PROTO_GENS_DIR}/src/proto/grpc/lb/v1/load_balancer.grpc.pb.h
   ${_gRPC_ROOT}/test/cpp/client/client_channel_stress_test.cc
)
  android_add_test(client_channel_stress_test)
  target_link_libraries(client_channel_stress_test PRIVATE gmock_main ssl crypto)
  target_include_directories(client_channel_stress_test PRIVATE ${_gRPC_ROOT})

  target_compile_definitions(client_channel_stress_test PRIVATE -DPB_FIELD_16BIT)
  target_compile_definitions(client_channel_stress_test PUBLIC  -DGRPC_ALLOW_EXCEPTIONS=0)
protobuf_generate_grpc_cpp(
  SOURCE_DIR ${_gRPC_ROOT}
  SOURCES ${_gRPC_ROOT}/src/proto/grpc/lb/v1/load_balancer.proto
)

  target_include_directories(client_channel_stress_test
  PRIVATE ${_gRPC_ROOT}
  PRIVATE ${_gRPC_ROOT}/include
  PRIVATE ${_gRPC_SSL_INCLUDE_DIR}
  PRIVATE ${_gRPC_BENCHMARK_INCLUDE_DIR}
  PRIVATE ${_gRPC_GFLAGS_INCLUDE_DIR}
  PRIVATE ${_gRPC_PROTOBUF_INCLUDE_DIR}
  PRIVATE ${_gRPC_NANOPB_INCLUDE_DIR}
  PRIVATE ${_gRPC_ADDRESS_SORTING_INCLUDE_DIR}
  PRIVATE ${_gRPC_GTEST_INCLUDE_DIR}
  PRIVATE ${_gRPC_PROTO_GENS_DIR}
)

  target_link_libraries(client_channel_stress_test PRIVATE
  ${_gRPC_PROTOBUF_LIBRARIES}
  ${_gRPC_ALLTARGETS_LIBRARIES}
  grpc++_test_util
  grpc_test_util
  grpc++
  grpc
  gpr_test_util
  gpr
  ${_gRPC_GFLAGS_LIBRARIES}
)

    add_dependencies(client_channel_stress_test project_benchmark project_gflags)
if(_gRPC_PLATFORM_LINUX OR _gRPC_PLATFORM_MAC OR _gRPC_PLATFORM_POSIX)

  set(client_crash_test_src
   ${_gRPC_ROOT}/test/cpp/end2end/client_crash_test.cc
)
  android_add_test(client_crash_test)
  target_link_libraries(client_crash_test PRIVATE gmock_main ssl crypto)
  target_include_directories(client_crash_test PRIVATE ${_gRPC_ROOT})

  target_compile_definitions(client_crash_test PRIVATE -DPB_FIELD_16BIT)
  target_compile_definitions(client_crash_test PUBLIC  -DGRPC_ALLOW_EXCEPTIONS=0)

  target_include_directories(client_crash_test
  PRIVATE ${_gRPC_ROOT}
  PRIVATE ${_gRPC_ROOT}/include
  PRIVATE ${_gRPC_SSL_INCLUDE_DIR}
  PRIVATE ${_gRPC_BENCHMARK_INCLUDE_DIR}
  PRIVATE ${_gRPC_GFLAGS_INCLUDE_DIR}
  PRIVATE ${_gRPC_PROTOBUF_INCLUDE_DIR}
  PRIVATE ${_gRPC_NANOPB_INCLUDE_DIR}
  PRIVATE ${_gRPC_ADDRESS_SORTING_INCLUDE_DIR}
  PRIVATE ${_gRPC_GTEST_INCLUDE_DIR}
  PRIVATE ${_gRPC_PROTO_GENS_DIR}
)

  target_link_libraries(client_crash_test PRIVATE
  ${_gRPC_PROTOBUF_LIBRARIES}
  ${_gRPC_ALLTARGETS_LIBRARIES}
  grpc++_test_util
  grpc_test_util
  grpc++
  grpc
  gpr_test_util
  gpr
  ${_gRPC_GFLAGS_LIBRARIES}
)

    add_dependencies(client_crash_test project_benchmark project_gflags)
endif()

  set(client_crash_test_server_src
   ${_gRPC_ROOT}/test/cpp/end2end/client_crash_test_server.cc
)
  android_add_test(client_crash_test_server)
  target_link_libraries(client_crash_test_server PRIVATE gmock_main ssl crypto)
  target_include_directories(client_crash_test_server PRIVATE ${_gRPC_ROOT})

  target_compile_definitions(client_crash_test_server PRIVATE -DPB_FIELD_16BIT)
  target_compile_definitions(client_crash_test_server PUBLIC  -DGRPC_ALLOW_EXCEPTIONS=0)

  target_include_directories(client_crash_test_server
  PRIVATE ${_gRPC_ROOT}
  PRIVATE ${_gRPC_ROOT}/include
  PRIVATE ${_gRPC_SSL_INCLUDE_DIR}
  PRIVATE ${_gRPC_BENCHMARK_INCLUDE_DIR}
  PRIVATE ${_gRPC_GFLAGS_INCLUDE_DIR}
  PRIVATE ${_gRPC_PROTOBUF_INCLUDE_DIR}
  PRIVATE ${_gRPC_NANOPB_INCLUDE_DIR}
  PRIVATE ${_gRPC_ADDRESS_SORTING_INCLUDE_DIR}
  PRIVATE ${_gRPC_GTEST_INCLUDE_DIR}
  PRIVATE ${_gRPC_PROTO_GENS_DIR}
)

  target_link_libraries(client_crash_test_server PRIVATE
  ${_gRPC_PROTOBUF_LIBRARIES}
  ${_gRPC_ALLTARGETS_LIBRARIES}
  grpc++_test_util
  grpc_test_util
  grpc++
  grpc
  gpr_test_util
  gpr
  ${_gRPC_GFLAGS_LIBRARIES}
)

    add_dependencies(client_crash_test_server project_benchmark project_gflags)

  set(client_lb_end2end_test_src
   ${_gRPC_ROOT}/test/cpp/end2end/client_lb_end2end_test.cc
)
  android_add_test(client_lb_end2end_test)
  target_link_libraries(client_lb_end2end_test PRIVATE gmock_main ssl crypto)
  target_include_directories(client_lb_end2end_test PRIVATE ${_gRPC_ROOT})

  target_compile_definitions(client_lb_end2end_test PRIVATE -DPB_FIELD_16BIT)
  target_compile_definitions(client_lb_end2end_test PUBLIC  -DGRPC_ALLOW_EXCEPTIONS=0)

  target_include_directories(client_lb_end2end_test
  PRIVATE ${_gRPC_ROOT}
  PRIVATE ${_gRPC_ROOT}/include
  PRIVATE ${_gRPC_SSL_INCLUDE_DIR}
  PRIVATE ${_gRPC_BENCHMARK_INCLUDE_DIR}
  PRIVATE ${_gRPC_GFLAGS_INCLUDE_DIR}
  PRIVATE ${_gRPC_PROTOBUF_INCLUDE_DIR}
  PRIVATE ${_gRPC_NANOPB_INCLUDE_DIR}
  PRIVATE ${_gRPC_ADDRESS_SORTING_INCLUDE_DIR}
  PRIVATE ${_gRPC_GTEST_INCLUDE_DIR}
  PRIVATE ${_gRPC_PROTO_GENS_DIR}
)

  target_link_libraries(client_lb_end2end_test PRIVATE
  ${_gRPC_PROTOBUF_LIBRARIES}
  ${_gRPC_ALLTARGETS_LIBRARIES}
  grpc++_test_util
  grpc_test_util
  grpc++
  grpc
  gpr_test_util
  gpr
  ${_gRPC_GFLAGS_LIBRARIES}
)

    add_dependencies(client_lb_end2end_test project_benchmark project_gflags)

  set(codegen_test_full_src
          ${_gRPC_PROTO_GENS_DIR}/src/proto/grpc/testing/control.pb.cc
          ${_gRPC_PROTO_GENS_DIR}/src/proto/grpc/testing/control.grpc.pb.cc
          ${_gRPC_PROTO_GENS_DIR}/src/proto/grpc/testing/control.pb.h
          ${_gRPC_PROTO_GENS_DIR}/src/proto/grpc/testing/control.grpc.pb.h
          ${_gRPC_PROTO_GENS_DIR}/src/proto/grpc/testing/messages.pb.cc
          ${_gRPC_PROTO_GENS_DIR}/src/proto/grpc/testing/messages.grpc.pb.cc
          ${_gRPC_PROTO_GENS_DIR}/src/proto/grpc/testing/messages.pb.h
          ${_gRPC_PROTO_GENS_DIR}/src/proto/grpc/testing/messages.grpc.pb.h
          ${_gRPC_PROTO_GENS_DIR}/src/proto/grpc/testing/payloads.pb.cc
          ${_gRPC_PROTO_GENS_DIR}/src/proto/grpc/testing/payloads.grpc.pb.cc
          ${_gRPC_PROTO_GENS_DIR}/src/proto/grpc/testing/payloads.pb.h
          ${_gRPC_PROTO_GENS_DIR}/src/proto/grpc/testing/payloads.grpc.pb.h
          ${_gRPC_PROTO_GENS_DIR}/src/proto/grpc/testing/benchmark_service.pb.cc
          ${_gRPC_PROTO_GENS_DIR}/src/proto/grpc/testing/benchmark_service.grpc.pb.cc
          ${_gRPC_PROTO_GENS_DIR}/src/proto/grpc/testing/benchmark_service.pb.h
          ${_gRPC_PROTO_GENS_DIR}/src/proto/grpc/testing/benchmark_service.grpc.pb.h
          ${_gRPC_PROTO_GENS_DIR}/src/proto/grpc/testing/report_qps_scenario_service.pb.cc
          ${_gRPC_PROTO_GENS_DIR}/src/proto/grpc/testing/report_qps_scenario_service.grpc.pb.cc
          ${_gRPC_PROTO_GENS_DIR}/src/proto/grpc/testing/report_qps_scenario_service.pb.h
          ${_gRPC_PROTO_GENS_DIR}/src/proto/grpc/testing/report_qps_scenario_service.grpc.pb.h
          ${_gRPC_PROTO_GENS_DIR}/src/proto/grpc/testing/worker_service.pb.cc
          ${_gRPC_PROTO_GENS_DIR}/src/proto/grpc/testing/worker_service.grpc.pb.cc
          ${_gRPC_PROTO_GENS_DIR}/src/proto/grpc/testing/worker_service.pb.h
          ${_gRPC_PROTO_GENS_DIR}/src/proto/grpc/testing/worker_service.grpc.pb.h
          ${_gRPC_PROTO_GENS_DIR}/src/proto/grpc/testing/stats.pb.cc
          ${_gRPC_PROTO_GENS_DIR}/src/proto/grpc/testing/stats.grpc.pb.cc
          ${_gRPC_PROTO_GENS_DIR}/src/proto/grpc/testing/stats.pb.h
          ${_gRPC_PROTO_GENS_DIR}/src/proto/grpc/testing/stats.grpc.pb.h
   ${_gRPC_ROOT}/test/cpp/codegen/codegen_test_full.cc
)
  android_add_test(codegen_test_full)
  target_link_libraries(codegen_test_full PRIVATE gmock_main ssl crypto)
  target_include_directories(codegen_test_full PRIVATE ${_gRPC_ROOT})

  target_compile_definitions(codegen_test_full PRIVATE -DPB_FIELD_16BIT)
  target_compile_definitions(codegen_test_full PUBLIC  -DGRPC_ALLOW_EXCEPTIONS=0)
protobuf_generate_grpc_cpp(
  SOURCE_DIR ${_gRPC_ROOT}
  SOURCES ${_gRPC_ROOT}/src/proto/grpc/testing/control.proto
)
protobuf_generate_grpc_cpp(
  SOURCE_DIR ${_gRPC_ROOT}
  SOURCES ${_gRPC_ROOT}/src/proto/grpc/testing/messages.proto
)
protobuf_generate_grpc_cpp(
  SOURCE_DIR ${_gRPC_ROOT}
  SOURCES ${_gRPC_ROOT}/src/proto/grpc/testing/payloads.proto
)
protobuf_generate_grpc_cpp(
  SOURCE_DIR ${_gRPC_ROOT}
  SOURCES ${_gRPC_ROOT}/src/proto/grpc/testing/benchmark_service.proto
)
protobuf_generate_grpc_cpp(
  SOURCE_DIR ${_gRPC_ROOT}
  SOURCES ${_gRPC_ROOT}/src/proto/grpc/testing/report_qps_scenario_service.proto
)
protobuf_generate_grpc_cpp(
  SOURCE_DIR ${_gRPC_ROOT}
  SOURCES ${_gRPC_ROOT}/src/proto/grpc/testing/worker_service.proto
)
protobuf_generate_grpc_cpp(
  SOURCE_DIR ${_gRPC_ROOT}
  SOURCES ${_gRPC_ROOT}/src/proto/grpc/testing/stats.proto
)

  target_include_directories(codegen_test_full
  PRIVATE ${_gRPC_ROOT}
  PRIVATE ${_gRPC_ROOT}/include
  PRIVATE ${_gRPC_SSL_INCLUDE_DIR}
  PRIVATE ${_gRPC_BENCHMARK_INCLUDE_DIR}
  PRIVATE ${_gRPC_GFLAGS_INCLUDE_DIR}
  PRIVATE ${_gRPC_PROTOBUF_INCLUDE_DIR}
  PRIVATE ${_gRPC_NANOPB_INCLUDE_DIR}
  PRIVATE ${_gRPC_ADDRESS_SORTING_INCLUDE_DIR}
  PRIVATE ${_gRPC_GTEST_INCLUDE_DIR}
  PRIVATE ${_gRPC_PROTO_GENS_DIR}
)

  target_link_libraries(codegen_test_full PRIVATE
  ${_gRPC_PROTOBUF_LIBRARIES}
  ${_gRPC_ALLTARGETS_LIBRARIES}
  grpc++_core_stats
  grpc++
  grpc
  gpr
  ${_gRPC_GFLAGS_LIBRARIES}
)

    add_dependencies(codegen_test_full project_benchmark project_gflags)

  set(codegen_test_minimal_src
          ${_gRPC_PROTO_GENS_DIR}/src/proto/grpc/testing/control.pb.cc
          ${_gRPC_PROTO_GENS_DIR}/src/proto/grpc/testing/control.grpc.pb.cc
          ${_gRPC_PROTO_GENS_DIR}/src/proto/grpc/testing/control.pb.h
          ${_gRPC_PROTO_GENS_DIR}/src/proto/grpc/testing/control.grpc.pb.h
          ${_gRPC_PROTO_GENS_DIR}/src/proto/grpc/testing/messages.pb.cc
          ${_gRPC_PROTO_GENS_DIR}/src/proto/grpc/testing/messages.grpc.pb.cc
          ${_gRPC_PROTO_GENS_DIR}/src/proto/grpc/testing/messages.pb.h
          ${_gRPC_PROTO_GENS_DIR}/src/proto/grpc/testing/messages.grpc.pb.h
          ${_gRPC_PROTO_GENS_DIR}/src/proto/grpc/testing/payloads.pb.cc
          ${_gRPC_PROTO_GENS_DIR}/src/proto/grpc/testing/payloads.grpc.pb.cc
          ${_gRPC_PROTO_GENS_DIR}/src/proto/grpc/testing/payloads.pb.h
          ${_gRPC_PROTO_GENS_DIR}/src/proto/grpc/testing/payloads.grpc.pb.h
          ${_gRPC_PROTO_GENS_DIR}/src/proto/grpc/testing/benchmark_service.pb.cc
          ${_gRPC_PROTO_GENS_DIR}/src/proto/grpc/testing/benchmark_service.grpc.pb.cc
          ${_gRPC_PROTO_GENS_DIR}/src/proto/grpc/testing/benchmark_service.pb.h
          ${_gRPC_PROTO_GENS_DIR}/src/proto/grpc/testing/benchmark_service.grpc.pb.h
          ${_gRPC_PROTO_GENS_DIR}/src/proto/grpc/testing/report_qps_scenario_service.pb.cc
          ${_gRPC_PROTO_GENS_DIR}/src/proto/grpc/testing/report_qps_scenario_service.grpc.pb.cc
          ${_gRPC_PROTO_GENS_DIR}/src/proto/grpc/testing/report_qps_scenario_service.pb.h
          ${_gRPC_PROTO_GENS_DIR}/src/proto/grpc/testing/report_qps_scenario_service.grpc.pb.h
          ${_gRPC_PROTO_GENS_DIR}/src/proto/grpc/testing/worker_service.pb.cc
          ${_gRPC_PROTO_GENS_DIR}/src/proto/grpc/testing/worker_service.grpc.pb.cc
          ${_gRPC_PROTO_GENS_DIR}/src/proto/grpc/testing/worker_service.pb.h
          ${_gRPC_PROTO_GENS_DIR}/src/proto/grpc/testing/worker_service.grpc.pb.h
          ${_gRPC_PROTO_GENS_DIR}/src/proto/grpc/testing/stats.pb.cc
          ${_gRPC_PROTO_GENS_DIR}/src/proto/grpc/testing/stats.grpc.pb.cc
          ${_gRPC_PROTO_GENS_DIR}/src/proto/grpc/testing/stats.pb.h
          ${_gRPC_PROTO_GENS_DIR}/src/proto/grpc/testing/stats.grpc.pb.h
   ${_gRPC_ROOT}/test/cpp/codegen/codegen_test_minimal.cc
   ${_gRPC_ROOT}/src/cpp/codegen/codegen_init.cc
)
  android_add_test(codegen_test_minimal)
  target_link_libraries(codegen_test_minimal PRIVATE gmock_main ssl crypto)
  target_include_directories(codegen_test_minimal PRIVATE ${_gRPC_ROOT})

  target_compile_definitions(codegen_test_minimal PRIVATE -DPB_FIELD_16BIT)
  target_compile_definitions(codegen_test_minimal PUBLIC  -DGRPC_ALLOW_EXCEPTIONS=0)
protobuf_generate_grpc_cpp(
  SOURCE_DIR ${_gRPC_ROOT}
  SOURCES ${_gRPC_ROOT}/src/proto/grpc/testing/control.proto
)
protobuf_generate_grpc_cpp(
  SOURCE_DIR ${_gRPC_ROOT}
  SOURCES ${_gRPC_ROOT}/src/proto/grpc/testing/messages.proto
)
protobuf_generate_grpc_cpp(
  SOURCE_DIR ${_gRPC_ROOT}
  SOURCES ${_gRPC_ROOT}/src/proto/grpc/testing/payloads.proto
)
protobuf_generate_grpc_cpp(
  SOURCE_DIR ${_gRPC_ROOT}
  SOURCES ${_gRPC_ROOT}/src/proto/grpc/testing/benchmark_service.proto
)
protobuf_generate_grpc_cpp(
  SOURCE_DIR ${_gRPC_ROOT}
  SOURCES ${_gRPC_ROOT}/src/proto/grpc/testing/report_qps_scenario_service.proto
)
protobuf_generate_grpc_cpp(
  SOURCE_DIR ${_gRPC_ROOT}
  SOURCES ${_gRPC_ROOT}/src/proto/grpc/testing/worker_service.proto
)
protobuf_generate_grpc_cpp(
  SOURCE_DIR ${_gRPC_ROOT}
  SOURCES ${_gRPC_ROOT}/src/proto/grpc/testing/stats.proto
)

  target_include_directories(codegen_test_minimal
  PRIVATE ${_gRPC_ROOT}
  PRIVATE ${_gRPC_ROOT}/include
  PRIVATE ${_gRPC_SSL_INCLUDE_DIR}
  PRIVATE ${_gRPC_BENCHMARK_INCLUDE_DIR}
  PRIVATE ${_gRPC_GFLAGS_INCLUDE_DIR}
  PRIVATE ${_gRPC_PROTOBUF_INCLUDE_DIR}
  PRIVATE ${_gRPC_NANOPB_INCLUDE_DIR}
  PRIVATE ${_gRPC_ADDRESS_SORTING_INCLUDE_DIR}
  PRIVATE ${_gRPC_GTEST_INCLUDE_DIR}
  PRIVATE ${_gRPC_PROTO_GENS_DIR}
)

  target_link_libraries(codegen_test_minimal PRIVATE
  ${_gRPC_PROTOBUF_LIBRARIES}
  ${_gRPC_ALLTARGETS_LIBRARIES}
  grpc++_core_stats
  grpc
  gpr
  ${_gRPC_GFLAGS_LIBRARIES}
)

    add_dependencies(codegen_test_minimal project_benchmark project_gflags)

  set(credentials_test_src
   ${_gRPC_ROOT}/test/cpp/client/credentials_test.cc
)
  android_add_test(credentials_test)
  target_link_libraries(credentials_test PRIVATE gmock_main ssl crypto)
  target_include_directories(credentials_test PRIVATE ${_gRPC_ROOT})

  target_compile_definitions(credentials_test PRIVATE -DPB_FIELD_16BIT)
  target_compile_definitions(credentials_test PUBLIC  -DGRPC_ALLOW_EXCEPTIONS=0)

  target_include_directories(credentials_test
  PRIVATE ${_gRPC_ROOT}
  PRIVATE ${_gRPC_ROOT}/include
  PRIVATE ${_gRPC_SSL_INCLUDE_DIR}
  PRIVATE ${_gRPC_BENCHMARK_INCLUDE_DIR}
  PRIVATE ${_gRPC_GFLAGS_INCLUDE_DIR}
  PRIVATE ${_gRPC_PROTOBUF_INCLUDE_DIR}
  PRIVATE ${_gRPC_NANOPB_INCLUDE_DIR}
  PRIVATE ${_gRPC_ADDRESS_SORTING_INCLUDE_DIR}
  PRIVATE ${_gRPC_GTEST_INCLUDE_DIR}
  PRIVATE ${_gRPC_PROTO_GENS_DIR}
)

  target_link_libraries(credentials_test PRIVATE
  ${_gRPC_PROTOBUF_LIBRARIES}
  ${_gRPC_ALLTARGETS_LIBRARIES}
  grpc++
  grpc
  gpr
  ${_gRPC_GFLAGS_LIBRARIES}
)

    add_dependencies(credentials_test project_benchmark project_gflags)

  set(cxx_byte_buffer_test_src
   ${_gRPC_ROOT}/test/cpp/util/byte_buffer_test.cc
)
  android_add_test(cxx_byte_buffer_test)
  target_link_libraries(cxx_byte_buffer_test PRIVATE gmock_main ssl crypto)
  target_include_directories(cxx_byte_buffer_test PRIVATE ${_gRPC_ROOT})

  target_compile_definitions(cxx_byte_buffer_test PRIVATE -DPB_FIELD_16BIT)
  target_compile_definitions(cxx_byte_buffer_test PUBLIC  -DGRPC_ALLOW_EXCEPTIONS=0)

  target_include_directories(cxx_byte_buffer_test
  PRIVATE ${_gRPC_ROOT}
  PRIVATE ${_gRPC_ROOT}/include
  PRIVATE ${_gRPC_SSL_INCLUDE_DIR}
  PRIVATE ${_gRPC_BENCHMARK_INCLUDE_DIR}
  PRIVATE ${_gRPC_GFLAGS_INCLUDE_DIR}
  PRIVATE ${_gRPC_PROTOBUF_INCLUDE_DIR}
  PRIVATE ${_gRPC_NANOPB_INCLUDE_DIR}
  PRIVATE ${_gRPC_ADDRESS_SORTING_INCLUDE_DIR}
  PRIVATE ${_gRPC_GTEST_INCLUDE_DIR}
  PRIVATE ${_gRPC_PROTO_GENS_DIR}
)

  target_link_libraries(cxx_byte_buffer_test PRIVATE
  ${_gRPC_PROTOBUF_LIBRARIES}
  ${_gRPC_ALLTARGETS_LIBRARIES}
  grpc_test_util
  grpc++
  grpc
  gpr_test_util
  gpr
  ${_gRPC_GFLAGS_LIBRARIES}
)

    add_dependencies(cxx_byte_buffer_test project_benchmark project_gflags)

  set(cxx_slice_test_src
   ${_gRPC_ROOT}/test/cpp/util/slice_test.cc
)
  android_add_test(cxx_slice_test)
  target_link_libraries(cxx_slice_test PRIVATE gmock_main ssl crypto)
  target_include_directories(cxx_slice_test PRIVATE ${_gRPC_ROOT})

  target_compile_definitions(cxx_slice_test PRIVATE -DPB_FIELD_16BIT)
  target_compile_definitions(cxx_slice_test PUBLIC  -DGRPC_ALLOW_EXCEPTIONS=0)

  target_include_directories(cxx_slice_test
  PRIVATE ${_gRPC_ROOT}
  PRIVATE ${_gRPC_ROOT}/include
  PRIVATE ${_gRPC_SSL_INCLUDE_DIR}
  PRIVATE ${_gRPC_BENCHMARK_INCLUDE_DIR}
  PRIVATE ${_gRPC_GFLAGS_INCLUDE_DIR}
  PRIVATE ${_gRPC_PROTOBUF_INCLUDE_DIR}
  PRIVATE ${_gRPC_NANOPB_INCLUDE_DIR}
  PRIVATE ${_gRPC_ADDRESS_SORTING_INCLUDE_DIR}
  PRIVATE ${_gRPC_GTEST_INCLUDE_DIR}
  PRIVATE ${_gRPC_PROTO_GENS_DIR}
)

  target_link_libraries(cxx_slice_test PRIVATE
  ${_gRPC_PROTOBUF_LIBRARIES}
  ${_gRPC_ALLTARGETS_LIBRARIES}
  grpc_test_util
  grpc++
  grpc
  gpr_test_util
  gpr
  ${_gRPC_GFLAGS_LIBRARIES}
)

    add_dependencies(cxx_slice_test project_benchmark project_gflags)

  set(cxx_string_ref_test_src
   ${_gRPC_ROOT}/test/cpp/util/string_ref_test.cc
)
  android_add_test(cxx_string_ref_test)
  target_link_libraries(cxx_string_ref_test PRIVATE gmock_main ssl crypto)
  target_include_directories(cxx_string_ref_test PRIVATE ${_gRPC_ROOT})

  target_compile_definitions(cxx_string_ref_test PRIVATE -DPB_FIELD_16BIT)
  target_compile_definitions(cxx_string_ref_test PUBLIC  -DGRPC_ALLOW_EXCEPTIONS=0)

  target_include_directories(cxx_string_ref_test
  PRIVATE ${_gRPC_ROOT}
  PRIVATE ${_gRPC_ROOT}/include
  PRIVATE ${_gRPC_SSL_INCLUDE_DIR}
  PRIVATE ${_gRPC_BENCHMARK_INCLUDE_DIR}
  PRIVATE ${_gRPC_GFLAGS_INCLUDE_DIR}
  PRIVATE ${_gRPC_PROTOBUF_INCLUDE_DIR}
  PRIVATE ${_gRPC_NANOPB_INCLUDE_DIR}
  PRIVATE ${_gRPC_ADDRESS_SORTING_INCLUDE_DIR}
  PRIVATE ${_gRPC_GTEST_INCLUDE_DIR}
  PRIVATE ${_gRPC_PROTO_GENS_DIR}
)

  target_link_libraries(cxx_string_ref_test PRIVATE
  ${_gRPC_PROTOBUF_LIBRARIES}
  ${_gRPC_ALLTARGETS_LIBRARIES}
  grpc++
  grpc
  ${_gRPC_GFLAGS_LIBRARIES}
)

    add_dependencies(cxx_string_ref_test project_benchmark project_gflags)

  set(cxx_time_test_src
   ${_gRPC_ROOT}/test/cpp/util/time_test.cc
)
  android_add_test(cxx_time_test)
  target_link_libraries(cxx_time_test PRIVATE gmock_main ssl crypto)
  target_include_directories(cxx_time_test PRIVATE ${_gRPC_ROOT})

  target_compile_definitions(cxx_time_test PRIVATE -DPB_FIELD_16BIT)
  target_compile_definitions(cxx_time_test PUBLIC  -DGRPC_ALLOW_EXCEPTIONS=0)

  target_include_directories(cxx_time_test
  PRIVATE ${_gRPC_ROOT}
  PRIVATE ${_gRPC_ROOT}/include
  PRIVATE ${_gRPC_SSL_INCLUDE_DIR}
  PRIVATE ${_gRPC_BENCHMARK_INCLUDE_DIR}
  PRIVATE ${_gRPC_GFLAGS_INCLUDE_DIR}
  PRIVATE ${_gRPC_PROTOBUF_INCLUDE_DIR}
  PRIVATE ${_gRPC_NANOPB_INCLUDE_DIR}
  PRIVATE ${_gRPC_ADDRESS_SORTING_INCLUDE_DIR}
  PRIVATE ${_gRPC_GTEST_INCLUDE_DIR}
  PRIVATE ${_gRPC_PROTO_GENS_DIR}
)

  target_link_libraries(cxx_time_test PRIVATE
  ${_gRPC_PROTOBUF_LIBRARIES}
  ${_gRPC_ALLTARGETS_LIBRARIES}
  grpc_test_util
  grpc++
  grpc
  gpr_test_util
  gpr
  ${_gRPC_GFLAGS_LIBRARIES}
)

    add_dependencies(cxx_time_test project_benchmark project_gflags)

  set(end2end_test_src
   ${_gRPC_ROOT}/test/cpp/end2end/end2end_test.cc
)
  android_add_test(end2end_test)
  target_link_libraries(end2end_test PRIVATE gmock_main ssl crypto)
  target_include_directories(end2end_test PRIVATE ${_gRPC_ROOT})

  target_compile_definitions(end2end_test PRIVATE -DPB_FIELD_16BIT)
  target_compile_definitions(end2end_test PUBLIC  -DGRPC_ALLOW_EXCEPTIONS=0)

  target_include_directories(end2end_test
  PRIVATE ${_gRPC_ROOT}
  PRIVATE ${_gRPC_ROOT}/include
  PRIVATE ${_gRPC_SSL_INCLUDE_DIR}
  PRIVATE ${_gRPC_BENCHMARK_INCLUDE_DIR}
  PRIVATE ${_gRPC_GFLAGS_INCLUDE_DIR}
  PRIVATE ${_gRPC_PROTOBUF_INCLUDE_DIR}
  PRIVATE ${_gRPC_NANOPB_INCLUDE_DIR}
  PRIVATE ${_gRPC_ADDRESS_SORTING_INCLUDE_DIR}
  PRIVATE ${_gRPC_GTEST_INCLUDE_DIR}
  PRIVATE ${_gRPC_PROTO_GENS_DIR}
)

  target_link_libraries(end2end_test PRIVATE
  ${_gRPC_PROTOBUF_LIBRARIES}
  ${_gRPC_ALLTARGETS_LIBRARIES}
  grpc++_test_util
  grpc_test_util
  grpc++
  grpc
  gpr_test_util
  gpr
  ${_gRPC_GFLAGS_LIBRARIES}
)

    add_dependencies(end2end_test project_benchmark project_gflags)

  set(exception_test_src
   ${_gRPC_ROOT}/test/cpp/end2end/exception_test.cc
)
  android_add_test(exception_test)
  target_link_libraries(exception_test PRIVATE gmock_main ssl crypto)
  target_include_directories(exception_test PRIVATE ${_gRPC_ROOT})

  target_compile_definitions(exception_test PRIVATE -DPB_FIELD_16BIT)
  target_compile_definitions(exception_test PUBLIC  -DGRPC_ALLOW_EXCEPTIONS=0)

  target_include_directories(exception_test
  PRIVATE ${_gRPC_ROOT}
  PRIVATE ${_gRPC_ROOT}/include
  PRIVATE ${_gRPC_SSL_INCLUDE_DIR}
  PRIVATE ${_gRPC_BENCHMARK_INCLUDE_DIR}
  PRIVATE ${_gRPC_GFLAGS_INCLUDE_DIR}
  PRIVATE ${_gRPC_PROTOBUF_INCLUDE_DIR}
  PRIVATE ${_gRPC_NANOPB_INCLUDE_DIR}
  PRIVATE ${_gRPC_ADDRESS_SORTING_INCLUDE_DIR}
  PRIVATE ${_gRPC_GTEST_INCLUDE_DIR}
  PRIVATE ${_gRPC_PROTO_GENS_DIR}
)

  target_link_libraries(exception_test PRIVATE
  ${_gRPC_PROTOBUF_LIBRARIES}
  ${_gRPC_ALLTARGETS_LIBRARIES}
  grpc++_test_util
  grpc_test_util
  grpc++
  grpc
  gpr_test_util
  gpr
  ${_gRPC_GFLAGS_LIBRARIES}
)

    add_dependencies(exception_test project_benchmark project_gflags)

  set(filter_end2end_test_src
   ${_gRPC_ROOT}/test/cpp/end2end/filter_end2end_test.cc
)
  android_add_test(filter_end2end_test)
  target_link_libraries(filter_end2end_test PRIVATE gmock_main ssl crypto)
  target_include_directories(filter_end2end_test PRIVATE ${_gRPC_ROOT})

  target_compile_definitions(filter_end2end_test PRIVATE -DPB_FIELD_16BIT)
  target_compile_definitions(filter_end2end_test PUBLIC  -DGRPC_ALLOW_EXCEPTIONS=0)

  target_include_directories(filter_end2end_test
  PRIVATE ${_gRPC_ROOT}
  PRIVATE ${_gRPC_ROOT}/include
  PRIVATE ${_gRPC_SSL_INCLUDE_DIR}
  PRIVATE ${_gRPC_BENCHMARK_INCLUDE_DIR}
  PRIVATE ${_gRPC_GFLAGS_INCLUDE_DIR}
  PRIVATE ${_gRPC_PROTOBUF_INCLUDE_DIR}
  PRIVATE ${_gRPC_NANOPB_INCLUDE_DIR}
  PRIVATE ${_gRPC_ADDRESS_SORTING_INCLUDE_DIR}
  PRIVATE ${_gRPC_GTEST_INCLUDE_DIR}
  PRIVATE ${_gRPC_PROTO_GENS_DIR}
)

  target_link_libraries(filter_end2end_test PRIVATE
  ${_gRPC_PROTOBUF_LIBRARIES}
  ${_gRPC_ALLTARGETS_LIBRARIES}
  grpc++_test_util
  grpc_test_util
  grpc++
  grpc
  gpr_test_util
  gpr
  ${_gRPC_GFLAGS_LIBRARIES}
)

    add_dependencies(filter_end2end_test project_benchmark project_gflags)

  set(generic_end2end_test_src
   ${_gRPC_ROOT}/test/cpp/end2end/generic_end2end_test.cc
)
  android_add_test(generic_end2end_test)
  target_link_libraries(generic_end2end_test PRIVATE gmock_main ssl crypto)
  target_include_directories(generic_end2end_test PRIVATE ${_gRPC_ROOT})

  target_compile_definitions(generic_end2end_test PRIVATE -DPB_FIELD_16BIT)
  target_compile_definitions(generic_end2end_test PUBLIC  -DGRPC_ALLOW_EXCEPTIONS=0)

  target_include_directories(generic_end2end_test
  PRIVATE ${_gRPC_ROOT}
  PRIVATE ${_gRPC_ROOT}/include
  PRIVATE ${_gRPC_SSL_INCLUDE_DIR}
  PRIVATE ${_gRPC_BENCHMARK_INCLUDE_DIR}
  PRIVATE ${_gRPC_GFLAGS_INCLUDE_DIR}
  PRIVATE ${_gRPC_PROTOBUF_INCLUDE_DIR}
  PRIVATE ${_gRPC_NANOPB_INCLUDE_DIR}
  PRIVATE ${_gRPC_ADDRESS_SORTING_INCLUDE_DIR}
  PRIVATE ${_gRPC_GTEST_INCLUDE_DIR}
  PRIVATE ${_gRPC_PROTO_GENS_DIR}
)

  target_link_libraries(generic_end2end_test PRIVATE
  ${_gRPC_PROTOBUF_LIBRARIES}
  ${_gRPC_ALLTARGETS_LIBRARIES}
  grpc++_test_util
  grpc_test_util
  grpc++
  grpc
  gpr_test_util
  gpr
  ${_gRPC_GFLAGS_LIBRARIES}
)

    add_dependencies(generic_end2end_test project_benchmark project_gflags)

  set(golden_file_test_src
          ${_gRPC_PROTO_GENS_DIR}/src/proto/grpc/testing/compiler_test.pb.cc
          ${_gRPC_PROTO_GENS_DIR}/src/proto/grpc/testing/compiler_test.grpc.pb.cc
          ${_gRPC_PROTO_GENS_DIR}/src/proto/grpc/testing/compiler_test.pb.h
          ${_gRPC_PROTO_GENS_DIR}/src/proto/grpc/testing/compiler_test.grpc.pb.h
   ${_gRPC_ROOT}/test/cpp/codegen/golden_file_test.cc
)
  android_add_test(golden_file_test)
  target_link_libraries(golden_file_test PRIVATE gmock_main ssl crypto)
  target_include_directories(golden_file_test PRIVATE ${_gRPC_ROOT})

  target_compile_definitions(golden_file_test PRIVATE -DPB_FIELD_16BIT)
  target_compile_definitions(golden_file_test PUBLIC  -DGRPC_ALLOW_EXCEPTIONS=0)
protobuf_generate_grpc_cpp(
  SOURCE_DIR ${_gRPC_ROOT}
  SOURCES ${_gRPC_ROOT}/src/proto/grpc/testing/compiler_test.proto
)

  target_include_directories(golden_file_test
  PRIVATE ${_gRPC_ROOT}
  PRIVATE ${_gRPC_ROOT}/include
  PRIVATE ${_gRPC_SSL_INCLUDE_DIR}
  PRIVATE ${_gRPC_BENCHMARK_INCLUDE_DIR}
  PRIVATE ${_gRPC_GFLAGS_INCLUDE_DIR}
  PRIVATE ${_gRPC_PROTOBUF_INCLUDE_DIR}
  PRIVATE ${_gRPC_NANOPB_INCLUDE_DIR}
  PRIVATE ${_gRPC_ADDRESS_SORTING_INCLUDE_DIR}
  PRIVATE ${_gRPC_GTEST_INCLUDE_DIR}
  PRIVATE ${_gRPC_PROTO_GENS_DIR}
)

  target_link_libraries(golden_file_test PRIVATE
  ${_gRPC_PROTOBUF_LIBRARIES}
  ${_gRPC_ALLTARGETS_LIBRARIES}
  grpc++
  grpc
  gpr
  ${_gRPC_GFLAGS_LIBRARIES}
)

    add_dependencies(golden_file_test project_benchmark project_gflags)

  set(grpc_alts_credentials_options_test_src
   ${_gRPC_ROOT}/test/core/security/grpc_alts_credentials_options_test.cc
)
  android_add_test(grpc_alts_credentials_options_test)
  target_link_libraries(grpc_alts_credentials_options_test PRIVATE gmock_main ssl crypto)
  target_include_directories(grpc_alts_credentials_options_test PRIVATE ${_gRPC_ROOT})

  target_compile_definitions(grpc_alts_credentials_options_test PRIVATE -DPB_FIELD_16BIT)
  target_compile_definitions(grpc_alts_credentials_options_test PUBLIC  -DGRPC_ALLOW_EXCEPTIONS=0)

  target_include_directories(grpc_alts_credentials_options_test
  PRIVATE ${_gRPC_ROOT}
  PRIVATE ${_gRPC_ROOT}/include
  PRIVATE ${_gRPC_SSL_INCLUDE_DIR}
  PRIVATE ${_gRPC_BENCHMARK_INCLUDE_DIR}
  PRIVATE ${_gRPC_GFLAGS_INCLUDE_DIR}
  PRIVATE ${_gRPC_PROTOBUF_INCLUDE_DIR}
  PRIVATE ${_gRPC_NANOPB_INCLUDE_DIR}
  PRIVATE ${_gRPC_ADDRESS_SORTING_INCLUDE_DIR}
  PRIVATE ${_gRPC_GTEST_INCLUDE_DIR}
  PRIVATE ${_gRPC_PROTO_GENS_DIR}
)

  target_link_libraries(grpc_alts_credentials_options_test PRIVATE
  ${_gRPC_PROTOBUF_LIBRARIES}
  ${_gRPC_ALLTARGETS_LIBRARIES}
  grpc
  gpr
  ${_gRPC_GFLAGS_LIBRARIES}
)

    add_dependencies(grpc_alts_credentials_options_test project_benchmark project_gflags)

  set(grpc_cli_src
   ${_gRPC_ROOT}/test/cpp/util/grpc_cli.cc
)
  android_add_test(grpc_cli)
  target_link_libraries(grpc_cli PRIVATE gmock_main ssl crypto)
  target_include_directories(grpc_cli PRIVATE ${_gRPC_ROOT})

  target_compile_definitions(grpc_cli PRIVATE -DPB_FIELD_16BIT)
  target_compile_definitions(grpc_cli PUBLIC  -DGRPC_ALLOW_EXCEPTIONS=0)

  target_include_directories(grpc_cli
  PRIVATE ${_gRPC_ROOT}
  PRIVATE ${_gRPC_ROOT}/include
  PRIVATE ${_gRPC_SSL_INCLUDE_DIR}
  PRIVATE ${_gRPC_BENCHMARK_INCLUDE_DIR}
  PRIVATE ${_gRPC_GFLAGS_INCLUDE_DIR}
  PRIVATE ${_gRPC_PROTOBUF_INCLUDE_DIR}
  PRIVATE ${_gRPC_NANOPB_INCLUDE_DIR}
  PRIVATE ${_gRPC_ADDRESS_SORTING_INCLUDE_DIR}
  PRIVATE ${_gRPC_GTEST_INCLUDE_DIR}
  PRIVATE ${_gRPC_PROTO_GENS_DIR}
)

  target_link_libraries(grpc_cli PRIVATE
  ${_gRPC_PROTOBUF_LIBRARIES}
  ${_gRPC_ALLTARGETS_LIBRARIES}
  grpc_cli_libs
  grpc++_proto_reflection_desc_db
  grpc++
  grpc
  gpr
  grpc++_test_config
  ${_gRPC_GFLAGS_LIBRARIES}
)

    add_dependencies(grpc_cli project_benchmark project_gflags)

  set(grpc_linux_system_roots_test_src
   ${_gRPC_ROOT}/test/core/security/linux_system_roots_test.cc
)
  android_add_test(grpc_linux_system_roots_test)
  target_link_libraries(grpc_linux_system_roots_test PRIVATE gmock_main ssl crypto)
  target_include_directories(grpc_linux_system_roots_test PRIVATE ${_gRPC_ROOT})

  target_compile_definitions(grpc_linux_system_roots_test PRIVATE -DPB_FIELD_16BIT)
  target_compile_definitions(grpc_linux_system_roots_test PUBLIC  -DGRPC_ALLOW_EXCEPTIONS=0)

  target_include_directories(grpc_linux_system_roots_test
  PRIVATE ${_gRPC_ROOT}
  PRIVATE ${_gRPC_ROOT}/include
  PRIVATE ${_gRPC_SSL_INCLUDE_DIR}
  PRIVATE ${_gRPC_BENCHMARK_INCLUDE_DIR}
  PRIVATE ${_gRPC_GFLAGS_INCLUDE_DIR}
  PRIVATE ${_gRPC_PROTOBUF_INCLUDE_DIR}
  PRIVATE ${_gRPC_NANOPB_INCLUDE_DIR}
  PRIVATE ${_gRPC_ADDRESS_SORTING_INCLUDE_DIR}
  PRIVATE ${_gRPC_GTEST_INCLUDE_DIR}
  PRIVATE ${_gRPC_PROTO_GENS_DIR}
)

  target_link_libraries(grpc_linux_system_roots_test PRIVATE
  ${_gRPC_PROTOBUF_LIBRARIES}
  ${_gRPC_ALLTARGETS_LIBRARIES}
  grpc_test_util
  grpc
  gpr_test_util
  gpr
  ${_gRPC_GFLAGS_LIBRARIES}
)

    add_dependencies(grpc_linux_system_roots_test project_benchmark project_gflags)

  set(grpclb_api_test_src
          ${_gRPC_PROTO_GENS_DIR}/src/proto/grpc/lb/v1/load_balancer.pb.cc
          ${_gRPC_PROTO_GENS_DIR}/src/proto/grpc/lb/v1/load_balancer.grpc.pb.cc
          ${_gRPC_PROTO_GENS_DIR}/src/proto/grpc/lb/v1/load_balancer.pb.h
          ${_gRPC_PROTO_GENS_DIR}/src/proto/grpc/lb/v1/load_balancer.grpc.pb.h
   ${_gRPC_ROOT}/test/cpp/grpclb/grpclb_api_test.cc
)
  android_add_test(grpclb_api_test)
  target_link_libraries(grpclb_api_test PRIVATE gmock_main ssl crypto)
  target_include_directories(grpclb_api_test PRIVATE ${_gRPC_ROOT})

  target_compile_definitions(grpclb_api_test PRIVATE -DPB_FIELD_16BIT)
  target_compile_definitions(grpclb_api_test PUBLIC  -DGRPC_ALLOW_EXCEPTIONS=0)
protobuf_generate_grpc_cpp(
  SOURCE_DIR ${_gRPC_ROOT}
  SOURCES ${_gRPC_ROOT}/src/proto/grpc/lb/v1/load_balancer.proto
)

  target_include_directories(grpclb_api_test
  PRIVATE ${_gRPC_ROOT}
  PRIVATE ${_gRPC_ROOT}/include
  PRIVATE ${_gRPC_SSL_INCLUDE_DIR}
  PRIVATE ${_gRPC_BENCHMARK_INCLUDE_DIR}
  PRIVATE ${_gRPC_GFLAGS_INCLUDE_DIR}
  PRIVATE ${_gRPC_PROTOBUF_INCLUDE_DIR}
  PRIVATE ${_gRPC_NANOPB_INCLUDE_DIR}
  PRIVATE ${_gRPC_ADDRESS_SORTING_INCLUDE_DIR}
  PRIVATE ${_gRPC_GTEST_INCLUDE_DIR}
  PRIVATE ${_gRPC_PROTO_GENS_DIR}
)

  target_link_libraries(grpclb_api_test PRIVATE
  ${_gRPC_PROTOBUF_LIBRARIES}
  ${_gRPC_ALLTARGETS_LIBRARIES}
  grpc++_test_util
  grpc_test_util
  grpc++
  grpc
  ${_gRPC_GFLAGS_LIBRARIES}
)

    add_dependencies(grpclb_api_test project_benchmark project_gflags)

  set(grpclb_end2end_test_src
          ${_gRPC_PROTO_GENS_DIR}/src/proto/grpc/lb/v1/load_balancer.pb.cc
          ${_gRPC_PROTO_GENS_DIR}/src/proto/grpc/lb/v1/load_balancer.grpc.pb.cc
          ${_gRPC_PROTO_GENS_DIR}/src/proto/grpc/lb/v1/load_balancer.pb.h
          ${_gRPC_PROTO_GENS_DIR}/src/proto/grpc/lb/v1/load_balancer.grpc.pb.h
   ${_gRPC_ROOT}/test/cpp/end2end/grpclb_end2end_test.cc
)
  android_add_test(grpclb_end2end_test)
  target_link_libraries(grpclb_end2end_test PRIVATE gmock_main ssl crypto)
  target_include_directories(grpclb_end2end_test PRIVATE ${_gRPC_ROOT})

  target_compile_definitions(grpclb_end2end_test PRIVATE -DPB_FIELD_16BIT)
  target_compile_definitions(grpclb_end2end_test PUBLIC  -DGRPC_ALLOW_EXCEPTIONS=0)
protobuf_generate_grpc_cpp(
  SOURCE_DIR ${_gRPC_ROOT}
  SOURCES ${_gRPC_ROOT}/src/proto/grpc/lb/v1/load_balancer.proto
)

  target_include_directories(grpclb_end2end_test
  PRIVATE ${_gRPC_ROOT}
  PRIVATE ${_gRPC_ROOT}/include
  PRIVATE ${_gRPC_SSL_INCLUDE_DIR}
  PRIVATE ${_gRPC_BENCHMARK_INCLUDE_DIR}
  PRIVATE ${_gRPC_GFLAGS_INCLUDE_DIR}
  PRIVATE ${_gRPC_PROTOBUF_INCLUDE_DIR}
  PRIVATE ${_gRPC_NANOPB_INCLUDE_DIR}
  PRIVATE ${_gRPC_ADDRESS_SORTING_INCLUDE_DIR}
  PRIVATE ${_gRPC_GTEST_INCLUDE_DIR}
  PRIVATE ${_gRPC_PROTO_GENS_DIR}
)

  target_link_libraries(grpclb_end2end_test PRIVATE
  ${_gRPC_PROTOBUF_LIBRARIES}
  ${_gRPC_ALLTARGETS_LIBRARIES}
  grpc++_test_util
  grpc_test_util
  grpc++
  grpc
  gpr_test_util
  gpr
  ${_gRPC_GFLAGS_LIBRARIES}
)

    add_dependencies(grpclb_end2end_test project_benchmark project_gflags)

  set(h2_ssl_cert_test_src
   ${_gRPC_ROOT}/test/core/end2end/h2_ssl_cert_test.cc
)
  android_add_test(h2_ssl_cert_test)
  target_link_libraries(h2_ssl_cert_test PRIVATE gmock_main ssl crypto)
  target_include_directories(h2_ssl_cert_test PRIVATE ${_gRPC_ROOT})

  target_compile_definitions(h2_ssl_cert_test PRIVATE -DPB_FIELD_16BIT)
  target_compile_definitions(h2_ssl_cert_test PUBLIC  -DGRPC_ALLOW_EXCEPTIONS=0)

  target_include_directories(h2_ssl_cert_test
  PRIVATE ${_gRPC_ROOT}
  PRIVATE ${_gRPC_ROOT}/include
  PRIVATE ${_gRPC_SSL_INCLUDE_DIR}
  PRIVATE ${_gRPC_BENCHMARK_INCLUDE_DIR}
  PRIVATE ${_gRPC_GFLAGS_INCLUDE_DIR}
  PRIVATE ${_gRPC_PROTOBUF_INCLUDE_DIR}
  PRIVATE ${_gRPC_NANOPB_INCLUDE_DIR}
  PRIVATE ${_gRPC_ADDRESS_SORTING_INCLUDE_DIR}
  PRIVATE ${_gRPC_GTEST_INCLUDE_DIR}
  PRIVATE ${_gRPC_PROTO_GENS_DIR}
)

  target_link_libraries(h2_ssl_cert_test PRIVATE
  ${_gRPC_PROTOBUF_LIBRARIES}
  ${_gRPC_ALLTARGETS_LIBRARIES}
  grpc_test_util
  grpc++
  grpc
  gpr_test_util
  gpr
  ${_gRPC_GFLAGS_LIBRARIES}
)

    add_dependencies(h2_ssl_cert_test project_benchmark project_gflags)

  set(h2_ssl_session_reuse_test_src
   ${_gRPC_ROOT}/test/core/end2end/h2_ssl_session_reuse_test.cc
)
  android_add_test(h2_ssl_session_reuse_test)
  target_link_libraries(h2_ssl_session_reuse_test PRIVATE gmock_main ssl crypto)
  target_include_directories(h2_ssl_session_reuse_test PRIVATE ${_gRPC_ROOT})

  target_compile_definitions(h2_ssl_session_reuse_test PRIVATE -DPB_FIELD_16BIT)
  target_compile_definitions(h2_ssl_session_reuse_test PUBLIC  -DGRPC_ALLOW_EXCEPTIONS=0)

  target_include_directories(h2_ssl_session_reuse_test
  PRIVATE ${_gRPC_ROOT}
  PRIVATE ${_gRPC_ROOT}/include
  PRIVATE ${_gRPC_SSL_INCLUDE_DIR}
  PRIVATE ${_gRPC_BENCHMARK_INCLUDE_DIR}
  PRIVATE ${_gRPC_GFLAGS_INCLUDE_DIR}
  PRIVATE ${_gRPC_PROTOBUF_INCLUDE_DIR}
  PRIVATE ${_gRPC_NANOPB_INCLUDE_DIR}
  PRIVATE ${_gRPC_ADDRESS_SORTING_INCLUDE_DIR}
  PRIVATE ${_gRPC_GTEST_INCLUDE_DIR}
  PRIVATE ${_gRPC_PROTO_GENS_DIR}
)

  target_link_libraries(h2_ssl_session_reuse_test PRIVATE
  ${_gRPC_PROTOBUF_LIBRARIES}
  ${_gRPC_ALLTARGETS_LIBRARIES}
  grpc_test_util
  grpc++
  grpc
  gpr_test_util
  gpr
  ${_gRPC_GFLAGS_LIBRARIES}
)

    add_dependencies(h2_ssl_session_reuse_test project_benchmark project_gflags)

  set(health_service_end2end_test_src
   ${_gRPC_ROOT}/test/cpp/end2end/health_service_end2end_test.cc
)
  android_add_test(health_service_end2end_test)
  target_link_libraries(health_service_end2end_test PRIVATE gmock_main ssl crypto)
  target_include_directories(health_service_end2end_test PRIVATE ${_gRPC_ROOT})

  target_compile_definitions(health_service_end2end_test PRIVATE -DPB_FIELD_16BIT)
  target_compile_definitions(health_service_end2end_test PUBLIC  -DGRPC_ALLOW_EXCEPTIONS=0)

  target_include_directories(health_service_end2end_test
  PRIVATE ${_gRPC_ROOT}
  PRIVATE ${_gRPC_ROOT}/include
  PRIVATE ${_gRPC_SSL_INCLUDE_DIR}
  PRIVATE ${_gRPC_BENCHMARK_INCLUDE_DIR}
  PRIVATE ${_gRPC_GFLAGS_INCLUDE_DIR}
  PRIVATE ${_gRPC_PROTOBUF_INCLUDE_DIR}
  PRIVATE ${_gRPC_NANOPB_INCLUDE_DIR}
  PRIVATE ${_gRPC_ADDRESS_SORTING_INCLUDE_DIR}
  PRIVATE ${_gRPC_GTEST_INCLUDE_DIR}
  PRIVATE ${_gRPC_PROTO_GENS_DIR}
)

  target_link_libraries(health_service_end2end_test PRIVATE
  ${_gRPC_PROTOBUF_LIBRARIES}
  ${_gRPC_ALLTARGETS_LIBRARIES}
  grpc++_test_util
  grpc_test_util
  grpc++
  grpc
  gpr_test_util
  gpr
  ${_gRPC_GFLAGS_LIBRARIES}
)

    add_dependencies(health_service_end2end_test project_benchmark project_gflags)
if(_gRPC_PLATFORM_LINUX OR _gRPC_PLATFORM_MAC OR _gRPC_PLATFORM_POSIX)


endif()

  set(hybrid_end2end_test_src
   ${_gRPC_ROOT}/test/cpp/end2end/hybrid_end2end_test.cc
)
  android_add_test(hybrid_end2end_test)
  target_link_libraries(hybrid_end2end_test PRIVATE gmock_main ssl crypto)
  target_include_directories(hybrid_end2end_test PRIVATE ${_gRPC_ROOT})

  target_compile_definitions(hybrid_end2end_test PRIVATE -DPB_FIELD_16BIT)
  target_compile_definitions(hybrid_end2end_test PUBLIC  -DGRPC_ALLOW_EXCEPTIONS=0)

  target_include_directories(hybrid_end2end_test
  PRIVATE ${_gRPC_ROOT}
  PRIVATE ${_gRPC_ROOT}/include
  PRIVATE ${_gRPC_SSL_INCLUDE_DIR}
  PRIVATE ${_gRPC_BENCHMARK_INCLUDE_DIR}
  PRIVATE ${_gRPC_GFLAGS_INCLUDE_DIR}
  PRIVATE ${_gRPC_PROTOBUF_INCLUDE_DIR}
  PRIVATE ${_gRPC_NANOPB_INCLUDE_DIR}
  PRIVATE ${_gRPC_ADDRESS_SORTING_INCLUDE_DIR}
  PRIVATE ${_gRPC_GTEST_INCLUDE_DIR}
  PRIVATE ${_gRPC_PROTO_GENS_DIR}
)

  target_link_libraries(hybrid_end2end_test PRIVATE
  ${_gRPC_PROTOBUF_LIBRARIES}
  ${_gRPC_ALLTARGETS_LIBRARIES}
  grpc++_test_util
  grpc_test_util
  grpc++
  grpc
  gpr_test_util
  gpr
  ${_gRPC_GFLAGS_LIBRARIES}
)

    add_dependencies(hybrid_end2end_test project_benchmark project_gflags)

  set(inlined_vector_test_src
   ${_gRPC_ROOT}/test/core/gprpp/inlined_vector_test.cc
)
  android_add_test(inlined_vector_test)
  target_link_libraries(inlined_vector_test PRIVATE gmock_main ssl crypto)
  target_include_directories(inlined_vector_test PRIVATE ${_gRPC_ROOT})

  target_compile_definitions(inlined_vector_test PRIVATE -DPB_FIELD_16BIT)
  target_compile_definitions(inlined_vector_test PUBLIC  -DGRPC_ALLOW_EXCEPTIONS=0)

  target_include_directories(inlined_vector_test
  PRIVATE ${_gRPC_ROOT}
  PRIVATE ${_gRPC_ROOT}/include
  PRIVATE ${_gRPC_SSL_INCLUDE_DIR}
  PRIVATE ${_gRPC_BENCHMARK_INCLUDE_DIR}
  PRIVATE ${_gRPC_GFLAGS_INCLUDE_DIR}
  PRIVATE ${_gRPC_PROTOBUF_INCLUDE_DIR}
  PRIVATE ${_gRPC_NANOPB_INCLUDE_DIR}
  PRIVATE ${_gRPC_ADDRESS_SORTING_INCLUDE_DIR}
  PRIVATE ${_gRPC_GTEST_INCLUDE_DIR}
  PRIVATE ${_gRPC_PROTO_GENS_DIR}
)

  target_link_libraries(inlined_vector_test PRIVATE
  ${_gRPC_PROTOBUF_LIBRARIES}
  ${_gRPC_ALLTARGETS_LIBRARIES}
  grpc_test_util
  grpc++
  grpc
  gpr_test_util
  gpr
  ${_gRPC_GFLAGS_LIBRARIES}
)

    add_dependencies(inlined_vector_test project_benchmark project_gflags)
if(_gRPC_PLATFORM_LINUX OR _gRPC_PLATFORM_MAC OR _gRPC_PLATFORM_POSIX)

  set(inproc_sync_unary_ping_pong_test_src
   ${_gRPC_ROOT}/test/cpp/qps/inproc_sync_unary_ping_pong_test.cc
)
  android_add_test(inproc_sync_unary_ping_pong_test)
  target_link_libraries(inproc_sync_unary_ping_pong_test PRIVATE gmock_main ssl crypto)
  target_include_directories(inproc_sync_unary_ping_pong_test PRIVATE ${_gRPC_ROOT})

  target_compile_definitions(inproc_sync_unary_ping_pong_test PRIVATE -DPB_FIELD_16BIT)
  target_compile_definitions(inproc_sync_unary_ping_pong_test PUBLIC  -DGRPC_ALLOW_EXCEPTIONS=0)

  target_include_directories(inproc_sync_unary_ping_pong_test
  PRIVATE ${_gRPC_ROOT}
  PRIVATE ${_gRPC_ROOT}/include
  PRIVATE ${_gRPC_SSL_INCLUDE_DIR}
  PRIVATE ${_gRPC_BENCHMARK_INCLUDE_DIR}
  PRIVATE ${_gRPC_GFLAGS_INCLUDE_DIR}
  PRIVATE ${_gRPC_PROTOBUF_INCLUDE_DIR}
  PRIVATE ${_gRPC_NANOPB_INCLUDE_DIR}
  PRIVATE ${_gRPC_ADDRESS_SORTING_INCLUDE_DIR}
  PRIVATE ${_gRPC_GTEST_INCLUDE_DIR}
  PRIVATE ${_gRPC_PROTO_GENS_DIR}
)

  target_link_libraries(inproc_sync_unary_ping_pong_test PRIVATE
  ${_gRPC_PROTOBUF_LIBRARIES}
  ${_gRPC_ALLTARGETS_LIBRARIES}
  qps
  grpc++_core_stats
  grpc++_test_util
  grpc_test_util
  grpc++
  grpc
  gpr_test_util
  gpr
  grpc++_test_config
  ${_gRPC_GFLAGS_LIBRARIES}
)

    add_dependencies(inproc_sync_unary_ping_pong_test project_benchmark project_gflags)
endif()
if(_gRPC_PLATFORM_LINUX OR _gRPC_PLATFORM_MAC OR _gRPC_PLATFORM_POSIX)


endif()
if(_gRPC_PLATFORM_LINUX OR _gRPC_PLATFORM_MAC OR _gRPC_PLATFORM_POSIX)


endif()
if(_gRPC_PLATFORM_LINUX OR _gRPC_PLATFORM_MAC OR _gRPC_PLATFORM_POSIX)

  set(interop_test_src
   ${_gRPC_ROOT}/test/cpp/interop/interop_test.cc
)
  android_add_test(interop_test)
  target_link_libraries(interop_test PRIVATE gmock_main ssl crypto)
  target_include_directories(interop_test PRIVATE ${_gRPC_ROOT})

  target_compile_definitions(interop_test PRIVATE -DPB_FIELD_16BIT)
  target_compile_definitions(interop_test PUBLIC  -DGRPC_ALLOW_EXCEPTIONS=0)

  target_include_directories(interop_test
  PRIVATE ${_gRPC_ROOT}
  PRIVATE ${_gRPC_ROOT}/include
  PRIVATE ${_gRPC_SSL_INCLUDE_DIR}
  PRIVATE ${_gRPC_BENCHMARK_INCLUDE_DIR}
  PRIVATE ${_gRPC_GFLAGS_INCLUDE_DIR}
  PRIVATE ${_gRPC_PROTOBUF_INCLUDE_DIR}
  PRIVATE ${_gRPC_NANOPB_INCLUDE_DIR}
  PRIVATE ${_gRPC_ADDRESS_SORTING_INCLUDE_DIR}
  PRIVATE ${_gRPC_GTEST_INCLUDE_DIR}
  PRIVATE ${_gRPC_PROTO_GENS_DIR}
)

  target_link_libraries(interop_test PRIVATE
  ${_gRPC_PROTOBUF_LIBRARIES}
  ${_gRPC_ALLTARGETS_LIBRARIES}
  grpc_test_util
  grpc
  gpr_test_util
  gpr
  grpc++_test_config
  ${_gRPC_GFLAGS_LIBRARIES}
)

    add_dependencies(interop_test project_benchmark project_gflags)
endif()
if(_gRPC_PLATFORM_LINUX OR _gRPC_PLATFORM_MAC OR _gRPC_PLATFORM_POSIX)

  set(json_run_localhost_src
   ${_gRPC_ROOT}/test/cpp/qps/json_run_localhost.cc
)
  android_add_test(json_run_localhost)
  target_link_libraries(json_run_localhost PRIVATE gmock_main ssl crypto)
  target_include_directories(json_run_localhost PRIVATE ${_gRPC_ROOT})

  target_compile_definitions(json_run_localhost PRIVATE -DPB_FIELD_16BIT)
  target_compile_definitions(json_run_localhost PUBLIC  -DGRPC_ALLOW_EXCEPTIONS=0)

  target_include_directories(json_run_localhost
  PRIVATE ${_gRPC_ROOT}
  PRIVATE ${_gRPC_ROOT}/include
  PRIVATE ${_gRPC_SSL_INCLUDE_DIR}
  PRIVATE ${_gRPC_BENCHMARK_INCLUDE_DIR}
  PRIVATE ${_gRPC_GFLAGS_INCLUDE_DIR}
  PRIVATE ${_gRPC_PROTOBUF_INCLUDE_DIR}
  PRIVATE ${_gRPC_NANOPB_INCLUDE_DIR}
  PRIVATE ${_gRPC_ADDRESS_SORTING_INCLUDE_DIR}
  PRIVATE ${_gRPC_GTEST_INCLUDE_DIR}
  PRIVATE ${_gRPC_PROTO_GENS_DIR}
)

  target_link_libraries(json_run_localhost PRIVATE
  ${_gRPC_PROTOBUF_LIBRARIES}
  ${_gRPC_ALLTARGETS_LIBRARIES}
  grpc++_test_util
  grpc_test_util
  grpc++
  grpc
  gpr_test_util
  gpr
  grpc++_test_config
  ${_gRPC_GFLAGS_LIBRARIES}
)

    add_dependencies(json_run_localhost project_benchmark project_gflags)
endif()

  set(memory_test_src
   ${_gRPC_ROOT}/test/core/gprpp/memory_test.cc
)
  android_add_test(memory_test)
  target_link_libraries(memory_test PRIVATE gmock_main ssl crypto)
  target_include_directories(memory_test PRIVATE ${_gRPC_ROOT})

  target_compile_definitions(memory_test PRIVATE -DPB_FIELD_16BIT)
  target_compile_definitions(memory_test PUBLIC  -DGRPC_ALLOW_EXCEPTIONS=0)

  target_include_directories(memory_test
  PRIVATE ${_gRPC_ROOT}
  PRIVATE ${_gRPC_ROOT}/include
  PRIVATE ${_gRPC_SSL_INCLUDE_DIR}
  PRIVATE ${_gRPC_BENCHMARK_INCLUDE_DIR}
  PRIVATE ${_gRPC_GFLAGS_INCLUDE_DIR}
  PRIVATE ${_gRPC_PROTOBUF_INCLUDE_DIR}
  PRIVATE ${_gRPC_NANOPB_INCLUDE_DIR}
  PRIVATE ${_gRPC_ADDRESS_SORTING_INCLUDE_DIR}
  PRIVATE ${_gRPC_GTEST_INCLUDE_DIR}
  PRIVATE ${_gRPC_PROTO_GENS_DIR}
)

  target_link_libraries(memory_test PRIVATE
  ${_gRPC_PROTOBUF_LIBRARIES}
  ${_gRPC_ALLTARGETS_LIBRARIES}
  grpc_test_util
  grpc++
  grpc
  gpr_test_util
  gpr
  ${_gRPC_GFLAGS_LIBRARIES}
)

    add_dependencies(memory_test project_benchmark project_gflags)

  set(metrics_client_src
          ${_gRPC_PROTO_GENS_DIR}/src/proto/grpc/testing/metrics.pb.cc
          ${_gRPC_PROTO_GENS_DIR}/src/proto/grpc/testing/metrics.grpc.pb.cc
          ${_gRPC_PROTO_GENS_DIR}/src/proto/grpc/testing/metrics.pb.h
          ${_gRPC_PROTO_GENS_DIR}/src/proto/grpc/testing/metrics.grpc.pb.h
   ${_gRPC_ROOT}/test/cpp/interop/metrics_client.cc
)
  android_add_test(metrics_client)
  target_link_libraries(metrics_client PRIVATE gmock_main ssl crypto)
  target_include_directories(metrics_client PRIVATE ${_gRPC_ROOT})

  target_compile_definitions(metrics_client PRIVATE -DPB_FIELD_16BIT)
  target_compile_definitions(metrics_client PUBLIC  -DGRPC_ALLOW_EXCEPTIONS=0)
protobuf_generate_grpc_cpp(
  SOURCE_DIR ${_gRPC_ROOT}
  SOURCES ${_gRPC_ROOT}/src/proto/grpc/testing/metrics.proto
)

  target_include_directories(metrics_client
  PRIVATE ${_gRPC_ROOT}
  PRIVATE ${_gRPC_ROOT}/include
  PRIVATE ${_gRPC_SSL_INCLUDE_DIR}
  PRIVATE ${_gRPC_BENCHMARK_INCLUDE_DIR}
  PRIVATE ${_gRPC_GFLAGS_INCLUDE_DIR}
  PRIVATE ${_gRPC_PROTOBUF_INCLUDE_DIR}
  PRIVATE ${_gRPC_NANOPB_INCLUDE_DIR}
  PRIVATE ${_gRPC_ADDRESS_SORTING_INCLUDE_DIR}
  PRIVATE ${_gRPC_GTEST_INCLUDE_DIR}
  PRIVATE ${_gRPC_PROTO_GENS_DIR}
)

  target_link_libraries(metrics_client PRIVATE
  ${_gRPC_PROTOBUF_LIBRARIES}
  ${_gRPC_ALLTARGETS_LIBRARIES}
  grpc++
  grpc
  gpr
  grpc++_test_config
  ${_gRPC_GFLAGS_LIBRARIES}
)

    add_dependencies(metrics_client project_benchmark project_gflags)

  set(mock_test_src
   ${_gRPC_ROOT}/test/cpp/end2end/mock_test.cc
)
  android_add_test(mock_test)
  target_link_libraries(mock_test PRIVATE gmock_main ssl crypto)
  target_include_directories(mock_test PRIVATE ${_gRPC_ROOT})

  target_compile_definitions(mock_test PRIVATE -DPB_FIELD_16BIT)
  target_compile_definitions(mock_test PUBLIC  -DGRPC_ALLOW_EXCEPTIONS=0)

  target_include_directories(mock_test
  PRIVATE ${_gRPC_ROOT}
  PRIVATE ${_gRPC_ROOT}/include
  PRIVATE ${_gRPC_SSL_INCLUDE_DIR}
  PRIVATE ${_gRPC_BENCHMARK_INCLUDE_DIR}
  PRIVATE ${_gRPC_GFLAGS_INCLUDE_DIR}
  PRIVATE ${_gRPC_PROTOBUF_INCLUDE_DIR}
  PRIVATE ${_gRPC_NANOPB_INCLUDE_DIR}
  PRIVATE ${_gRPC_ADDRESS_SORTING_INCLUDE_DIR}
  PRIVATE ${_gRPC_GTEST_INCLUDE_DIR}
  PRIVATE ${_gRPC_PROTO_GENS_DIR}
)

  target_link_libraries(mock_test PRIVATE
  ${_gRPC_PROTOBUF_LIBRARIES}
  ${_gRPC_ALLTARGETS_LIBRARIES}
  grpc++_test_util
  grpc_test_util
  grpc++
  grpc
  gpr_test_util
  gpr
  ${_gRPC_GFLAGS_LIBRARIES}
)

    add_dependencies(mock_test project_benchmark project_gflags)

  set(nonblocking_test_src
   ${_gRPC_ROOT}/test/cpp/end2end/nonblocking_test.cc
)
  android_add_test(nonblocking_test)
  target_link_libraries(nonblocking_test PRIVATE gmock_main ssl crypto)
  target_include_directories(nonblocking_test PRIVATE ${_gRPC_ROOT})

  target_compile_definitions(nonblocking_test PRIVATE -DPB_FIELD_16BIT)
  target_compile_definitions(nonblocking_test PUBLIC  -DGRPC_ALLOW_EXCEPTIONS=0)

  target_include_directories(nonblocking_test
  PRIVATE ${_gRPC_ROOT}
  PRIVATE ${_gRPC_ROOT}/include
  PRIVATE ${_gRPC_SSL_INCLUDE_DIR}
  PRIVATE ${_gRPC_BENCHMARK_INCLUDE_DIR}
  PRIVATE ${_gRPC_GFLAGS_INCLUDE_DIR}
  PRIVATE ${_gRPC_PROTOBUF_INCLUDE_DIR}
  PRIVATE ${_gRPC_NANOPB_INCLUDE_DIR}
  PRIVATE ${_gRPC_ADDRESS_SORTING_INCLUDE_DIR}
  PRIVATE ${_gRPC_GTEST_INCLUDE_DIR}
  PRIVATE ${_gRPC_PROTO_GENS_DIR}
)

  target_link_libraries(nonblocking_test PRIVATE
  ${_gRPC_PROTOBUF_LIBRARIES}
  ${_gRPC_ALLTARGETS_LIBRARIES}
  grpc++_test_util
  grpc_test_util
  grpc++
  grpc
  gpr_test_util
  gpr
  ${_gRPC_GFLAGS_LIBRARIES}
)

    add_dependencies(nonblocking_test project_benchmark project_gflags)

  set(noop-benchmark_src
   ${_gRPC_ROOT}/test/cpp/microbenchmarks/noop-benchmark.cc
)
  android_add_test(noop-benchmark)
  target_link_libraries(noop-benchmark PRIVATE gmock_main ssl crypto)
  target_include_directories(noop-benchmark PRIVATE ${_gRPC_ROOT})

  target_compile_definitions(noop-benchmark PRIVATE -DPB_FIELD_16BIT)
  target_compile_definitions(noop-benchmark PUBLIC  -DGRPC_ALLOW_EXCEPTIONS=0)

  target_include_directories(noop-benchmark
  PRIVATE ${_gRPC_ROOT}
  PRIVATE ${_gRPC_ROOT}/include
  PRIVATE ${_gRPC_SSL_INCLUDE_DIR}
  PRIVATE ${_gRPC_BENCHMARK_INCLUDE_DIR}
  PRIVATE ${_gRPC_GFLAGS_INCLUDE_DIR}
  PRIVATE ${_gRPC_PROTOBUF_INCLUDE_DIR}
  PRIVATE ${_gRPC_NANOPB_INCLUDE_DIR}
  PRIVATE ${_gRPC_ADDRESS_SORTING_INCLUDE_DIR}
  PRIVATE ${_gRPC_GTEST_INCLUDE_DIR}
  PRIVATE ${_gRPC_PROTO_GENS_DIR}
)

  target_link_libraries(noop-benchmark PRIVATE
  ${_gRPC_PROTOBUF_LIBRARIES}
  ${_gRPC_ALLTARGETS_LIBRARIES}
  ${_gRPC_BENCHMARK_LIBRARIES}
  ${_gRPC_GFLAGS_LIBRARIES}
)

    add_dependencies(noop-benchmark project_benchmark project_gflags)

  set(orphanable_test_src
   ${_gRPC_ROOT}/test/core/gprpp/orphanable_test.cc
)
  android_add_test(orphanable_test)
  target_link_libraries(orphanable_test PRIVATE gmock_main ssl crypto)
  target_include_directories(orphanable_test PRIVATE ${_gRPC_ROOT})

  target_compile_definitions(orphanable_test PRIVATE -DPB_FIELD_16BIT)
  target_compile_definitions(orphanable_test PUBLIC  -DGRPC_ALLOW_EXCEPTIONS=0)

  target_include_directories(orphanable_test
  PRIVATE ${_gRPC_ROOT}
  PRIVATE ${_gRPC_ROOT}/include
  PRIVATE ${_gRPC_SSL_INCLUDE_DIR}
  PRIVATE ${_gRPC_BENCHMARK_INCLUDE_DIR}
  PRIVATE ${_gRPC_GFLAGS_INCLUDE_DIR}
  PRIVATE ${_gRPC_PROTOBUF_INCLUDE_DIR}
  PRIVATE ${_gRPC_NANOPB_INCLUDE_DIR}
  PRIVATE ${_gRPC_ADDRESS_SORTING_INCLUDE_DIR}
  PRIVATE ${_gRPC_GTEST_INCLUDE_DIR}
  PRIVATE ${_gRPC_PROTO_GENS_DIR}
)

  target_link_libraries(orphanable_test PRIVATE
  ${_gRPC_PROTOBUF_LIBRARIES}
  ${_gRPC_ALLTARGETS_LIBRARIES}
  grpc_test_util
  grpc++
  grpc
  gpr_test_util
  gpr
  ${_gRPC_GFLAGS_LIBRARIES}
)

    add_dependencies(orphanable_test project_benchmark project_gflags)

  set(proto_utils_test_src
   ${_gRPC_ROOT}/test/cpp/codegen/proto_utils_test.cc
)
  android_add_test(proto_utils_test)
  target_link_libraries(proto_utils_test PRIVATE gmock_main ssl crypto)
  target_include_directories(proto_utils_test PRIVATE ${_gRPC_ROOT})

  target_compile_definitions(proto_utils_test PRIVATE -DPB_FIELD_16BIT)
  target_compile_definitions(proto_utils_test PUBLIC  -DGRPC_ALLOW_EXCEPTIONS=0)

  target_include_directories(proto_utils_test
  PRIVATE ${_gRPC_ROOT}
  PRIVATE ${_gRPC_ROOT}/include
  PRIVATE ${_gRPC_SSL_INCLUDE_DIR}
  PRIVATE ${_gRPC_BENCHMARK_INCLUDE_DIR}
  PRIVATE ${_gRPC_GFLAGS_INCLUDE_DIR}
  PRIVATE ${_gRPC_PROTOBUF_INCLUDE_DIR}
  PRIVATE ${_gRPC_NANOPB_INCLUDE_DIR}
  PRIVATE ${_gRPC_ADDRESS_SORTING_INCLUDE_DIR}
  PRIVATE ${_gRPC_GTEST_INCLUDE_DIR}
  PRIVATE ${_gRPC_PROTO_GENS_DIR}
)

  target_link_libraries(proto_utils_test PRIVATE
  ${_gRPC_PROTOBUF_LIBRARIES}
  ${_gRPC_ALLTARGETS_LIBRARIES}
  grpc++
  grpc
  ${_gRPC_GFLAGS_LIBRARIES}
)

    add_dependencies(proto_utils_test project_benchmark project_gflags)
if(_gRPC_PLATFORM_LINUX OR _gRPC_PLATFORM_MAC OR _gRPC_PLATFORM_POSIX)

  set(qps_interarrival_test_src
   ${_gRPC_ROOT}/test/cpp/qps/qps_interarrival_test.cc
)
  android_add_test(qps_interarrival_test)
  target_link_libraries(qps_interarrival_test PRIVATE gmock_main ssl crypto)
  target_include_directories(qps_interarrival_test PRIVATE ${_gRPC_ROOT})

  target_compile_definitions(qps_interarrival_test PRIVATE -DPB_FIELD_16BIT)
  target_compile_definitions(qps_interarrival_test PUBLIC  -DGRPC_ALLOW_EXCEPTIONS=0)

  target_include_directories(qps_interarrival_test
  PRIVATE ${_gRPC_ROOT}
  PRIVATE ${_gRPC_ROOT}/include
  PRIVATE ${_gRPC_SSL_INCLUDE_DIR}
  PRIVATE ${_gRPC_BENCHMARK_INCLUDE_DIR}
  PRIVATE ${_gRPC_GFLAGS_INCLUDE_DIR}
  PRIVATE ${_gRPC_PROTOBUF_INCLUDE_DIR}
  PRIVATE ${_gRPC_NANOPB_INCLUDE_DIR}
  PRIVATE ${_gRPC_ADDRESS_SORTING_INCLUDE_DIR}
  PRIVATE ${_gRPC_GTEST_INCLUDE_DIR}
  PRIVATE ${_gRPC_PROTO_GENS_DIR}
)

  target_link_libraries(qps_interarrival_test PRIVATE
  ${_gRPC_PROTOBUF_LIBRARIES}
  ${_gRPC_ALLTARGETS_LIBRARIES}
  qps
  grpc++_test_util
  grpc_test_util
  grpc++
  grpc
  gpr_test_util
  gpr
  grpc++_test_config
  ${_gRPC_GFLAGS_LIBRARIES}
)

    add_dependencies(qps_interarrival_test project_benchmark project_gflags)
endif()

  set(qps_json_driver_src
   ${_gRPC_ROOT}/test/cpp/qps/qps_json_driver.cc
)
  android_add_test(qps_json_driver)
  target_link_libraries(qps_json_driver PRIVATE gmock_main ssl crypto)
  target_include_directories(qps_json_driver PRIVATE ${_gRPC_ROOT})

  target_compile_definitions(qps_json_driver PRIVATE -DPB_FIELD_16BIT)
  target_compile_definitions(qps_json_driver PUBLIC  -DGRPC_ALLOW_EXCEPTIONS=0)

  target_include_directories(qps_json_driver
  PRIVATE ${_gRPC_ROOT}
  PRIVATE ${_gRPC_ROOT}/include
  PRIVATE ${_gRPC_SSL_INCLUDE_DIR}
  PRIVATE ${_gRPC_BENCHMARK_INCLUDE_DIR}
  PRIVATE ${_gRPC_GFLAGS_INCLUDE_DIR}
  PRIVATE ${_gRPC_PROTOBUF_INCLUDE_DIR}
  PRIVATE ${_gRPC_NANOPB_INCLUDE_DIR}
  PRIVATE ${_gRPC_ADDRESS_SORTING_INCLUDE_DIR}
  PRIVATE ${_gRPC_GTEST_INCLUDE_DIR}
  PRIVATE ${_gRPC_PROTO_GENS_DIR}
)

  target_link_libraries(qps_json_driver PRIVATE
  ${_gRPC_PROTOBUF_LIBRARIES}
  ${_gRPC_ALLTARGETS_LIBRARIES}
  qps
  grpc++_core_stats
  grpc++_test_util
  grpc_test_util
  grpc++
  grpc
  gpr_test_util
  gpr
  grpc++_test_config
  ${_gRPC_GFLAGS_LIBRARIES}
)

    add_dependencies(qps_json_driver project_benchmark project_gflags)
if(_gRPC_PLATFORM_LINUX OR _gRPC_PLATFORM_MAC OR _gRPC_PLATFORM_POSIX)

  set(qps_openloop_test_src
   ${_gRPC_ROOT}/test/cpp/qps/qps_openloop_test.cc
)
  android_add_test(qps_openloop_test)
  target_link_libraries(qps_openloop_test PRIVATE gmock_main ssl crypto)
  target_include_directories(qps_openloop_test PRIVATE ${_gRPC_ROOT})

  target_compile_definitions(qps_openloop_test PRIVATE -DPB_FIELD_16BIT)
  target_compile_definitions(qps_openloop_test PUBLIC  -DGRPC_ALLOW_EXCEPTIONS=0)

  target_include_directories(qps_openloop_test
  PRIVATE ${_gRPC_ROOT}
  PRIVATE ${_gRPC_ROOT}/include
  PRIVATE ${_gRPC_SSL_INCLUDE_DIR}
  PRIVATE ${_gRPC_BENCHMARK_INCLUDE_DIR}
  PRIVATE ${_gRPC_GFLAGS_INCLUDE_DIR}
  PRIVATE ${_gRPC_PROTOBUF_INCLUDE_DIR}
  PRIVATE ${_gRPC_NANOPB_INCLUDE_DIR}
  PRIVATE ${_gRPC_ADDRESS_SORTING_INCLUDE_DIR}
  PRIVATE ${_gRPC_GTEST_INCLUDE_DIR}
  PRIVATE ${_gRPC_PROTO_GENS_DIR}
)

  target_link_libraries(qps_openloop_test PRIVATE
  ${_gRPC_PROTOBUF_LIBRARIES}
  ${_gRPC_ALLTARGETS_LIBRARIES}
  qps
  grpc++_core_stats
  grpc++_test_util
  grpc_test_util
  grpc++
  grpc
  gpr_test_util
  gpr
  grpc++_test_config
  ${_gRPC_GFLAGS_LIBRARIES}
)

    add_dependencies(qps_openloop_test project_benchmark project_gflags)
endif()

  set(qps_worker_src
   ${_gRPC_ROOT}/test/cpp/qps/worker.cc
)
  android_add_test(qps_worker)
  target_link_libraries(qps_worker PRIVATE gmock_main ssl crypto)
  target_include_directories(qps_worker PRIVATE ${_gRPC_ROOT})

  target_compile_definitions(qps_worker PRIVATE -DPB_FIELD_16BIT)
  target_compile_definitions(qps_worker PUBLIC  -DGRPC_ALLOW_EXCEPTIONS=0)

  target_include_directories(qps_worker
  PRIVATE ${_gRPC_ROOT}
  PRIVATE ${_gRPC_ROOT}/include
  PRIVATE ${_gRPC_SSL_INCLUDE_DIR}
  PRIVATE ${_gRPC_BENCHMARK_INCLUDE_DIR}
  PRIVATE ${_gRPC_GFLAGS_INCLUDE_DIR}
  PRIVATE ${_gRPC_PROTOBUF_INCLUDE_DIR}
  PRIVATE ${_gRPC_NANOPB_INCLUDE_DIR}
  PRIVATE ${_gRPC_ADDRESS_SORTING_INCLUDE_DIR}
  PRIVATE ${_gRPC_GTEST_INCLUDE_DIR}
  PRIVATE ${_gRPC_PROTO_GENS_DIR}
)

  target_link_libraries(qps_worker PRIVATE
  ${_gRPC_PROTOBUF_LIBRARIES}
  ${_gRPC_ALLTARGETS_LIBRARIES}
  qps
  grpc++_core_stats
  grpc++_test_util
  grpc_test_util
  grpc++
  grpc
  gpr_test_util
  gpr
  grpc++_test_config
  ${_gRPC_GFLAGS_LIBRARIES}
)

    add_dependencies(qps_worker project_benchmark project_gflags)

  set(raw_end2end_test_src
   ${_gRPC_ROOT}/test/cpp/end2end/raw_end2end_test.cc
)
  android_add_test(raw_end2end_test)
  target_link_libraries(raw_end2end_test PRIVATE gmock_main ssl crypto)
  target_include_directories(raw_end2end_test PRIVATE ${_gRPC_ROOT})

  target_compile_definitions(raw_end2end_test PRIVATE -DPB_FIELD_16BIT)
  target_compile_definitions(raw_end2end_test PUBLIC  -DGRPC_ALLOW_EXCEPTIONS=0)

  target_include_directories(raw_end2end_test
  PRIVATE ${_gRPC_ROOT}
  PRIVATE ${_gRPC_ROOT}/include
  PRIVATE ${_gRPC_SSL_INCLUDE_DIR}
  PRIVATE ${_gRPC_BENCHMARK_INCLUDE_DIR}
  PRIVATE ${_gRPC_GFLAGS_INCLUDE_DIR}
  PRIVATE ${_gRPC_PROTOBUF_INCLUDE_DIR}
  PRIVATE ${_gRPC_NANOPB_INCLUDE_DIR}
  PRIVATE ${_gRPC_ADDRESS_SORTING_INCLUDE_DIR}
  PRIVATE ${_gRPC_GTEST_INCLUDE_DIR}
  PRIVATE ${_gRPC_PROTO_GENS_DIR}
)

  target_link_libraries(raw_end2end_test PRIVATE
  ${_gRPC_PROTOBUF_LIBRARIES}
  ${_gRPC_ALLTARGETS_LIBRARIES}
  grpc++_test_util
  grpc_test_util
  grpc++
  grpc
  gpr_test_util
  gpr
  ${_gRPC_GFLAGS_LIBRARIES}
)

    add_dependencies(raw_end2end_test project_benchmark project_gflags)

  set(reconnect_interop_client_src
          ${_gRPC_PROTO_GENS_DIR}/src/proto/grpc/testing/empty.pb.cc
          ${_gRPC_PROTO_GENS_DIR}/src/proto/grpc/testing/empty.grpc.pb.cc
          ${_gRPC_PROTO_GENS_DIR}/src/proto/grpc/testing/empty.pb.h
          ${_gRPC_PROTO_GENS_DIR}/src/proto/grpc/testing/empty.grpc.pb.h
          ${_gRPC_PROTO_GENS_DIR}/src/proto/grpc/testing/messages.pb.cc
          ${_gRPC_PROTO_GENS_DIR}/src/proto/grpc/testing/messages.grpc.pb.cc
          ${_gRPC_PROTO_GENS_DIR}/src/proto/grpc/testing/messages.pb.h
          ${_gRPC_PROTO_GENS_DIR}/src/proto/grpc/testing/messages.grpc.pb.h
          ${_gRPC_PROTO_GENS_DIR}/src/proto/grpc/testing/test.pb.cc
          ${_gRPC_PROTO_GENS_DIR}/src/proto/grpc/testing/test.grpc.pb.cc
          ${_gRPC_PROTO_GENS_DIR}/src/proto/grpc/testing/test.pb.h
          ${_gRPC_PROTO_GENS_DIR}/src/proto/grpc/testing/test.grpc.pb.h
   ${_gRPC_ROOT}/test/cpp/interop/reconnect_interop_client.cc
)
  android_add_test(reconnect_interop_client)
  target_link_libraries(reconnect_interop_client PRIVATE gmock_main ssl crypto)
  target_include_directories(reconnect_interop_client PRIVATE ${_gRPC_ROOT})

  target_compile_definitions(reconnect_interop_client PRIVATE -DPB_FIELD_16BIT)
  target_compile_definitions(reconnect_interop_client PUBLIC  -DGRPC_ALLOW_EXCEPTIONS=0)
protobuf_generate_grpc_cpp(
  SOURCE_DIR ${_gRPC_ROOT}
  SOURCES ${_gRPC_ROOT}/src/proto/grpc/testing/empty.proto
)
protobuf_generate_grpc_cpp(
  SOURCE_DIR ${_gRPC_ROOT}
  SOURCES ${_gRPC_ROOT}/src/proto/grpc/testing/messages.proto
)
protobuf_generate_grpc_cpp(
  SOURCE_DIR ${_gRPC_ROOT}
  SOURCES ${_gRPC_ROOT}/src/proto/grpc/testing/test.proto
)

  target_include_directories(reconnect_interop_client
  PRIVATE ${_gRPC_ROOT}
  PRIVATE ${_gRPC_ROOT}/include
  PRIVATE ${_gRPC_SSL_INCLUDE_DIR}
  PRIVATE ${_gRPC_BENCHMARK_INCLUDE_DIR}
  PRIVATE ${_gRPC_GFLAGS_INCLUDE_DIR}
  PRIVATE ${_gRPC_PROTOBUF_INCLUDE_DIR}
  PRIVATE ${_gRPC_NANOPB_INCLUDE_DIR}
  PRIVATE ${_gRPC_ADDRESS_SORTING_INCLUDE_DIR}
  PRIVATE ${_gRPC_GTEST_INCLUDE_DIR}
  PRIVATE ${_gRPC_PROTO_GENS_DIR}
)

  target_link_libraries(reconnect_interop_client PRIVATE
  ${_gRPC_PROTOBUF_LIBRARIES}
  ${_gRPC_ALLTARGETS_LIBRARIES}
  grpc++_test_util
  grpc_test_util
  grpc++
  grpc
  gpr_test_util
  gpr
  grpc++_test_config
  ${_gRPC_GFLAGS_LIBRARIES}
)

    add_dependencies(reconnect_interop_client project_benchmark project_gflags)

  set(reconnect_interop_server_src
          ${_gRPC_PROTO_GENS_DIR}/src/proto/grpc/testing/empty.pb.cc
          ${_gRPC_PROTO_GENS_DIR}/src/proto/grpc/testing/empty.grpc.pb.cc
          ${_gRPC_PROTO_GENS_DIR}/src/proto/grpc/testing/empty.pb.h
          ${_gRPC_PROTO_GENS_DIR}/src/proto/grpc/testing/empty.grpc.pb.h
          ${_gRPC_PROTO_GENS_DIR}/src/proto/grpc/testing/messages.pb.cc
          ${_gRPC_PROTO_GENS_DIR}/src/proto/grpc/testing/messages.grpc.pb.cc
          ${_gRPC_PROTO_GENS_DIR}/src/proto/grpc/testing/messages.pb.h
          ${_gRPC_PROTO_GENS_DIR}/src/proto/grpc/testing/messages.grpc.pb.h
          ${_gRPC_PROTO_GENS_DIR}/src/proto/grpc/testing/test.pb.cc
          ${_gRPC_PROTO_GENS_DIR}/src/proto/grpc/testing/test.grpc.pb.cc
          ${_gRPC_PROTO_GENS_DIR}/src/proto/grpc/testing/test.pb.h
          ${_gRPC_PROTO_GENS_DIR}/src/proto/grpc/testing/test.grpc.pb.h
   ${_gRPC_ROOT}/test/cpp/interop/reconnect_interop_server.cc
)
  android_add_test(reconnect_interop_server)
  target_link_libraries(reconnect_interop_server PRIVATE gmock_main ssl crypto)
  target_include_directories(reconnect_interop_server PRIVATE ${_gRPC_ROOT})

  target_compile_definitions(reconnect_interop_server PRIVATE -DPB_FIELD_16BIT)
  target_compile_definitions(reconnect_interop_server PUBLIC  -DGRPC_ALLOW_EXCEPTIONS=0)
protobuf_generate_grpc_cpp(
  SOURCE_DIR ${_gRPC_ROOT}
  SOURCES ${_gRPC_ROOT}/src/proto/grpc/testing/empty.proto
)
protobuf_generate_grpc_cpp(
  SOURCE_DIR ${_gRPC_ROOT}
  SOURCES ${_gRPC_ROOT}/src/proto/grpc/testing/messages.proto
)
protobuf_generate_grpc_cpp(
  SOURCE_DIR ${_gRPC_ROOT}
  SOURCES ${_gRPC_ROOT}/src/proto/grpc/testing/test.proto
)

  target_include_directories(reconnect_interop_server
  PRIVATE ${_gRPC_ROOT}
  PRIVATE ${_gRPC_ROOT}/include
  PRIVATE ${_gRPC_SSL_INCLUDE_DIR}
  PRIVATE ${_gRPC_BENCHMARK_INCLUDE_DIR}
  PRIVATE ${_gRPC_GFLAGS_INCLUDE_DIR}
  PRIVATE ${_gRPC_PROTOBUF_INCLUDE_DIR}
  PRIVATE ${_gRPC_NANOPB_INCLUDE_DIR}
  PRIVATE ${_gRPC_ADDRESS_SORTING_INCLUDE_DIR}
  PRIVATE ${_gRPC_GTEST_INCLUDE_DIR}
  PRIVATE ${_gRPC_PROTO_GENS_DIR}
)

  target_link_libraries(reconnect_interop_server PRIVATE
  ${_gRPC_PROTOBUF_LIBRARIES}
  ${_gRPC_ALLTARGETS_LIBRARIES}
  reconnect_server
  test_tcp_server
  grpc++_test_util
  grpc_test_util
  grpc++
  grpc
  gpr_test_util
  gpr
  grpc++_test_config
  ${_gRPC_GFLAGS_LIBRARIES}
)

    add_dependencies(reconnect_interop_server project_benchmark project_gflags)

  set(ref_counted_ptr_test_src
   ${_gRPC_ROOT}/test/core/gprpp/ref_counted_ptr_test.cc
)
  android_add_test(ref_counted_ptr_test)
  target_link_libraries(ref_counted_ptr_test PRIVATE gmock_main ssl crypto)
  target_include_directories(ref_counted_ptr_test PRIVATE ${_gRPC_ROOT})

  target_compile_definitions(ref_counted_ptr_test PRIVATE -DPB_FIELD_16BIT)
  target_compile_definitions(ref_counted_ptr_test PUBLIC  -DGRPC_ALLOW_EXCEPTIONS=0)

  target_include_directories(ref_counted_ptr_test
  PRIVATE ${_gRPC_ROOT}
  PRIVATE ${_gRPC_ROOT}/include
  PRIVATE ${_gRPC_SSL_INCLUDE_DIR}
  PRIVATE ${_gRPC_BENCHMARK_INCLUDE_DIR}
  PRIVATE ${_gRPC_GFLAGS_INCLUDE_DIR}
  PRIVATE ${_gRPC_PROTOBUF_INCLUDE_DIR}
  PRIVATE ${_gRPC_NANOPB_INCLUDE_DIR}
  PRIVATE ${_gRPC_ADDRESS_SORTING_INCLUDE_DIR}
  PRIVATE ${_gRPC_GTEST_INCLUDE_DIR}
  PRIVATE ${_gRPC_PROTO_GENS_DIR}
)

  target_link_libraries(ref_counted_ptr_test PRIVATE
  ${_gRPC_PROTOBUF_LIBRARIES}
  ${_gRPC_ALLTARGETS_LIBRARIES}
  grpc_test_util
  grpc++
  grpc
  gpr_test_util
  gpr
  ${_gRPC_GFLAGS_LIBRARIES}
)

    add_dependencies(ref_counted_ptr_test project_benchmark project_gflags)

  set(ref_counted_test_src
   ${_gRPC_ROOT}/test/core/gprpp/ref_counted_test.cc
)
  android_add_test(ref_counted_test)
  target_link_libraries(ref_counted_test PRIVATE gmock_main ssl crypto)
  target_include_directories(ref_counted_test PRIVATE ${_gRPC_ROOT})

  target_compile_definitions(ref_counted_test PRIVATE -DPB_FIELD_16BIT)
  target_compile_definitions(ref_counted_test PUBLIC  -DGRPC_ALLOW_EXCEPTIONS=0)

  target_include_directories(ref_counted_test
  PRIVATE ${_gRPC_ROOT}
  PRIVATE ${_gRPC_ROOT}/include
  PRIVATE ${_gRPC_SSL_INCLUDE_DIR}
  PRIVATE ${_gRPC_BENCHMARK_INCLUDE_DIR}
  PRIVATE ${_gRPC_GFLAGS_INCLUDE_DIR}
  PRIVATE ${_gRPC_PROTOBUF_INCLUDE_DIR}
  PRIVATE ${_gRPC_NANOPB_INCLUDE_DIR}
  PRIVATE ${_gRPC_ADDRESS_SORTING_INCLUDE_DIR}
  PRIVATE ${_gRPC_GTEST_INCLUDE_DIR}
  PRIVATE ${_gRPC_PROTO_GENS_DIR}
)

  target_link_libraries(ref_counted_test PRIVATE
  ${_gRPC_PROTOBUF_LIBRARIES}
  ${_gRPC_ALLTARGETS_LIBRARIES}
  grpc_test_util
  grpc++
  grpc
  gpr_test_util
  gpr
  ${_gRPC_GFLAGS_LIBRARIES}
)

    add_dependencies(ref_counted_test project_benchmark project_gflags)

  set(retry_throttle_test_src
   ${_gRPC_ROOT}/test/core/client_channel/retry_throttle_test.cc
)
  android_add_test(retry_throttle_test)
  target_link_libraries(retry_throttle_test PRIVATE gmock_main ssl crypto)
  target_include_directories(retry_throttle_test PRIVATE ${_gRPC_ROOT})

  target_compile_definitions(retry_throttle_test PRIVATE -DPB_FIELD_16BIT)
  target_compile_definitions(retry_throttle_test PUBLIC  -DGRPC_ALLOW_EXCEPTIONS=0)

  target_include_directories(retry_throttle_test
  PRIVATE ${_gRPC_ROOT}
  PRIVATE ${_gRPC_ROOT}/include
  PRIVATE ${_gRPC_SSL_INCLUDE_DIR}
  PRIVATE ${_gRPC_BENCHMARK_INCLUDE_DIR}
  PRIVATE ${_gRPC_GFLAGS_INCLUDE_DIR}
  PRIVATE ${_gRPC_PROTOBUF_INCLUDE_DIR}
  PRIVATE ${_gRPC_NANOPB_INCLUDE_DIR}
  PRIVATE ${_gRPC_ADDRESS_SORTING_INCLUDE_DIR}
  PRIVATE ${_gRPC_GTEST_INCLUDE_DIR}
  PRIVATE ${_gRPC_PROTO_GENS_DIR}
)

  target_link_libraries(retry_throttle_test PRIVATE
  ${_gRPC_PROTOBUF_LIBRARIES}
  ${_gRPC_ALLTARGETS_LIBRARIES}
  grpc_test_util
  grpc
  gpr_test_util
  gpr
  ${_gRPC_GFLAGS_LIBRARIES}
)

    add_dependencies(retry_throttle_test project_benchmark project_gflags)

  set(secure_auth_context_test_src
   ${_gRPC_ROOT}/test/cpp/common/secure_auth_context_test.cc
)
  android_add_test(secure_auth_context_test)
  target_link_libraries(secure_auth_context_test PRIVATE gmock_main ssl crypto)
  target_include_directories(secure_auth_context_test PRIVATE ${_gRPC_ROOT})

  target_compile_definitions(secure_auth_context_test PRIVATE -DPB_FIELD_16BIT)
  target_compile_definitions(secure_auth_context_test PUBLIC  -DGRPC_ALLOW_EXCEPTIONS=0)

  target_include_directories(secure_auth_context_test
  PRIVATE ${_gRPC_ROOT}
  PRIVATE ${_gRPC_ROOT}/include
  PRIVATE ${_gRPC_SSL_INCLUDE_DIR}
  PRIVATE ${_gRPC_BENCHMARK_INCLUDE_DIR}
  PRIVATE ${_gRPC_GFLAGS_INCLUDE_DIR}
  PRIVATE ${_gRPC_PROTOBUF_INCLUDE_DIR}
  PRIVATE ${_gRPC_NANOPB_INCLUDE_DIR}
  PRIVATE ${_gRPC_ADDRESS_SORTING_INCLUDE_DIR}
  PRIVATE ${_gRPC_GTEST_INCLUDE_DIR}
  PRIVATE ${_gRPC_PROTO_GENS_DIR}
)

  target_link_libraries(secure_auth_context_test PRIVATE
  ${_gRPC_PROTOBUF_LIBRARIES}
  ${_gRPC_ALLTARGETS_LIBRARIES}
  grpc++_test_util
  grpc_test_util
  grpc++
  grpc
  gpr_test_util
  gpr
  ${_gRPC_GFLAGS_LIBRARIES}
)

    add_dependencies(secure_auth_context_test project_benchmark project_gflags)
if(_gRPC_PLATFORM_LINUX OR _gRPC_PLATFORM_MAC OR _gRPC_PLATFORM_POSIX)

  set(secure_sync_unary_ping_pong_test_src
   ${_gRPC_ROOT}/test/cpp/qps/secure_sync_unary_ping_pong_test.cc
)
  android_add_test(secure_sync_unary_ping_pong_test)
  target_link_libraries(secure_sync_unary_ping_pong_test PRIVATE gmock_main ssl crypto)
  target_include_directories(secure_sync_unary_ping_pong_test PRIVATE ${_gRPC_ROOT})

  target_compile_definitions(secure_sync_unary_ping_pong_test PRIVATE -DPB_FIELD_16BIT)
  target_compile_definitions(secure_sync_unary_ping_pong_test PUBLIC  -DGRPC_ALLOW_EXCEPTIONS=0)

  target_include_directories(secure_sync_unary_ping_pong_test
  PRIVATE ${_gRPC_ROOT}
  PRIVATE ${_gRPC_ROOT}/include
  PRIVATE ${_gRPC_SSL_INCLUDE_DIR}
  PRIVATE ${_gRPC_BENCHMARK_INCLUDE_DIR}
  PRIVATE ${_gRPC_GFLAGS_INCLUDE_DIR}
  PRIVATE ${_gRPC_PROTOBUF_INCLUDE_DIR}
  PRIVATE ${_gRPC_NANOPB_INCLUDE_DIR}
  PRIVATE ${_gRPC_ADDRESS_SORTING_INCLUDE_DIR}
  PRIVATE ${_gRPC_GTEST_INCLUDE_DIR}
  PRIVATE ${_gRPC_PROTO_GENS_DIR}
)

  target_link_libraries(secure_sync_unary_ping_pong_test PRIVATE
  ${_gRPC_PROTOBUF_LIBRARIES}
  ${_gRPC_ALLTARGETS_LIBRARIES}
  qps
  grpc++_core_stats
  grpc++_test_util
  grpc_test_util
  grpc++
  grpc
  gpr_test_util
  gpr
  grpc++_test_config
  ${_gRPC_GFLAGS_LIBRARIES}
)

    add_dependencies(secure_sync_unary_ping_pong_test project_benchmark project_gflags)
endif()

  set(server_builder_plugin_test_src
   ${_gRPC_ROOT}/test/cpp/end2end/server_builder_plugin_test.cc
)
  android_add_test(server_builder_plugin_test)
  target_link_libraries(server_builder_plugin_test PRIVATE gmock_main ssl crypto)
  target_include_directories(server_builder_plugin_test PRIVATE ${_gRPC_ROOT})

  target_compile_definitions(server_builder_plugin_test PRIVATE -DPB_FIELD_16BIT)
  target_compile_definitions(server_builder_plugin_test PUBLIC  -DGRPC_ALLOW_EXCEPTIONS=0)

  target_include_directories(server_builder_plugin_test
  PRIVATE ${_gRPC_ROOT}
  PRIVATE ${_gRPC_ROOT}/include
  PRIVATE ${_gRPC_SSL_INCLUDE_DIR}
  PRIVATE ${_gRPC_BENCHMARK_INCLUDE_DIR}
  PRIVATE ${_gRPC_GFLAGS_INCLUDE_DIR}
  PRIVATE ${_gRPC_PROTOBUF_INCLUDE_DIR}
  PRIVATE ${_gRPC_NANOPB_INCLUDE_DIR}
  PRIVATE ${_gRPC_ADDRESS_SORTING_INCLUDE_DIR}
  PRIVATE ${_gRPC_GTEST_INCLUDE_DIR}
  PRIVATE ${_gRPC_PROTO_GENS_DIR}
)

  target_link_libraries(server_builder_plugin_test PRIVATE
  ${_gRPC_PROTOBUF_LIBRARIES}
  ${_gRPC_ALLTARGETS_LIBRARIES}
  grpc++_test_util
  grpc_test_util
  grpc++
  grpc
  gpr_test_util
  gpr
  ${_gRPC_GFLAGS_LIBRARIES}
)

    add_dependencies(server_builder_plugin_test project_benchmark project_gflags)

  set(server_builder_test_src
          ${_gRPC_PROTO_GENS_DIR}/src/proto/grpc/testing/echo_messages.pb.cc
          ${_gRPC_PROTO_GENS_DIR}/src/proto/grpc/testing/echo_messages.grpc.pb.cc
          ${_gRPC_PROTO_GENS_DIR}/src/proto/grpc/testing/echo_messages.pb.h
          ${_gRPC_PROTO_GENS_DIR}/src/proto/grpc/testing/echo_messages.grpc.pb.h
          ${_gRPC_PROTO_GENS_DIR}/src/proto/grpc/testing/echo.pb.cc
          ${_gRPC_PROTO_GENS_DIR}/src/proto/grpc/testing/echo.grpc.pb.cc
          ${_gRPC_PROTO_GENS_DIR}/src/proto/grpc/testing/echo.pb.h
          ${_gRPC_PROTO_GENS_DIR}/src/proto/grpc/testing/echo.grpc.pb.h
   ${_gRPC_ROOT}/test/cpp/server/server_builder_test.cc
)
  android_add_test(server_builder_test)
  target_link_libraries(server_builder_test PRIVATE gmock_main ssl crypto)
  target_include_directories(server_builder_test PRIVATE ${_gRPC_ROOT})

  target_compile_definitions(server_builder_test PRIVATE -DPB_FIELD_16BIT)
  target_compile_definitions(server_builder_test PUBLIC  -DGRPC_ALLOW_EXCEPTIONS=0)
protobuf_generate_grpc_cpp(
  SOURCE_DIR ${_gRPC_ROOT}
  SOURCES ${_gRPC_ROOT}/src/proto/grpc/testing/echo_messages.proto
)
protobuf_generate_grpc_cpp(
  SOURCE_DIR ${_gRPC_ROOT}
  SOURCES ${_gRPC_ROOT}/src/proto/grpc/testing/echo.proto
)

  target_include_directories(server_builder_test
  PRIVATE ${_gRPC_ROOT}
  PRIVATE ${_gRPC_ROOT}/include
  PRIVATE ${_gRPC_SSL_INCLUDE_DIR}
  PRIVATE ${_gRPC_BENCHMARK_INCLUDE_DIR}
  PRIVATE ${_gRPC_GFLAGS_INCLUDE_DIR}
  PRIVATE ${_gRPC_PROTOBUF_INCLUDE_DIR}
  PRIVATE ${_gRPC_NANOPB_INCLUDE_DIR}
  PRIVATE ${_gRPC_ADDRESS_SORTING_INCLUDE_DIR}
  PRIVATE ${_gRPC_GTEST_INCLUDE_DIR}
  PRIVATE ${_gRPC_PROTO_GENS_DIR}
)

  target_link_libraries(server_builder_test PRIVATE
  ${_gRPC_PROTOBUF_LIBRARIES}
  ${_gRPC_ALLTARGETS_LIBRARIES}
  grpc++_test_util_unsecure
  grpc_test_util_unsecure
  gpr_test_util
  grpc++_unsecure
  grpc_unsecure
  gpr
  ${_gRPC_GFLAGS_LIBRARIES}
)

    add_dependencies(server_builder_test project_benchmark project_gflags)
if(_gRPC_PLATFORM_POSIX)

  set(server_builder_with_socket_mutator_test_src
          ${_gRPC_PROTO_GENS_DIR}/src/proto/grpc/testing/echo_messages.pb.cc
          ${_gRPC_PROTO_GENS_DIR}/src/proto/grpc/testing/echo_messages.grpc.pb.cc
          ${_gRPC_PROTO_GENS_DIR}/src/proto/grpc/testing/echo_messages.pb.h
          ${_gRPC_PROTO_GENS_DIR}/src/proto/grpc/testing/echo_messages.grpc.pb.h
          ${_gRPC_PROTO_GENS_DIR}/src/proto/grpc/testing/echo.pb.cc
          ${_gRPC_PROTO_GENS_DIR}/src/proto/grpc/testing/echo.grpc.pb.cc
          ${_gRPC_PROTO_GENS_DIR}/src/proto/grpc/testing/echo.pb.h
          ${_gRPC_PROTO_GENS_DIR}/src/proto/grpc/testing/echo.grpc.pb.h
   ${_gRPC_ROOT}/test/cpp/server/server_builder_with_socket_mutator_test.cc
)
  android_add_test(server_builder_with_socket_mutator_test)
  target_link_libraries(server_builder_with_socket_mutator_test PRIVATE gmock_main ssl crypto)
  target_include_directories(server_builder_with_socket_mutator_test PRIVATE ${_gRPC_ROOT})

  target_compile_definitions(server_builder_with_socket_mutator_test PRIVATE -DPB_FIELD_16BIT)
  target_compile_definitions(server_builder_with_socket_mutator_test PUBLIC  -DGRPC_ALLOW_EXCEPTIONS=0)
protobuf_generate_grpc_cpp(
  SOURCE_DIR ${_gRPC_ROOT}
  SOURCES ${_gRPC_ROOT}/src/proto/grpc/testing/echo_messages.proto
)
protobuf_generate_grpc_cpp(
  SOURCE_DIR ${_gRPC_ROOT}
  SOURCES ${_gRPC_ROOT}/src/proto/grpc/testing/echo.proto
)

  target_include_directories(server_builder_with_socket_mutator_test
  PRIVATE ${_gRPC_ROOT}
  PRIVATE ${_gRPC_ROOT}/include
  PRIVATE ${_gRPC_SSL_INCLUDE_DIR}
  PRIVATE ${_gRPC_BENCHMARK_INCLUDE_DIR}
  PRIVATE ${_gRPC_GFLAGS_INCLUDE_DIR}
  PRIVATE ${_gRPC_PROTOBUF_INCLUDE_DIR}
  PRIVATE ${_gRPC_NANOPB_INCLUDE_DIR}
  PRIVATE ${_gRPC_ADDRESS_SORTING_INCLUDE_DIR}
  PRIVATE ${_gRPC_GTEST_INCLUDE_DIR}
  PRIVATE ${_gRPC_PROTO_GENS_DIR}
)

  target_link_libraries(server_builder_with_socket_mutator_test PRIVATE
  ${_gRPC_PROTOBUF_LIBRARIES}
  ${_gRPC_ALLTARGETS_LIBRARIES}
  grpc++_test_util_unsecure
  grpc_test_util_unsecure
  gpr_test_util
  grpc++_unsecure
  grpc_unsecure
  gpr
  ${_gRPC_GFLAGS_LIBRARIES}
)

    add_dependencies(server_builder_with_socket_mutator_test project_benchmark project_gflags)
endif()

  set(server_context_test_spouse_test_src
   ${_gRPC_ROOT}/test/cpp/test/server_context_test_spouse_test.cc
)
  android_add_test(server_context_test_spouse_test)
  target_link_libraries(server_context_test_spouse_test PRIVATE gmock_main ssl crypto)
  target_include_directories(server_context_test_spouse_test PRIVATE ${_gRPC_ROOT})

  target_compile_definitions(server_context_test_spouse_test PRIVATE -DPB_FIELD_16BIT)
  target_compile_definitions(server_context_test_spouse_test PUBLIC  -DGRPC_ALLOW_EXCEPTIONS=0)

  target_include_directories(server_context_test_spouse_test
  PRIVATE ${_gRPC_ROOT}
  PRIVATE ${_gRPC_ROOT}/include
  PRIVATE ${_gRPC_SSL_INCLUDE_DIR}
  PRIVATE ${_gRPC_BENCHMARK_INCLUDE_DIR}
  PRIVATE ${_gRPC_GFLAGS_INCLUDE_DIR}
  PRIVATE ${_gRPC_PROTOBUF_INCLUDE_DIR}
  PRIVATE ${_gRPC_NANOPB_INCLUDE_DIR}
  PRIVATE ${_gRPC_ADDRESS_SORTING_INCLUDE_DIR}
  PRIVATE ${_gRPC_GTEST_INCLUDE_DIR}
  PRIVATE ${_gRPC_PROTO_GENS_DIR}
)

  target_link_libraries(server_context_test_spouse_test PRIVATE
  ${_gRPC_PROTOBUF_LIBRARIES}
  ${_gRPC_ALLTARGETS_LIBRARIES}
  grpc_test_util
  grpc++
  grpc
  gpr_test_util
  gpr
  ${_gRPC_GFLAGS_LIBRARIES}
)

    add_dependencies(server_context_test_spouse_test project_benchmark project_gflags)
if(_gRPC_PLATFORM_LINUX OR _gRPC_PLATFORM_MAC OR _gRPC_PLATFORM_POSIX)

  set(server_crash_test_src
   ${_gRPC_ROOT}/test/cpp/end2end/server_crash_test.cc
)
  android_add_test(server_crash_test)
  target_link_libraries(server_crash_test PRIVATE gmock_main ssl crypto)
  target_include_directories(server_crash_test PRIVATE ${_gRPC_ROOT})

  target_compile_definitions(server_crash_test PRIVATE -DPB_FIELD_16BIT)
  target_compile_definitions(server_crash_test PUBLIC  -DGRPC_ALLOW_EXCEPTIONS=0)

  target_include_directories(server_crash_test
  PRIVATE ${_gRPC_ROOT}
  PRIVATE ${_gRPC_ROOT}/include
  PRIVATE ${_gRPC_SSL_INCLUDE_DIR}
  PRIVATE ${_gRPC_BENCHMARK_INCLUDE_DIR}
  PRIVATE ${_gRPC_GFLAGS_INCLUDE_DIR}
  PRIVATE ${_gRPC_PROTOBUF_INCLUDE_DIR}
  PRIVATE ${_gRPC_NANOPB_INCLUDE_DIR}
  PRIVATE ${_gRPC_ADDRESS_SORTING_INCLUDE_DIR}
  PRIVATE ${_gRPC_GTEST_INCLUDE_DIR}
  PRIVATE ${_gRPC_PROTO_GENS_DIR}
)

  target_link_libraries(server_crash_test PRIVATE
  ${_gRPC_PROTOBUF_LIBRARIES}
  ${_gRPC_ALLTARGETS_LIBRARIES}
  grpc++_test_util
  grpc_test_util
  grpc++
  grpc
  gpr_test_util
  gpr
  ${_gRPC_GFLAGS_LIBRARIES}
)

    add_dependencies(server_crash_test project_benchmark project_gflags)
endif()

  set(server_crash_test_client_src
   ${_gRPC_ROOT}/test/cpp/end2end/server_crash_test_client.cc
)
  android_add_test(server_crash_test_client)
  target_link_libraries(server_crash_test_client PRIVATE gmock_main ssl crypto)
  target_include_directories(server_crash_test_client PRIVATE ${_gRPC_ROOT})

  target_compile_definitions(server_crash_test_client PRIVATE -DPB_FIELD_16BIT)
  target_compile_definitions(server_crash_test_client PUBLIC  -DGRPC_ALLOW_EXCEPTIONS=0)

  target_include_directories(server_crash_test_client
  PRIVATE ${_gRPC_ROOT}
  PRIVATE ${_gRPC_ROOT}/include
  PRIVATE ${_gRPC_SSL_INCLUDE_DIR}
  PRIVATE ${_gRPC_BENCHMARK_INCLUDE_DIR}
  PRIVATE ${_gRPC_GFLAGS_INCLUDE_DIR}
  PRIVATE ${_gRPC_PROTOBUF_INCLUDE_DIR}
  PRIVATE ${_gRPC_NANOPB_INCLUDE_DIR}
  PRIVATE ${_gRPC_ADDRESS_SORTING_INCLUDE_DIR}
  PRIVATE ${_gRPC_GTEST_INCLUDE_DIR}
  PRIVATE ${_gRPC_PROTO_GENS_DIR}
)

  target_link_libraries(server_crash_test_client PRIVATE
  ${_gRPC_PROTOBUF_LIBRARIES}
  ${_gRPC_ALLTARGETS_LIBRARIES}
  grpc++_test_util
  grpc_test_util
  grpc++
  grpc
  gpr_test_util
  gpr
  ${_gRPC_GFLAGS_LIBRARIES}
)

    add_dependencies(server_crash_test_client project_benchmark project_gflags)

  set(server_early_return_test_src
   ${_gRPC_ROOT}/test/cpp/end2end/server_early_return_test.cc
)
  android_add_test(server_early_return_test)
  target_link_libraries(server_early_return_test PRIVATE gmock_main ssl crypto)
  target_include_directories(server_early_return_test PRIVATE ${_gRPC_ROOT})

  target_compile_definitions(server_early_return_test PRIVATE -DPB_FIELD_16BIT)
  target_compile_definitions(server_early_return_test PUBLIC  -DGRPC_ALLOW_EXCEPTIONS=0)

  target_include_directories(server_early_return_test
  PRIVATE ${_gRPC_ROOT}
  PRIVATE ${_gRPC_ROOT}/include
  PRIVATE ${_gRPC_SSL_INCLUDE_DIR}
  PRIVATE ${_gRPC_BENCHMARK_INCLUDE_DIR}
  PRIVATE ${_gRPC_GFLAGS_INCLUDE_DIR}
  PRIVATE ${_gRPC_PROTOBUF_INCLUDE_DIR}
  PRIVATE ${_gRPC_NANOPB_INCLUDE_DIR}
  PRIVATE ${_gRPC_ADDRESS_SORTING_INCLUDE_DIR}
  PRIVATE ${_gRPC_GTEST_INCLUDE_DIR}
  PRIVATE ${_gRPC_PROTO_GENS_DIR}
)

  target_link_libraries(server_early_return_test PRIVATE
  ${_gRPC_PROTOBUF_LIBRARIES}
  ${_gRPC_ALLTARGETS_LIBRARIES}
  grpc++_test_util
  grpc_test_util
  grpc++
  grpc
  gpr_test_util
  gpr
  ${_gRPC_GFLAGS_LIBRARIES}
)

    add_dependencies(server_early_return_test project_benchmark project_gflags)

  set(server_request_call_test_src
          ${_gRPC_PROTO_GENS_DIR}/src/proto/grpc/testing/echo_messages.pb.cc
          ${_gRPC_PROTO_GENS_DIR}/src/proto/grpc/testing/echo_messages.grpc.pb.cc
          ${_gRPC_PROTO_GENS_DIR}/src/proto/grpc/testing/echo_messages.pb.h
          ${_gRPC_PROTO_GENS_DIR}/src/proto/grpc/testing/echo_messages.grpc.pb.h
          ${_gRPC_PROTO_GENS_DIR}/src/proto/grpc/testing/echo.pb.cc
          ${_gRPC_PROTO_GENS_DIR}/src/proto/grpc/testing/echo.grpc.pb.cc
          ${_gRPC_PROTO_GENS_DIR}/src/proto/grpc/testing/echo.pb.h
          ${_gRPC_PROTO_GENS_DIR}/src/proto/grpc/testing/echo.grpc.pb.h
   ${_gRPC_ROOT}/test/cpp/server/server_request_call_test.cc
)
  android_add_test(server_request_call_test)
  target_link_libraries(server_request_call_test PRIVATE gmock_main ssl crypto)
  target_include_directories(server_request_call_test PRIVATE ${_gRPC_ROOT})

  target_compile_definitions(server_request_call_test PRIVATE -DPB_FIELD_16BIT)
  target_compile_definitions(server_request_call_test PUBLIC  -DGRPC_ALLOW_EXCEPTIONS=0)
protobuf_generate_grpc_cpp(
  SOURCE_DIR ${_gRPC_ROOT}
  SOURCES ${_gRPC_ROOT}/src/proto/grpc/testing/echo_messages.proto
)
protobuf_generate_grpc_cpp(
  SOURCE_DIR ${_gRPC_ROOT}
  SOURCES ${_gRPC_ROOT}/src/proto/grpc/testing/echo.proto
)

  target_include_directories(server_request_call_test
  PRIVATE ${_gRPC_ROOT}
  PRIVATE ${_gRPC_ROOT}/include
  PRIVATE ${_gRPC_SSL_INCLUDE_DIR}
  PRIVATE ${_gRPC_BENCHMARK_INCLUDE_DIR}
  PRIVATE ${_gRPC_GFLAGS_INCLUDE_DIR}
  PRIVATE ${_gRPC_PROTOBUF_INCLUDE_DIR}
  PRIVATE ${_gRPC_NANOPB_INCLUDE_DIR}
  PRIVATE ${_gRPC_ADDRESS_SORTING_INCLUDE_DIR}
  PRIVATE ${_gRPC_GTEST_INCLUDE_DIR}
  PRIVATE ${_gRPC_PROTO_GENS_DIR}
)

  target_link_libraries(server_request_call_test PRIVATE
  ${_gRPC_PROTOBUF_LIBRARIES}
  ${_gRPC_ALLTARGETS_LIBRARIES}
  grpc++_test_util_unsecure
  grpc_test_util_unsecure
  gpr_test_util
  grpc++_unsecure
  grpc_unsecure
  gpr
  ${_gRPC_GFLAGS_LIBRARIES}
)

    add_dependencies(server_request_call_test project_benchmark project_gflags)

  set(shutdown_test_src
   ${_gRPC_ROOT}/test/cpp/end2end/shutdown_test.cc
)
  android_add_test(shutdown_test)
  target_link_libraries(shutdown_test PRIVATE gmock_main ssl crypto)
  target_include_directories(shutdown_test PRIVATE ${_gRPC_ROOT})

  target_compile_definitions(shutdown_test PRIVATE -DPB_FIELD_16BIT)
  target_compile_definitions(shutdown_test PUBLIC  -DGRPC_ALLOW_EXCEPTIONS=0)

  target_include_directories(shutdown_test
  PRIVATE ${_gRPC_ROOT}
  PRIVATE ${_gRPC_ROOT}/include
  PRIVATE ${_gRPC_SSL_INCLUDE_DIR}
  PRIVATE ${_gRPC_BENCHMARK_INCLUDE_DIR}
  PRIVATE ${_gRPC_GFLAGS_INCLUDE_DIR}
  PRIVATE ${_gRPC_PROTOBUF_INCLUDE_DIR}
  PRIVATE ${_gRPC_NANOPB_INCLUDE_DIR}
  PRIVATE ${_gRPC_ADDRESS_SORTING_INCLUDE_DIR}
  PRIVATE ${_gRPC_GTEST_INCLUDE_DIR}
  PRIVATE ${_gRPC_PROTO_GENS_DIR}
)

  target_link_libraries(shutdown_test PRIVATE
  ${_gRPC_PROTOBUF_LIBRARIES}
  ${_gRPC_ALLTARGETS_LIBRARIES}
  grpc++_test_util
  grpc_test_util
  grpc++
  grpc
  gpr_test_util
  gpr
  ${_gRPC_GFLAGS_LIBRARIES}
)

    add_dependencies(shutdown_test project_benchmark project_gflags)

  set(slice_hash_table_test_src
   ${_gRPC_ROOT}/test/core/slice/slice_hash_table_test.cc
)
  android_add_test(slice_hash_table_test)
  target_link_libraries(slice_hash_table_test PRIVATE gmock_main ssl crypto)
  target_include_directories(slice_hash_table_test PRIVATE ${_gRPC_ROOT})

  target_compile_definitions(slice_hash_table_test PRIVATE -DPB_FIELD_16BIT)
  target_compile_definitions(slice_hash_table_test PUBLIC  -DGRPC_ALLOW_EXCEPTIONS=0)

  target_include_directories(slice_hash_table_test
  PRIVATE ${_gRPC_ROOT}
  PRIVATE ${_gRPC_ROOT}/include
  PRIVATE ${_gRPC_SSL_INCLUDE_DIR}
  PRIVATE ${_gRPC_BENCHMARK_INCLUDE_DIR}
  PRIVATE ${_gRPC_GFLAGS_INCLUDE_DIR}
  PRIVATE ${_gRPC_PROTOBUF_INCLUDE_DIR}
  PRIVATE ${_gRPC_NANOPB_INCLUDE_DIR}
  PRIVATE ${_gRPC_ADDRESS_SORTING_INCLUDE_DIR}
  PRIVATE ${_gRPC_GTEST_INCLUDE_DIR}
  PRIVATE ${_gRPC_PROTO_GENS_DIR}
)

  target_link_libraries(slice_hash_table_test PRIVATE
  ${_gRPC_PROTOBUF_LIBRARIES}
  ${_gRPC_ALLTARGETS_LIBRARIES}
  grpc_test_util
  grpc
  gpr_test_util
  gpr
  ${_gRPC_GFLAGS_LIBRARIES}
)

    add_dependencies(slice_hash_table_test project_benchmark project_gflags)

  set(slice_weak_hash_table_test_src
   ${_gRPC_ROOT}/test/core/slice/slice_weak_hash_table_test.cc
)
  android_add_test(slice_weak_hash_table_test)
  target_link_libraries(slice_weak_hash_table_test PRIVATE gmock_main ssl crypto)
  target_include_directories(slice_weak_hash_table_test PRIVATE ${_gRPC_ROOT})

  target_compile_definitions(slice_weak_hash_table_test PRIVATE -DPB_FIELD_16BIT)
  target_compile_definitions(slice_weak_hash_table_test PUBLIC  -DGRPC_ALLOW_EXCEPTIONS=0)

  target_include_directories(slice_weak_hash_table_test
  PRIVATE ${_gRPC_ROOT}
  PRIVATE ${_gRPC_ROOT}/include
  PRIVATE ${_gRPC_SSL_INCLUDE_DIR}
  PRIVATE ${_gRPC_BENCHMARK_INCLUDE_DIR}
  PRIVATE ${_gRPC_GFLAGS_INCLUDE_DIR}
  PRIVATE ${_gRPC_PROTOBUF_INCLUDE_DIR}
  PRIVATE ${_gRPC_NANOPB_INCLUDE_DIR}
  PRIVATE ${_gRPC_ADDRESS_SORTING_INCLUDE_DIR}
  PRIVATE ${_gRPC_GTEST_INCLUDE_DIR}
  PRIVATE ${_gRPC_PROTO_GENS_DIR}
)

  target_link_libraries(slice_weak_hash_table_test PRIVATE
  ${_gRPC_PROTOBUF_LIBRARIES}
  ${_gRPC_ALLTARGETS_LIBRARIES}
  grpc_test_util
  grpc
  gpr_test_util
  gpr
  ${_gRPC_GFLAGS_LIBRARIES}
)

    add_dependencies(slice_weak_hash_table_test project_benchmark project_gflags)

  set(stats_test_src
   ${_gRPC_ROOT}/test/core/debug/stats_test.cc
)
  android_add_test(stats_test)
  target_link_libraries(stats_test PRIVATE gmock_main ssl crypto)
  target_include_directories(stats_test PRIVATE ${_gRPC_ROOT})

  target_compile_definitions(stats_test PRIVATE -DPB_FIELD_16BIT)
  target_compile_definitions(stats_test PUBLIC  -DGRPC_ALLOW_EXCEPTIONS=0)

  target_include_directories(stats_test
  PRIVATE ${_gRPC_ROOT}
  PRIVATE ${_gRPC_ROOT}/include
  PRIVATE ${_gRPC_SSL_INCLUDE_DIR}
  PRIVATE ${_gRPC_BENCHMARK_INCLUDE_DIR}
  PRIVATE ${_gRPC_GFLAGS_INCLUDE_DIR}
  PRIVATE ${_gRPC_PROTOBUF_INCLUDE_DIR}
  PRIVATE ${_gRPC_NANOPB_INCLUDE_DIR}
  PRIVATE ${_gRPC_ADDRESS_SORTING_INCLUDE_DIR}
  PRIVATE ${_gRPC_GTEST_INCLUDE_DIR}
  PRIVATE ${_gRPC_PROTO_GENS_DIR}
)

  target_link_libraries(stats_test PRIVATE
  ${_gRPC_PROTOBUF_LIBRARIES}
  ${_gRPC_ALLTARGETS_LIBRARIES}
  grpc++_test_util
  grpc_test_util
  grpc
  gpr_test_util
  gpr
  ${_gRPC_GFLAGS_LIBRARIES}
)

    add_dependencies(stats_test project_benchmark project_gflags)

  set(status_metadata_test_src
   ${_gRPC_ROOT}/test/core/transport/status_metadata_test.cc
)
  android_add_test(status_metadata_test)
  target_link_libraries(status_metadata_test PRIVATE gmock_main ssl crypto)
  target_include_directories(status_metadata_test PRIVATE ${_gRPC_ROOT})

  target_compile_definitions(status_metadata_test PRIVATE -DPB_FIELD_16BIT)
  target_compile_definitions(status_metadata_test PUBLIC  -DGRPC_ALLOW_EXCEPTIONS=0)

  target_include_directories(status_metadata_test
  PRIVATE ${_gRPC_ROOT}
  PRIVATE ${_gRPC_ROOT}/include
  PRIVATE ${_gRPC_SSL_INCLUDE_DIR}
  PRIVATE ${_gRPC_BENCHMARK_INCLUDE_DIR}
  PRIVATE ${_gRPC_GFLAGS_INCLUDE_DIR}
  PRIVATE ${_gRPC_PROTOBUF_INCLUDE_DIR}
  PRIVATE ${_gRPC_NANOPB_INCLUDE_DIR}
  PRIVATE ${_gRPC_ADDRESS_SORTING_INCLUDE_DIR}
  PRIVATE ${_gRPC_GTEST_INCLUDE_DIR}
  PRIVATE ${_gRPC_PROTO_GENS_DIR}
)

  target_link_libraries(status_metadata_test PRIVATE
  ${_gRPC_PROTOBUF_LIBRARIES}
  ${_gRPC_ALLTARGETS_LIBRARIES}
  grpc
  ${_gRPC_GFLAGS_LIBRARIES}
)

    add_dependencies(status_metadata_test project_benchmark project_gflags)

  set(status_util_test_src
   ${_gRPC_ROOT}/test/core/channel/status_util_test.cc
)
  android_add_test(status_util_test)
  target_link_libraries(status_util_test PRIVATE gmock_main ssl crypto)
  target_include_directories(status_util_test PRIVATE ${_gRPC_ROOT})

  target_compile_definitions(status_util_test PRIVATE -DPB_FIELD_16BIT)
  target_compile_definitions(status_util_test PUBLIC  -DGRPC_ALLOW_EXCEPTIONS=0)

  target_include_directories(status_util_test
  PRIVATE ${_gRPC_ROOT}
  PRIVATE ${_gRPC_ROOT}/include
  PRIVATE ${_gRPC_SSL_INCLUDE_DIR}
  PRIVATE ${_gRPC_BENCHMARK_INCLUDE_DIR}
  PRIVATE ${_gRPC_GFLAGS_INCLUDE_DIR}
  PRIVATE ${_gRPC_PROTOBUF_INCLUDE_DIR}
  PRIVATE ${_gRPC_NANOPB_INCLUDE_DIR}
  PRIVATE ${_gRPC_ADDRESS_SORTING_INCLUDE_DIR}
  PRIVATE ${_gRPC_GTEST_INCLUDE_DIR}
  PRIVATE ${_gRPC_PROTO_GENS_DIR}
)

  target_link_libraries(status_util_test PRIVATE
  ${_gRPC_PROTOBUF_LIBRARIES}
  ${_gRPC_ALLTARGETS_LIBRARIES}
  grpc
  ${_gRPC_GFLAGS_LIBRARIES}
)

    add_dependencies(status_util_test project_benchmark project_gflags)
if(_gRPC_PLATFORM_LINUX OR _gRPC_PLATFORM_MAC OR _gRPC_PLATFORM_POSIX)

  set(streaming_throughput_test_src
   ${_gRPC_ROOT}/test/cpp/end2end/streaming_throughput_test.cc
)
  android_add_test(streaming_throughput_test)
  target_link_libraries(streaming_throughput_test PRIVATE gmock_main ssl crypto)
  target_include_directories(streaming_throughput_test PRIVATE ${_gRPC_ROOT})

  target_compile_definitions(streaming_throughput_test PRIVATE -DPB_FIELD_16BIT)
  target_compile_definitions(streaming_throughput_test PUBLIC  -DGRPC_ALLOW_EXCEPTIONS=0)

  target_include_directories(streaming_throughput_test
  PRIVATE ${_gRPC_ROOT}
  PRIVATE ${_gRPC_ROOT}/include
  PRIVATE ${_gRPC_SSL_INCLUDE_DIR}
  PRIVATE ${_gRPC_BENCHMARK_INCLUDE_DIR}
  PRIVATE ${_gRPC_GFLAGS_INCLUDE_DIR}
  PRIVATE ${_gRPC_PROTOBUF_INCLUDE_DIR}
  PRIVATE ${_gRPC_NANOPB_INCLUDE_DIR}
  PRIVATE ${_gRPC_ADDRESS_SORTING_INCLUDE_DIR}
  PRIVATE ${_gRPC_GTEST_INCLUDE_DIR}
  PRIVATE ${_gRPC_PROTO_GENS_DIR}
)

  target_link_libraries(streaming_throughput_test PRIVATE
  ${_gRPC_PROTOBUF_LIBRARIES}
  ${_gRPC_ALLTARGETS_LIBRARIES}
  grpc++_test_util
  grpc_test_util
  grpc++
  grpc
  gpr_test_util
  gpr
  ${_gRPC_GFLAGS_LIBRARIES}
)

    add_dependencies(streaming_throughput_test project_benchmark project_gflags)
endif()

  set(stress_test_src
          ${_gRPC_PROTO_GENS_DIR}/src/proto/grpc/testing/empty.pb.cc
          ${_gRPC_PROTO_GENS_DIR}/src/proto/grpc/testing/empty.grpc.pb.cc
          ${_gRPC_PROTO_GENS_DIR}/src/proto/grpc/testing/empty.pb.h
          ${_gRPC_PROTO_GENS_DIR}/src/proto/grpc/testing/empty.grpc.pb.h
          ${_gRPC_PROTO_GENS_DIR}/src/proto/grpc/testing/messages.pb.cc
          ${_gRPC_PROTO_GENS_DIR}/src/proto/grpc/testing/messages.grpc.pb.cc
          ${_gRPC_PROTO_GENS_DIR}/src/proto/grpc/testing/messages.pb.h
          ${_gRPC_PROTO_GENS_DIR}/src/proto/grpc/testing/messages.grpc.pb.h
          ${_gRPC_PROTO_GENS_DIR}/src/proto/grpc/testing/metrics.pb.cc
          ${_gRPC_PROTO_GENS_DIR}/src/proto/grpc/testing/metrics.grpc.pb.cc
          ${_gRPC_PROTO_GENS_DIR}/src/proto/grpc/testing/metrics.pb.h
          ${_gRPC_PROTO_GENS_DIR}/src/proto/grpc/testing/metrics.grpc.pb.h
          ${_gRPC_PROTO_GENS_DIR}/src/proto/grpc/testing/test.pb.cc
          ${_gRPC_PROTO_GENS_DIR}/src/proto/grpc/testing/test.grpc.pb.cc
          ${_gRPC_PROTO_GENS_DIR}/src/proto/grpc/testing/test.pb.h
          ${_gRPC_PROTO_GENS_DIR}/src/proto/grpc/testing/test.grpc.pb.h
   ${_gRPC_ROOT}/test/cpp/interop/interop_client.cc
   ${_gRPC_ROOT}/test/cpp/interop/stress_interop_client.cc
   ${_gRPC_ROOT}/test/cpp/interop/stress_test.cc
   ${_gRPC_ROOT}/test/cpp/util/metrics_server.cc
)
  android_add_test(stress_test)
  target_link_libraries(stress_test PRIVATE gmock_main ssl crypto)
  target_include_directories(stress_test PRIVATE ${_gRPC_ROOT})

  target_compile_definitions(stress_test PRIVATE -DPB_FIELD_16BIT)
  target_compile_definitions(stress_test PUBLIC  -DGRPC_ALLOW_EXCEPTIONS=0)
protobuf_generate_grpc_cpp(
  SOURCE_DIR ${_gRPC_ROOT}
  SOURCES ${_gRPC_ROOT}/src/proto/grpc/testing/empty.proto
)
protobuf_generate_grpc_cpp(
  SOURCE_DIR ${_gRPC_ROOT}
  SOURCES ${_gRPC_ROOT}/src/proto/grpc/testing/messages.proto
)
protobuf_generate_grpc_cpp(
  SOURCE_DIR ${_gRPC_ROOT}
  SOURCES ${_gRPC_ROOT}/src/proto/grpc/testing/metrics.proto
)
protobuf_generate_grpc_cpp(
  SOURCE_DIR ${_gRPC_ROOT}
  SOURCES ${_gRPC_ROOT}/src/proto/grpc/testing/test.proto
)

  target_include_directories(stress_test
  PRIVATE ${_gRPC_ROOT}
  PRIVATE ${_gRPC_ROOT}/include
  PRIVATE ${_gRPC_SSL_INCLUDE_DIR}
  PRIVATE ${_gRPC_BENCHMARK_INCLUDE_DIR}
  PRIVATE ${_gRPC_GFLAGS_INCLUDE_DIR}
  PRIVATE ${_gRPC_PROTOBUF_INCLUDE_DIR}
  PRIVATE ${_gRPC_NANOPB_INCLUDE_DIR}
  PRIVATE ${_gRPC_ADDRESS_SORTING_INCLUDE_DIR}
  PRIVATE ${_gRPC_GTEST_INCLUDE_DIR}
  PRIVATE ${_gRPC_PROTO_GENS_DIR}
)

  target_link_libraries(stress_test PRIVATE
  ${_gRPC_PROTOBUF_LIBRARIES}
  ${_gRPC_ALLTARGETS_LIBRARIES}
  grpc++_test_util
  grpc_test_util
  grpc++
  grpc
  gpr_test_util
  gpr
  grpc++_test_config
  ${_gRPC_GFLAGS_LIBRARIES}
)

    add_dependencies(stress_test project_benchmark project_gflags)

  set(thread_manager_test_src
   ${_gRPC_ROOT}/test/cpp/thread_manager/thread_manager_test.cc
)
  android_add_test(thread_manager_test)
  target_link_libraries(thread_manager_test PRIVATE gmock_main ssl crypto)
  target_include_directories(thread_manager_test PRIVATE ${_gRPC_ROOT})

  target_compile_definitions(thread_manager_test PRIVATE -DPB_FIELD_16BIT)
  target_compile_definitions(thread_manager_test PUBLIC  -DGRPC_ALLOW_EXCEPTIONS=0)

  target_include_directories(thread_manager_test
  PRIVATE ${_gRPC_ROOT}
  PRIVATE ${_gRPC_ROOT}/include
  PRIVATE ${_gRPC_SSL_INCLUDE_DIR}
  PRIVATE ${_gRPC_BENCHMARK_INCLUDE_DIR}
  PRIVATE ${_gRPC_GFLAGS_INCLUDE_DIR}
  PRIVATE ${_gRPC_PROTOBUF_INCLUDE_DIR}
  PRIVATE ${_gRPC_NANOPB_INCLUDE_DIR}
  PRIVATE ${_gRPC_ADDRESS_SORTING_INCLUDE_DIR}
  PRIVATE ${_gRPC_GTEST_INCLUDE_DIR}
  PRIVATE ${_gRPC_PROTO_GENS_DIR}
)

  target_link_libraries(thread_manager_test PRIVATE
  ${_gRPC_PROTOBUF_LIBRARIES}
  ${_gRPC_ALLTARGETS_LIBRARIES}
  grpc++_unsecure
  grpc_unsecure
  gpr
  grpc++_test_config
  ${_gRPC_GFLAGS_LIBRARIES}
)

    add_dependencies(thread_manager_test project_benchmark project_gflags)

  set(thread_stress_test_src
   ${_gRPC_ROOT}/test/cpp/end2end/thread_stress_test.cc
)
  android_add_test(thread_stress_test)
  target_link_libraries(thread_stress_test PRIVATE gmock_main ssl crypto)
  target_include_directories(thread_stress_test PRIVATE ${_gRPC_ROOT})

  target_compile_definitions(thread_stress_test PRIVATE -DPB_FIELD_16BIT)
  target_compile_definitions(thread_stress_test PUBLIC  -DGRPC_ALLOW_EXCEPTIONS=0)

  target_include_directories(thread_stress_test
  PRIVATE ${_gRPC_ROOT}
  PRIVATE ${_gRPC_ROOT}/include
  PRIVATE ${_gRPC_SSL_INCLUDE_DIR}
  PRIVATE ${_gRPC_BENCHMARK_INCLUDE_DIR}
  PRIVATE ${_gRPC_GFLAGS_INCLUDE_DIR}
  PRIVATE ${_gRPC_PROTOBUF_INCLUDE_DIR}
  PRIVATE ${_gRPC_NANOPB_INCLUDE_DIR}
  PRIVATE ${_gRPC_ADDRESS_SORTING_INCLUDE_DIR}
  PRIVATE ${_gRPC_GTEST_INCLUDE_DIR}
  PRIVATE ${_gRPC_PROTO_GENS_DIR}
)

  target_link_libraries(thread_stress_test PRIVATE
  ${_gRPC_PROTOBUF_LIBRARIES}
  ${_gRPC_ALLTARGETS_LIBRARIES}
  grpc++_test_util_unsecure
  grpc_test_util_unsecure
  grpc++_unsecure
  grpc_unsecure
  gpr_test_util
  gpr
  ${_gRPC_GFLAGS_LIBRARIES}
)

    add_dependencies(thread_stress_test project_benchmark project_gflags)

  set(transport_pid_controller_test_src
   ${_gRPC_ROOT}/test/core/transport/pid_controller_test.cc
)
  android_add_test(transport_pid_controller_test)
  target_link_libraries(transport_pid_controller_test PRIVATE gmock_main ssl crypto)
  target_include_directories(transport_pid_controller_test PRIVATE ${_gRPC_ROOT})

  target_compile_definitions(transport_pid_controller_test PRIVATE -DPB_FIELD_16BIT)
  target_compile_definitions(transport_pid_controller_test PUBLIC  -DGRPC_ALLOW_EXCEPTIONS=0)

  target_include_directories(transport_pid_controller_test
  PRIVATE ${_gRPC_ROOT}
  PRIVATE ${_gRPC_ROOT}/include
  PRIVATE ${_gRPC_SSL_INCLUDE_DIR}
  PRIVATE ${_gRPC_BENCHMARK_INCLUDE_DIR}
  PRIVATE ${_gRPC_GFLAGS_INCLUDE_DIR}
  PRIVATE ${_gRPC_PROTOBUF_INCLUDE_DIR}
  PRIVATE ${_gRPC_NANOPB_INCLUDE_DIR}
  PRIVATE ${_gRPC_ADDRESS_SORTING_INCLUDE_DIR}
  PRIVATE ${_gRPC_GTEST_INCLUDE_DIR}
  PRIVATE ${_gRPC_PROTO_GENS_DIR}
)

  target_link_libraries(transport_pid_controller_test PRIVATE
  ${_gRPC_PROTOBUF_LIBRARIES}
  ${_gRPC_ALLTARGETS_LIBRARIES}
  grpc++_test_util
  grpc++
  grpc_test_util
  grpc
  gpr_test_util
  gpr
  ${_gRPC_GFLAGS_LIBRARIES}
)

    add_dependencies(transport_pid_controller_test project_benchmark project_gflags)

  set(transport_security_common_api_test_src
   ${_gRPC_ROOT}/test/core/tsi/alts/handshaker/transport_security_common_api_test.cc
)
  android_add_test(transport_security_common_api_test)
  target_link_libraries(transport_security_common_api_test PRIVATE gmock_main ssl crypto)
  target_include_directories(transport_security_common_api_test PRIVATE ${_gRPC_ROOT})

  target_compile_definitions(transport_security_common_api_test PRIVATE -DPB_FIELD_16BIT)
  target_compile_definitions(transport_security_common_api_test PUBLIC  -DGRPC_ALLOW_EXCEPTIONS=0)

  target_include_directories(transport_security_common_api_test
  PRIVATE ${_gRPC_ROOT}
  PRIVATE ${_gRPC_ROOT}/include
  PRIVATE ${_gRPC_SSL_INCLUDE_DIR}
  PRIVATE ${_gRPC_BENCHMARK_INCLUDE_DIR}
  PRIVATE ${_gRPC_GFLAGS_INCLUDE_DIR}
  PRIVATE ${_gRPC_PROTOBUF_INCLUDE_DIR}
  PRIVATE ${_gRPC_NANOPB_INCLUDE_DIR}
  PRIVATE ${_gRPC_ADDRESS_SORTING_INCLUDE_DIR}
  PRIVATE ${_gRPC_GTEST_INCLUDE_DIR}
  PRIVATE ${_gRPC_PROTO_GENS_DIR}
)

  target_link_libraries(transport_security_common_api_test PRIVATE
  ${_gRPC_PROTOBUF_LIBRARIES}
  ${_gRPC_ALLTARGETS_LIBRARIES}
  alts_test_util
  gpr
  grpc
  ${_gRPC_GFLAGS_LIBRARIES}
)

    add_dependencies(transport_security_common_api_test project_benchmark project_gflags)
if(_gRPC_PLATFORM_LINUX OR _gRPC_PLATFORM_MAC OR _gRPC_PLATFORM_POSIX)

  set(writes_per_rpc_test_src
   ${_gRPC_ROOT}/test/cpp/performance/writes_per_rpc_test.cc
)
  android_add_test(writes_per_rpc_test)
  target_link_libraries(writes_per_rpc_test PRIVATE gmock_main ssl crypto)
  target_include_directories(writes_per_rpc_test PRIVATE ${_gRPC_ROOT})

  target_compile_definitions(writes_per_rpc_test PRIVATE -DPB_FIELD_16BIT)
  target_compile_definitions(writes_per_rpc_test PUBLIC  -DGRPC_ALLOW_EXCEPTIONS=0)

  target_include_directories(writes_per_rpc_test
  PRIVATE ${_gRPC_ROOT}
  PRIVATE ${_gRPC_ROOT}/include
  PRIVATE ${_gRPC_SSL_INCLUDE_DIR}
  PRIVATE ${_gRPC_BENCHMARK_INCLUDE_DIR}
  PRIVATE ${_gRPC_GFLAGS_INCLUDE_DIR}
  PRIVATE ${_gRPC_PROTOBUF_INCLUDE_DIR}
  PRIVATE ${_gRPC_NANOPB_INCLUDE_DIR}
  PRIVATE ${_gRPC_ADDRESS_SORTING_INCLUDE_DIR}
  PRIVATE ${_gRPC_GTEST_INCLUDE_DIR}
  PRIVATE ${_gRPC_PROTO_GENS_DIR}
)

  target_link_libraries(writes_per_rpc_test PRIVATE
  ${_gRPC_PROTOBUF_LIBRARIES}
  ${_gRPC_ALLTARGETS_LIBRARIES}
  grpc++_test_util
  grpc_test_util
  grpc++
  grpc
  gpr_test_util
  gpr
  ${_gRPC_GFLAGS_LIBRARIES}
)

    add_dependencies(writes_per_rpc_test project_benchmark project_gflags)
endif()

  set(public_headers_must_be_c89_src
   ${_gRPC_ROOT}/test/core/surface/public_headers_must_be_c89.c
)
  android_add_executable(public_headers_must_be_c89)

  target_compile_definitions(public_headers_must_be_c89 PRIVATE -DPB_FIELD_16BIT)
  target_compile_definitions(public_headers_must_be_c89 PUBLIC  -DGRPC_ALLOW_EXCEPTIONS=0)

  target_include_directories(public_headers_must_be_c89
  PRIVATE ${_gRPC_ROOT}
  PRIVATE ${_gRPC_ROOT}/include
  PRIVATE ${_gRPC_SSL_INCLUDE_DIR}
  PRIVATE ${_gRPC_BENCHMARK_INCLUDE_DIR}
  PRIVATE ${_gRPC_GFLAGS_INCLUDE_DIR}
  PRIVATE ${_gRPC_PROTOBUF_INCLUDE_DIR}
  PRIVATE ${_gRPC_NANOPB_INCLUDE_DIR}
  PRIVATE ${_gRPC_ADDRESS_SORTING_INCLUDE_DIR}
)

  target_link_libraries(public_headers_must_be_c89 PRIVATE
  ${_gRPC_ALLTARGETS_LIBRARIES}
  grpc
  gpr
)

    add_dependencies(public_headers_must_be_c89 project_benchmark project_gflags)

  set(badreq_bad_client_test_src
   ${_gRPC_ROOT}/test/core/bad_client/tests/badreq.cc
)
  android_add_executable(badreq_bad_client_test)

  target_compile_definitions(badreq_bad_client_test PRIVATE -DPB_FIELD_16BIT)
  target_compile_definitions(badreq_bad_client_test PUBLIC  -DGRPC_ALLOW_EXCEPTIONS=0)

  target_include_directories(badreq_bad_client_test
  PRIVATE ${_gRPC_ROOT}
  PRIVATE ${_gRPC_ROOT}/include
  PRIVATE ${_gRPC_SSL_INCLUDE_DIR}
  PRIVATE ${_gRPC_BENCHMARK_INCLUDE_DIR}
  PRIVATE ${_gRPC_GFLAGS_INCLUDE_DIR}
  PRIVATE ${_gRPC_PROTOBUF_INCLUDE_DIR}
  PRIVATE ${_gRPC_NANOPB_INCLUDE_DIR}
  PRIVATE ${_gRPC_ADDRESS_SORTING_INCLUDE_DIR}
)

  target_link_libraries(badreq_bad_client_test PRIVATE
  ssl
  crypto
  ${_gRPC_ALLTARGETS_LIBRARIES}
  bad_client_test
  grpc_test_util_unsecure
  grpc_unsecure
  gpr_test_util
  gpr
)

    add_dependencies(badreq_bad_client_test project_benchmark project_gflags)

  set(connection_prefix_bad_client_test_src
   ${_gRPC_ROOT}/test/core/bad_client/tests/connection_prefix.cc
)
  android_add_executable(connection_prefix_bad_client_test)

  target_compile_definitions(connection_prefix_bad_client_test PRIVATE -DPB_FIELD_16BIT)
  target_compile_definitions(connection_prefix_bad_client_test PUBLIC  -DGRPC_ALLOW_EXCEPTIONS=0)

  target_include_directories(connection_prefix_bad_client_test
  PRIVATE ${_gRPC_ROOT}
  PRIVATE ${_gRPC_ROOT}/include
  PRIVATE ${_gRPC_SSL_INCLUDE_DIR}
  PRIVATE ${_gRPC_BENCHMARK_INCLUDE_DIR}
  PRIVATE ${_gRPC_GFLAGS_INCLUDE_DIR}
  PRIVATE ${_gRPC_PROTOBUF_INCLUDE_DIR}
  PRIVATE ${_gRPC_NANOPB_INCLUDE_DIR}
  PRIVATE ${_gRPC_ADDRESS_SORTING_INCLUDE_DIR}
)

  target_link_libraries(connection_prefix_bad_client_test PRIVATE
  ssl
  crypto
  ${_gRPC_ALLTARGETS_LIBRARIES}
  bad_client_test
  grpc_test_util_unsecure
  grpc_unsecure
  gpr_test_util
  gpr
)

    add_dependencies(connection_prefix_bad_client_test project_benchmark project_gflags)

  set(duplicate_header_bad_client_test_src
   ${_gRPC_ROOT}/test/core/bad_client/tests/duplicate_header.cc
)
  android_add_executable(duplicate_header_bad_client_test)

  target_compile_definitions(duplicate_header_bad_client_test PRIVATE -DPB_FIELD_16BIT)
  target_compile_definitions(duplicate_header_bad_client_test PUBLIC  -DGRPC_ALLOW_EXCEPTIONS=0)

  target_include_directories(duplicate_header_bad_client_test
  PRIVATE ${_gRPC_ROOT}
  PRIVATE ${_gRPC_ROOT}/include
  PRIVATE ${_gRPC_SSL_INCLUDE_DIR}
  PRIVATE ${_gRPC_BENCHMARK_INCLUDE_DIR}
  PRIVATE ${_gRPC_GFLAGS_INCLUDE_DIR}
  PRIVATE ${_gRPC_PROTOBUF_INCLUDE_DIR}
  PRIVATE ${_gRPC_NANOPB_INCLUDE_DIR}
  PRIVATE ${_gRPC_ADDRESS_SORTING_INCLUDE_DIR}
)

  target_link_libraries(duplicate_header_bad_client_test PRIVATE
  ssl
  crypto
  ${_gRPC_ALLTARGETS_LIBRARIES}
  bad_client_test
  grpc_test_util_unsecure
  grpc_unsecure
  gpr_test_util
  gpr
)

    add_dependencies(duplicate_header_bad_client_test project_benchmark project_gflags)

  set(head_of_line_blocking_bad_client_test_src
   ${_gRPC_ROOT}/test/core/bad_client/tests/head_of_line_blocking.cc
)
  android_add_executable(head_of_line_blocking_bad_client_test)

  target_compile_definitions(head_of_line_blocking_bad_client_test PRIVATE -DPB_FIELD_16BIT)
  target_compile_definitions(head_of_line_blocking_bad_client_test PUBLIC  -DGRPC_ALLOW_EXCEPTIONS=0)

  target_include_directories(head_of_line_blocking_bad_client_test
  PRIVATE ${_gRPC_ROOT}
  PRIVATE ${_gRPC_ROOT}/include
  PRIVATE ${_gRPC_SSL_INCLUDE_DIR}
  PRIVATE ${_gRPC_BENCHMARK_INCLUDE_DIR}
  PRIVATE ${_gRPC_GFLAGS_INCLUDE_DIR}
  PRIVATE ${_gRPC_PROTOBUF_INCLUDE_DIR}
  PRIVATE ${_gRPC_NANOPB_INCLUDE_DIR}
  PRIVATE ${_gRPC_ADDRESS_SORTING_INCLUDE_DIR}
)

  target_link_libraries(head_of_line_blocking_bad_client_test PRIVATE
  ssl
  crypto
  ${_gRPC_ALLTARGETS_LIBRARIES}
  bad_client_test
  grpc_test_util_unsecure
  grpc_unsecure
  gpr_test_util
  gpr
)

    add_dependencies(head_of_line_blocking_bad_client_test project_benchmark project_gflags)

  set(headers_bad_client_test_src
   ${_gRPC_ROOT}/test/core/bad_client/tests/headers.cc
)
  android_add_executable(headers_bad_client_test)

  target_compile_definitions(headers_bad_client_test PRIVATE -DPB_FIELD_16BIT)
  target_compile_definitions(headers_bad_client_test PUBLIC  -DGRPC_ALLOW_EXCEPTIONS=0)

  target_include_directories(headers_bad_client_test
  PRIVATE ${_gRPC_ROOT}
  PRIVATE ${_gRPC_ROOT}/include
  PRIVATE ${_gRPC_SSL_INCLUDE_DIR}
  PRIVATE ${_gRPC_BENCHMARK_INCLUDE_DIR}
  PRIVATE ${_gRPC_GFLAGS_INCLUDE_DIR}
  PRIVATE ${_gRPC_PROTOBUF_INCLUDE_DIR}
  PRIVATE ${_gRPC_NANOPB_INCLUDE_DIR}
  PRIVATE ${_gRPC_ADDRESS_SORTING_INCLUDE_DIR}
)

  target_link_libraries(headers_bad_client_test PRIVATE
  ssl
  crypto
  ${_gRPC_ALLTARGETS_LIBRARIES}
  bad_client_test
  grpc_test_util_unsecure
  grpc_unsecure
  gpr_test_util
  gpr
)

    add_dependencies(headers_bad_client_test project_benchmark project_gflags)

  set(initial_settings_frame_bad_client_test_src
   ${_gRPC_ROOT}/test/core/bad_client/tests/initial_settings_frame.cc
)
  android_add_executable(initial_settings_frame_bad_client_test)

  target_compile_definitions(initial_settings_frame_bad_client_test PRIVATE -DPB_FIELD_16BIT)
  target_compile_definitions(initial_settings_frame_bad_client_test PUBLIC  -DGRPC_ALLOW_EXCEPTIONS=0)

  target_include_directories(initial_settings_frame_bad_client_test
  PRIVATE ${_gRPC_ROOT}
  PRIVATE ${_gRPC_ROOT}/include
  PRIVATE ${_gRPC_SSL_INCLUDE_DIR}
  PRIVATE ${_gRPC_BENCHMARK_INCLUDE_DIR}
  PRIVATE ${_gRPC_GFLAGS_INCLUDE_DIR}
  PRIVATE ${_gRPC_PROTOBUF_INCLUDE_DIR}
  PRIVATE ${_gRPC_NANOPB_INCLUDE_DIR}
  PRIVATE ${_gRPC_ADDRESS_SORTING_INCLUDE_DIR}
)

  target_link_libraries(initial_settings_frame_bad_client_test PRIVATE
  ssl
  crypto
  ${_gRPC_ALLTARGETS_LIBRARIES}
  bad_client_test
  grpc_test_util_unsecure
  grpc_unsecure
  gpr_test_util
  gpr
)

    add_dependencies(initial_settings_frame_bad_client_test project_benchmark project_gflags)

  set(large_metadata_bad_client_test_src
   ${_gRPC_ROOT}/test/core/bad_client/tests/large_metadata.cc
)
  android_add_executable(large_metadata_bad_client_test)

  target_compile_definitions(large_metadata_bad_client_test PRIVATE -DPB_FIELD_16BIT)
  target_compile_definitions(large_metadata_bad_client_test PUBLIC  -DGRPC_ALLOW_EXCEPTIONS=0)

  target_include_directories(large_metadata_bad_client_test
  PRIVATE ${_gRPC_ROOT}
  PRIVATE ${_gRPC_ROOT}/include
  PRIVATE ${_gRPC_SSL_INCLUDE_DIR}
  PRIVATE ${_gRPC_BENCHMARK_INCLUDE_DIR}
  PRIVATE ${_gRPC_GFLAGS_INCLUDE_DIR}
  PRIVATE ${_gRPC_PROTOBUF_INCLUDE_DIR}
  PRIVATE ${_gRPC_NANOPB_INCLUDE_DIR}
  PRIVATE ${_gRPC_ADDRESS_SORTING_INCLUDE_DIR}
)

  target_link_libraries(large_metadata_bad_client_test PRIVATE
  ssl
  crypto
  ${_gRPC_ALLTARGETS_LIBRARIES}
  bad_client_test
  grpc_test_util_unsecure
  grpc_unsecure
  gpr_test_util
  gpr
)

    add_dependencies(large_metadata_bad_client_test project_benchmark project_gflags)

  set(server_registered_method_bad_client_test_src
   ${_gRPC_ROOT}/test/core/bad_client/tests/server_registered_method.cc
)
  android_add_executable(server_registered_method_bad_client_test)

  target_compile_definitions(server_registered_method_bad_client_test PRIVATE -DPB_FIELD_16BIT)
  target_compile_definitions(server_registered_method_bad_client_test PUBLIC  -DGRPC_ALLOW_EXCEPTIONS=0)

  target_include_directories(server_registered_method_bad_client_test
  PRIVATE ${_gRPC_ROOT}
  PRIVATE ${_gRPC_ROOT}/include
  PRIVATE ${_gRPC_SSL_INCLUDE_DIR}
  PRIVATE ${_gRPC_BENCHMARK_INCLUDE_DIR}
  PRIVATE ${_gRPC_GFLAGS_INCLUDE_DIR}
  PRIVATE ${_gRPC_PROTOBUF_INCLUDE_DIR}
  PRIVATE ${_gRPC_NANOPB_INCLUDE_DIR}
  PRIVATE ${_gRPC_ADDRESS_SORTING_INCLUDE_DIR}
)

  target_link_libraries(server_registered_method_bad_client_test PRIVATE
  ssl
  crypto
  ${_gRPC_ALLTARGETS_LIBRARIES}
  bad_client_test
  grpc_test_util_unsecure
  grpc_unsecure
  gpr_test_util
  gpr
)

    add_dependencies(server_registered_method_bad_client_test project_benchmark project_gflags)

  set(simple_request_bad_client_test_src
   ${_gRPC_ROOT}/test/core/bad_client/tests/simple_request.cc
)
  android_add_executable(simple_request_bad_client_test)

  target_compile_definitions(simple_request_bad_client_test PRIVATE -DPB_FIELD_16BIT)
  target_compile_definitions(simple_request_bad_client_test PUBLIC  -DGRPC_ALLOW_EXCEPTIONS=0)

  target_include_directories(simple_request_bad_client_test
  PRIVATE ${_gRPC_ROOT}
  PRIVATE ${_gRPC_ROOT}/include
  PRIVATE ${_gRPC_SSL_INCLUDE_DIR}
  PRIVATE ${_gRPC_BENCHMARK_INCLUDE_DIR}
  PRIVATE ${_gRPC_GFLAGS_INCLUDE_DIR}
  PRIVATE ${_gRPC_PROTOBUF_INCLUDE_DIR}
  PRIVATE ${_gRPC_NANOPB_INCLUDE_DIR}
  PRIVATE ${_gRPC_ADDRESS_SORTING_INCLUDE_DIR}
)

  target_link_libraries(simple_request_bad_client_test PRIVATE
  ssl
  crypto
  ${_gRPC_ALLTARGETS_LIBRARIES}
  bad_client_test
  grpc_test_util_unsecure
  grpc_unsecure
  gpr_test_util
  gpr
)

    add_dependencies(simple_request_bad_client_test project_benchmark project_gflags)

  set(unknown_frame_bad_client_test_src
   ${_gRPC_ROOT}/test/core/bad_client/tests/unknown_frame.cc
)
  android_add_executable(unknown_frame_bad_client_test)

  target_compile_definitions(unknown_frame_bad_client_test PRIVATE -DPB_FIELD_16BIT)
  target_compile_definitions(unknown_frame_bad_client_test PUBLIC  -DGRPC_ALLOW_EXCEPTIONS=0)

  target_include_directories(unknown_frame_bad_client_test
  PRIVATE ${_gRPC_ROOT}
  PRIVATE ${_gRPC_ROOT}/include
  PRIVATE ${_gRPC_SSL_INCLUDE_DIR}
  PRIVATE ${_gRPC_BENCHMARK_INCLUDE_DIR}
  PRIVATE ${_gRPC_GFLAGS_INCLUDE_DIR}
  PRIVATE ${_gRPC_PROTOBUF_INCLUDE_DIR}
  PRIVATE ${_gRPC_NANOPB_INCLUDE_DIR}
  PRIVATE ${_gRPC_ADDRESS_SORTING_INCLUDE_DIR}
)

  target_link_libraries(unknown_frame_bad_client_test PRIVATE
  ssl
  crypto
  ${_gRPC_ALLTARGETS_LIBRARIES}
  bad_client_test
  grpc_test_util_unsecure
  grpc_unsecure
  gpr_test_util
  gpr
)

    add_dependencies(unknown_frame_bad_client_test project_benchmark project_gflags)

  set(window_overflow_bad_client_test_src
   ${_gRPC_ROOT}/test/core/bad_client/tests/window_overflow.cc
)
  android_add_executable(window_overflow_bad_client_test)

  target_compile_definitions(window_overflow_bad_client_test PRIVATE -DPB_FIELD_16BIT)
  target_compile_definitions(window_overflow_bad_client_test PUBLIC  -DGRPC_ALLOW_EXCEPTIONS=0)

  target_include_directories(window_overflow_bad_client_test
  PRIVATE ${_gRPC_ROOT}
  PRIVATE ${_gRPC_ROOT}/include
  PRIVATE ${_gRPC_SSL_INCLUDE_DIR}
  PRIVATE ${_gRPC_BENCHMARK_INCLUDE_DIR}
  PRIVATE ${_gRPC_GFLAGS_INCLUDE_DIR}
  PRIVATE ${_gRPC_PROTOBUF_INCLUDE_DIR}
  PRIVATE ${_gRPC_NANOPB_INCLUDE_DIR}
  PRIVATE ${_gRPC_ADDRESS_SORTING_INCLUDE_DIR}
)

  target_link_libraries(window_overflow_bad_client_test PRIVATE
  ssl
  crypto
  ${_gRPC_ALLTARGETS_LIBRARIES}
  bad_client_test
  grpc_test_util_unsecure
  grpc_unsecure
  gpr_test_util
  gpr
)

    add_dependencies(window_overflow_bad_client_test project_benchmark project_gflags)
if(_gRPC_PLATFORM_LINUX OR _gRPC_PLATFORM_MAC OR _gRPC_PLATFORM_POSIX)

  set(bad_ssl_cert_server_src
   ${_gRPC_ROOT}/test/core/bad_ssl/servers/cert.cc
)
  android_add_executable(bad_ssl_cert_server)

  target_compile_definitions(bad_ssl_cert_server PRIVATE -DPB_FIELD_16BIT)
  target_compile_definitions(bad_ssl_cert_server PUBLIC  -DGRPC_ALLOW_EXCEPTIONS=0)

  target_include_directories(bad_ssl_cert_server
  PRIVATE ${_gRPC_ROOT}
  PRIVATE ${_gRPC_ROOT}/include
  PRIVATE ${_gRPC_SSL_INCLUDE_DIR}
  PRIVATE ${_gRPC_BENCHMARK_INCLUDE_DIR}
  PRIVATE ${_gRPC_GFLAGS_INCLUDE_DIR}
  PRIVATE ${_gRPC_PROTOBUF_INCLUDE_DIR}
  PRIVATE ${_gRPC_NANOPB_INCLUDE_DIR}
  PRIVATE ${_gRPC_ADDRESS_SORTING_INCLUDE_DIR}
)

  target_link_libraries(bad_ssl_cert_server PRIVATE
  ${_gRPC_ALLTARGETS_LIBRARIES}
  bad_ssl_test_server
  grpc_test_util
  grpc
  gpr_test_util
  gpr
)

    add_dependencies(bad_ssl_cert_server project_benchmark project_gflags)
endif()
if(_gRPC_PLATFORM_LINUX OR _gRPC_PLATFORM_MAC OR _gRPC_PLATFORM_POSIX)

  set(bad_ssl_cert_test_src
   ${_gRPC_ROOT}/test/core/bad_ssl/bad_ssl_test.cc
)
  android_add_executable(bad_ssl_cert_test)

  target_compile_definitions(bad_ssl_cert_test PRIVATE -DPB_FIELD_16BIT)
  target_compile_definitions(bad_ssl_cert_test PUBLIC  -DGRPC_ALLOW_EXCEPTIONS=0)

  target_include_directories(bad_ssl_cert_test
  PRIVATE ${_gRPC_ROOT}
  PRIVATE ${_gRPC_ROOT}/include
  PRIVATE ${_gRPC_SSL_INCLUDE_DIR}
  PRIVATE ${_gRPC_BENCHMARK_INCLUDE_DIR}
  PRIVATE ${_gRPC_GFLAGS_INCLUDE_DIR}
  PRIVATE ${_gRPC_PROTOBUF_INCLUDE_DIR}
  PRIVATE ${_gRPC_NANOPB_INCLUDE_DIR}
  PRIVATE ${_gRPC_ADDRESS_SORTING_INCLUDE_DIR}
)

  target_link_libraries(bad_ssl_cert_test PRIVATE
  ${_gRPC_ALLTARGETS_LIBRARIES}
  grpc_test_util
  grpc
  gpr_test_util
  gpr
)

    add_dependencies(bad_ssl_cert_test project_benchmark project_gflags)
endif()

  set(h2_census_test_src
   ${_gRPC_ROOT}/test/core/end2end/fixtures/h2_census.cc
)
  android_add_executable(h2_census_test)

  target_compile_definitions(h2_census_test PRIVATE -DPB_FIELD_16BIT)
  target_compile_definitions(h2_census_test PUBLIC  -DGRPC_ALLOW_EXCEPTIONS=0)

  target_include_directories(h2_census_test
  PRIVATE ${_gRPC_ROOT}
  PRIVATE ${_gRPC_ROOT}/include
  PRIVATE ${_gRPC_SSL_INCLUDE_DIR}
  PRIVATE ${_gRPC_BENCHMARK_INCLUDE_DIR}
  PRIVATE ${_gRPC_GFLAGS_INCLUDE_DIR}
  PRIVATE ${_gRPC_PROTOBUF_INCLUDE_DIR}
  PRIVATE ${_gRPC_NANOPB_INCLUDE_DIR}
  PRIVATE ${_gRPC_ADDRESS_SORTING_INCLUDE_DIR}
)

  target_link_libraries(h2_census_test PRIVATE
  ${_gRPC_ALLTARGETS_LIBRARIES}
  end2end_tests
  grpc_test_util
  grpc
  gpr_test_util
  gpr
)

    add_dependencies(h2_census_test project_benchmark project_gflags)

  set(h2_compress_test_src
   ${_gRPC_ROOT}/test/core/end2end/fixtures/h2_compress.cc
)
  android_add_executable(h2_compress_test)

  target_compile_definitions(h2_compress_test PRIVATE -DPB_FIELD_16BIT)
  target_compile_definitions(h2_compress_test PUBLIC  -DGRPC_ALLOW_EXCEPTIONS=0)

  target_include_directories(h2_compress_test
  PRIVATE ${_gRPC_ROOT}
  PRIVATE ${_gRPC_ROOT}/include
  PRIVATE ${_gRPC_SSL_INCLUDE_DIR}
  PRIVATE ${_gRPC_BENCHMARK_INCLUDE_DIR}
  PRIVATE ${_gRPC_GFLAGS_INCLUDE_DIR}
  PRIVATE ${_gRPC_PROTOBUF_INCLUDE_DIR}
  PRIVATE ${_gRPC_NANOPB_INCLUDE_DIR}
  PRIVATE ${_gRPC_ADDRESS_SORTING_INCLUDE_DIR}
)

  target_link_libraries(h2_compress_test PRIVATE
  ${_gRPC_ALLTARGETS_LIBRARIES}
  end2end_tests
  grpc_test_util
  grpc
  gpr_test_util
  gpr
)

    add_dependencies(h2_compress_test project_benchmark project_gflags)

  set(h2_fakesec_test_src
   ${_gRPC_ROOT}/test/core/end2end/fixtures/h2_fakesec.cc
)
  android_add_executable(h2_fakesec_test)

  target_compile_definitions(h2_fakesec_test PRIVATE -DPB_FIELD_16BIT)
  target_compile_definitions(h2_fakesec_test PUBLIC  -DGRPC_ALLOW_EXCEPTIONS=0)

  target_include_directories(h2_fakesec_test
  PRIVATE ${_gRPC_ROOT}
  PRIVATE ${_gRPC_ROOT}/include
  PRIVATE ${_gRPC_SSL_INCLUDE_DIR}
  PRIVATE ${_gRPC_BENCHMARK_INCLUDE_DIR}
  PRIVATE ${_gRPC_GFLAGS_INCLUDE_DIR}
  PRIVATE ${_gRPC_PROTOBUF_INCLUDE_DIR}
  PRIVATE ${_gRPC_NANOPB_INCLUDE_DIR}
  PRIVATE ${_gRPC_ADDRESS_SORTING_INCLUDE_DIR}
)

  target_link_libraries(h2_fakesec_test PRIVATE
  ${_gRPC_ALLTARGETS_LIBRARIES}
  end2end_tests
  grpc_test_util
  grpc
  gpr_test_util
  gpr
)

    add_dependencies(h2_fakesec_test project_benchmark project_gflags)
if(_gRPC_PLATFORM_LINUX OR _gRPC_PLATFORM_MAC OR _gRPC_PLATFORM_POSIX)

  set(h2_fd_test_src
   ${_gRPC_ROOT}/test/core/end2end/fixtures/h2_fd.cc
)
  android_add_executable(h2_fd_test)

  target_compile_definitions(h2_fd_test PRIVATE -DPB_FIELD_16BIT)
  target_compile_definitions(h2_fd_test PUBLIC  -DGRPC_ALLOW_EXCEPTIONS=0)

  target_include_directories(h2_fd_test
  PRIVATE ${_gRPC_ROOT}
  PRIVATE ${_gRPC_ROOT}/include
  PRIVATE ${_gRPC_SSL_INCLUDE_DIR}
  PRIVATE ${_gRPC_BENCHMARK_INCLUDE_DIR}
  PRIVATE ${_gRPC_GFLAGS_INCLUDE_DIR}
  PRIVATE ${_gRPC_PROTOBUF_INCLUDE_DIR}
  PRIVATE ${_gRPC_NANOPB_INCLUDE_DIR}
  PRIVATE ${_gRPC_ADDRESS_SORTING_INCLUDE_DIR}
)

  target_link_libraries(h2_fd_test PRIVATE
  ${_gRPC_ALLTARGETS_LIBRARIES}
  end2end_tests
  grpc_test_util
  grpc
  gpr_test_util
  gpr
)

    add_dependencies(h2_fd_test project_benchmark project_gflags)
endif()

  set(h2_full_test_src
   ${_gRPC_ROOT}/test/core/end2end/fixtures/h2_full.cc
)
  android_add_executable(h2_full_test)

  target_compile_definitions(h2_full_test PRIVATE -DPB_FIELD_16BIT)
  target_compile_definitions(h2_full_test PUBLIC  -DGRPC_ALLOW_EXCEPTIONS=0)

  target_include_directories(h2_full_test
  PRIVATE ${_gRPC_ROOT}
  PRIVATE ${_gRPC_ROOT}/include
  PRIVATE ${_gRPC_SSL_INCLUDE_DIR}
  PRIVATE ${_gRPC_BENCHMARK_INCLUDE_DIR}
  PRIVATE ${_gRPC_GFLAGS_INCLUDE_DIR}
  PRIVATE ${_gRPC_PROTOBUF_INCLUDE_DIR}
  PRIVATE ${_gRPC_NANOPB_INCLUDE_DIR}
  PRIVATE ${_gRPC_ADDRESS_SORTING_INCLUDE_DIR}
)

  target_link_libraries(h2_full_test PRIVATE
  ${_gRPC_ALLTARGETS_LIBRARIES}
  end2end_tests
  grpc_test_util
  grpc
  gpr_test_util
  gpr
)

    add_dependencies(h2_full_test project_benchmark project_gflags)
if(_gRPC_PLATFORM_LINUX)

  set(h2_full+pipe_test_src
   ${_gRPC_ROOT}/test/core/end2end/fixtures/h2_full+pipe.cc
)
  android_add_executable(h2_full+pipe_test)

  target_compile_definitions(h2_full+pipe_test PRIVATE -DPB_FIELD_16BIT)
  target_compile_definitions(h2_full+pipe_test PUBLIC  -DGRPC_ALLOW_EXCEPTIONS=0)

  target_include_directories(h2_full+pipe_test
  PRIVATE ${_gRPC_ROOT}
  PRIVATE ${_gRPC_ROOT}/include
  PRIVATE ${_gRPC_SSL_INCLUDE_DIR}
  PRIVATE ${_gRPC_BENCHMARK_INCLUDE_DIR}
  PRIVATE ${_gRPC_GFLAGS_INCLUDE_DIR}
  PRIVATE ${_gRPC_PROTOBUF_INCLUDE_DIR}
  PRIVATE ${_gRPC_NANOPB_INCLUDE_DIR}
  PRIVATE ${_gRPC_ADDRESS_SORTING_INCLUDE_DIR}
)

  target_link_libraries(h2_full+pipe_test PRIVATE
  ${_gRPC_ALLTARGETS_LIBRARIES}
  end2end_tests
  grpc_test_util
  grpc
  gpr_test_util
  gpr
)

    add_dependencies(h2_full+pipe_test project_benchmark project_gflags)
endif()

  set(h2_full+trace_test_src
   ${_gRPC_ROOT}/test/core/end2end/fixtures/h2_full+trace.cc
)
  android_add_executable(h2_full+trace_test)

  target_compile_definitions(h2_full+trace_test PRIVATE -DPB_FIELD_16BIT)
  target_compile_definitions(h2_full+trace_test PUBLIC  -DGRPC_ALLOW_EXCEPTIONS=0)

  target_include_directories(h2_full+trace_test
  PRIVATE ${_gRPC_ROOT}
  PRIVATE ${_gRPC_ROOT}/include
  PRIVATE ${_gRPC_SSL_INCLUDE_DIR}
  PRIVATE ${_gRPC_BENCHMARK_INCLUDE_DIR}
  PRIVATE ${_gRPC_GFLAGS_INCLUDE_DIR}
  PRIVATE ${_gRPC_PROTOBUF_INCLUDE_DIR}
  PRIVATE ${_gRPC_NANOPB_INCLUDE_DIR}
  PRIVATE ${_gRPC_ADDRESS_SORTING_INCLUDE_DIR}
)

  target_link_libraries(h2_full+trace_test PRIVATE
  ${_gRPC_ALLTARGETS_LIBRARIES}
  end2end_tests
  grpc_test_util
  grpc
  gpr_test_util
  gpr
)

    add_dependencies(h2_full+trace_test project_benchmark project_gflags)

  set(h2_full+workarounds_test_src
   ${_gRPC_ROOT}/test/core/end2end/fixtures/h2_full+workarounds.cc
)
  android_add_executable(h2_full+workarounds_test)

  target_compile_definitions(h2_full+workarounds_test PRIVATE -DPB_FIELD_16BIT)
  target_compile_definitions(h2_full+workarounds_test PUBLIC  -DGRPC_ALLOW_EXCEPTIONS=0)

  target_include_directories(h2_full+workarounds_test
  PRIVATE ${_gRPC_ROOT}
  PRIVATE ${_gRPC_ROOT}/include
  PRIVATE ${_gRPC_SSL_INCLUDE_DIR}
  PRIVATE ${_gRPC_BENCHMARK_INCLUDE_DIR}
  PRIVATE ${_gRPC_GFLAGS_INCLUDE_DIR}
  PRIVATE ${_gRPC_PROTOBUF_INCLUDE_DIR}
  PRIVATE ${_gRPC_NANOPB_INCLUDE_DIR}
  PRIVATE ${_gRPC_ADDRESS_SORTING_INCLUDE_DIR}
)

  target_link_libraries(h2_full+workarounds_test PRIVATE
  ${_gRPC_ALLTARGETS_LIBRARIES}
  end2end_tests
  grpc_test_util
  grpc
  gpr_test_util
  gpr
)

    add_dependencies(h2_full+workarounds_test project_benchmark project_gflags)

  set(h2_http_proxy_test_src
   ${_gRPC_ROOT}/test/core/end2end/fixtures/h2_http_proxy.cc
)
  android_add_executable(h2_http_proxy_test)

  target_compile_definitions(h2_http_proxy_test PRIVATE -DPB_FIELD_16BIT)
  target_compile_definitions(h2_http_proxy_test PUBLIC  -DGRPC_ALLOW_EXCEPTIONS=0)

  target_include_directories(h2_http_proxy_test
  PRIVATE ${_gRPC_ROOT}
  PRIVATE ${_gRPC_ROOT}/include
  PRIVATE ${_gRPC_SSL_INCLUDE_DIR}
  PRIVATE ${_gRPC_BENCHMARK_INCLUDE_DIR}
  PRIVATE ${_gRPC_GFLAGS_INCLUDE_DIR}
  PRIVATE ${_gRPC_PROTOBUF_INCLUDE_DIR}
  PRIVATE ${_gRPC_NANOPB_INCLUDE_DIR}
  PRIVATE ${_gRPC_ADDRESS_SORTING_INCLUDE_DIR}
)

  target_link_libraries(h2_http_proxy_test PRIVATE
  ${_gRPC_ALLTARGETS_LIBRARIES}
  end2end_tests
  grpc_test_util
  grpc
  gpr_test_util
  gpr
)

    add_dependencies(h2_http_proxy_test project_benchmark project_gflags)
if(_gRPC_PLATFORM_LINUX OR _gRPC_PLATFORM_MAC OR _gRPC_PLATFORM_POSIX)

  set(h2_local_test_src
   ${_gRPC_ROOT}/test/core/end2end/fixtures/h2_local.cc
)
  android_add_executable(h2_local_test)

  target_compile_definitions(h2_local_test PRIVATE -DPB_FIELD_16BIT)
  target_compile_definitions(h2_local_test PUBLIC  -DGRPC_ALLOW_EXCEPTIONS=0)

  target_include_directories(h2_local_test
  PRIVATE ${_gRPC_ROOT}
  PRIVATE ${_gRPC_ROOT}/include
  PRIVATE ${_gRPC_SSL_INCLUDE_DIR}
  PRIVATE ${_gRPC_BENCHMARK_INCLUDE_DIR}
  PRIVATE ${_gRPC_GFLAGS_INCLUDE_DIR}
  PRIVATE ${_gRPC_PROTOBUF_INCLUDE_DIR}
  PRIVATE ${_gRPC_NANOPB_INCLUDE_DIR}
  PRIVATE ${_gRPC_ADDRESS_SORTING_INCLUDE_DIR}
)

  target_link_libraries(h2_local_test PRIVATE
  ${_gRPC_ALLTARGETS_LIBRARIES}
  end2end_tests
  grpc_test_util
  grpc
  gpr_test_util
  gpr
)

    add_dependencies(h2_local_test project_benchmark project_gflags)
endif()

  set(h2_oauth2_test_src
   ${_gRPC_ROOT}/test/core/end2end/fixtures/h2_oauth2.cc
)
  android_add_executable(h2_oauth2_test)

  target_compile_definitions(h2_oauth2_test PRIVATE -DPB_FIELD_16BIT)
  target_compile_definitions(h2_oauth2_test PUBLIC  -DGRPC_ALLOW_EXCEPTIONS=0)

  target_include_directories(h2_oauth2_test
  PRIVATE ${_gRPC_ROOT}
  PRIVATE ${_gRPC_ROOT}/include
  PRIVATE ${_gRPC_SSL_INCLUDE_DIR}
  PRIVATE ${_gRPC_BENCHMARK_INCLUDE_DIR}
  PRIVATE ${_gRPC_GFLAGS_INCLUDE_DIR}
  PRIVATE ${_gRPC_PROTOBUF_INCLUDE_DIR}
  PRIVATE ${_gRPC_NANOPB_INCLUDE_DIR}
  PRIVATE ${_gRPC_ADDRESS_SORTING_INCLUDE_DIR}
)

  target_link_libraries(h2_oauth2_test PRIVATE
  ${_gRPC_ALLTARGETS_LIBRARIES}
  end2end_tests
  grpc_test_util
  grpc
  gpr_test_util
  gpr
)

    add_dependencies(h2_oauth2_test project_benchmark project_gflags)

  set(h2_proxy_test_src
   ${_gRPC_ROOT}/test/core/end2end/fixtures/h2_proxy.cc
)
  android_add_executable(h2_proxy_test)

  target_compile_definitions(h2_proxy_test PRIVATE -DPB_FIELD_16BIT)
  target_compile_definitions(h2_proxy_test PUBLIC  -DGRPC_ALLOW_EXCEPTIONS=0)

  target_include_directories(h2_proxy_test
  PRIVATE ${_gRPC_ROOT}
  PRIVATE ${_gRPC_ROOT}/include
  PRIVATE ${_gRPC_SSL_INCLUDE_DIR}
  PRIVATE ${_gRPC_BENCHMARK_INCLUDE_DIR}
  PRIVATE ${_gRPC_GFLAGS_INCLUDE_DIR}
  PRIVATE ${_gRPC_PROTOBUF_INCLUDE_DIR}
  PRIVATE ${_gRPC_NANOPB_INCLUDE_DIR}
  PRIVATE ${_gRPC_ADDRESS_SORTING_INCLUDE_DIR}
)

  target_link_libraries(h2_proxy_test PRIVATE
  ${_gRPC_ALLTARGETS_LIBRARIES}
  end2end_tests
  grpc_test_util
  grpc
  gpr_test_util
  gpr
)

    add_dependencies(h2_proxy_test project_benchmark project_gflags)

  set(h2_sockpair_test_src
   ${_gRPC_ROOT}/test/core/end2end/fixtures/h2_sockpair.cc
)
  android_add_executable(h2_sockpair_test)

  target_compile_definitions(h2_sockpair_test PRIVATE -DPB_FIELD_16BIT)
  target_compile_definitions(h2_sockpair_test PUBLIC  -DGRPC_ALLOW_EXCEPTIONS=0)

  target_include_directories(h2_sockpair_test
  PRIVATE ${_gRPC_ROOT}
  PRIVATE ${_gRPC_ROOT}/include
  PRIVATE ${_gRPC_SSL_INCLUDE_DIR}
  PRIVATE ${_gRPC_BENCHMARK_INCLUDE_DIR}
  PRIVATE ${_gRPC_GFLAGS_INCLUDE_DIR}
  PRIVATE ${_gRPC_PROTOBUF_INCLUDE_DIR}
  PRIVATE ${_gRPC_NANOPB_INCLUDE_DIR}
  PRIVATE ${_gRPC_ADDRESS_SORTING_INCLUDE_DIR}
)

  target_link_libraries(h2_sockpair_test PRIVATE
  ${_gRPC_ALLTARGETS_LIBRARIES}
  end2end_tests
  grpc_test_util
  grpc
  gpr_test_util
  gpr
)

    add_dependencies(h2_sockpair_test project_benchmark project_gflags)

  set(h2_sockpair+trace_test_src
   ${_gRPC_ROOT}/test/core/end2end/fixtures/h2_sockpair+trace.cc
)
  android_add_executable(h2_sockpair+trace_test)

  target_compile_definitions(h2_sockpair+trace_test PRIVATE -DPB_FIELD_16BIT)
  target_compile_definitions(h2_sockpair+trace_test PUBLIC  -DGRPC_ALLOW_EXCEPTIONS=0)

  target_include_directories(h2_sockpair+trace_test
  PRIVATE ${_gRPC_ROOT}
  PRIVATE ${_gRPC_ROOT}/include
  PRIVATE ${_gRPC_SSL_INCLUDE_DIR}
  PRIVATE ${_gRPC_BENCHMARK_INCLUDE_DIR}
  PRIVATE ${_gRPC_GFLAGS_INCLUDE_DIR}
  PRIVATE ${_gRPC_PROTOBUF_INCLUDE_DIR}
  PRIVATE ${_gRPC_NANOPB_INCLUDE_DIR}
  PRIVATE ${_gRPC_ADDRESS_SORTING_INCLUDE_DIR}
)

  target_link_libraries(h2_sockpair+trace_test PRIVATE
  ${_gRPC_ALLTARGETS_LIBRARIES}
  end2end_tests
  grpc_test_util
  grpc
  gpr_test_util
  gpr
)

    add_dependencies(h2_sockpair+trace_test project_benchmark project_gflags)

  set(h2_sockpair_1byte_test_src
   ${_gRPC_ROOT}/test/core/end2end/fixtures/h2_sockpair_1byte.cc
)
  android_add_executable(h2_sockpair_1byte_test)

  target_compile_definitions(h2_sockpair_1byte_test PRIVATE -DPB_FIELD_16BIT)
  target_compile_definitions(h2_sockpair_1byte_test PUBLIC  -DGRPC_ALLOW_EXCEPTIONS=0)

  target_include_directories(h2_sockpair_1byte_test
  PRIVATE ${_gRPC_ROOT}
  PRIVATE ${_gRPC_ROOT}/include
  PRIVATE ${_gRPC_SSL_INCLUDE_DIR}
  PRIVATE ${_gRPC_BENCHMARK_INCLUDE_DIR}
  PRIVATE ${_gRPC_GFLAGS_INCLUDE_DIR}
  PRIVATE ${_gRPC_PROTOBUF_INCLUDE_DIR}
  PRIVATE ${_gRPC_NANOPB_INCLUDE_DIR}
  PRIVATE ${_gRPC_ADDRESS_SORTING_INCLUDE_DIR}
)

  target_link_libraries(h2_sockpair_1byte_test PRIVATE
  ${_gRPC_ALLTARGETS_LIBRARIES}
  end2end_tests
  grpc_test_util
  grpc
  gpr_test_util
  gpr
)

    add_dependencies(h2_sockpair_1byte_test project_benchmark project_gflags)

  set(h2_ssl_test_src
   ${_gRPC_ROOT}/test/core/end2end/fixtures/h2_ssl.cc
)
  android_add_executable(h2_ssl_test)

  target_compile_definitions(h2_ssl_test PRIVATE -DPB_FIELD_16BIT)
  target_compile_definitions(h2_ssl_test PUBLIC  -DGRPC_ALLOW_EXCEPTIONS=0)

  target_include_directories(h2_ssl_test
  PRIVATE ${_gRPC_ROOT}
  PRIVATE ${_gRPC_ROOT}/include
  PRIVATE ${_gRPC_SSL_INCLUDE_DIR}
  PRIVATE ${_gRPC_BENCHMARK_INCLUDE_DIR}
  PRIVATE ${_gRPC_GFLAGS_INCLUDE_DIR}
  PRIVATE ${_gRPC_PROTOBUF_INCLUDE_DIR}
  PRIVATE ${_gRPC_NANOPB_INCLUDE_DIR}
  PRIVATE ${_gRPC_ADDRESS_SORTING_INCLUDE_DIR}
)

  target_link_libraries(h2_ssl_test PRIVATE
  ${_gRPC_ALLTARGETS_LIBRARIES}
  end2end_tests
  grpc_test_util
  grpc
  gpr_test_util
  gpr
)

    add_dependencies(h2_ssl_test project_benchmark project_gflags)

  set(h2_ssl_proxy_test_src
   ${_gRPC_ROOT}/test/core/end2end/fixtures/h2_ssl_proxy.cc
)
  android_add_executable(h2_ssl_proxy_test)

  target_compile_definitions(h2_ssl_proxy_test PRIVATE -DPB_FIELD_16BIT)
  target_compile_definitions(h2_ssl_proxy_test PUBLIC  -DGRPC_ALLOW_EXCEPTIONS=0)

  target_include_directories(h2_ssl_proxy_test
  PRIVATE ${_gRPC_ROOT}
  PRIVATE ${_gRPC_ROOT}/include
  PRIVATE ${_gRPC_SSL_INCLUDE_DIR}
  PRIVATE ${_gRPC_BENCHMARK_INCLUDE_DIR}
  PRIVATE ${_gRPC_GFLAGS_INCLUDE_DIR}
  PRIVATE ${_gRPC_PROTOBUF_INCLUDE_DIR}
  PRIVATE ${_gRPC_NANOPB_INCLUDE_DIR}
  PRIVATE ${_gRPC_ADDRESS_SORTING_INCLUDE_DIR}
)

  target_link_libraries(h2_ssl_proxy_test PRIVATE
  ${_gRPC_ALLTARGETS_LIBRARIES}
  end2end_tests
  grpc_test_util
  grpc
  gpr_test_util
  gpr
)

    add_dependencies(h2_ssl_proxy_test project_benchmark project_gflags)
if(_gRPC_PLATFORM_LINUX OR _gRPC_PLATFORM_MAC OR _gRPC_PLATFORM_POSIX)

  set(h2_uds_test_src
   ${_gRPC_ROOT}/test/core/end2end/fixtures/h2_uds.cc
)
  android_add_executable(h2_uds_test)

  target_compile_definitions(h2_uds_test PRIVATE -DPB_FIELD_16BIT)
  target_compile_definitions(h2_uds_test PUBLIC  -DGRPC_ALLOW_EXCEPTIONS=0)

  target_include_directories(h2_uds_test
  PRIVATE ${_gRPC_ROOT}
  PRIVATE ${_gRPC_ROOT}/include
  PRIVATE ${_gRPC_SSL_INCLUDE_DIR}
  PRIVATE ${_gRPC_BENCHMARK_INCLUDE_DIR}
  PRIVATE ${_gRPC_GFLAGS_INCLUDE_DIR}
  PRIVATE ${_gRPC_PROTOBUF_INCLUDE_DIR}
  PRIVATE ${_gRPC_NANOPB_INCLUDE_DIR}
  PRIVATE ${_gRPC_ADDRESS_SORTING_INCLUDE_DIR}
)

  target_link_libraries(h2_uds_test PRIVATE
  ${_gRPC_ALLTARGETS_LIBRARIES}
  end2end_tests
  grpc_test_util
  grpc
  gpr_test_util
  gpr
)

    add_dependencies(h2_uds_test project_benchmark project_gflags)
endif()

  set(inproc_test_src
   ${_gRPC_ROOT}/test/core/end2end/fixtures/inproc.cc
)
  android_add_executable(inproc_test)

  target_compile_definitions(inproc_test PRIVATE -DPB_FIELD_16BIT)
  target_compile_definitions(inproc_test PUBLIC  -DGRPC_ALLOW_EXCEPTIONS=0)

  target_include_directories(inproc_test
  PRIVATE ${_gRPC_ROOT}
  PRIVATE ${_gRPC_ROOT}/include
  PRIVATE ${_gRPC_SSL_INCLUDE_DIR}
  PRIVATE ${_gRPC_BENCHMARK_INCLUDE_DIR}
  PRIVATE ${_gRPC_GFLAGS_INCLUDE_DIR}
  PRIVATE ${_gRPC_PROTOBUF_INCLUDE_DIR}
  PRIVATE ${_gRPC_NANOPB_INCLUDE_DIR}
  PRIVATE ${_gRPC_ADDRESS_SORTING_INCLUDE_DIR}
)

  target_link_libraries(inproc_test PRIVATE
  ${_gRPC_ALLTARGETS_LIBRARIES}
  end2end_tests
  grpc_test_util
  grpc
  gpr_test_util
  gpr
)

    add_dependencies(inproc_test project_benchmark project_gflags)

  set(h2_census_nosec_test_src
   ${_gRPC_ROOT}/test/core/end2end/fixtures/h2_census.cc
)
  android_add_executable(h2_census_nosec_test)

  target_compile_definitions(h2_census_nosec_test PRIVATE -DPB_FIELD_16BIT)
  target_compile_definitions(h2_census_nosec_test PUBLIC  -DGRPC_ALLOW_EXCEPTIONS=0)

  target_include_directories(h2_census_nosec_test
  PRIVATE ${_gRPC_ROOT}
  PRIVATE ${_gRPC_ROOT}/include
  PRIVATE ${_gRPC_SSL_INCLUDE_DIR}
  PRIVATE ${_gRPC_BENCHMARK_INCLUDE_DIR}
  PRIVATE ${_gRPC_GFLAGS_INCLUDE_DIR}
  PRIVATE ${_gRPC_PROTOBUF_INCLUDE_DIR}
  PRIVATE ${_gRPC_NANOPB_INCLUDE_DIR}
  PRIVATE ${_gRPC_ADDRESS_SORTING_INCLUDE_DIR}
)

  target_link_libraries(h2_census_nosec_test PRIVATE
  ${_gRPC_ALLTARGETS_LIBRARIES}
  end2end_nosec_tests
  grpc_test_util_unsecure
  grpc_unsecure
  gpr_test_util
  gpr
)

    add_dependencies(h2_census_nosec_test project_benchmark project_gflags)

  set(h2_compress_nosec_test_src
   ${_gRPC_ROOT}/test/core/end2end/fixtures/h2_compress.cc
)
  android_add_executable(h2_compress_nosec_test)

  target_compile_definitions(h2_compress_nosec_test PRIVATE -DPB_FIELD_16BIT)
  target_compile_definitions(h2_compress_nosec_test PUBLIC  -DGRPC_ALLOW_EXCEPTIONS=0)

  target_include_directories(h2_compress_nosec_test
  PRIVATE ${_gRPC_ROOT}
  PRIVATE ${_gRPC_ROOT}/include
  PRIVATE ${_gRPC_SSL_INCLUDE_DIR}
  PRIVATE ${_gRPC_BENCHMARK_INCLUDE_DIR}
  PRIVATE ${_gRPC_GFLAGS_INCLUDE_DIR}
  PRIVATE ${_gRPC_PROTOBUF_INCLUDE_DIR}
  PRIVATE ${_gRPC_NANOPB_INCLUDE_DIR}
  PRIVATE ${_gRPC_ADDRESS_SORTING_INCLUDE_DIR}
)

  target_link_libraries(h2_compress_nosec_test PRIVATE
  ${_gRPC_ALLTARGETS_LIBRARIES}
  end2end_nosec_tests
  grpc_test_util_unsecure
  grpc_unsecure
  gpr_test_util
  gpr
)

    add_dependencies(h2_compress_nosec_test project_benchmark project_gflags)
if(_gRPC_PLATFORM_LINUX OR _gRPC_PLATFORM_MAC OR _gRPC_PLATFORM_POSIX)

  set(h2_fd_nosec_test_src
   ${_gRPC_ROOT}/test/core/end2end/fixtures/h2_fd.cc
)
  android_add_executable(h2_fd_nosec_test)

  target_compile_definitions(h2_fd_nosec_test PRIVATE -DPB_FIELD_16BIT)
  target_compile_definitions(h2_fd_nosec_test PUBLIC  -DGRPC_ALLOW_EXCEPTIONS=0)

  target_include_directories(h2_fd_nosec_test
  PRIVATE ${_gRPC_ROOT}
  PRIVATE ${_gRPC_ROOT}/include
  PRIVATE ${_gRPC_SSL_INCLUDE_DIR}
  PRIVATE ${_gRPC_BENCHMARK_INCLUDE_DIR}
  PRIVATE ${_gRPC_GFLAGS_INCLUDE_DIR}
  PRIVATE ${_gRPC_PROTOBUF_INCLUDE_DIR}
  PRIVATE ${_gRPC_NANOPB_INCLUDE_DIR}
  PRIVATE ${_gRPC_ADDRESS_SORTING_INCLUDE_DIR}
)

  target_link_libraries(h2_fd_nosec_test PRIVATE
  ${_gRPC_ALLTARGETS_LIBRARIES}
  end2end_nosec_tests
  grpc_test_util_unsecure
  grpc_unsecure
  gpr_test_util
  gpr
)

    add_dependencies(h2_fd_nosec_test project_benchmark project_gflags)
endif()

  set(h2_full_nosec_test_src
   ${_gRPC_ROOT}/test/core/end2end/fixtures/h2_full.cc
)
  android_add_executable(h2_full_nosec_test)

  target_compile_definitions(h2_full_nosec_test PRIVATE -DPB_FIELD_16BIT)
  target_compile_definitions(h2_full_nosec_test PUBLIC  -DGRPC_ALLOW_EXCEPTIONS=0)

  target_include_directories(h2_full_nosec_test
  PRIVATE ${_gRPC_ROOT}
  PRIVATE ${_gRPC_ROOT}/include
  PRIVATE ${_gRPC_SSL_INCLUDE_DIR}
  PRIVATE ${_gRPC_BENCHMARK_INCLUDE_DIR}
  PRIVATE ${_gRPC_GFLAGS_INCLUDE_DIR}
  PRIVATE ${_gRPC_PROTOBUF_INCLUDE_DIR}
  PRIVATE ${_gRPC_NANOPB_INCLUDE_DIR}
  PRIVATE ${_gRPC_ADDRESS_SORTING_INCLUDE_DIR}
)

  target_link_libraries(h2_full_nosec_test PRIVATE
  ${_gRPC_ALLTARGETS_LIBRARIES}
  end2end_nosec_tests
  grpc_test_util_unsecure
  grpc_unsecure
  gpr_test_util
  gpr
)

    add_dependencies(h2_full_nosec_test project_benchmark project_gflags)
if(_gRPC_PLATFORM_LINUX)

  set(h2_full+pipe_nosec_test_src
   ${_gRPC_ROOT}/test/core/end2end/fixtures/h2_full+pipe.cc
)
  android_add_executable(h2_full+pipe_nosec_test)

  target_compile_definitions(h2_full+pipe_nosec_test PRIVATE -DPB_FIELD_16BIT)
  target_compile_definitions(h2_full+pipe_nosec_test PUBLIC  -DGRPC_ALLOW_EXCEPTIONS=0)

  target_include_directories(h2_full+pipe_nosec_test
  PRIVATE ${_gRPC_ROOT}
  PRIVATE ${_gRPC_ROOT}/include
  PRIVATE ${_gRPC_SSL_INCLUDE_DIR}
  PRIVATE ${_gRPC_BENCHMARK_INCLUDE_DIR}
  PRIVATE ${_gRPC_GFLAGS_INCLUDE_DIR}
  PRIVATE ${_gRPC_PROTOBUF_INCLUDE_DIR}
  PRIVATE ${_gRPC_NANOPB_INCLUDE_DIR}
  PRIVATE ${_gRPC_ADDRESS_SORTING_INCLUDE_DIR}
)

  target_link_libraries(h2_full+pipe_nosec_test PRIVATE
  ${_gRPC_ALLTARGETS_LIBRARIES}
  end2end_nosec_tests
  grpc_test_util_unsecure
  grpc_unsecure
  gpr_test_util
  gpr
)

    add_dependencies(h2_full+pipe_nosec_test project_benchmark project_gflags)
endif()

  set(h2_full+trace_nosec_test_src
   ${_gRPC_ROOT}/test/core/end2end/fixtures/h2_full+trace.cc
)
  android_add_executable(h2_full+trace_nosec_test)

  target_compile_definitions(h2_full+trace_nosec_test PRIVATE -DPB_FIELD_16BIT)
  target_compile_definitions(h2_full+trace_nosec_test PUBLIC  -DGRPC_ALLOW_EXCEPTIONS=0)

  target_include_directories(h2_full+trace_nosec_test
  PRIVATE ${_gRPC_ROOT}
  PRIVATE ${_gRPC_ROOT}/include
  PRIVATE ${_gRPC_SSL_INCLUDE_DIR}
  PRIVATE ${_gRPC_BENCHMARK_INCLUDE_DIR}
  PRIVATE ${_gRPC_GFLAGS_INCLUDE_DIR}
  PRIVATE ${_gRPC_PROTOBUF_INCLUDE_DIR}
  PRIVATE ${_gRPC_NANOPB_INCLUDE_DIR}
  PRIVATE ${_gRPC_ADDRESS_SORTING_INCLUDE_DIR}
)

  target_link_libraries(h2_full+trace_nosec_test PRIVATE
  ${_gRPC_ALLTARGETS_LIBRARIES}
  end2end_nosec_tests
  grpc_test_util_unsecure
  grpc_unsecure
  gpr_test_util
  gpr
)

    add_dependencies(h2_full+trace_nosec_test project_benchmark project_gflags)

  set(h2_full+workarounds_nosec_test_src
   ${_gRPC_ROOT}/test/core/end2end/fixtures/h2_full+workarounds.cc
)
  android_add_executable(h2_full+workarounds_nosec_test)

  target_compile_definitions(h2_full+workarounds_nosec_test PRIVATE -DPB_FIELD_16BIT)
  target_compile_definitions(h2_full+workarounds_nosec_test PUBLIC  -DGRPC_ALLOW_EXCEPTIONS=0)

  target_include_directories(h2_full+workarounds_nosec_test
  PRIVATE ${_gRPC_ROOT}
  PRIVATE ${_gRPC_ROOT}/include
  PRIVATE ${_gRPC_SSL_INCLUDE_DIR}
  PRIVATE ${_gRPC_BENCHMARK_INCLUDE_DIR}
  PRIVATE ${_gRPC_GFLAGS_INCLUDE_DIR}
  PRIVATE ${_gRPC_PROTOBUF_INCLUDE_DIR}
  PRIVATE ${_gRPC_NANOPB_INCLUDE_DIR}
  PRIVATE ${_gRPC_ADDRESS_SORTING_INCLUDE_DIR}
)

  target_link_libraries(h2_full+workarounds_nosec_test PRIVATE
  ${_gRPC_ALLTARGETS_LIBRARIES}
  end2end_nosec_tests
  grpc_test_util_unsecure
  grpc_unsecure
  gpr_test_util
  gpr
)

    add_dependencies(h2_full+workarounds_nosec_test project_benchmark project_gflags)

  set(h2_http_proxy_nosec_test_src
   ${_gRPC_ROOT}/test/core/end2end/fixtures/h2_http_proxy.cc
)
  android_add_executable(h2_http_proxy_nosec_test)

  target_compile_definitions(h2_http_proxy_nosec_test PRIVATE -DPB_FIELD_16BIT)
  target_compile_definitions(h2_http_proxy_nosec_test PUBLIC  -DGRPC_ALLOW_EXCEPTIONS=0)

  target_include_directories(h2_http_proxy_nosec_test
  PRIVATE ${_gRPC_ROOT}
  PRIVATE ${_gRPC_ROOT}/include
  PRIVATE ${_gRPC_SSL_INCLUDE_DIR}
  PRIVATE ${_gRPC_BENCHMARK_INCLUDE_DIR}
  PRIVATE ${_gRPC_GFLAGS_INCLUDE_DIR}
  PRIVATE ${_gRPC_PROTOBUF_INCLUDE_DIR}
  PRIVATE ${_gRPC_NANOPB_INCLUDE_DIR}
  PRIVATE ${_gRPC_ADDRESS_SORTING_INCLUDE_DIR}
)

  target_link_libraries(h2_http_proxy_nosec_test PRIVATE
  ${_gRPC_ALLTARGETS_LIBRARIES}
  end2end_nosec_tests
  grpc_test_util_unsecure
  grpc_unsecure
  gpr_test_util
  gpr
)

    add_dependencies(h2_http_proxy_nosec_test project_benchmark project_gflags)

  set(h2_proxy_nosec_test_src
   ${_gRPC_ROOT}/test/core/end2end/fixtures/h2_proxy.cc
)
  android_add_executable(h2_proxy_nosec_test)

  target_compile_definitions(h2_proxy_nosec_test PRIVATE -DPB_FIELD_16BIT)
  target_compile_definitions(h2_proxy_nosec_test PUBLIC  -DGRPC_ALLOW_EXCEPTIONS=0)

  target_include_directories(h2_proxy_nosec_test
  PRIVATE ${_gRPC_ROOT}
  PRIVATE ${_gRPC_ROOT}/include
  PRIVATE ${_gRPC_SSL_INCLUDE_DIR}
  PRIVATE ${_gRPC_BENCHMARK_INCLUDE_DIR}
  PRIVATE ${_gRPC_GFLAGS_INCLUDE_DIR}
  PRIVATE ${_gRPC_PROTOBUF_INCLUDE_DIR}
  PRIVATE ${_gRPC_NANOPB_INCLUDE_DIR}
  PRIVATE ${_gRPC_ADDRESS_SORTING_INCLUDE_DIR}
)

  target_link_libraries(h2_proxy_nosec_test PRIVATE
  ${_gRPC_ALLTARGETS_LIBRARIES}
  end2end_nosec_tests
  grpc_test_util_unsecure
  grpc_unsecure
  gpr_test_util
  gpr
)

    add_dependencies(h2_proxy_nosec_test project_benchmark project_gflags)

  set(h2_sockpair_nosec_test_src
   ${_gRPC_ROOT}/test/core/end2end/fixtures/h2_sockpair.cc
)
  android_add_executable(h2_sockpair_nosec_test)

  target_compile_definitions(h2_sockpair_nosec_test PRIVATE -DPB_FIELD_16BIT)
  target_compile_definitions(h2_sockpair_nosec_test PUBLIC  -DGRPC_ALLOW_EXCEPTIONS=0)

  target_include_directories(h2_sockpair_nosec_test
  PRIVATE ${_gRPC_ROOT}
  PRIVATE ${_gRPC_ROOT}/include
  PRIVATE ${_gRPC_SSL_INCLUDE_DIR}
  PRIVATE ${_gRPC_BENCHMARK_INCLUDE_DIR}
  PRIVATE ${_gRPC_GFLAGS_INCLUDE_DIR}
  PRIVATE ${_gRPC_PROTOBUF_INCLUDE_DIR}
  PRIVATE ${_gRPC_NANOPB_INCLUDE_DIR}
  PRIVATE ${_gRPC_ADDRESS_SORTING_INCLUDE_DIR}
)

  target_link_libraries(h2_sockpair_nosec_test PRIVATE
  ${_gRPC_ALLTARGETS_LIBRARIES}
  end2end_nosec_tests
  grpc_test_util_unsecure
  grpc_unsecure
  gpr_test_util
  gpr
)

    add_dependencies(h2_sockpair_nosec_test project_benchmark project_gflags)

  set(h2_sockpair+trace_nosec_test_src
   ${_gRPC_ROOT}/test/core/end2end/fixtures/h2_sockpair+trace.cc
)
  android_add_executable(h2_sockpair+trace_nosec_test)

  target_compile_definitions(h2_sockpair+trace_nosec_test PRIVATE -DPB_FIELD_16BIT)
  target_compile_definitions(h2_sockpair+trace_nosec_test PUBLIC  -DGRPC_ALLOW_EXCEPTIONS=0)

  target_include_directories(h2_sockpair+trace_nosec_test
  PRIVATE ${_gRPC_ROOT}
  PRIVATE ${_gRPC_ROOT}/include
  PRIVATE ${_gRPC_SSL_INCLUDE_DIR}
  PRIVATE ${_gRPC_BENCHMARK_INCLUDE_DIR}
  PRIVATE ${_gRPC_GFLAGS_INCLUDE_DIR}
  PRIVATE ${_gRPC_PROTOBUF_INCLUDE_DIR}
  PRIVATE ${_gRPC_NANOPB_INCLUDE_DIR}
  PRIVATE ${_gRPC_ADDRESS_SORTING_INCLUDE_DIR}
)

  target_link_libraries(h2_sockpair+trace_nosec_test PRIVATE
  ${_gRPC_ALLTARGETS_LIBRARIES}
  end2end_nosec_tests
  grpc_test_util_unsecure
  grpc_unsecure
  gpr_test_util
  gpr
)

    add_dependencies(h2_sockpair+trace_nosec_test project_benchmark project_gflags)

  set(h2_sockpair_1byte_nosec_test_src
   ${_gRPC_ROOT}/test/core/end2end/fixtures/h2_sockpair_1byte.cc
)
  android_add_executable(h2_sockpair_1byte_nosec_test)

  target_compile_definitions(h2_sockpair_1byte_nosec_test PRIVATE -DPB_FIELD_16BIT)
  target_compile_definitions(h2_sockpair_1byte_nosec_test PUBLIC  -DGRPC_ALLOW_EXCEPTIONS=0)

  target_include_directories(h2_sockpair_1byte_nosec_test
  PRIVATE ${_gRPC_ROOT}
  PRIVATE ${_gRPC_ROOT}/include
  PRIVATE ${_gRPC_SSL_INCLUDE_DIR}
  PRIVATE ${_gRPC_BENCHMARK_INCLUDE_DIR}
  PRIVATE ${_gRPC_GFLAGS_INCLUDE_DIR}
  PRIVATE ${_gRPC_PROTOBUF_INCLUDE_DIR}
  PRIVATE ${_gRPC_NANOPB_INCLUDE_DIR}
  PRIVATE ${_gRPC_ADDRESS_SORTING_INCLUDE_DIR}
)

  target_link_libraries(h2_sockpair_1byte_nosec_test PRIVATE
  ${_gRPC_ALLTARGETS_LIBRARIES}
  end2end_nosec_tests
  grpc_test_util_unsecure
  grpc_unsecure
  gpr_test_util
  gpr
)

    add_dependencies(h2_sockpair_1byte_nosec_test project_benchmark project_gflags)
if(_gRPC_PLATFORM_LINUX OR _gRPC_PLATFORM_MAC OR _gRPC_PLATFORM_POSIX)

  set(h2_uds_nosec_test_src
   ${_gRPC_ROOT}/test/core/end2end/fixtures/h2_uds.cc
)
  android_add_executable(h2_uds_nosec_test)

  target_compile_definitions(h2_uds_nosec_test PRIVATE -DPB_FIELD_16BIT)
  target_compile_definitions(h2_uds_nosec_test PUBLIC  -DGRPC_ALLOW_EXCEPTIONS=0)

  target_include_directories(h2_uds_nosec_test
  PRIVATE ${_gRPC_ROOT}
  PRIVATE ${_gRPC_ROOT}/include
  PRIVATE ${_gRPC_SSL_INCLUDE_DIR}
  PRIVATE ${_gRPC_BENCHMARK_INCLUDE_DIR}
  PRIVATE ${_gRPC_GFLAGS_INCLUDE_DIR}
  PRIVATE ${_gRPC_PROTOBUF_INCLUDE_DIR}
  PRIVATE ${_gRPC_NANOPB_INCLUDE_DIR}
  PRIVATE ${_gRPC_ADDRESS_SORTING_INCLUDE_DIR}
)

  target_link_libraries(h2_uds_nosec_test PRIVATE
  ${_gRPC_ALLTARGETS_LIBRARIES}
  end2end_nosec_tests
  grpc_test_util_unsecure
  grpc_unsecure
  gpr_test_util
  gpr
)

    add_dependencies(h2_uds_nosec_test project_benchmark project_gflags)
endif()

  set(inproc_nosec_test_src
   ${_gRPC_ROOT}/test/core/end2end/fixtures/inproc.cc
)
  android_add_executable(inproc_nosec_test)

  target_compile_definitions(inproc_nosec_test PRIVATE -DPB_FIELD_16BIT)
  target_compile_definitions(inproc_nosec_test PUBLIC  -DGRPC_ALLOW_EXCEPTIONS=0)

  target_include_directories(inproc_nosec_test
  PRIVATE ${_gRPC_ROOT}
  PRIVATE ${_gRPC_ROOT}/include
  PRIVATE ${_gRPC_SSL_INCLUDE_DIR}
  PRIVATE ${_gRPC_BENCHMARK_INCLUDE_DIR}
  PRIVATE ${_gRPC_GFLAGS_INCLUDE_DIR}
  PRIVATE ${_gRPC_PROTOBUF_INCLUDE_DIR}
  PRIVATE ${_gRPC_NANOPB_INCLUDE_DIR}
  PRIVATE ${_gRPC_ADDRESS_SORTING_INCLUDE_DIR}
)

  target_link_libraries(inproc_nosec_test PRIVATE
  ${_gRPC_ALLTARGETS_LIBRARIES}
  end2end_nosec_tests
  grpc_test_util_unsecure
  grpc_unsecure
  gpr_test_util
  gpr
)

    add_dependencies(inproc_nosec_test project_benchmark project_gflags)

  set(address_sorting_test_unsecure_src
   ${_gRPC_ROOT}/test/cpp/naming/address_sorting_test.cc
)
  android_add_test(address_sorting_test_unsecure)
  target_link_libraries(address_sorting_test_unsecure PRIVATE gmock_main ssl crypto)
  target_include_directories(address_sorting_test_unsecure PRIVATE ${_gRPC_ROOT})

  target_compile_definitions(address_sorting_test_unsecure PRIVATE -DPB_FIELD_16BIT)
  target_compile_definitions(address_sorting_test_unsecure PUBLIC  -DGRPC_ALLOW_EXCEPTIONS=0)

  target_include_directories(address_sorting_test_unsecure
  PRIVATE ${_gRPC_ROOT}
  PRIVATE ${_gRPC_ROOT}/include
  PRIVATE ${_gRPC_SSL_INCLUDE_DIR}
  PRIVATE ${_gRPC_BENCHMARK_INCLUDE_DIR}
  PRIVATE ${_gRPC_GFLAGS_INCLUDE_DIR}
  PRIVATE ${_gRPC_PROTOBUF_INCLUDE_DIR}
  PRIVATE ${_gRPC_NANOPB_INCLUDE_DIR}
  PRIVATE ${_gRPC_ADDRESS_SORTING_INCLUDE_DIR}
  PRIVATE ${_gRPC_GTEST_INCLUDE_DIR}
  PRIVATE ${_gRPC_PROTO_GENS_DIR}
)

  target_link_libraries(address_sorting_test_unsecure PRIVATE
  ${_gRPC_PROTOBUF_LIBRARIES}
  ${_gRPC_ALLTARGETS_LIBRARIES}
  grpc++_test_util_unsecure
  grpc_test_util_unsecure
  gpr_test_util
  grpc++_unsecure
  grpc_unsecure
  gpr
  grpc++_test_config
  ${_gRPC_GFLAGS_LIBRARIES}
)

    add_dependencies(address_sorting_test_unsecure project_benchmark project_gflags)

  set(address_sorting_test_src
   ${_gRPC_ROOT}/test/cpp/naming/address_sorting_test.cc
)
  android_add_test(address_sorting_test)
  target_link_libraries(address_sorting_test PRIVATE gmock_main ssl crypto)
  target_include_directories(address_sorting_test PRIVATE ${_gRPC_ROOT})

  target_compile_definitions(address_sorting_test PRIVATE -DPB_FIELD_16BIT)
  target_compile_definitions(address_sorting_test PUBLIC  -DGRPC_ALLOW_EXCEPTIONS=0)

  target_include_directories(address_sorting_test
  PRIVATE ${_gRPC_ROOT}
  PRIVATE ${_gRPC_ROOT}/include
  PRIVATE ${_gRPC_SSL_INCLUDE_DIR}
  PRIVATE ${_gRPC_BENCHMARK_INCLUDE_DIR}
  PRIVATE ${_gRPC_GFLAGS_INCLUDE_DIR}
  PRIVATE ${_gRPC_PROTOBUF_INCLUDE_DIR}
  PRIVATE ${_gRPC_NANOPB_INCLUDE_DIR}
  PRIVATE ${_gRPC_ADDRESS_SORTING_INCLUDE_DIR}
  PRIVATE ${_gRPC_GTEST_INCLUDE_DIR}
  PRIVATE ${_gRPC_PROTO_GENS_DIR}
)

  target_link_libraries(address_sorting_test PRIVATE
  ${_gRPC_PROTOBUF_LIBRARIES}
  ${_gRPC_ALLTARGETS_LIBRARIES}
  grpc++_test_util
  grpc_test_util
  gpr_test_util
  grpc++
  grpc
  gpr
  grpc++_test_config
  ${_gRPC_GFLAGS_LIBRARIES}
)

    add_dependencies(address_sorting_test project_benchmark project_gflags)

  set(cancel_ares_query_test_src
   ${_gRPC_ROOT}/test/cpp/naming/cancel_ares_query_test.cc
)
  android_add_test(cancel_ares_query_test)
  target_link_libraries(cancel_ares_query_test PRIVATE gmock_main ssl crypto)
  target_include_directories(cancel_ares_query_test PRIVATE ${_gRPC_ROOT})

  target_compile_definitions(cancel_ares_query_test PRIVATE -DPB_FIELD_16BIT)
  target_compile_definitions(cancel_ares_query_test PUBLIC  -DGRPC_ALLOW_EXCEPTIONS=0)

  target_include_directories(cancel_ares_query_test
  PRIVATE ${_gRPC_ROOT}
  PRIVATE ${_gRPC_ROOT}/include
  PRIVATE ${_gRPC_SSL_INCLUDE_DIR}
  PRIVATE ${_gRPC_BENCHMARK_INCLUDE_DIR}
  PRIVATE ${_gRPC_GFLAGS_INCLUDE_DIR}
  PRIVATE ${_gRPC_PROTOBUF_INCLUDE_DIR}
  PRIVATE ${_gRPC_NANOPB_INCLUDE_DIR}
  PRIVATE ${_gRPC_ADDRESS_SORTING_INCLUDE_DIR}
  PRIVATE ${_gRPC_GTEST_INCLUDE_DIR}
  PRIVATE ${_gRPC_PROTO_GENS_DIR}
)

  target_link_libraries(cancel_ares_query_test PRIVATE
  ${_gRPC_PROTOBUF_LIBRARIES}
  ${_gRPC_ALLTARGETS_LIBRARIES}
  grpc++_test_util
  grpc_test_util
  gpr_test_util
  grpc++
  grpc
  gpr
  grpc++_test_config
  ${_gRPC_GFLAGS_LIBRARIES}
)

    add_dependencies(cancel_ares_query_test project_benchmark project_gflags)

  set(alts_credentials_fuzzer_one_entry_src
   ${_gRPC_ROOT}/test/core/security/alts_credentials_fuzzer.cc
   ${_gRPC_ROOT}/test/core/util/one_corpus_entry_fuzzer.cc
)
  android_add_executable(alts_credentials_fuzzer_one_entry)

  target_compile_definitions(alts_credentials_fuzzer_one_entry PRIVATE -DPB_FIELD_16BIT)
  target_compile_definitions(alts_credentials_fuzzer_one_entry PUBLIC  -DGRPC_ALLOW_EXCEPTIONS=0)

  target_include_directories(alts_credentials_fuzzer_one_entry
  PRIVATE ${_gRPC_ROOT}
  PRIVATE ${_gRPC_ROOT}/include
  PRIVATE ${_gRPC_SSL_INCLUDE_DIR}
  PRIVATE ${_gRPC_BENCHMARK_INCLUDE_DIR}
  PRIVATE ${_gRPC_GFLAGS_INCLUDE_DIR}
  PRIVATE ${_gRPC_PROTOBUF_INCLUDE_DIR}
  PRIVATE ${_gRPC_NANOPB_INCLUDE_DIR}
  PRIVATE ${_gRPC_ADDRESS_SORTING_INCLUDE_DIR}
)

  target_link_libraries(alts_credentials_fuzzer_one_entry PRIVATE
  ${_gRPC_ALLTARGETS_LIBRARIES}
  grpc_test_util
  grpc
  gpr_test_util
  gpr
)

    add_dependencies(alts_credentials_fuzzer_one_entry project_benchmark project_gflags)

  set(api_fuzzer_one_entry_src
   ${_gRPC_ROOT}/test/core/end2end/fuzzers/api_fuzzer.cc
   ${_gRPC_ROOT}/test/core/util/one_corpus_entry_fuzzer.cc
)
  android_add_executable(api_fuzzer_one_entry)

  target_compile_definitions(api_fuzzer_one_entry PRIVATE -DPB_FIELD_16BIT)
  target_compile_definitions(api_fuzzer_one_entry PUBLIC  -DGRPC_ALLOW_EXCEPTIONS=0)

  target_include_directories(api_fuzzer_one_entry
  PRIVATE ${_gRPC_ROOT}
  PRIVATE ${_gRPC_ROOT}/include
  PRIVATE ${_gRPC_SSL_INCLUDE_DIR}
  PRIVATE ${_gRPC_BENCHMARK_INCLUDE_DIR}
  PRIVATE ${_gRPC_GFLAGS_INCLUDE_DIR}
  PRIVATE ${_gRPC_PROTOBUF_INCLUDE_DIR}
  PRIVATE ${_gRPC_NANOPB_INCLUDE_DIR}
  PRIVATE ${_gRPC_ADDRESS_SORTING_INCLUDE_DIR}
)

  target_link_libraries(api_fuzzer_one_entry PRIVATE
  ${_gRPC_ALLTARGETS_LIBRARIES}
  grpc_test_util
  grpc
  gpr_test_util
  gpr
)

    add_dependencies(api_fuzzer_one_entry project_benchmark project_gflags)

  set(client_fuzzer_one_entry_src
   ${_gRPC_ROOT}/test/core/end2end/fuzzers/client_fuzzer.cc
   ${_gRPC_ROOT}/test/core/util/one_corpus_entry_fuzzer.cc
)
  android_add_executable(client_fuzzer_one_entry)

  target_compile_definitions(client_fuzzer_one_entry PRIVATE -DPB_FIELD_16BIT)
  target_compile_definitions(client_fuzzer_one_entry PUBLIC  -DGRPC_ALLOW_EXCEPTIONS=0)

  target_include_directories(client_fuzzer_one_entry
  PRIVATE ${_gRPC_ROOT}
  PRIVATE ${_gRPC_ROOT}/include
  PRIVATE ${_gRPC_SSL_INCLUDE_DIR}
  PRIVATE ${_gRPC_BENCHMARK_INCLUDE_DIR}
  PRIVATE ${_gRPC_GFLAGS_INCLUDE_DIR}
  PRIVATE ${_gRPC_PROTOBUF_INCLUDE_DIR}
  PRIVATE ${_gRPC_NANOPB_INCLUDE_DIR}
  PRIVATE ${_gRPC_ADDRESS_SORTING_INCLUDE_DIR}
)

  target_link_libraries(client_fuzzer_one_entry PRIVATE
  ${_gRPC_ALLTARGETS_LIBRARIES}
  grpc_test_util
  grpc
  gpr_test_util
  gpr
)

    add_dependencies(client_fuzzer_one_entry project_benchmark project_gflags)

  set(hpack_parser_fuzzer_test_one_entry_src
   ${_gRPC_ROOT}/test/core/transport/chttp2/hpack_parser_fuzzer_test.cc
   ${_gRPC_ROOT}/test/core/util/one_corpus_entry_fuzzer.cc
)
  android_add_executable(hpack_parser_fuzzer_test_one_entry)

  target_compile_definitions(hpack_parser_fuzzer_test_one_entry PRIVATE -DPB_FIELD_16BIT)
  target_compile_definitions(hpack_parser_fuzzer_test_one_entry PUBLIC  -DGRPC_ALLOW_EXCEPTIONS=0)

  target_include_directories(hpack_parser_fuzzer_test_one_entry
  PRIVATE ${_gRPC_ROOT}
  PRIVATE ${_gRPC_ROOT}/include
  PRIVATE ${_gRPC_SSL_INCLUDE_DIR}
  PRIVATE ${_gRPC_BENCHMARK_INCLUDE_DIR}
  PRIVATE ${_gRPC_GFLAGS_INCLUDE_DIR}
  PRIVATE ${_gRPC_PROTOBUF_INCLUDE_DIR}
  PRIVATE ${_gRPC_NANOPB_INCLUDE_DIR}
  PRIVATE ${_gRPC_ADDRESS_SORTING_INCLUDE_DIR}
)

  target_link_libraries(hpack_parser_fuzzer_test_one_entry PRIVATE
  ${_gRPC_ALLTARGETS_LIBRARIES}
  grpc_test_util
  grpc
  gpr_test_util
  gpr
)

    add_dependencies(hpack_parser_fuzzer_test_one_entry project_benchmark project_gflags)

  set(http_request_fuzzer_test_one_entry_src
   ${_gRPC_ROOT}/test/core/http/request_fuzzer.cc
   ${_gRPC_ROOT}/test/core/util/one_corpus_entry_fuzzer.cc
)
  android_add_executable(http_request_fuzzer_test_one_entry)

  target_compile_definitions(http_request_fuzzer_test_one_entry PRIVATE -DPB_FIELD_16BIT)
  target_compile_definitions(http_request_fuzzer_test_one_entry PUBLIC  -DGRPC_ALLOW_EXCEPTIONS=0)

  target_include_directories(http_request_fuzzer_test_one_entry
  PRIVATE ${_gRPC_ROOT}
  PRIVATE ${_gRPC_ROOT}/include
  PRIVATE ${_gRPC_SSL_INCLUDE_DIR}
  PRIVATE ${_gRPC_BENCHMARK_INCLUDE_DIR}
  PRIVATE ${_gRPC_GFLAGS_INCLUDE_DIR}
  PRIVATE ${_gRPC_PROTOBUF_INCLUDE_DIR}
  PRIVATE ${_gRPC_NANOPB_INCLUDE_DIR}
  PRIVATE ${_gRPC_ADDRESS_SORTING_INCLUDE_DIR}
)

  target_link_libraries(http_request_fuzzer_test_one_entry PRIVATE
  ${_gRPC_ALLTARGETS_LIBRARIES}
  grpc_test_util
  grpc
  gpr_test_util
  gpr
)

    add_dependencies(http_request_fuzzer_test_one_entry project_benchmark project_gflags)

  set(http_response_fuzzer_test_one_entry_src
   ${_gRPC_ROOT}/test/core/http/response_fuzzer.cc
   ${_gRPC_ROOT}/test/core/util/one_corpus_entry_fuzzer.cc
)
  android_add_executable(http_response_fuzzer_test_one_entry)

  target_compile_definitions(http_response_fuzzer_test_one_entry PRIVATE -DPB_FIELD_16BIT)
  target_compile_definitions(http_response_fuzzer_test_one_entry PUBLIC  -DGRPC_ALLOW_EXCEPTIONS=0)

  target_include_directories(http_response_fuzzer_test_one_entry
  PRIVATE ${_gRPC_ROOT}
  PRIVATE ${_gRPC_ROOT}/include
  PRIVATE ${_gRPC_SSL_INCLUDE_DIR}
  PRIVATE ${_gRPC_BENCHMARK_INCLUDE_DIR}
  PRIVATE ${_gRPC_GFLAGS_INCLUDE_DIR}
  PRIVATE ${_gRPC_PROTOBUF_INCLUDE_DIR}
  PRIVATE ${_gRPC_NANOPB_INCLUDE_DIR}
  PRIVATE ${_gRPC_ADDRESS_SORTING_INCLUDE_DIR}
)

  target_link_libraries(http_response_fuzzer_test_one_entry PRIVATE
  ${_gRPC_ALLTARGETS_LIBRARIES}
  grpc_test_util
  grpc
  gpr_test_util
  gpr
)

    add_dependencies(http_response_fuzzer_test_one_entry project_benchmark project_gflags)

  set(json_fuzzer_test_one_entry_src
   ${_gRPC_ROOT}/test/core/json/fuzzer.cc
   ${_gRPC_ROOT}/test/core/util/one_corpus_entry_fuzzer.cc
)
  android_add_executable(json_fuzzer_test_one_entry)

  target_compile_definitions(json_fuzzer_test_one_entry PRIVATE -DPB_FIELD_16BIT)
  target_compile_definitions(json_fuzzer_test_one_entry PUBLIC  -DGRPC_ALLOW_EXCEPTIONS=0)

  target_include_directories(json_fuzzer_test_one_entry
  PRIVATE ${_gRPC_ROOT}
  PRIVATE ${_gRPC_ROOT}/include
  PRIVATE ${_gRPC_SSL_INCLUDE_DIR}
  PRIVATE ${_gRPC_BENCHMARK_INCLUDE_DIR}
  PRIVATE ${_gRPC_GFLAGS_INCLUDE_DIR}
  PRIVATE ${_gRPC_PROTOBUF_INCLUDE_DIR}
  PRIVATE ${_gRPC_NANOPB_INCLUDE_DIR}
  PRIVATE ${_gRPC_ADDRESS_SORTING_INCLUDE_DIR}
)

  target_link_libraries(json_fuzzer_test_one_entry PRIVATE
  ${_gRPC_ALLTARGETS_LIBRARIES}
  grpc_test_util
  grpc
  gpr_test_util
  gpr
)

    add_dependencies(json_fuzzer_test_one_entry project_benchmark project_gflags)

  set(nanopb_fuzzer_response_test_one_entry_src
   ${_gRPC_ROOT}/test/core/nanopb/fuzzer_response.cc
   ${_gRPC_ROOT}/test/core/util/one_corpus_entry_fuzzer.cc
)
  android_add_executable(nanopb_fuzzer_response_test_one_entry)

  target_compile_definitions(nanopb_fuzzer_response_test_one_entry PRIVATE -DPB_FIELD_16BIT)
  target_compile_definitions(nanopb_fuzzer_response_test_one_entry PUBLIC  -DGRPC_ALLOW_EXCEPTIONS=0)

  target_include_directories(nanopb_fuzzer_response_test_one_entry
  PRIVATE ${_gRPC_ROOT}
  PRIVATE ${_gRPC_ROOT}/include
  PRIVATE ${_gRPC_SSL_INCLUDE_DIR}
  PRIVATE ${_gRPC_BENCHMARK_INCLUDE_DIR}
  PRIVATE ${_gRPC_GFLAGS_INCLUDE_DIR}
  PRIVATE ${_gRPC_PROTOBUF_INCLUDE_DIR}
  PRIVATE ${_gRPC_NANOPB_INCLUDE_DIR}
  PRIVATE ${_gRPC_ADDRESS_SORTING_INCLUDE_DIR}
)

  target_link_libraries(nanopb_fuzzer_response_test_one_entry PRIVATE
  ${_gRPC_ALLTARGETS_LIBRARIES}
  grpc_test_util
  grpc
  gpr_test_util
  gpr
)

    add_dependencies(nanopb_fuzzer_response_test_one_entry project_benchmark project_gflags)

  set(nanopb_fuzzer_serverlist_test_one_entry_src
   ${_gRPC_ROOT}/test/core/nanopb/fuzzer_serverlist.cc
   ${_gRPC_ROOT}/test/core/util/one_corpus_entry_fuzzer.cc
)
  android_add_executable(nanopb_fuzzer_serverlist_test_one_entry)

  target_compile_definitions(nanopb_fuzzer_serverlist_test_one_entry PRIVATE -DPB_FIELD_16BIT)
  target_compile_definitions(nanopb_fuzzer_serverlist_test_one_entry PUBLIC  -DGRPC_ALLOW_EXCEPTIONS=0)

  target_include_directories(nanopb_fuzzer_serverlist_test_one_entry
  PRIVATE ${_gRPC_ROOT}
  PRIVATE ${_gRPC_ROOT}/include
  PRIVATE ${_gRPC_SSL_INCLUDE_DIR}
  PRIVATE ${_gRPC_BENCHMARK_INCLUDE_DIR}
  PRIVATE ${_gRPC_GFLAGS_INCLUDE_DIR}
  PRIVATE ${_gRPC_PROTOBUF_INCLUDE_DIR}
  PRIVATE ${_gRPC_NANOPB_INCLUDE_DIR}
  PRIVATE ${_gRPC_ADDRESS_SORTING_INCLUDE_DIR}
)

  target_link_libraries(nanopb_fuzzer_serverlist_test_one_entry PRIVATE
  ${_gRPC_ALLTARGETS_LIBRARIES}
  grpc_test_util
  grpc
  gpr_test_util
  gpr
)

    add_dependencies(nanopb_fuzzer_serverlist_test_one_entry project_benchmark project_gflags)

  set(percent_decode_fuzzer_one_entry_src
   ${_gRPC_ROOT}/test/core/slice/percent_decode_fuzzer.cc
   ${_gRPC_ROOT}/test/core/util/one_corpus_entry_fuzzer.cc
)
  android_add_executable(percent_decode_fuzzer_one_entry)

  target_compile_definitions(percent_decode_fuzzer_one_entry PRIVATE -DPB_FIELD_16BIT)
  target_compile_definitions(percent_decode_fuzzer_one_entry PUBLIC  -DGRPC_ALLOW_EXCEPTIONS=0)

  target_include_directories(percent_decode_fuzzer_one_entry
  PRIVATE ${_gRPC_ROOT}
  PRIVATE ${_gRPC_ROOT}/include
  PRIVATE ${_gRPC_SSL_INCLUDE_DIR}
  PRIVATE ${_gRPC_BENCHMARK_INCLUDE_DIR}
  PRIVATE ${_gRPC_GFLAGS_INCLUDE_DIR}
  PRIVATE ${_gRPC_PROTOBUF_INCLUDE_DIR}
  PRIVATE ${_gRPC_NANOPB_INCLUDE_DIR}
  PRIVATE ${_gRPC_ADDRESS_SORTING_INCLUDE_DIR}
)

  target_link_libraries(percent_decode_fuzzer_one_entry PRIVATE
  ${_gRPC_ALLTARGETS_LIBRARIES}
  grpc_test_util
  grpc
  gpr_test_util
  gpr
)

    add_dependencies(percent_decode_fuzzer_one_entry project_benchmark project_gflags)

  set(percent_encode_fuzzer_one_entry_src
   ${_gRPC_ROOT}/test/core/slice/percent_encode_fuzzer.cc
   ${_gRPC_ROOT}/test/core/util/one_corpus_entry_fuzzer.cc
)
  android_add_executable(percent_encode_fuzzer_one_entry)

  target_compile_definitions(percent_encode_fuzzer_one_entry PRIVATE -DPB_FIELD_16BIT)
  target_compile_definitions(percent_encode_fuzzer_one_entry PUBLIC  -DGRPC_ALLOW_EXCEPTIONS=0)

  target_include_directories(percent_encode_fuzzer_one_entry
  PRIVATE ${_gRPC_ROOT}
  PRIVATE ${_gRPC_ROOT}/include
  PRIVATE ${_gRPC_SSL_INCLUDE_DIR}
  PRIVATE ${_gRPC_BENCHMARK_INCLUDE_DIR}
  PRIVATE ${_gRPC_GFLAGS_INCLUDE_DIR}
  PRIVATE ${_gRPC_PROTOBUF_INCLUDE_DIR}
  PRIVATE ${_gRPC_NANOPB_INCLUDE_DIR}
  PRIVATE ${_gRPC_ADDRESS_SORTING_INCLUDE_DIR}
)

  target_link_libraries(percent_encode_fuzzer_one_entry PRIVATE
  ${_gRPC_ALLTARGETS_LIBRARIES}
  grpc_test_util
  grpc
  gpr_test_util
  gpr
)

    add_dependencies(percent_encode_fuzzer_one_entry project_benchmark project_gflags)

  set(server_fuzzer_one_entry_src
   ${_gRPC_ROOT}/test/core/end2end/fuzzers/server_fuzzer.cc
   ${_gRPC_ROOT}/test/core/util/one_corpus_entry_fuzzer.cc
)
  android_add_executable(server_fuzzer_one_entry)

  target_compile_definitions(server_fuzzer_one_entry PRIVATE -DPB_FIELD_16BIT)
  target_compile_definitions(server_fuzzer_one_entry PUBLIC  -DGRPC_ALLOW_EXCEPTIONS=0)

  target_include_directories(server_fuzzer_one_entry
  PRIVATE ${_gRPC_ROOT}
  PRIVATE ${_gRPC_ROOT}/include
  PRIVATE ${_gRPC_SSL_INCLUDE_DIR}
  PRIVATE ${_gRPC_BENCHMARK_INCLUDE_DIR}
  PRIVATE ${_gRPC_GFLAGS_INCLUDE_DIR}
  PRIVATE ${_gRPC_PROTOBUF_INCLUDE_DIR}
  PRIVATE ${_gRPC_NANOPB_INCLUDE_DIR}
  PRIVATE ${_gRPC_ADDRESS_SORTING_INCLUDE_DIR}
)

  target_link_libraries(server_fuzzer_one_entry PRIVATE
  ${_gRPC_ALLTARGETS_LIBRARIES}
  grpc_test_util
  grpc
  gpr_test_util
  gpr
)

    add_dependencies(server_fuzzer_one_entry project_benchmark project_gflags)

  set(ssl_server_fuzzer_one_entry_src
   ${_gRPC_ROOT}/test/core/security/ssl_server_fuzzer.cc
   ${_gRPC_ROOT}/test/core/util/one_corpus_entry_fuzzer.cc
)
  android_add_executable(ssl_server_fuzzer_one_entry)

  target_compile_definitions(ssl_server_fuzzer_one_entry PRIVATE -DPB_FIELD_16BIT)
  target_compile_definitions(ssl_server_fuzzer_one_entry PUBLIC  -DGRPC_ALLOW_EXCEPTIONS=0)

  target_include_directories(ssl_server_fuzzer_one_entry
  PRIVATE ${_gRPC_ROOT}
  PRIVATE ${_gRPC_ROOT}/include
  PRIVATE ${_gRPC_SSL_INCLUDE_DIR}
  PRIVATE ${_gRPC_BENCHMARK_INCLUDE_DIR}
  PRIVATE ${_gRPC_GFLAGS_INCLUDE_DIR}
  PRIVATE ${_gRPC_PROTOBUF_INCLUDE_DIR}
  PRIVATE ${_gRPC_NANOPB_INCLUDE_DIR}
  PRIVATE ${_gRPC_ADDRESS_SORTING_INCLUDE_DIR}
)

  target_link_libraries(ssl_server_fuzzer_one_entry PRIVATE
  ${_gRPC_ALLTARGETS_LIBRARIES}
  grpc_test_util
  grpc
  gpr_test_util
  gpr
)

    add_dependencies(ssl_server_fuzzer_one_entry project_benchmark project_gflags)

  set(uri_fuzzer_test_one_entry_src
   ${_gRPC_ROOT}/test/core/client_channel/uri_fuzzer_test.cc
   ${_gRPC_ROOT}/test/core/util/one_corpus_entry_fuzzer.cc
)
  android_add_executable(uri_fuzzer_test_one_entry)

  target_compile_definitions(uri_fuzzer_test_one_entry PRIVATE -DPB_FIELD_16BIT)
  target_compile_definitions(uri_fuzzer_test_one_entry PUBLIC  -DGRPC_ALLOW_EXCEPTIONS=0)

  target_include_directories(uri_fuzzer_test_one_entry
  PRIVATE ${_gRPC_ROOT}
  PRIVATE ${_gRPC_ROOT}/include
  PRIVATE ${_gRPC_SSL_INCLUDE_DIR}
  PRIVATE ${_gRPC_BENCHMARK_INCLUDE_DIR}
  PRIVATE ${_gRPC_GFLAGS_INCLUDE_DIR}
  PRIVATE ${_gRPC_PROTOBUF_INCLUDE_DIR}
  PRIVATE ${_gRPC_NANOPB_INCLUDE_DIR}
  PRIVATE ${_gRPC_ADDRESS_SORTING_INCLUDE_DIR}
)

  target_link_libraries(uri_fuzzer_test_one_entry PRIVATE
  ${_gRPC_ALLTARGETS_LIBRARIES}
  grpc_test_util
  grpc
  gpr_test_util
  gpr
)

    add_dependencies(uri_fuzzer_test_one_entry project_benchmark project_gflags)





add_custom_target(buildtests_c)
   add_dependencies(buildtests_c algorithm_test)
   add_dependencies(buildtests_c alloc_test)
   add_dependencies(buildtests_c alpn_test)
   add_dependencies(buildtests_c arena_test)
   add_dependencies(buildtests_c avl_test)
   add_dependencies(buildtests_c bad_server_response_test)
   add_dependencies(buildtests_c bin_decoder_test)
   add_dependencies(buildtests_c bin_encoder_test)
if(_gRPC_PLATFORM_LINUX)
   add_dependencies(buildtests_c buffer_list_test)
endif()
   add_dependencies(buildtests_c channel_create_test)
   add_dependencies(buildtests_c chttp2_hpack_encoder_test)
   add_dependencies(buildtests_c chttp2_stream_map_test)
   add_dependencies(buildtests_c chttp2_varint_test)
   add_dependencies(buildtests_c cmdline_test)
   add_dependencies(buildtests_c combiner_test)
   add_dependencies(buildtests_c compression_test)
   add_dependencies(buildtests_c concurrent_connectivity_test)
   add_dependencies(buildtests_c connection_refused_test)
   add_dependencies(buildtests_c dns_resolver_connectivity_test)
   add_dependencies(buildtests_c dns_resolver_cooldown_test)
   add_dependencies(buildtests_c dns_resolver_test)
if(_gRPC_PLATFORM_LINUX OR _gRPC_PLATFORM_MAC OR _gRPC_PLATFORM_POSIX)
   add_dependencies(buildtests_c dualstack_socket_test)
endif()
   add_dependencies(buildtests_c endpoint_pair_test)
   add_dependencies(buildtests_c error_test)
if(_gRPC_PLATFORM_LINUX)
   add_dependencies(buildtests_c ev_epollex_linux_test)
endif()
if(_gRPC_PLATFORM_LINUX)
   add_dependencies(buildtests_c ev_epollsig_linux_test)
endif()
   add_dependencies(buildtests_c fake_resolver_test)
if(_gRPC_PLATFORM_LINUX OR _gRPC_PLATFORM_MAC OR _gRPC_PLATFORM_POSIX)
   add_dependencies(buildtests_c fake_transport_security_test)
endif()
if(_gRPC_PLATFORM_LINUX OR _gRPC_PLATFORM_MAC OR _gRPC_PLATFORM_POSIX)
   add_dependencies(buildtests_c fd_conservation_posix_test)
endif()
if(_gRPC_PLATFORM_LINUX OR _gRPC_PLATFORM_MAC OR _gRPC_PLATFORM_POSIX)
   add_dependencies(buildtests_c fd_posix_test)
endif()
   add_dependencies(buildtests_c fling_client)
   add_dependencies(buildtests_c fling_server)
if(_gRPC_PLATFORM_LINUX OR _gRPC_PLATFORM_MAC OR _gRPC_PLATFORM_POSIX)
   add_dependencies(buildtests_c fling_stream_test)
endif()
if(_gRPC_PLATFORM_LINUX OR _gRPC_PLATFORM_MAC OR _gRPC_PLATFORM_POSIX)
   add_dependencies(buildtests_c fling_test)
endif()
if(_gRPC_PLATFORM_LINUX OR _gRPC_PLATFORM_MAC)
   add_dependencies(buildtests_c fork_test)
endif()
if(_gRPC_PLATFORM_LINUX OR _gRPC_PLATFORM_MAC OR _gRPC_PLATFORM_POSIX)
   add_dependencies(buildtests_c goaway_server_test)
endif()
   add_dependencies(buildtests_c gpr_cpu_test)
   add_dependencies(buildtests_c gpr_env_test)
   add_dependencies(buildtests_c gpr_host_port_test)
   add_dependencies(buildtests_c gpr_log_test)
   add_dependencies(buildtests_c gpr_manual_constructor_test)
   add_dependencies(buildtests_c gpr_mpscq_test)
   add_dependencies(buildtests_c gpr_spinlock_test)
   add_dependencies(buildtests_c gpr_string_test)
   add_dependencies(buildtests_c gpr_sync_test)
   add_dependencies(buildtests_c gpr_thd_test)
   add_dependencies(buildtests_c gpr_time_test)
   add_dependencies(buildtests_c gpr_tls_test)
   add_dependencies(buildtests_c gpr_useful_test)
   add_dependencies(buildtests_c grpc_auth_context_test)
   add_dependencies(buildtests_c grpc_b64_test)
   add_dependencies(buildtests_c grpc_byte_buffer_reader_test)
   add_dependencies(buildtests_c grpc_channel_args_test)
   add_dependencies(buildtests_c grpc_channel_stack_builder_test)
   add_dependencies(buildtests_c grpc_channel_stack_test)
   add_dependencies(buildtests_c grpc_completion_queue_test)
   add_dependencies(buildtests_c grpc_completion_queue_threading_test)
   add_dependencies(buildtests_c grpc_credentials_test)
   add_dependencies(buildtests_c grpc_fetch_oauth2)
   add_dependencies(buildtests_c grpc_ipv6_loopback_available_test)
if(_gRPC_PLATFORM_LINUX OR _gRPC_PLATFORM_MAC OR _gRPC_PLATFORM_POSIX)
   add_dependencies(buildtests_c grpc_json_token_test)
endif()
   add_dependencies(buildtests_c grpc_jwt_verifier_test)
   add_dependencies(buildtests_c grpc_security_connector_test)
   add_dependencies(buildtests_c grpc_ssl_credentials_test)
if(_gRPC_PLATFORM_LINUX)
   add_dependencies(buildtests_c handshake_client)
endif()
if(_gRPC_PLATFORM_LINUX)
   add_dependencies(buildtests_c handshake_server)
endif()
if(_gRPC_PLATFORM_LINUX)
   add_dependencies(buildtests_c handshake_server_with_readahead_handshaker)
endif()
if(_gRPC_PLATFORM_LINUX)
   add_dependencies(buildtests_c handshake_verify_peer_options)
endif()
   add_dependencies(buildtests_c histogram_test)
   add_dependencies(buildtests_c hpack_parser_test)
   add_dependencies(buildtests_c hpack_table_test)
   add_dependencies(buildtests_c http_parser_test)
   add_dependencies(buildtests_c httpcli_format_request_test)
if(_gRPC_PLATFORM_LINUX OR _gRPC_PLATFORM_MAC OR _gRPC_PLATFORM_POSIX)
   add_dependencies(buildtests_c httpcli_test)
endif()
if(_gRPC_PLATFORM_LINUX)
   add_dependencies(buildtests_c httpscli_test)
endif()
   add_dependencies(buildtests_c init_test)
   add_dependencies(buildtests_c inproc_callback_test)
   add_dependencies(buildtests_c invalid_call_argument_test)
   add_dependencies(buildtests_c json_rewrite)
   add_dependencies(buildtests_c json_rewrite_test)
   add_dependencies(buildtests_c json_stream_error_test)
   add_dependencies(buildtests_c json_test)
   add_dependencies(buildtests_c lame_client_test)
   add_dependencies(buildtests_c load_file_test)
   add_dependencies(buildtests_c memory_profile_client)
   add_dependencies(buildtests_c memory_profile_server)
if(_gRPC_PLATFORM_LINUX OR _gRPC_PLATFORM_MAC OR _gRPC_PLATFORM_POSIX)
   add_dependencies(buildtests_c memory_profile_test)
endif()
   add_dependencies(buildtests_c message_compress_test)
   add_dependencies(buildtests_c minimal_stack_is_minimal_test)
   add_dependencies(buildtests_c multiple_server_queues_test)
   add_dependencies(buildtests_c murmur_hash_test)
   add_dependencies(buildtests_c no_server_test)
   add_dependencies(buildtests_c num_external_connectivity_watchers_test)
   add_dependencies(buildtests_c parse_address_test)
   add_dependencies(buildtests_c percent_encoding_test)
if(_gRPC_PLATFORM_LINUX)
   add_dependencies(buildtests_c pollset_set_test)
endif()
if(_gRPC_PLATFORM_LINUX OR _gRPC_PLATFORM_MAC OR _gRPC_PLATFORM_POSIX)
   add_dependencies(buildtests_c resolve_address_posix_test)
endif()
   add_dependencies(buildtests_c resolve_address_using_ares_resolver_test)
   add_dependencies(buildtests_c resolve_address_using_native_resolver_test)
   add_dependencies(buildtests_c resource_quota_test)
   add_dependencies(buildtests_c secure_channel_create_test)
   add_dependencies(buildtests_c secure_endpoint_test)
   add_dependencies(buildtests_c sequential_connectivity_test)
   add_dependencies(buildtests_c server_chttp2_test)
   add_dependencies(buildtests_c server_test)
   add_dependencies(buildtests_c slice_buffer_test)
   add_dependencies(buildtests_c slice_string_helpers_test)
   add_dependencies(buildtests_c slice_test)
   add_dependencies(buildtests_c sockaddr_resolver_test)
   add_dependencies(buildtests_c sockaddr_utils_test)
if(_gRPC_PLATFORM_LINUX OR _gRPC_PLATFORM_MAC OR _gRPC_PLATFORM_POSIX)
   add_dependencies(buildtests_c socket_utils_test)
endif()
if(_gRPC_PLATFORM_LINUX OR _gRPC_PLATFORM_MAC OR _gRPC_PLATFORM_POSIX)
   add_dependencies(buildtests_c ssl_transport_security_test)
endif()
   add_dependencies(buildtests_c status_conversion_test)
   add_dependencies(buildtests_c stream_compression_test)
   add_dependencies(buildtests_c stream_owned_slice_test)
if(_gRPC_PLATFORM_LINUX OR _gRPC_PLATFORM_MAC OR _gRPC_PLATFORM_POSIX)
   add_dependencies(buildtests_c tcp_client_posix_test)
endif()
   add_dependencies(buildtests_c tcp_client_uv_test)
if(_gRPC_PLATFORM_LINUX OR _gRPC_PLATFORM_MAC OR _gRPC_PLATFORM_POSIX)
   add_dependencies(buildtests_c tcp_posix_test)
endif()
if(_gRPC_PLATFORM_LINUX OR _gRPC_PLATFORM_MAC OR _gRPC_PLATFORM_POSIX)
   add_dependencies(buildtests_c tcp_server_posix_test)
endif()
   add_dependencies(buildtests_c tcp_server_uv_test)
   add_dependencies(buildtests_c time_averaged_stats_test)
   add_dependencies(buildtests_c timeout_encoding_test)
   add_dependencies(buildtests_c timer_heap_test)
   add_dependencies(buildtests_c timer_list_test)
   add_dependencies(buildtests_c transport_connectivity_state_test)
   add_dependencies(buildtests_c transport_metadata_test)
if(_gRPC_PLATFORM_LINUX OR _gRPC_PLATFORM_MAC OR _gRPC_PLATFORM_POSIX)
   add_dependencies(buildtests_c transport_security_test)
endif()
if(_gRPC_PLATFORM_LINUX OR _gRPC_PLATFORM_MAC OR _gRPC_PLATFORM_POSIX)
   add_dependencies(buildtests_c udp_server_test)
endif()
   add_dependencies(buildtests_c uri_parser_test)
if(_gRPC_PLATFORM_LINUX OR _gRPC_PLATFORM_MAC OR _gRPC_PLATFORM_POSIX)
   add_dependencies(buildtests_c wakeup_fd_cv_test)
endif()
   add_dependencies(buildtests_c public_headers_must_be_c89)
   add_dependencies(buildtests_c badreq_bad_client_test)
   add_dependencies(buildtests_c connection_prefix_bad_client_test)
   add_dependencies(buildtests_c duplicate_header_bad_client_test)
   add_dependencies(buildtests_c head_of_line_blocking_bad_client_test)
   add_dependencies(buildtests_c headers_bad_client_test)
   add_dependencies(buildtests_c initial_settings_frame_bad_client_test)
   add_dependencies(buildtests_c large_metadata_bad_client_test)
   add_dependencies(buildtests_c server_registered_method_bad_client_test)
   add_dependencies(buildtests_c simple_request_bad_client_test)
   add_dependencies(buildtests_c unknown_frame_bad_client_test)
   add_dependencies(buildtests_c window_overflow_bad_client_test)
if(_gRPC_PLATFORM_LINUX OR _gRPC_PLATFORM_MAC OR _gRPC_PLATFORM_POSIX)
   add_dependencies(buildtests_c bad_ssl_cert_server)
endif()
if(_gRPC_PLATFORM_LINUX OR _gRPC_PLATFORM_MAC OR _gRPC_PLATFORM_POSIX)
   add_dependencies(buildtests_c bad_ssl_cert_test)
endif()
   add_dependencies(buildtests_c h2_census_test)
   add_dependencies(buildtests_c h2_compress_test)
   add_dependencies(buildtests_c h2_fakesec_test)
if(_gRPC_PLATFORM_LINUX OR _gRPC_PLATFORM_MAC OR _gRPC_PLATFORM_POSIX)
   add_dependencies(buildtests_c h2_fd_test)
endif()
   add_dependencies(buildtests_c h2_full_test)
if(_gRPC_PLATFORM_LINUX)
   add_dependencies(buildtests_c h2_full+pipe_test)
endif()
   add_dependencies(buildtests_c h2_full+trace_test)
   add_dependencies(buildtests_c h2_full+workarounds_test)
   add_dependencies(buildtests_c h2_http_proxy_test)
if(_gRPC_PLATFORM_LINUX OR _gRPC_PLATFORM_MAC OR _gRPC_PLATFORM_POSIX)
   add_dependencies(buildtests_c h2_local_test)
endif()
   add_dependencies(buildtests_c h2_oauth2_test)
   add_dependencies(buildtests_c h2_proxy_test)
   add_dependencies(buildtests_c h2_sockpair_test)
   add_dependencies(buildtests_c h2_sockpair+trace_test)
   add_dependencies(buildtests_c h2_sockpair_1byte_test)
   add_dependencies(buildtests_c h2_ssl_test)
   add_dependencies(buildtests_c h2_ssl_proxy_test)
if(_gRPC_PLATFORM_LINUX OR _gRPC_PLATFORM_MAC OR _gRPC_PLATFORM_POSIX)
   add_dependencies(buildtests_c h2_uds_test)
endif()
   add_dependencies(buildtests_c inproc_test)
   add_dependencies(buildtests_c h2_census_nosec_test)
   add_dependencies(buildtests_c h2_compress_nosec_test)
if(_gRPC_PLATFORM_LINUX OR _gRPC_PLATFORM_MAC OR _gRPC_PLATFORM_POSIX)
   add_dependencies(buildtests_c h2_fd_nosec_test)
endif()
   add_dependencies(buildtests_c h2_full_nosec_test)
if(_gRPC_PLATFORM_LINUX)
   add_dependencies(buildtests_c h2_full+pipe_nosec_test)
endif()
   add_dependencies(buildtests_c h2_full+trace_nosec_test)
   add_dependencies(buildtests_c h2_full+workarounds_nosec_test)
   add_dependencies(buildtests_c h2_http_proxy_nosec_test)
   add_dependencies(buildtests_c h2_proxy_nosec_test)
   add_dependencies(buildtests_c h2_sockpair_nosec_test)
   add_dependencies(buildtests_c h2_sockpair+trace_nosec_test)
   add_dependencies(buildtests_c h2_sockpair_1byte_nosec_test)
if(_gRPC_PLATFORM_LINUX OR _gRPC_PLATFORM_MAC OR _gRPC_PLATFORM_POSIX)
   add_dependencies(buildtests_c h2_uds_nosec_test)
endif()
   add_dependencies(buildtests_c inproc_nosec_test)
   add_dependencies(buildtests_c alts_credentials_fuzzer_one_entry)
   add_dependencies(buildtests_c api_fuzzer_one_entry)
   add_dependencies(buildtests_c client_fuzzer_one_entry)
   add_dependencies(buildtests_c hpack_parser_fuzzer_test_one_entry)
   add_dependencies(buildtests_c http_request_fuzzer_test_one_entry)
   add_dependencies(buildtests_c http_response_fuzzer_test_one_entry)
   add_dependencies(buildtests_c json_fuzzer_test_one_entry)
   add_dependencies(buildtests_c nanopb_fuzzer_response_test_one_entry)
   add_dependencies(buildtests_c nanopb_fuzzer_serverlist_test_one_entry)
   add_dependencies(buildtests_c percent_decode_fuzzer_one_entry)
   add_dependencies(buildtests_c percent_encode_fuzzer_one_entry)
   add_dependencies(buildtests_c server_fuzzer_one_entry)
   add_dependencies(buildtests_c ssl_server_fuzzer_one_entry)
   add_dependencies(buildtests_c uri_fuzzer_test_one_entry)

add_custom_target(buildtests_cxx)
  add_dependencies(buildtests_cxx alarm_test)
  add_dependencies(buildtests_cxx alts_counter_test)
  add_dependencies(buildtests_cxx alts_crypt_test)
  add_dependencies(buildtests_cxx alts_crypter_test)
  add_dependencies(buildtests_cxx alts_frame_handler_test)
  add_dependencies(buildtests_cxx alts_frame_protector_test)
  add_dependencies(buildtests_cxx alts_grpc_record_protocol_test)
  add_dependencies(buildtests_cxx alts_handshaker_client_test)
  add_dependencies(buildtests_cxx alts_handshaker_service_api_test)
  add_dependencies(buildtests_cxx alts_iovec_record_protocol_test)
  add_dependencies(buildtests_cxx alts_security_connector_test)
  add_dependencies(buildtests_cxx alts_tsi_handshaker_test)
  add_dependencies(buildtests_cxx alts_tsi_utils_test)
  add_dependencies(buildtests_cxx alts_zero_copy_grpc_protector_test)
  add_dependencies(buildtests_cxx async_end2end_test)
  add_dependencies(buildtests_cxx auth_property_iterator_test)
  add_dependencies(buildtests_cxx backoff_test)
  add_dependencies(buildtests_cxx bdp_estimator_test)
if(_gRPC_PLATFORM_LINUX OR _gRPC_PLATFORM_MAC OR _gRPC_PLATFORM_POSIX)
  add_dependencies(buildtests_cxx bm_arena)
endif()
if(_gRPC_PLATFORM_LINUX OR _gRPC_PLATFORM_MAC OR _gRPC_PLATFORM_POSIX)
  add_dependencies(buildtests_cxx bm_call_create)
endif()
if(_gRPC_PLATFORM_LINUX OR _gRPC_PLATFORM_MAC OR _gRPC_PLATFORM_POSIX)
  add_dependencies(buildtests_cxx bm_channel)
endif()
if(_gRPC_PLATFORM_LINUX OR _gRPC_PLATFORM_MAC OR _gRPC_PLATFORM_POSIX)
  add_dependencies(buildtests_cxx bm_chttp2_hpack)
endif()
if(_gRPC_PLATFORM_LINUX OR _gRPC_PLATFORM_MAC OR _gRPC_PLATFORM_POSIX)
  add_dependencies(buildtests_cxx bm_chttp2_transport)
endif()
if(_gRPC_PLATFORM_LINUX OR _gRPC_PLATFORM_MAC OR _gRPC_PLATFORM_POSIX)
  add_dependencies(buildtests_cxx bm_closure)
endif()
if(_gRPC_PLATFORM_LINUX OR _gRPC_PLATFORM_MAC OR _gRPC_PLATFORM_POSIX)
  add_dependencies(buildtests_cxx bm_cq)
endif()
if(_gRPC_PLATFORM_LINUX OR _gRPC_PLATFORM_MAC OR _gRPC_PLATFORM_POSIX)
  add_dependencies(buildtests_cxx bm_cq_multiple_threads)
endif()
if(_gRPC_PLATFORM_LINUX OR _gRPC_PLATFORM_MAC OR _gRPC_PLATFORM_POSIX)
  add_dependencies(buildtests_cxx bm_error)
endif()
if(_gRPC_PLATFORM_LINUX OR _gRPC_PLATFORM_MAC OR _gRPC_PLATFORM_POSIX)
  add_dependencies(buildtests_cxx bm_fullstack_streaming_ping_pong)
endif()
if(_gRPC_PLATFORM_LINUX OR _gRPC_PLATFORM_MAC OR _gRPC_PLATFORM_POSIX)
  add_dependencies(buildtests_cxx bm_fullstack_streaming_pump)
endif()
if(_gRPC_PLATFORM_LINUX OR _gRPC_PLATFORM_MAC OR _gRPC_PLATFORM_POSIX)
  add_dependencies(buildtests_cxx bm_fullstack_trickle)
endif()
if(_gRPC_PLATFORM_LINUX OR _gRPC_PLATFORM_MAC OR _gRPC_PLATFORM_POSIX)
  add_dependencies(buildtests_cxx bm_fullstack_unary_ping_pong)
endif()
if(_gRPC_PLATFORM_LINUX OR _gRPC_PLATFORM_MAC OR _gRPC_PLATFORM_POSIX)
  add_dependencies(buildtests_cxx bm_metadata)
endif()
if(_gRPC_PLATFORM_LINUX OR _gRPC_PLATFORM_MAC OR _gRPC_PLATFORM_POSIX)
  add_dependencies(buildtests_cxx bm_pollset)
endif()
  add_dependencies(buildtests_cxx byte_stream_test)
  add_dependencies(buildtests_cxx channel_arguments_test)
  add_dependencies(buildtests_cxx channel_filter_test)
  add_dependencies(buildtests_cxx channel_trace_test)
  add_dependencies(buildtests_cxx channelz_registry_test)
  add_dependencies(buildtests_cxx channelz_test)
  add_dependencies(buildtests_cxx check_gcp_environment_linux_test)
  add_dependencies(buildtests_cxx check_gcp_environment_windows_test)
  add_dependencies(buildtests_cxx chttp2_settings_timeout_test)
  add_dependencies(buildtests_cxx cli_call_test)
  add_dependencies(buildtests_cxx client_callback_end2end_test)
  add_dependencies(buildtests_cxx client_channel_stress_test)
if(_gRPC_PLATFORM_LINUX OR _gRPC_PLATFORM_MAC OR _gRPC_PLATFORM_POSIX)
  add_dependencies(buildtests_cxx client_crash_test)
endif()
  add_dependencies(buildtests_cxx client_crash_test_server)
  add_dependencies(buildtests_cxx client_lb_end2end_test)
  add_dependencies(buildtests_cxx codegen_test_full)
  add_dependencies(buildtests_cxx codegen_test_minimal)
  add_dependencies(buildtests_cxx credentials_test)
  add_dependencies(buildtests_cxx cxx_byte_buffer_test)
  add_dependencies(buildtests_cxx cxx_slice_test)
  add_dependencies(buildtests_cxx cxx_string_ref_test)
  add_dependencies(buildtests_cxx cxx_time_test)
  add_dependencies(buildtests_cxx end2end_test)
  add_dependencies(buildtests_cxx exception_test)
  add_dependencies(buildtests_cxx filter_end2end_test)
  add_dependencies(buildtests_cxx generic_end2end_test)
  add_dependencies(buildtests_cxx golden_file_test)
  add_dependencies(buildtests_cxx grpc_alts_credentials_options_test)
  add_dependencies(buildtests_cxx grpc_cli)
  add_dependencies(buildtests_cxx grpc_linux_system_roots_test)
  add_dependencies(buildtests_cxx grpclb_api_test)
  add_dependencies(buildtests_cxx grpclb_end2end_test)
  add_dependencies(buildtests_cxx h2_ssl_cert_test)
  add_dependencies(buildtests_cxx h2_ssl_session_reuse_test)
  add_dependencies(buildtests_cxx health_service_end2end_test)
if(_gRPC_PLATFORM_LINUX OR _gRPC_PLATFORM_MAC OR _gRPC_PLATFORM_POSIX)
endif()
  add_dependencies(buildtests_cxx hybrid_end2end_test)
  add_dependencies(buildtests_cxx inlined_vector_test)
if(_gRPC_PLATFORM_LINUX OR _gRPC_PLATFORM_MAC OR _gRPC_PLATFORM_POSIX)
  add_dependencies(buildtests_cxx inproc_sync_unary_ping_pong_test)
endif()
if(_gRPC_PLATFORM_LINUX OR _gRPC_PLATFORM_MAC OR _gRPC_PLATFORM_POSIX)
endif()
if(_gRPC_PLATFORM_LINUX OR _gRPC_PLATFORM_MAC OR _gRPC_PLATFORM_POSIX)
endif()
if(_gRPC_PLATFORM_LINUX OR _gRPC_PLATFORM_MAC OR _gRPC_PLATFORM_POSIX)
  add_dependencies(buildtests_cxx interop_test)
endif()
if(_gRPC_PLATFORM_LINUX OR _gRPC_PLATFORM_MAC OR _gRPC_PLATFORM_POSIX)
  add_dependencies(buildtests_cxx json_run_localhost)
endif()
  add_dependencies(buildtests_cxx memory_test)
  add_dependencies(buildtests_cxx metrics_client)
  add_dependencies(buildtests_cxx mock_test)
  add_dependencies(buildtests_cxx nonblocking_test)
  add_dependencies(buildtests_cxx noop-benchmark)
  add_dependencies(buildtests_cxx orphanable_test)
  add_dependencies(buildtests_cxx proto_utils_test)
if(_gRPC_PLATFORM_LINUX OR _gRPC_PLATFORM_MAC OR _gRPC_PLATFORM_POSIX)
  add_dependencies(buildtests_cxx qps_interarrival_test)
endif()
  add_dependencies(buildtests_cxx qps_json_driver)
if(_gRPC_PLATFORM_LINUX OR _gRPC_PLATFORM_MAC OR _gRPC_PLATFORM_POSIX)
  add_dependencies(buildtests_cxx qps_openloop_test)
endif()
  add_dependencies(buildtests_cxx qps_worker)
  add_dependencies(buildtests_cxx raw_end2end_test)
  add_dependencies(buildtests_cxx reconnect_interop_client)
  add_dependencies(buildtests_cxx reconnect_interop_server)
  add_dependencies(buildtests_cxx ref_counted_ptr_test)
  add_dependencies(buildtests_cxx ref_counted_test)
  add_dependencies(buildtests_cxx retry_throttle_test)
  add_dependencies(buildtests_cxx secure_auth_context_test)
if(_gRPC_PLATFORM_LINUX OR _gRPC_PLATFORM_MAC OR _gRPC_PLATFORM_POSIX)
  add_dependencies(buildtests_cxx secure_sync_unary_ping_pong_test)
endif()
  add_dependencies(buildtests_cxx server_builder_plugin_test)
  add_dependencies(buildtests_cxx server_builder_test)
if(_gRPC_PLATFORM_POSIX)
  add_dependencies(buildtests_cxx server_builder_with_socket_mutator_test)
endif()
  add_dependencies(buildtests_cxx server_context_test_spouse_test)
if(_gRPC_PLATFORM_LINUX OR _gRPC_PLATFORM_MAC OR _gRPC_PLATFORM_POSIX)
  add_dependencies(buildtests_cxx server_crash_test)
endif()
  add_dependencies(buildtests_cxx server_crash_test_client)
  add_dependencies(buildtests_cxx server_early_return_test)
  add_dependencies(buildtests_cxx server_request_call_test)
  add_dependencies(buildtests_cxx shutdown_test)
  add_dependencies(buildtests_cxx slice_hash_table_test)
  add_dependencies(buildtests_cxx slice_weak_hash_table_test)
  add_dependencies(buildtests_cxx stats_test)
  add_dependencies(buildtests_cxx status_metadata_test)
  add_dependencies(buildtests_cxx status_util_test)
if(_gRPC_PLATFORM_LINUX OR _gRPC_PLATFORM_MAC OR _gRPC_PLATFORM_POSIX)
  add_dependencies(buildtests_cxx streaming_throughput_test)
endif()
  add_dependencies(buildtests_cxx stress_test)
  add_dependencies(buildtests_cxx thread_manager_test)
  add_dependencies(buildtests_cxx thread_stress_test)
  add_dependencies(buildtests_cxx transport_pid_controller_test)
  add_dependencies(buildtests_cxx transport_security_common_api_test)
if(_gRPC_PLATFORM_LINUX OR _gRPC_PLATFORM_MAC OR _gRPC_PLATFORM_POSIX)
  add_dependencies(buildtests_cxx writes_per_rpc_test)
endif()
  add_dependencies(buildtests_cxx address_sorting_test_unsecure)
  add_dependencies(buildtests_cxx address_sorting_test)
  add_dependencies(buildtests_cxx cancel_ares_query_test)

add_custom_target(buildtests
  DEPENDS buildtests_c buildtests_cxx)
