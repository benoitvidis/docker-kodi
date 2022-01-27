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
  && groupadd -g 1000 kodi \
  && useradd -g 1000 -m -u 1000 kodi \
  && mkdir /home/kodi/.kodi \
  && chown -R kodi:kodi /home/kodi \
  \
  && apt-get autoremove -y --purge \
  && rm -rf /var/lib/apt/lists/*

COPY pulse-client.conf /etc/pulse/client.conf

USER kodi:kodi

VOLUME /home/kodi/.kodi

ENTRYPOINT [ "kodi" ]
