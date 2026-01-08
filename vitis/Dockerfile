# Latest LTS Ubuntu
ARG BASE_IMAGE=ubuntu:24.04
FROM $BASE_IMAGE


# folder where the pre-download files are for copying into the container
ARG INSTALL_DIR=vitis_2025.2
# copy doesn't exand arg, this is a workaround
# ENV VIVADO_DIR_PATH=${VIVADO_DIR}

# set the varaible to use host's X11 display
ENV DISPLAY=0

# COPY ${VIVADO_DIR_PATH} /viv_install/

# Install packages required for running the vivado installer
RUN \
    ln -fs /usr/share/zoneinfo/UTC /etc/localtime && \
    apt-get update -y && \
    apt-get upgrade -y


# libs have been taken from Xilinx's installLibs.sh script (for 2025.2)
RUN \
    apt-get install -y --no-install-recommends \
    build-essential \
    libtinfo-dev \
    libncurses5-dev \
    python3-pip \
    python3-venv \
    python3-dev \
    ca-certificates \
    lsb-release \
    net-tools \
    patch \
    pigz \
    unzip \
    wget \
    graphviz \
    zip \
    xvfb \
    git \
    file \
    locales \
    openssh-client \
    libc6-dev-i386 \
    libnss3-dev \
    libgdk-pixbuf2.0-dev \
    libgtk-3-dev \
    libxss-dev  \
    fdisk \
    openssl \
    x11-apps \
    xauth \
    libsecret-1-dev

##############################3
## SSH Setup

RUN mkdir -p /root/.ssh

# Set permissions for SSH config
RUN chmod 700 /root/.ssh

# Avoid SSH host authenticity prompt
RUN touch /root/.ssh/config && echo "StrictHostKeyChecking no" >> /root/.ssh/config


########################
## Locale setup
    # TBD on whether this is needed.

# COPY /usr/lib/locale/locale-archive /usr/lib/locale/locale-archive

# # Set environment variables
# ENV LANG=en_US.UTF-8
# ENV LC_ALL=en_US.UTF-8
RUN locale-gen en_US.UTF-8 && \
    update-locale LANG=en_US.UTF-8

##########################
## Vivado/Vitis Setup

RUN mkdir -p /tmp_install
# COPY vitis_fix.sh /tmp_install/vitis_fix.sh
COPY install_config.txt /tmp_install/install_config.txt

RUN --mount=type=bind,source=$INSTALL_DIR,target=/tmp_install/$INSTALL_DIR \
    cd /tmp_install/$INSTALL_DIR && \
    ./xsetup \
    --agree 3rdPartyEULA,XilinxEULA \
    --config /tmp_install/install_config.txt \
    --batch Install \
    --location "/tools/Xilinx"

##############################3
## Cleanup

RUN \
    apt-get autoclean && \
    apt-get autoremove && \
    rm -rf /var/lib/apt/lists/*

##############################3
#
RUN mkdir -p /project
WORKDIR /project

# # Ensure that we're using bash for interactive sessions
# COPY --chmod=0755 entrypoint.sh /entrypoint.sh

RUN git config --global --add safe.directory /project

# Ensure that we're using bash for interactive sessions
# COPY --chmod=0755 entrypoint.sh /entrypoint.sh

# CMD ["/bin/bash", "-l"]
CMD ["bash", "-c", "source /tools/Xilinx/2025.2/Vitis/settings64.sh && exec bash"]

# ENTRYPOINT ["/entrypoint.sh"]
