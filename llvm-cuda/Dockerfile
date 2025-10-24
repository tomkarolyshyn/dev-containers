ARG BASE_IMAGE=nvidia/cuda:12.8.1-cudnn-runtime-ubuntu24.04
FROM $BASE_IMAGE

RUN apt-get update 
 


RUN apt-get update && apt-get install -y --no-install-recommends \
    wget \
    gnupg \
    curl \
    lsb-release \
    ca-certificates \
    apt-transport-https \
    software-properties-common 

RUN apt-get update && apt-get install --no-install-recommends \
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
    nodejs \
    libz-dev \
    libzstd-dev

RUN apt-get install -y  telnet dnsutils net-tools 

RUN DEBIAN_FRONTEND=noninteractive TZ=America/New_York apt-get -y install tzdata


RUN curl -Ls https://astral.sh/uv/install.sh | sh


ARG OSS_CAD_SUITE_VERSION=20251024
# Convert YYYYMMDD to YYYY-MM-DD format for download URL
RUN OSS_CAD_SUITE_DATE=$(echo ${OSS_CAD_SUITE_VERSION} | sed 's/^\([0-9]\{4\}\)\([0-9]\{2\}\)\([0-9]\{2\}\)$/\1-\2-\3/') && \
    echo "Downloading from: https://github.com/YosysHQ/oss-cad-suite-build/releases/download/${OSS_CAD_SUITE_DATE}/oss-cad-suite-linux-x64-${OSS_CAD_SUITE_VERSION}.tgz" && \
    curl -fsSL -o oss-cad-suite-linux-x64-${OSS_CAD_SUITE_VERSION}.tgz \
        "https://github.com/YosysHQ/oss-cad-suite-build/releases/download/${OSS_CAD_SUITE_DATE}/oss-cad-suite-linux-x64-${OSS_CAD_SUITE_VERSION}.tgz" && \
    mkdir -p /opt && \
    tar -xzf oss-cad-suite-linux-x64-${OSS_CAD_SUITE_VERSION}.tgz -C /opt && \
    rm oss-cad-suite-linux-x64-${OSS_CAD_SUITE_VERSION}.tgz

ENV PATH="/root/.local/bin:/opt/oss-cad-suite/bin:${PATH}" 

  

ARG LLVM_VERSION=20

RUN echo "Setting up LLVM version $LLVM_VERSION, be sure to run this script with sudo"

RUN wget -N --no-clobber=no https://apt.llvm.org/llvm.sh
RUN chmod +x llvm.sh
RUN ./llvm.sh ${LLVM_VERSION} all

# there might be a better way to do this, but let's:
# Set up alternatives to make LLVM the default
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


##############################
# Cleanup
RUN \
    apt-get autoclean && \
    apt-get autoremove -y && \
    rm -rf /var/lib/apt/lists/*

