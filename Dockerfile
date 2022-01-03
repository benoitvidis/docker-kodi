FROM ubuntu:focal

LABEL fr.ben0.maintainer="Benoît Vidis"

RUN  set -x \
  \
  && apt-get update \
  && apt-get install -y --no-install-recommends --no-install-suggests \
    software-properties-common \
  && add-apt-repository ppa:team-xbmc/ppa \
  && apt-get update \
  && apt-get install -y --no-install-recommends --no-install-suggests \
    ca-certificates \
    kodi \
    pulseaudio \
    samba-common-bin \
    tzdata \
    va-driver-all \
  \
  && mkdir -p /root/.kodi \
  \
  && apt-get autoremove -y --purge \
  && rm -rf /var/lib/apt/lists/*

VOLUME /root/.kodi

ENTRYPOINT [ "kodi" ]
