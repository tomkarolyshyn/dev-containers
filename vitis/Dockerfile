# Latest LTS Ubuntu
ARG BASE_IMAGE=ubuntu:24.04
FROM $BASE_IMAGE


# ARG VERILATOR_REV=v5.034
ARG VIVADO_DIR=Xilinx_2025.1
# copy doesn't exand arg, this is a workaround
# ENV VIVADO_DIR_PATH=${VIVADO_DIR}

# set the varaible to use host's X11 display
ENV DISPLAY=0

# COPY ${VIVADO_DIR_PATH} /viv_install/

RUN mkdir -p /viv_install
# COPY vitis_fix.sh /viv_install/vitis_fix.sh  # needed for the Vitis GUI to work
COPY install_config.txt /viv_install/install_config.txt
COPY installLibs.sh /viv_install/installLibs.sh


# Install packages required for running the vivado installer
RUN \
  ln -fs /usr/share/zoneinfo/UTC /etc/localtime && \
  apt-get update -y && \
  apt-get upgrade -y

RUN \
  apt-get install -y --no-install-recommends \
    build-essential \
    libtinfo-dev \
    python3-pip \
    python3-venv \
    python3-dev \
    git \
    make \
    ca-certificates \
    locales \
    lsb-release \
    net-tools \
    patch \
    pigz \
    unzip \
    wget \
    libc6-dev-i386 net-tools \
    graphviz \
    make \
    unzip \
    zip \
    g++ \
    xvfb \
    git \
    openssh-client \
    libc6-dev-i386 \
    libnss3-dev \
    libgdk-pixbuf2.0-dev \
    libgtk-3-dev \
    libxss-dev  \
    fdisk


##############################3
## SSH Setup

RUN mkdir -p /root/.ssh

# Set permissions for SSH config
RUN chmod 700 /root/.ssh

# Avoid SSH host authenticity prompt
RUN touch /root/.ssh/config && echo "StrictHostKeyChecking no" >> /root/.ssh/config

RUN apt-get install -y x11-apps xauth
##########################
## Vivado/Vitis Setup

RUN --mount=type=bind,source=$VIVADO_DIR,target=/$VIVADO_DIR \
    cd /$VIVADO_DIR  && ./xsetup --agree 3rdPartyEULA,XilinxEULA --batch Install --config /viv_install/install_config.txt

# RUN cd /viv_install  && \
#      ./xsetup --agree 3rdPartyEULA,XilinxEULA --batch Install --config /viv_install/install_config.txt

# RUN /viv_install/installLibs.sh && /viv_install/vitis_fix.sh
# RUN cd / && rm -r viv_install
##############################3
## Cleanup

RUN \
  apt-get autoclean && \
  apt-get autoremove && \
  locale-gen en_US.UTF-8 && \
  update-locale LANG=en_US.UTF-8 && \
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

CMD ["/bin/bash", "-l"]

# ENTRYPOINT ["/entrypoint.sh"]