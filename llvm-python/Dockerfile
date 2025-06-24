ARG BASE_IMAGE=ubuntu:24.04
FROM $BASE_IMAGE


ARG LLVM_VERSION=20

# Add LLVM repository for clang 20
RUN apt-get update && apt-get install -y --no-install-recommends \
    wget \
    gnupg \
    lsb-release \
    ca-certificates \
    apt-transport-https \
    software-properties-common

RUN apt-get update ; apt-get install --no-install-recommends \
    -y \
    autoconf \
    automake \
    cmake \
    libfreetype6-dev \
    g++ \
    gcc \
    time \
    libxml2-dev \
    python3 \
    python3-pip \
    python3-venv \
    python3-dev \
    make \
    musl-dev \
    ninja-build \
    libncurses5-dev libncursesw5-dev \
    nano \
    git \
    libz-dev \
    libzstd-dev

RUN echo "Setting up LLVM version $LLVM_VERSION, be sure to run this script with sudo"

RUN wget -N --no-clobber=no https://apt.llvm.org/llvm.sh
RUN chmod +x llvm.sh
RUN ./llvm.sh ${LLVM_VERSION} all

RUN # Set up alternatives to make LLVM the default
RUN update-alternatives --install /usr/bin/llvm-config llvm-config /usr/bin/llvm-config-${LLVM_VERSION} 100
RUN update-alternatives --install /usr/bin/clang clang /usr/bin/clang-${LLVM_VERSION} 100
RUN update-alternatives --install /usr/bin/clangd clangd /usr/bin/clangd-${LLVM_VERSION} 100
RUN update-alternatives --install /usr/bin/clang++ clang++ /usr/bin/clang++-${LLVM_VERSION} 100
RUN update-alternatives --install /usr/bin/clang-tidy clang-tidy /usr/bin/clang-tidy-${LLVM_VERSION} 100
RUN update-alternatives --install /usr/bin/clang-format clang-format /usr/bin/clang-format-${LLVM_VERSION} 100
RUN update-alternatives --install /usr/bin/lld lld /usr/bin/lld-${LLVM_VERSION} 100
RUN update-alternatives --install /usr/bin/lldb lldb /usr/bin/lldb-${LLVM_VERSION} 100
RUN update-alternatives --install /usr/bin/intercept-build intercept-build /usr/bin/intercept-build-${LLVM_VERSION} 100
RUN update-alternatives --install /usr/bin/scan-build scan-build /usr/bin/scan-build-${LLVM_VERSION} 100


# install some python packages,
#     --break-system-packages is OK in containers.

ENV PIP_NO_CACHE_DIR=1
RUN pip install --break-system-packages uv
RUN pip install --break-system-packages pre-commit

WORKDIR /project
# Necessary for a couple of old tests
# cmd ["make" "examples"]


##############################
# Cleanup
RUN \
  apt-get autoclean && \
  apt-get autoremove && \
  rm -rf /var/lib/apt/lists/*


CMD ["bash"]
