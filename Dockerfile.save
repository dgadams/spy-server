
# Dockerfile to build spyserver image
#
# D. G. Adams 2026-11-07
# Notes: As of Dec 2025 this only builds correctly with bookworm

FROM debian:bookworm-slim AS build1
WORKDIR /

ADD https://github.com/airspy/airspyhf/archive/master.zip .

RUN <<EOR
#   Make airspy libraries
    apt-get -yq  update
    apt-get -yq install --no-install-recommends build-essential cmake libusb-1.0-0-dev pkg-config unzip
    unzip master.zip
    mkdir /airspyhf-master/build
    cd /airspyhf-master/build
    cmake ../
    make
    make install
    strip --strip-unneeded /usr/local/lib/libairspyhf.so*

#   preserve library links
    mkdir /stage
    cp -a /usr/local/lib/libairspyhf.so* /stage/
EOR

# Download spyserver binary
WORKDIR /spy
ADD https://airspy.com/downloads/spyserver-linux-x64.tgz ./spy.tgz
RUN  tar -xzf spy.tgz && rm spy.tgz

########################################################
# Layer to build the filesystem. Loads dependancies then muntz files.
# Neat Trick:   Copy from busybox:musl pulls static musl based busybox
#               Saves several hundred KB.

FROM debian:bookworm-slim AS muntz
WORKDIR /spy
COPY --from=build1 /spy /spy
COPY --from=build1 /stage/ /usr/local/lib/
COPY --from=busybox:musl /bin/busybox /usr/bin/busybox

RUN <<EOR
#!/bin/bash
    apt-get -yq update
    apt-get -yq install --no-install-recommends libusb-1.0-0

    shopt -s extglob    #bash extension for rm -rf !(except_these_files)

#   remove all libraries except ...
    cd /usr/lib/x86_64-linux-gnu
    EXC="!(libc.*|ld-linux*|libm.*|libmvec*"
    EXC+="|libudev*|libusb*|libdl*|librt*"
    EXC+="|libpthread*|libgcc_s*|libstdc++.*)"
    rm -rf $EXC

#   Remove unneeded files & directories
    cd /            && rm -rf !(bin|dev|etc|lib|lib64|proc|run|sbin|spy|sys|usr)
    cd /etc         && rm -rf !(passwd|group|ld.so.cache)
    cd /usr         && rm -rf !(lib|bin|sbin|lib64|libexec|local)
    cd /usr/lib     && rm -rf !(x86_64-linux-gnu)
    cd /usr/sbin    && rm *
    cd /usr/bin     && rm !(busybox|bash)

    /bin/busybox --install -s
    rm /bin/bash
EOR

#####################################################################
# Copy filesystem to scratch base image which removes deleted files.

FROM scratch
COPY --from=muntz / /
EXPOSE 5555
USER nobody
WORKDIR /spy
CMD ["/spy/spyserver", "/spy/spyserver.config"]

  
