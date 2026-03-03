# Base image: Ubuntu 24.04
ARG BASE_IMAGE=ubuntu:24.04
FROM $BASE_IMAGE

ARG VERILATOR_REV=v5.036

# Copy setup scripts and other files
COPY --chmod=0755 verilator_setup.sh /tmp/verilator_setup.sh
COPY requirements.txt /tmp/requirements.txt


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
    python3-dev

# Run the verilator install (includes apt install)
RUN /tmp/verilator_setup.sh  ${VERILATOR_REV}

ENV PIP_NO_CACHE_DIR=1

# install some python packages for use in sim
RUN pip install --break-system-packages -r /tmp/requirements.txt

# Set up a working directory
RUN mkdir -p /project
WORKDIR /project


# let's re-do this to be sure.
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
##############################
# Cleanup
RUN \
    apt-get autoclean && \
    apt-get autoremove -y && \
    rm -rf /var/lib/apt/lists/*

# Default command
CMD ["/bin/bash"]
