cmake_minimum_required(VERSION 3.15)
project(spconv_trt)

include(cmake/spconv.cmake)

find_package(gflags REQUIRED)
find_package(CUDAToolkit REQUIRED)

add_executable(${PROJECT_NAME}
  main.cpp
)

target_link_libraries(${PROJECT_NAME}
  PRIVATE
    CUDA::cudart
    spconv::onnx_parser
    gflags
)

install(TARGETS ${PROJECT_NAME}
  ARCHIVE DESTINATION lib
  LIBRARY DESTINATION lib
  RUNTIME DESTINATION bin
)
