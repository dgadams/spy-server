#  Dockerfile for building sdrconnect docker image
#
#  D.G. Adams 2023-09-28
#
#  Notes:  This file relies on udev rules for the airspy hf+ being set
#          to allow all users read/write access. create etc/udev/rules.d/67-Airspy.rules with
#  SUBSYSTEM=="usb",ENV{DEVTYPE}=="usb_device",ATTRS{idVendor}=="03eb",ATTRS{idProduct}=="800c",MODE:="0666"
#
FROM debian:bookworm-slim AS build

WORKDIR /
RUN <<EOF
    apt-get -yq  update
    apt-get -yq install build-essential cmake libusb-1.0-0-dev pkg-config wget unzip
    wget https://github.com/airspy/airspyhf/archive/master.zip
    unzip master.zip
    mkdir airspyhf-master/build
    cd airspyhf-master/build
    cmake ../
    make
    make install
EOF
#########################################################

FROM alpine:latest

RUN <<EOF
    apk add libstdc++ rtl-sdr libgcc gcompat
    adduser -D sdr
    adduser sdr sdr
EOF

COPY --from=build /usr/local/lib /usr/local/lib
COPY ./spyserver /usr/local/bin
COPY ./spyserver.conf /etc

EXPOSE 5555
USER sdr
CMD ["/usr/local/bin/spyserver", "/etc/spyserver.conf"]
