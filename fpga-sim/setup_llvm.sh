#!/bin/bash

# Define the LLVM version
LLVM_VERSION=${1:-"20"}

echo "Setting up LLVM version $LLVM_VERSION, be sure to run this script with sudo"



wget  -N --no-clobber=no https://apt.llvm.org/llvm.sh
chmod +x llvm.sh
./llvm.sh ${LLVM_VERSION} all


# Set up alternatives to make LLVM the default
update-alternatives --install /usr/bin/llvm-config llvm-config /usr/bin/llvm-config-${LLVM_VERSION} 100
update-alternatives --install /usr/bin/clang clang /usr/bin/clang-${LLVM_VERSION} 100
update-alternatives --install /usr/bin/clangd clangd /usr/bin/clangd-${LLVM_VERSION} 100
update-alternatives --install /usr/bin/clang++ clang++ /usr/bin/clang++-${LLVM_VERSION} 100
update-alternatives --install /usr/bin/clang-tidy clang-tidy /usr/bin/clang-tidy-${LLVM_VERSION} 100
update-alternatives --install /usr/bin/clang-format clang-format /usr/bin/clang-format-${LLVM_VERSION} 100
update-alternatives --install /usr/bin/lld lld /usr/bin/lld-${LLVM_VERSION} 100
update-alternatives --install /usr/bin/lldb lldb /usr/bin/lldb-${LLVM_VERSION} 100
update-alternatives --install /usr/bin/intercept-build intercept-build /usr/bin/intercept-build-${LLVM_VERSION} 100
update-alternatives --install /usr/bin/scan-build scan-build /usr/bin/scan-build-${LLVM_VERSION} 100