FROM ubuntu:jammy

LABEL fr.ben0.maintainer="Benoît Vidis"

ARG DEBIAN_FRONTEND=noninteractive
ARG TZ=Etc/UTC
ENV TZ=${TZ}

RUN  set -x \
  \
  && apt-get update \
  && apt-get install -y --no-install-recommends --no-install-suggests \
    gpg-agent \
    software-properties-common \
  && add-apt-repository ppa:team-xbmc/ppa \
  && add-apt-repository ppa:deadsnakes/ppa \
  && apt-get update \
  && apt-get install -y --no-install-recommends --no-install-suggests \
    ca-certificates \
    gdb \
    kodi \
    libpython3.11-dev \
    mesa-va-drivers \
    mesa-vdpau-drivers \
    mesa-vulkan-drivers \
    patchelf \
    pulseaudio \
    python3.11-dev \
    python3.11-full \
    samba-common-bin \
    sudo \
    tzdata \
    va-driver-all \
    vainfo \
    vdpauinfo \
  \
  && patchelf --replace-needed libpython3.10.so.1.0 libpython3.11.so.1.0 /usr/lib/x86_64-linux-gnu/kodi/kodi.bin \
  \
  && useradd -m -U -u 1000 -G video kodi \
  && echo 'kodi ALL=(ALL:ALL) NOPASSWD: ALL' >> /etc/sudoers \
  \
  && apt-get autoremove -y --purge \
  && rm -rf /var/lib/apt/lists/*

COPY pulse-client.conf /etc/pulse/client.conf

USER kodi:kodi

VOLUME /home/kodi/.kodi

CMD [ "kodi" ]
