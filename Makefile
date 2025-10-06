# PROJECT_DIR=$(shell cd ../test_mnt && pwd)
include .env
export

.PHONY: help all llvm-python llvm-python-test rtl-sim vitis rtl-sim-test vitis-run llvm-verilator llvm-ver-test push

help:
	@echo "Makefile for building the rtl project using Docker"
	@echo "Usage:"
	@echo "  make llvm-python   - Build the Docker image for llvm-python"
	@echo "  make rtl-sim      - Build the Docker image for rtl simulation"

llvm-python:
	docker compose build llvm-python
	docker tag tomkarolyshyn/llvm-python:3.12-$(LLVM_VERSION) tomkarolyshyn/llvm-python:latest

llvm-python-test:
	docker compose run --rm llvm-python bash -c "clang --version"

rtl-sim:
	docker compose build rtl-sim
	docker tag tomkarolyshyn/rtl-sim:$(VERILATOR_REV) tomkarolyshyn/rtl-sim:latest

rtl-sim-test:
	docker compose run --rm rtl-sim bash -c "verilator --version"

llvm-verilator:
	docker compose build llvm-verilator
	docker tag tomkarolyshyn/llvm-verilator:$(LLVM_VERSION)-$(VERILATOR_REV) tomkarolyshyn/llvm-verilator:latest

llvm-ver-test:
	docker compose run --rm llvm-verilator bash -c "clang --version && verilator --version"

vitis:
	docker compose build vitis

vitis-run :
	docker compose run --rm vitis
all:
	docker compose build llvm-python rtl-sim llvm-verilator
    # Tagging latest for all images, note that
	# this may be dangerous if builds fail.
	docker tag tomkarolyshyn/llvm-python:3.12-$(LLVM_VERSION) tomkarolyshyn/llvm-python:latest
	docker tag tomkarolyshyn/rtl-sim:$(VERILATOR_REV) tomkarolyshyn/rtl-sim:latest
	docker tag tomkarolyshyn/llvm-verilator:$(LLVM_VERSION)-$(VERILATOR_REV) tomkarolyshyn/llvm-verilator:latest


push:
	# Intentionally skipping vitis image push
	docker push tomkarolyshyn/llvm-python:3.12-$(LLVM_VERSION)
	docker push tomkarolyshyn/rtl-sim:$(VERILATOR_REV)
	docker push tomkarolyshyn/llvm-verilator:$(LLVM_VERSION)-$(VERILATOR_REV)
	docker push tomkarolyshyn/llvm-python:latest
	docker push tomkarolyshyn/rtl-sim:latest
	docker push tomkarolyshyn/llvm-verilator:latest
