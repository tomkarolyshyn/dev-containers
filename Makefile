# PROJECT_DIR=$(shell cd ../test_mnt && pwd)

.PHONY: help all llvm-python llvm-python-test rtl-sim vitis rtl-sim-test vitis-run

help:
	@echo "Makefile for building the rtl project using Docker"
	@echo "Usage:"
	@echo "  make llvm-python   - Build the Docker image for llvm-python"
	@echo "  make rtl-sim      - Build the Docker image for rtl simulation"

llvm-python:
	docker compose build llvm-python

llvm-python-test:
	docker compose run --rm llvm-python bash -c "clang --version"

rtl-sim:
	docker compose build rtl-sim

rtl-sim-test:
	docker compose run --rm rtl-sim bash -c "verilator --version"

vitis:
	docker compose build vitis

vitis-run :
	docker compose run --rm vitis
all:
	docker compose build
