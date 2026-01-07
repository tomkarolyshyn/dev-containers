# PROJECT_DIR=$(shell cd ../test_mnt && pwd)
include .env
export

.PHONY: help all launch llvm-python llvm-python-test rtl-sim vitis rtl-sim-test vitis-run \
 llvm-verilator llvm-ver-test llvm-cuda llvm-oss  llvm-oss-test push github-oss github-oss-test \
 llvm-cuda-22 llvm-cuda-22-test

help:
	@echo "Makefile for building Docker images"
	@echo "      see the compose.yaml for more details on the Docker images"
	@echo "Usage:"
	@echo "  make llvm-python   - Build the Docker image for llvm-python"
	@echo "  make rtl-sim      - Build the Docker image for rtl simulation"
	@echo "  make github-oss   - Build the Docker image for github-oss"
	@echo "  make llvm-oss     - Build the Docker image for llvm-oss"
	@echo "  make llvm-verilator - Build the Docker image for llvm-verilator"
	@echo "  make llvm-cuda    - Build the Docker image for llvm-cuda"
	@echo "  make vitis        - Build the Docker image for vitis"
	@echo "  make vitis-run    - Run the vitis container"
	@echo "  make launch <service> - Launch a container interactively (e.g., make launch rtl-sim)"
	@echo "  make <name>-test - Test CUDA image with explicit GPU access"
	@echo "  make all          - Build all primary images and tag latest"
	@echo "  make push         - Push images to Docker Hub"

launch:
	@SERVICE=$$(echo $(filter-out $@,$(MAKECMDGOALS)) | awk '{print $$1}'); \
	if [ -z "$$SERVICE" ]; then \
		echo "Usage: make launch <service-name>"; \
		echo "Available services: llvm-python, rtl-sim, llvm-cuda (or llvm-cuda-24), llvm-cuda-22, llvm-verilator, llvm-oss, github-oss"; \
		exit 1; \
	fi; \
	if [ "$$SERVICE" = "llvm-cuda" ]; then \
		SERVICE="llvm-cuda-24"; \
	fi; \
	docker compose run --no-build --rm $$SERVICE

# Catch-all to prevent Make from trying to build the service name as a target
%:
	@:

llvm-python:
	docker compose build llvm-python
	docker tag tomkarolyshyn/llvm-python:3.12-$(LLVM_VERSION) tomkarolyshyn/llvm-python:latest

llvm-python-test:
	docker compose run --rm llvm-python bash -c "clang --version && opt --version"

rtl-sim:
	docker compose build rtl-sim
	docker tag tomkarolyshyn/rtl-sim:$(VERILATOR_REV) tomkarolyshyn/rtl-sim:latest

github-oss:
	docker compose build github-oss
	docker tag tomkarolyshyn/github-oss:$(OSS_CAD_SUITE_VERSION) tomkarolyshyn/github-oss:latest

github-oss-test:
	docker compose run --rm github-oss bash -c "yosys --version && verilator --version && opt --version"

rtl-sim-test:
	docker compose run --rm rtl-sim bash -c "verilator --version"

llvm-oss:
	docker compose build llvm-oss
	docker tag tomkarolyshyn/llvm-oss:$(LLVM_VERSION)-$(OSS_CAD_SUITE_VERSION) tomkarolyshyn/llvm-oss:latest

llvm-oss-test:
	docker compose run --rm llvm-oss bash -c "clang --version && yosys --version && verilator --version && uv --version && opt --version"

llvm-verilator:
	docker compose build llvm-verilator
	docker tag tomkarolyshyn/llvm-verilator:$(LLVM_VERSION)-$(VERILATOR_REV) tomkarolyshyn/llvm-verilator:latest

llvm-verilator-test:
	docker compose run --rm llvm-verilator bash -c "clang --version && verilator --version && opt --version"

llvm-cuda:
	docker compose build llvm-cuda-24
	docker tag tomkarolyshyn/llvm-cuda:cuda-${CUDA_VERSION}-llvm-${LLVM_VERSION} tomkarolyshyn/llvm-cuda:latest

llvm-cuda-test:
	@echo "Testing CUDA 24 container with GPU access (requires GPU)..."
	docker compose run --rm llvm-cuda-24 bash -c "nvidia-smi && clang --version && yosys --version && verilator --version"

vitis:
	docker compose build vitis

vitis-run :
	docker compose run --rm vitis
all:
	# Build all images, parallel builds through docker compose
	docker compose build llvm-python rtl-sim llvm-verilator llvm-cuda-24 llvm-oss github-oss
	# Tagging latest for all images, note that
	# this may be dangerous if builds fail.
	docker tag tomkarolyshyn/llvm-python:3.12-$(LLVM_VERSION) tomkarolyshyn/llvm-python:latest
	docker tag tomkarolyshyn/rtl-sim:$(VERILATOR_REV) tomkarolyshyn/rtl-sim:latest
	docker tag tomkarolyshyn/llvm-verilator:$(LLVM_VERSION)-$(VERILATOR_REV) tomkarolyshyn/llvm-verilator:latest
	docker tag tomkarolyshyn/llvm-cuda:cuda-${CUDA_VERSION}-llvm-${LLVM_VERSION} tomkarolyshyn/llvm-cuda:latest
	docker tag tomkarolyshyn/llvm-oss:$(LLVM_VERSION)-$(OSS_CAD_SUITE_VERSION) tomkarolyshyn/llvm-oss:latest
push:
	# Intentionally skipping vitis image push
	docker push tomkarolyshyn/llvm-python:3.12-$(LLVM_VERSION)
	docker push tomkarolyshyn/rtl-sim:$(VERILATOR_REV)
	docker push tomkarolyshyn/llvm-verilator:$(LLVM_VERSION)-$(VERILATOR_REV)
	docker push tomkarolyshyn/llvm-cuda:cuda-${CUDA_VERSION}-llvm-${LLVM_VERSION}

	docker push tomkarolyshyn/llvm-python:latest
	docker push tomkarolyshyn/rtl-sim:latest
	docker push tomkarolyshyn/llvm-verilator:latest
	docker push tomkarolyshyn/llvm-cuda:latest
	docker push tomkarolyshyn/llvm-cuda-22:latest
	docker push tomkarolyshyn/llvm-oss:$(LLVM_VERSION)-$(OSS_CAD_SUITE_VERSION)
	docker push tomkarolyshyn/llvm-oss:latest
