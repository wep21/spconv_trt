include(FetchContent)
FetchContent_Populate(spconv
  GIT_REPOSITORY https://github.com/NVIDIA-AI-IOT/Lidar_AI_Solution.git
  GIT_TAG a8461f0a024477dbcf8746a3ea8a0f5e3aa14540
  GIT_PROGRESS TRUE
  PATCH_COMMAND git checkout . && git apply ${CMAKE_CURRENT_SOURCE_DIR}/spconv.patch
)

add_library(spconv::spconv SHARED IMPORTED)

set(SPCONV_PATH ${spconv_SOURCE_DIR}/libraries/3DSparseConvolution/libspconv-1.1.2)
set(SPCONV_INCLUDE_DIR ${SPCONV_PATH}/include)
set(SPCONV_LIB_DIR ${SPCONV_PATH}/lib/${CMAKE_SYSTEM_PROCESSOR})
set_target_properties(spconv::spconv PROPERTIES
  IMPORTED_LOCATION
    ${CMAKE_INSTALL_PREFIX}/lib/libspconv.so
  INTERFACE_INCLUDE_DIRECTORIES
    $<BUILD_INTERFACE:${SPCONV_INCLUDE_DIR}>
)
file(COPY ${SPCONV_LIB_DIR}/libspconv.so
  DESTINATION ${CMAKE_INSTALL_PREFIX}/lib
)

find_package(Protobuf REQUIRED)

add_library(onnx_parser SHARED
  ${spconv_SOURCE_DIR}/libraries/3DSparseConvolution/src/onnx-parser.cpp
  ${spconv_SOURCE_DIR}/libraries/3DSparseConvolution/src/onnx/onnx-ml.pb.cpp
  ${spconv_SOURCE_DIR}/libraries/3DSparseConvolution/src/onnx/onnx-operators-ml.pb.cpp
)

target_include_directories(onnx_parser
  PUBLIC
    $<BUILD_INTERFACE:${spconv_SOURCE_DIR}/libraries/3DSparseConvolution/src/>
)

target_link_libraries(onnx_parser
  spconv::spconv
  protobuf::libprotobuf
)

add_library(spconv::onnx_parser ALIAS onnx_parser)

install(DIRECTORY ${SPCONV_INCLUDE_DIR}/ DESTINATION include)
install(TARGETS onnx_parser
  ARCHIVE DESTINATION lib
  LIBRARY DESTINATION lib
  RUNTIME DESTINATION bin
)
