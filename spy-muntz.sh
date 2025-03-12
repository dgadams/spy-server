#!/bin/bash

#   remove unneeded files - do a little muntzing.
#   This works in conjuction with the filesystem build layer to allow
#   us to remove any file from the debian distribution

#   This is rather ugly and was created by iteratively removing and testing
#   until things broke.  Then put it back.  This is called muntzing.
#   Need to add extended globbing so rm !() works
    shopt -s extglob

#   Nuke some misc stuff, /usr/sbin and /usr/bin
    rm -rf /var/lib/dpkg
    rm -rf /var/lib/apt
    rm -rf /var/cache/debconf
    rm -rf /usr/share/doc
    rm -rf /usr/share/zoneinfo
    rm -rf /usr/share/perl5
    rm -rf /usr/share/common-licenses
    rm -rf /usr/sbin/*

    cd /usr/bin
    rm !(busybox|rm)

#   Remove select libraries
    cd /usr/lib
    rm -rf !(x86_64-linux-gnu)

#   Remove everything but what we need from x86_64_linux-gnu
    cd /usr/lib/x86_64-linux-gnu
    EXCLUDE="!(libstdc++*|libc.*|libm.*|libmvec*|libselinux*"
    EXCLUDE+="|libpcre2*|ld-linux*|libudev*|libtinfo*"
    EXCLUDE+="|libusb*|libmd*|libdl*|libpthread*|libgcc_s*"
    EXCLUDE+="|librt*|libresolv.*)"
    rm -rf $EXCLUDE

