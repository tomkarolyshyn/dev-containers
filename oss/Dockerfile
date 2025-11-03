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

ENV PATH="/root/.local/bin:/opt/oss-cad-suite/bin:${PATH}"

