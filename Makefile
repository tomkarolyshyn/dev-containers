# PROJECT_DIR=$(shell cd ../test_mnt && pwd)
include .env
export

.PHONY: help all push build-and-push \
 llvm-python llvm-python-run llvm-python-build llvm-python-test \
 rtl-sim rtl-sim-run rtl-sim-build rtl-sim-test \
 llvm-oss llvm-oss-run llvm-oss-build llvm-oss-test \
 llvm-verilator llvm-verilator-run llvm-verilator-build llvm-verilator-test \
 llvm-cuda llvm-cuda-run llvm-cuda-build llvm-cuda-test \
 vitis vitis-run vitis-build vitis-test

# Images to push to Docker Hub
PUSH_IMAGES = llvm-python rtl-sim llvm-verilator llvm-cuda llvm-oss

help:
	@echo "Makefile for building Podman images"
	@echo "      see the compose.yaml for more details on the container images"
	@echo "Usage:"
	@echo "  make <name>-build  - Build the container image"
	@echo "  make <name>-run    - Launch container interactively"
	@echo "  make <name>-test   - Test the container"
	@echo ""
	@echo "Available images: llvm-python, rtl-sim, llvm-oss, llvm-verilator, llvm-cuda, vitis"
	@echo ""
	@echo "  make all          - Build all primary images and tag latest"
	@echo "  make push         - Push images to Docker Hub"
	@echo "  make build-and-push - Build all images and push to Docker Hub"

##########################
# llvm-python
##########################
llvm-python-build:
	podman compose build llvm-python
	podman tag tomkarolyshyn/llvm-python:3.12-$(LLVM_VERSION) tomkarolyshyn/llvm-python:latest

llvm-python-run:
	podman compose run --rm llvm-python

llvm-python-test:
	podman compose run --rm llvm-python bash -c "clang --version && opt --version && node -v"

##########################
# rtl-sim
##########################
rtl-sim-build:
	podman compose build rtl-sim
	podman tag tomkarolyshyn/rtl-sim:$(VERILATOR_REV) tomkarolyshyn/rtl-sim:latest

rtl-sim-run:
	podman compose run --rm rtl-sim

rtl-sim-test:
	podman compose run --rm rtl-sim bash -c "verilator --version"

##########################
# llvm-oss
##########################
llvm-oss-build:
	podman compose build llvm-oss
	podman tag tomkarolyshyn/llvm-oss:$(LLVM_VERSION)-$(OSS_CAD_SUITE_VERSION) tomkarolyshyn/llvm-oss:latest

llvm-oss-run:
	podman compose run --rm llvm-oss

llvm-oss-test:
	podman compose run --rm llvm-oss bash -c "clang --version && yosys --version && verilator --version && uv --version && opt --version"

##########################
# llvm-verilator
##########################
llvm-verilator-build:
	podman compose build llvm-verilator
	podman tag tomkarolyshyn/llvm-verilator:$(LLVM_VERSION)-$(VERILATOR_REV) tomkarolyshyn/llvm-verilator:latest

llvm-verilator-run:
	podman compose run --rm llvm-verilator

llvm-verilator-test:
	podman compose run --rm llvm-verilator bash -c "clang --version && verilator --version && opt --version && node -v"

##########################
# llvm-cuda
##########################
llvm-cuda-build:
	podman compose build llvm-cuda-24
	podman tag tomkarolyshyn/llvm-cuda:cuda-${CUDA_VERSION}-llvm-${LLVM_VERSION} tomkarolyshyn/llvm-cuda:latest

llvm-cuda-run:
	podman compose run --rm llvm-cuda-24

llvm-cuda-test:
	@echo "Testing CUDA 24 container with GPU access (requires GPU)..."
	podman compose run --rm llvm-cuda-24 bash -c "nvidia-smi && clang --version && yosys --version && verilator --version  && node -v"

##########################
# vitis
##########################
# Built rootful: rootless podman commits the ~60GB install layer extremely
# slowly even with native overlay, due to user-namespace metadata overhead.
# The image lives in /var/lib/containers/storage and is only visible to
# `sudo podman`, never your rootless store. See README for details.
vitis-build:
	sudo podman compose build vitis

vitis-run:
	sudo podman compose run --rm vitis

vitis-test:
	sudo podman compose run --rm vitis bash -c "source /tools/Xilinx/2025.2/Vitis/settings64.sh && vivado -version && vitis --version"

##########################
# Build all
##########################
all:
	# Build all images, parallel builds through podman compose
	podman compose build llvm-python rtl-sim llvm-verilator llvm-cuda-24 llvm-oss
	# Tagging latest for all images, note that
	# this may be dangerous if builds fail.
	podman tag tomkarolyshyn/llvm-python:3.12-$(LLVM_VERSION) tomkarolyshyn/llvm-python:latest
	podman tag tomkarolyshyn/rtl-sim:$(VERILATOR_REV) tomkarolyshyn/rtl-sim:latest
	podman tag tomkarolyshyn/llvm-verilator:$(LLVM_VERSION)-$(VERILATOR_REV) tomkarolyshyn/llvm-verilator:latest
	podman tag tomkarolyshyn/llvm-cuda:cuda-${CUDA_VERSION}-llvm-${LLVM_VERSION} tomkarolyshyn/llvm-cuda:latest
	podman tag tomkarolyshyn/llvm-oss:$(LLVM_VERSION)-$(OSS_CAD_SUITE_VERSION) tomkarolyshyn/llvm-oss:latest

##########################
# Push to Docker Hub
##########################
push:
	# Intentionally skipping vitis image push
	@echo "Pushing all images to Docker Hub..."
	@for img in $(PUSH_IMAGES); do \
		echo "Pushing $$img..."; \
		podman push --all-tags tomkarolyshyn/$$img || exit 1; \
	done
	@echo "All images pushed successfully!"

build-and-push: all
	@echo "Build complete. Starting push to Docker Hub..."
	$(MAKE) push

##########################
# Catch-all for unknown targets
##########################
%:
	@echo "Unknown target: $@"
	@echo ""
	@$(MAKE) --no-print-directory help
