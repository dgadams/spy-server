# Dockerfile to build spyserver image
#
# D. G. Adams 2024-09-16
#
# Must use alpaquita!  Alpine has issues with relocating libmvec.so.1
# Most likely a glibc incompatibility that alpaquita can fix.

FROM debian:bookworm-slim AS build
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

#########################################################

FROM bellsoft/alpaquita-linux-base:stream-glibc AS install
WORKDIR /spy

# Get spyserver and libraries from build.
ADD  https://airspy.com/?ddownload=4262EOF ./spy.tgz
COPY --from=build /usr/local/lib           /usr/local/lib

RUN <<EOR
    apk --no-cache add libusb libstdc++
    tar -xzf spy.tgz
    rm spy.tgz
EOR

EXPOSE 5555
USER nobody
CMD ["/spy/spyserver", "/spy/spyserver.config"]
