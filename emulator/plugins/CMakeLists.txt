# THIS FILE IS FOR USE BY THE ANDROID EMULATOR CMAKE BUILD
# IT CONTAINS ALL THE GRPC PLUGINS THAT TARGET THE HOST.
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
include(android)
set(PACKAGE_NAME      "grpc-protoc-plugin")
set(PACKAGE_VERSION   "1.16.0-dev")
set(PACKAGE_STRING    "${PACKAGE_NAME} ${PACKAGE_VERSION}")
set(PACKAGE_TARNAME   "${PACKAGE_NAME}-${PACKAGE_VERSION}")
set(PACKAGE_BUGREPORT "https://github.com/grpc/grpc/issues/")
if (NOT _gRPC_ROOT)
  get_filename_component(_gRPC_ROOT "${CMAKE_CURRENT_LIST_DIR}/../.." ABSOLUTE)
endif()
set(_gRPC_PROTOBUF_LIBRARIES libprotoc)

if (NOT TARGET protoc)
  add_subdirectory(${ANDROID_QEMU2_TOP_DIR}/android/third_party/protobuf/ protoc)
endif()


set(grpc_cpp_plugin_src
   ${_gRPC_ROOT}/src/compiler/cpp_plugin.cc
)
  android_add_executable(grpc_cpp_plugin)

  target_compile_definitions(grpc_cpp_plugin PRIVATE -DPB_FIELD_16BIT)

 target_include_directories(grpc_cpp_plugin
 PRIVATE ${_gRPC_ROOT}
 PRIVATE ${_gRPC_ROOT}/include
  PRIVATE ${_gRPC_PROTO_GENS_DIR}
)

  target_link_libraries(grpc_cpp_plugin PRIVATE
  ${_gRPC_PROTOBUF_PROTOC_LIBRARIES}
  ${_gRPC_PROTOBUF_LIBRARIES}
  ${_gRPC_ALLTARGETS_LIBRARIES}
  grpc_plugin_support
)



set(grpc_plugin_support_src
  ${_gRPC_ROOT}/src/compiler/cpp_generator.cc
  ${_gRPC_ROOT}/src/compiler/csharp_generator.cc
  ${_gRPC_ROOT}/src/compiler/node_generator.cc
  ${_gRPC_ROOT}/src/compiler/objective_c_generator.cc
  ${_gRPC_ROOT}/src/compiler/php_generator.cc
  ${_gRPC_ROOT}/src/compiler/python_generator.cc
  ${_gRPC_ROOT}/src/compiler/ruby_generator.cc
)
android_add_library(grpc_plugin_support)


target_compile_definitions(grpc_plugin_support PRIVATE -DPB_FIELD_16BIT)
target_include_directories(grpc_plugin_support
                           PUBLIC  ${_gRPC_ROOT}/include
                           PRIVATE ${_gRPC_ROOT}
                           PRIVATE ${_gRPC_PROTO_GENS_DIR}
)

target_link_libraries(grpc_plugin_support PRIVATE
  ${_gRPC_PROTOBUF_PROTOC_LIBRARIES}
  ${_gRPC_PROTOBUF_LIBRARIES}
  ${_gRPC_ALLTARGETS_LIBRARIES}
)






