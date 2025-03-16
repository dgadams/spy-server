#!/bin/bash

#   remove unneeded files - do a little muntzing.
#   This works in conjuction with the filesystem build layer to allow
#   us to remove any file from the debian distribution

#   This is rather ugly and was created by iteratively removing and testing
#   until things broke.  Then put it back.  This is called muntzing.
#   Need to add extended globbing so rm !() works
    shopt -s extglob

#   Remove select libraries
    cd /usr/lib
    rm -rf !(x86_64-linux-gnu)

# remove all libraries except ...
	cd /usr/lib/x86_64-linux-gnu
	EXC="!(libc.*|ld-linux*"							# basic c library
#	EXC+="|libtinfo*"									# needed for bash
#	EXC+="|libselinux*|libacl.*|libattr.*|libpcre*"		# needed for cp
	EXC+="|libresolv.*"									# needed for busybox
	EXC+="|libm.*|libmvec*|libselinux*|libpcre2*|"		# For spy-server
	EXC+="|libudev*|libusb*|libmd*|libdl*|"
	EXC+="|libpthread*|libgcc_s*|librt*|libstdc++.*"
	EXC+=")"
	rm -rf $EXC

#   Nuke anything not needed in the container
    cd /var && rm -rf !(nothing)
    cd /etc && rm -rf apt dpkg
    cd /usr && rm -rf !(lib|bin|sbin|lib64|libexec|local)

#   Clean up bin and sbin
    cd /usr/sbin && rm !(nothing)
    cd /usr/bin  && rm !(busybox)
