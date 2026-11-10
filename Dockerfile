# Dockerfile to build spyserver image
#
# D. G. Adams 2026-11-07
# Notes: As of Dec 2025 this only builds correctly with bookworm

FROM debian:bookworm-slim AS build
WORKDIR /

ADD https://github.com/airspy/airspyhf/archive/master.zip .

RUN <<EOR
#   Make airspy libraries
    set -e
    apt-get -yq update
    apt-get -yq install --no-install-recommends build-essential cmake libusb-1.0-0-dev pkg-config unzip
    unzip master.zip
    mkdir /airspyhf-master/build
    cd /airspyhf-master/build
    cmake ../
    make
    make install
    strip --strip-unneeded /usr/local/lib/libairspyhf.so*
EOR
# libusb-1.0-0 (runtime) is pulled in by libusb-1.0-0-dev, so ldd below can find it

# Download spyserver binary
WORKDIR /spy
ADD https://airspy.com/downloads/spyserver-linux-x64.tgz ./spy.tgz
RUN  tar -xzf spy.tgz && rm spy.tgz

# Neat Trick:   Copy from busybox:musl pulls static musl based busybox
#               Saves several hundred KB.
COPY --from=busybox:musl /bin/busybox /usr/bin/busybox

######################################################
# Build the final filesystem in /out by copying IN only what is needed:
#   - the spyserver binary and config
#   - libairspyhf (with its symlinks)
#   - every shared library spyserver and libairspyhf need, found with ldd
#   - busybox with all applets (the compose healthcheck uses nc), plus
#     /etc/passwd and /etc/group (for USER nobody and Dockhand shell)
# Nothing is ever deleted, so scratch gets a minimal, clean filesystem.

WORKDIR /
RUN <<EOR
#!/bin/bash
    set -e
    OUT=/out
    mkdir -p $OUT/usr/lib/x86_64-linux-gnu $OUT/usr/local/lib \
             $OUT/usr/bin $OUT/lib64 $OUT/etc $OUT/spy
    ln -s usr/lib $OUT/lib
    ln -s usr/bin $OUT/bin

#   spyserver and its config
    cp -a /spy/. $OUT/spy/

#   airspyhf, keeping the .so symlinks
    cp -a /usr/local/lib/libairspyhf.so* $OUT/usr/local/lib/

#   busybox: copy the static binary, then create every applet symlink
    cp -a /usr/bin/busybox $OUT/usr/bin/busybox
    /usr/bin/busybox --install -s $OUT/usr/bin

#   users for USER nobody
    cp -a /etc/passwd /etc/group $OUT/etc/

#   shared libraries: whatever ldd says the binary and airspyhf need.
#   /usr/local/lib is not in the default search path, so ldd needs help here.
    export LD_LIBRARY_PATH=/usr/local/lib
    for f in /spy/spyserver $OUT/usr/local/lib/libairspyhf.so.*; do
        [ -L "$f" ] && continue
        ldd "$f" | grep 'not found' && { echo "missing library for $f"; exit 1; } || true
        ldd "$f"
    done | awk '$2=="=>" && $3 ~ /^\// {print $3} $1 ~ /^\// && $2 ~ /^\(/ {print $1}' \
         | grep -v '^/usr/local/' | sort -u | while read -r lib; do
        cp -L --parents "$lib" $OUT
    done
EOR

#####################################################################
# Copy filesystem to scratch base image, so only the needed files are in it.
#   airspyhf is in /usr/local/lib, which is not in the default loader path

FROM scratch
COPY --from=build /out/ /
ENV LD_LIBRARY_PATH=/usr/local/lib
EXPOSE 5555
USER nobody
WORKDIR /spy
CMD ["/spy/spyserver", "/spy/spyserver.config"]
