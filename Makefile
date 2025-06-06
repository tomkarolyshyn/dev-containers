# PROJECT_DIR=$(shell cd ../test_mnt && pwd)

.PHONY: help all llvm-python fpga-sim vitis fpga-sim-test vitis-run

help:
	@echo "Makefile for building the FPGA project using Docker"
	@echo "Usage:"
	@echo "  make llvm-python   - Build the Docker image for llvm-python"
	@echo "  make fpga-sim      - Build the Docker image for FPGA simulation"

llvm-python:
	docker-compose build llvm-python

fpga-sim:
	docker-compose build fpga-sim

fpga-sim-test:
	docker run -it --rm --name fpga-sim fpga-sim:latest bash

vitis:
	docker-compose build vitis

vitis-run :
	docker-compose run --rm vitis
all:
	docker-compose build
