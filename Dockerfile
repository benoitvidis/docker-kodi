FROM vidiben/rootless_x_intel:alpine-3.12

# The build is heavily inspired by Alpine's package
# @see https://git.alpinelinux.org/aports/tree/community/kodi/APKBUILD

LABEL fr.ben0.maintainer="Benoît Vidis"

ARG KODI_VERSION=18.9-Leia
ARG LIBDVDCSS_VERSION=1.4.2-Leia-Beta-5
ARG LIBDVDREAD_VERSION=6.0.0-Leia-Alpha-3
ARG LIBDVDNAV_VERSION=6.0.0-Leia-Alpha-3
ARG CROSSGUID_VERSION=8f399e8bd4

COPY alpine.patch /home/me/alpine.patch
RUN  set -x \
  \
  && sudo apk add --no-cache --virtual deps \
      alsa-lib-dev \
      autoconf \
      automake \
      avahi-dev \
      bluez-dev \
      build-base \
      ccache \
      cmake \
      coreutils \
      curl-dev \
      dbus-dev \
      doxygen \
      eudev-dev \
      ffmpeg-dev \
      flatbuffers-dev \
      fmt-dev \
      freetype-dev \
      fribidi-dev \
      fstrcmp-dev \
      giflib-dev \
      git \
      glu-dev \
      graphviz \
      jpeg-dev \
      lcms2-dev \
      libass-dev \
      libbluray-dev \
      libcap-dev \
      libcdio-dev \
      libcec-dev \
      libdvdcss-dev \
      libinput-dev \
      libjpeg-turbo-dev \
      libplist-dev \
      libmicrohttpd-dev \
      libnfs-dev \
      libshairport-dev \
      libtool \
      libva-dev \
      libva-glx-dev \
      libvorbis-dev \
      libvdpau-dev \
      libxslt-dev \
      lzo-dev \
      mariadb-connector-c-dev \
      mesa-dev \
      openjdk8-jre-base \
      openssl-dev \
      pcre-dev \
      pugixml-dev \
      pulseaudio-dev \
      python2-dev \
      rapidjson-dev \
      samba-dev \
      sndio-dev \
      sqlite-dev \
      taglib-dev \
      tar \
      tinyxml-dev \
      util-linux-dev \
      xz \
      yasm \
      zlib-dev \
  && sudo apk add --no-cache \
      avahi \
      bash \
      curl \
      eudev-libs \
      ffmpeg-libs \
      fmt \
      fstrcmp \
      hicolor-icon-theme \
      libass \
      libbluray \
      libcdio \
      libcec \
      libmicrohttpd \
      libnfs \
      libpcrecpp \
      libsmbclient \
      libva \
      libxslt \
      lzo \
      mariadb-connector-c \
      mesa-egl \
      mesa-gl \
      pcre \
      py-bluez \
      py-pillow \
      py-simplejson \
      python2 \
      sndio-libs \
      taglib \
      tinyxml \
      xdpyinfo \
  \
  && git clone -b ${KODI_VERSION} https://github.com/xbmc/xbmc kodi \
  && cd kodi \
  && patch -p1 < /home/me/alpine.patch \
  && curl -sSLo libdvdcss.tar.gz https://github.com/xbmc/libdvdcss/archive/${LIBDVDCSS_VERSION}.tar.gz \
  && curl -sSLo libdvdread.tar.gz https://github.com/xbmc/libdvdread/archive/${LIBDVDREAD_VERSION}.tar.gz \
  && curl -sSLo libdvdnav.tar.gz https://github.com/xbmc/libdvdnav/archive/${LIBDVDNAV_VERSION}.tar.gz \
  && curl -sSLo crossguid.tar.gz https://mirrors.kodi.tv/build-deps/sources/crossguid-${CROSSGUID_VERSION}.tar.gz \
  \
  && sudo make -C tools/depends/target/crossguid PREFIX=/usr/local \
  && mkdir ../kodi-build \
  && cd ../kodi-build \
  && cmake ../kodi \
      -DCMAKE_BUILD_TYPE=None \
      -DCMAKE_INSTALL_PREFIX=/usr/local \
      -DCMAKE_INSTALL_LIBDIR=lib \
      -DENABLE_INTERNAL_CROSSGUID=ON \
      -DENABLE_INTERNAL_FFMPEG=OFF \
      -DENABLE_INTERNAL_RapidJSON=OFF \
      -DENABLE_INTERNAL_FMT=OFF \
      -DENABLE_INTERNAL_FSTRCMP=OFF \
      -DENABLE_INTERNAL_FLATBUFFERS=OFF \
      -Dlibdvdcss_URL=../kodi/libdvdcss.tar.gz \
      -Dlibdvdread_URL=../kodi/libdvdread.tar.gz \
      -Dlibdvdnav_URL=../kodi/libdvdnav.tar.gz \
      -DCROSSGUID_URL=../kodi/crossguid.tar.gz \
  && make \
  && sudo make install \
  \
  && rm /home/me/alpine.patch \
  && sudo rm -rf /home/me/kodi \
  && sudo rm -rf /home/me/kodi-build \
  && sudo apk del deps \
  \
  && echo done

VOLUME /home/me/.kodi
VOLUME /root/.kodi

# running as non-root crashes 
# @todo: fix it when possible
#
# COPY docker-entrypoint.sh /usr/local/bin/docker-entrypoint.sh
# ENTRYPOINT [ "docker-entrypoint.sh" ]

ENTRYPOINT [ "sudo" ]
CMD [ "kodi" ]
