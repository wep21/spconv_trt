#include <cuda_runtime.h>
#include <gflags/gflags.h>
#include <iostream>

#include "spconv/engine.hpp"
#include "onnx-parser.hpp"
#include "spconv/engine.hpp"
#include "spconv/tensor.hpp"

DEFINE_string(pts_middle_encoder_onnx, "", "pts middle encoder onnx");
DEFINE_string(precision, "fp16", "precision");

enum class IndiceOrder : int { ZYX = 0, XYZ = 1 };

int main(int argc, char * argv[]) {
  gflags::ParseCommandLineFlags(&argc, &argv, true);

  if (!FLAGS_pts_middle_encoder_onnx.empty()) {
    spconv::set_verbose(true);
    auto engine = spconv::load_engine_from_onnx(
       FLAGS_pts_middle_encoder_onnx,
       FLAGS_precision == "fp16" ? spconv::Precision::Float16 : spconv::Precision::Int8
    );
    auto features = spconv::Tensor::load("data/bevfusion/infer.xyz.voxels");
    auto indices = spconv::Tensor::load("data/bevfusion/infer.xyz.coors");
    std::vector<int> grid_size{41, 1440, 1440};
    auto order = IndiceOrder::XYZ;
    cudaStream_t stream;
    cudaStreamCreate(&stream);
    engine->input(0)->set_data(
      features.shape, spconv::DataType::Float16, features.ptr(),
      indices.shape, spconv::DataType::Int32, indices.ptr(), grid_size
    );
    engine->forward(stream);
    auto out_features = engine->output(0)->features();
    auto out_grid_size = engine->output(0)->grid_size();

    printf("🙌 Output.shape: %s\n", spconv::format_shape(out_features.shape).c_str());
    cudaStreamDestroy(stream);
  } else {
    std::cerr << "Error: Use --pts_middle_encoder_onnx flag to give a pts middle encoder onnx" << std::endl;
  }
  return 0;
}