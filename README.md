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

- Following this [Install Ref](https://docs.amd.com/r/en-US/ug973-vivado-release-notes-install-license/Batch-Mode-Installation-Flow)

1. Download the [Linux web installer](https://www.xilinx.com/member/forms/download/xef.html?filename=FPGAs_AdaptiveSoCs_Unified_SDI_2025.2_1114_2157_Lin64.bin) from [Xilinx Downloads](https://www.xilinx.com/support/download.html)
    - you will need a valid login from AMD/Xilinx
2. Run the tool setup tool :
    - Enter login information
    - Select "Download Image (Install Separately)"
    - Select "Selected Product Only" (to reduce size)
    - Enter desired save location (ie : /home/USERNAME/Downloads/vitis_2025.2)
    - Click Next>
3. Select **Vitis**, Click Next
4. Click Next again (for **Vitis Unified Software Platform**)
5. Select Desired components:   (examples below)
    - SOCs -> Zynq-7000
    - 7 Series -> Artix-7 FPGAs
    - Ultrascale+ -> Artix Ultrascale+ FPGAs, Spartan Ultrascale+
    - can remove acquire or manaage license key.
    - Click **Next>**
6. Final page, Click **Download** and wait
7. Move the downloaded folder to dev-containers/vitis/vitis_2025.2
8. Update the [install_config.txt](./vitis/install_config.txt) to reflect required devices selected above.

_NOTE_: **Cannot upload to docker hub due to size and license issues.**
