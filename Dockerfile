# Dockerfile to build spyserver image
#
# D. G. Adams 2025-March-11
#
FROM debian:bookworm-slim AS dga-build
WORKDIR /

ADD https://github.com/airspy/airspyhf/archive/master.zip .

RUN <<EOR
#   Make airspy libraries
    apt-get -yq  update
    apt-get -yq install build-essential cmake libusb-1.0-0-dev pkg-config unzip
    unzip master.zip
    mkdir /airspyhf-master/build
    cd /airspyhf-master/build
    cmake ../
    make
    make install
EOR

# Download spyserver binary
WORKDIR /spy
ADD  https://airspy.com/?ddownload=4262EOF ./spy.tgz
RUN  tar -xzf spy.tgz && rm spy.tgz

########################################################
# Layer to build the filesystem. Loads dependancies then muntz files.

FROM debian:bookworm-slim AS dga-filesystem
WORKDIR /spy
COPY --from=dga-build /spy /spy
COPY --from=dga-build /usr/local/lib  /usr/local/lib
COPY spy-muntz.sh .
RUN <<EOR
    apt-get -yq update
    apt-get -yq install libusb-1.0-0 busybox
    apt-get clean

#   Remove lots of unneeded files and install busybox
    ./spy-muntz.sh
    /bin/busybox --install -s
    rm spy-muntz.sh
EOR
#####################################################################
# Copy filesystem to scratch base image which removes deleted files.

FROM scratch AS dga-install
COPY --from=dga-filesystem / /
EXPOSE 5555
USER nobody
WORKDIR /spy
CMD ["/spy/spyserver", "/spy/spyserver.config"]
