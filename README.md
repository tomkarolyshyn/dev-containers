# dev-containers

Docker files needed for general development.

Versions are set in the .env file and loaded by the docker compose.

## llvm-python

LLVM 20 and python3.12

- Posted on [DockerHub](https://hub.docker.com/repository/docker/tomkarolyshyn/llvm-python/general)

## rtl-sim

Verilog simulation libraries using [cocotb](https://www.cocotb.org/) and [Verilator](https://verilator.org/guide/latest/index.html)

- Posted on [DockerHub](https://hub.docker.com/repository/docker/tomkarolyshyn/rtl-sim/general)

## llvm-oss
LLVM base image with OSS-CAD-SUITE installed.

## llvm-cuda
CUDA image with LLVM and OSS installed (full dev build)

**NOTE:** this contains both llvm-cuda (Ubuntu 24) and llvm-cuda-22 (Ubuntu 22)

### Building CUDA containers
Be sure to follow the [instructions](https://docs.nvidia.com/datacenter/cloud-native/container-toolkit/latest/install-guide.html) from Nvidia on setup for both building and running.


## vitis

Vitis 2025.2 install
Currently downloaded with offline installer for specific devices.

- [Install Ref](https://docs.amd.com/r/en-US/ug973-vivado-release-notes-install-license/Batch-Mode-Installation-Flow)
- **Cannot upload to docker hub due to size and license issues.**
