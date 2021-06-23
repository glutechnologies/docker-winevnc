#
################################################################################
# base system
################################################################################
FROM ubuntu:20.04 as system


RUN sed -i 's#http://archive.ubuntu.com/ubuntu/#mirror://mirrors.ubuntu.com/mirrors.txt#' /etc/apt/sources.list;

# built-in packages
ENV DEBIAN_FRONTEND noninteractive
RUN apt update \
    && apt install -y --no-install-recommends software-properties-common curl \
    && apt update \
    && apt install -y --no-install-recommends --allow-unauthenticated \
        supervisor sudo net-tools zenity xz-utils \
        dbus-x11 x11-utils alsa-utils \
        mesa-utils libgl1-mesa-dri openbox \
        lxqt-core  featherpad lxqt-about lxqt-config lxqt-qtplugin \
        pavucontrol-qt qlipper qterminal \
    && apt autoclean -y \
    && apt autoremove -y \
    && rm -rf /var/lib/apt/lists/*
# install debs error if combine together
RUN apt update \
    && apt install -y --no-install-recommends --allow-unauthenticated \
        xvfb x11vnc \
        vim-tiny firefox ttf-ubuntu-font-family ttf-wqy-zenhei  \
    && apt autoclean -y \
    && apt autoremove -y \
    && rm -rf /var/lib/apt/lists/*

# Install wine
RUN dpkg --add-architecture i386 \
    && apt update \
    && apt install -y --no-install-recommends --allow-unauthenticated \
        wine64 wine32 \
    && apt autoclean -y \
    && apt autoremove -y \
    && rm -rf /var/lib/apt/lists/*

# tini to fix subreap
ARG TINI_VERSION=v0.18.0
ADD https://github.com/krallin/tini/releases/download/${TINI_VERSION}/tini /bin/tini
RUN chmod +x /bin/tini

################################################################################
# merge
################################################################################
FROM system
LABEL maintainer="roger@glutec.net"

COPY rootfs /

EXPOSE 5900
WORKDIR /root
ENV HOME=/home/ubuntu \
    SHELL=/bin/bash
ENTRYPOINT ["/entrypoint.sh"]