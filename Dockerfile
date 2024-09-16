# Dockerfile to build spyserver image
#
# D. G. Adams 2024-09-16

FROM debian:bookworm-slim AS build

RUN <<EOF
#   Make airspy libraries
    apt-get -yq  update
    apt-get -yq install build-essential cmake libusb-1.0-0-dev pkg-config wget unzip
    wget https://github.com/airspy/airspyhf/archive/master.zip
    unzip master.zip
    mkdir airspyhf-master/build
    cd airspyhf-master/build
    cmake ../
    make
    make install

#   Get spyserver from airspy
    wget "https://airspy.com/?ddownload=4262EOF" -O spyserver-linux-x64.tgz
EOF

#########################################################
# Install binaries and libraries from build into
# an alpaquita (alpine glibc) image.

FROM bellsoft/alpaquita-linux-base:stream-glibc AS install

WORKDIR /spy
COPY --from=build /usr/local/lib /usr/local/lib
COPY --from=build /airspyhf-master/build/spyserver-linux-x64.tgz .

RUN <<EOF
    apk --no-cache add libusb libstdc++ eudev
    adduser -D spy
    adduser spy spy
    tar xzf spyserver-linux-x64.tgz
    rm spyserver-linux-x64.tgz
EOF

EXPOSE 5555
USER spy
CMD ["/spy/spyserver", "/spy/spyserver.config"]
