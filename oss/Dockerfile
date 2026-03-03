# Base image: Ubuntu 24.04
ARG BASE_IMAGE=ubuntu:24.04
FROM $BASE_IMAGE

# Install required packages
RUN apt-get update \
    && apt-get install -y \
    curl \
    nodejs \
    npm \
    && apt-get clean && \
    rm -rf /var/lib/apt/lists/*

WORKDIR /app

COPY --from=ghcr.io/astral-sh/uv:latest /uv /uvx /bin/

# Copy requirements.txt and install Python dependencies into uv cache
ARG OSS_CAD_SUITE_VERSION=20251024
# Convert YYYYMMDD to YYYY-MM-DD format for download URL
RUN OSS_CAD_SUITE_DATE=$(echo ${OSS_CAD_SUITE_VERSION} | sed 's/^\([0-9]\{4\}\)\([0-9]\{2\}\)\([0-9]\{2\}\)$/\1-\2-\3/') && \
    echo "Downloading from: https://github.com/YosysHQ/oss-cad-suite-build/releases/download/${OSS_CAD_SUITE_DATE}/oss-cad-suite-linux-x64-${OSS_CAD_SUITE_VERSION}.tgz" && \
    curl -fsSL -o oss-cad-suite-linux-x64-${OSS_CAD_SUITE_VERSION}.tgz \
        "https://github.com/YosysHQ/oss-cad-suite-build/releases/download/${OSS_CAD_SUITE_DATE}/oss-cad-suite-linux-x64-${OSS_CAD_SUITE_VERSION}.tgz" && \
    mkdir -p /opt && \
    tar -xzf oss-cad-suite-linux-x64-${OSS_CAD_SUITE_VERSION}.tgz -C /opt && \
    rm oss-cad-suite-linux-x64-${OSS_CAD_SUITE_VERSION}.tgz





# Install nvm and Node.js
ARG NODE_VERSION=23
ENV NVM_DIR=/usr/local/nvm
RUN mkdir -p $NVM_DIR \
    && curl -fsSL https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.1/install.sh -o /tmp/install_nvm.sh \
    && bash /tmp/install_nvm.sh \
    && . "$NVM_DIR/nvm.sh" \
    && nvm install ${NODE_VERSION} \
    && nvm alias default ${NODE_VERSION}
# Source nvm in interactive shells
RUN echo 'export NVM_DIR="/usr/local/nvm"' >> /etc/bash.bashrc \
    && echo '[ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"' >> /etc/bash.bashrc

# Make node, npm, and npx available system-wide for non-interactive shells
RUN . "$NVM_DIR/nvm.sh" \
    && nvm use default >/dev/null \
    && NODE_BIN_DIR="$(dirname "$(nvm which current)")" \
    && ln -sf "$NODE_BIN_DIR/node" /usr/local/bin/node \
    && ln -sf "$NODE_BIN_DIR/npm" /usr/local/bin/npm \
    && ln -sf "$NODE_BIN_DIR/npx" /usr/local/bin/npx
RUN echo "Setting up LLVM version $LLVM_VERSION, be sure to run this script with sudo"


ENV PATH="/root/.local/bin:/opt/oss-cad-suite/bin:${PATH}"

