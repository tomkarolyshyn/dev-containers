# Base image: Ubuntu 24.04
ARG BASE_IMAGE=ubuntu:24.04
FROM $BASE_IMAGE

ARG VERILATOR_REV=v5.036

# Copy setup scripts and other files
COPY --chmod=0755 verilator_setup.sh /tmp/verilator_setup.sh
COPY requirements.txt /tmp/requirements.txt

# Run the verilator install (includes apt install)
RUN /tmp/verilator_setup.sh  ${VERILATOR_REV}

# Install additional useful tools
RUN apt-get update && apt-get install -y --no-install-recommends \
    lsb-release  \
    build-essential \
    software-properties-common \
    gnupg \
    git \
    make \
    gdb \
    curl \
    wget \
    vim \
    nano \
    sudo \
    procps \
    locales \
    python3 \
    python3-pip \
    python3-venv \
    python3-dev \

ENV PIP_NO_CACHE_DIR=1


RUN pip install --break-system-packages -r /tmp/requirements.txt


# Set up a working directory
RUN mkdir -p /project
WORKDIR /project


##############################
# Cleanup
RUN \
  apt-get autoclean && \
  apt-get autoremove && \
  rm -rf /var/lib/apt/lists/*

# Default command
CMD ["/bin/bash"]