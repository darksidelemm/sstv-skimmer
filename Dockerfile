FROM ubuntu:22.04

ARG DEBIAN_FRONTEND=noninteractive
ARG QSSTV_CONFIG=qsstv_9.0.conf

#RUN sed -i -re 's/ports.ubuntu.com\/ubuntu-ports|security.ubuntu.com\/ubuntu-ports|archive.ubuntu.com\/ubuntu|security.ubuntu.com\/ubuntu/old-releases.ubuntu.com\/ubuntu/g' /etc/apt/sources.list

RUN apt-get update && apt-get install -y libfftw3-dev libfftw3-3 ffmpeg \
xvfb qsstv pulseaudio build-essential git libsamplerate0-dev alsa-utils \
xvfb python3 python3-pip cmake portaudio19-dev python3-dev python3-opencv \
alsa-utils rtl-sdr

# Utilities needed for ka9q-radio build
RUN apt-get -y update && apt-get -y upgrade && apt-get -y install --no-install-recommends \
    cmake build-essential ca-certificates git libusb-1.0-0-dev \
    libatlas-base-dev libsoapysdr-dev soapysdr-module-all \
    libairspy-dev libairspyhf-dev libavahi-client-dev libbsd-dev \
    libfftw3-dev libhackrf-dev libiniparser-dev libncurses5-dev \
    libopus-dev librtlsdr-dev libusb-1.0-0-dev libusb-dev \
    portaudio19-dev libasound2-dev libogg-dev uuid-dev avahi-utils libnss-mdns unzip && rm -rf /var/lib/apt/lists/*

# spy server
RUN git clone https://github.com/miweber67/spyserver_client.git && cd spyserver_client && make && cp ss_client /usr/bin/ss_iq
#csdr
RUN cd / && git clone https://github.com/jketterl/csdr.git && cd csdr && git checkout master && mkdir -p build && cd build && cmake .. && make && make install && ldconfig


# ka9q-radio commit:
ARG KA9Q_REF=cc22b5f5e3c26c37df441ebff29eea7d59031afd

# Compile and install pcmrecord and tune from KA9Q-Radio
ADD https://github.com/ka9q/ka9q-radio/archive/$KA9Q_REF.zip /tmp/ka9q-radio.zip
RUN unzip /tmp/ka9q-radio.zip -d /tmp && \
  cd /tmp/ka9q-radio-$KA9Q_REF && \
  make \
    -f Makefile.linux \
    ARCHOPTS= \
    pcmrecord tune && \
  cp pcmrecord /usr/bin/ && \
  cp tune /usr/bin/ && \
  rm -rf /root/ka9q-radio

# python dependencies
RUN pip3 install Mastodon.py watchdog soundmeter requests
#pulse server requiremeent
RUN adduser root pulse-access

# qsstv config
RUN mkdir -p /root/.config/ON4QZ/
COPY ${QSSTV_CONFIG} /root/.config/ON4QZ/qsstv_9.0.conf

# poster script
COPY poster.py /poster.py

#copy monitor scripts
COPY shutdown.sh /shutdown.sh
RUN chmod a+x /shutdown.sh

# startup script
COPY run.sh /run.sh
RUN chmod a+x /run.sh

ENTRYPOINT ["/bin/sh", "-c", "/run.sh"]
VOLUME /images
VOLUME /drm