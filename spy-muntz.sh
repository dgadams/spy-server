#!/bin/bash

#   remove unneeded files - do a little muntzing.
#   This works in conjuction with the filesystem build layer to allow
#   us to remove any file from the debian distribution

#   This is rather ugly and was created by iteratively removing and testing
#   until things broke.  Then put it back.  This is called muntzing.
#   Need to add extended globbing so rm !(bash|ls) works
    shopt -s extglob

#   Nuke some big stuff and /usr/sbin
    rm -rf /var/lib/dpkg/info/*
    rm -rf /var/cache/debconf/*
    rm -rf /usr/share/doc
    rm -rf /usr/share/zoneinfo
    rm -rf /usr/share/perl5
    rm -rf /usr/share/common-licenses
    rm -rf /usr/sbin/*

#   remove stuff from /usr/bin.  Remove everthing but the exceptions
    cd /usr/bin
    rm !(bash|ls|more|cd|rm|ldd)

 #   Now we tackle libraries individually (messy, but works)
    rm -rf /usr/lib/apt
    rm -rf /usr/lib/systemd

    cd /lib/x86_64-linux-gnu
    rm -rf perl-base
    rm -fr krb5
    rm -fr gconv
    rm -f libsystemd*
    rm -f libsmartcols*
    rm -f libreadline*
    rm -f libp11-kit*
    rm -f libkrb5*
    rm -f libicu*
    rm -f libgnutls*
    rm -f libdb*
    rm -f libboost*
    rm -f libnettle*
    rm -f libndn2*
    rm -f libcuuc*
    rm -f libgmp*
    rm -f libbpf*
    rm -f libapt*
    rm -f libxxhash*
    rm -f libtirpc*
    rm -f libnsl*
    rm -f libhogweed*
    rm -f libgssapi*
    rm -f liblzma5*
    rm -f libffi*
    rm -f libunistring*
    rm -f libmount*
    rm -f libblkid*
    rm -f libgcrypt*
    rm -f libsepol*
    rm -f libzstd*
    rm -f libsemanage*
    rm -f libidn2*
    rm -f libext2fs*
    rm -f libcrypt*
    rm -f liblzma*
    rm -f libgpg-error*
    rm -f liblz4*
    rm -f libseccomp*
    rm -f libaudit*
    rm -f libtasn1*
    rm -f libz*
    rm -f libtic*
    rm -f libpam*
    rm -f libresolv*