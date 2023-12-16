# spconv_trt


## Setup

```bash
$ cmake -B build -DCMAKE_INSTALL_PREFIX=install
$ cmake --build build -jN
$ cmake --install build --prefix install
$ export LD_LIBRARY_PATH=install/lib:$LD_LIBRARY_PATH
```

## Run

```bash
./install/bin/spconv_trt --pts_middle_encoder_onnx /path/to/model/resnet50/lidar.backbone.xyz.onnx
```

