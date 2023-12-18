# Copyright 2019 gRPC authors.
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

if(NOT DEFINED _gRPC_ROOT)
    get_filename_component(_gRPC_ROOT "${CMAKE_CURRENT_LIST_DIR}/.." ABSOLUTE)
endif()
set(UPB_ROOT_DIR ${_gRPC_ROOT}/third_party/upb)

set(_gRPC_UPB_INCLUDE_DIR "${UPB_ROOT_DIR}" "${_gRPC_ROOT}/third_party/utf8_range")
set(_gRPC_UPB_GRPC_GENERATED_DIR "${_gRPC_ROOT}/src/core/ext/upbdefs-gen" "${_gRPC_ROOT}/src/core/ext/upb-gen")
set(_gRPC_UPB_LIBRARIES upb)
