#!/bin/bash

VERILATOR_REV=${1:-v5.036}

# install the prerequisites
apt-get update \
&& DEBIAN_FRONTEND=noninteractive \
&& apt-get install --no-install-recommends -y \
                    autoconf \
                    bc \
                    bison \
                    build-essential \
                    ca-certificates \
                    ccache \
                    flex \
                    git \
                    help2man \
                    libfl2 \
                    libfl-dev \
                    libgoogle-perftools-dev \
                    numactl \
                    perl \
                    perl-doc \
                    python3 \
                    zlib1g \
                    zlib1g-dev


# Add an exception for the linter, we want to cd here in one layer
# to reduce the number of layers (and thereby size).
# hadolint ignore=DL3003
git clone --branch "${VERILATOR_REV}" --depth 1 https://github.com/verilator/verilator verilator
cd verilator
autoconf
./configure
make -j
make install
cd ..
rm -r verilator

