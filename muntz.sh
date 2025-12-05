#!/bin/bash
shopt -s extglob    #bash extension allows rm -rf !(except_these_files)

# remove all libraries except ...
cd /usr/lib/x86_64-linux-gnu
	EXC="!(libc.*|ld-linux*|libresolv.*"
	EXC+="|libm.*|libmvec*|libselinux*|libpcre2*|"		# For spy-server
	EXC+="|libudev*|libusb*|libmd*|libdl*"
	EXC+="|libpthread*|libgcc_s*|librt*|libstdc++.*"
	EXC+=")"
rm -rf $EXC

# Remove unneeded files & directories
cd /var && rm -rf *
cd /etc && !(passwd|group|gshadow|shadow)
cd /usr && rm -rf !(lib|bin|sbin|lib64|libexec|local)
cd /usr/lib && rm -rf !(x86_64-linux-gnu)
cd /usr/sbin && rm *
cd /usr/bin  && rm !(busybox)
