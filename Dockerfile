FROM lsiobase/xenial
MAINTAINER peap0d

# set environment variables
ARG DEBIAN_FRONTEND="noninteractive"
ENV XDG_CONFIG_HOME="/config/xdg"
ARG RADARR_TAG="0.2.0.45"
ARG RADARR_FILENAME=Radarr.develop.v${RADARR_TAG}.linux
ARG RADARR_ZIP=Radarr.develop.${RADARR_TAG}.linux.tar.gz

# Add mono
RUN \
 apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys 3FA7E0328081BFF6A14DA29AA6A19B38D3D831EF && \
 echo "deb http://download.mono-project.com/repo/debian wheezy main" | tee /etc/apt/sources.list.d/mono-xamarin.list && \

# install packages
 apt-get update && \
 apt-get install -y \
  libcurl3 \
  mono-xsp4 \
  mediainfo \
  wget && \

# cleanup
 apt-get clean && \
 rm -rf \
  /tmp/* \
  /var/lib/apt/lists/* \
  /var/tmp/*

WORKDIR /opt
RUN wget "https://github.com/galli-leo/Radarr/releases/download/v$RADARR_TAG/$RADARR_ZIP"

RUN tar -xvzf /opt/$RADARR_ZIP && \
 rm -f "/opt/$RADARR_ZIP"

COPY s6-run /tmp/
RUN mkdir -p /var/run/s6/services/radarr/ && \
 mv /tmp/s6-run /var/run/s6/services/radarr/run && \
 chmod 755 /var/run/s6/services/radarr/run

# ports and volumes
EXPOSE 7878
VOLUME /config /downloads /movies
