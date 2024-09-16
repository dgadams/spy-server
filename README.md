# Spy Server AMD64 Docker Project
A Dockerized Airspy HF+ Discovery server.
This project allows a HF+ to be run remotely.
## Notes:
- Built on an Alpaquita Linux an Alpine Linux/glibc OS.
    -spy-server image size is 34 MB.
- Build this with "docker buildx build -t spy-server ."
- Pulls the spyserver binary from Airspy 
         
## Usage:
I generally run this with a docker compose file:
```
# spy-server
# this server connects to an Airspy hf+ Discovery  usb device
# and shares it on the network for use with client sdr console
# software like sdr++.
#
# Don't forget to make a udev rule in /etc/udev/rules.d in the
# host to allow access to the usb HF+ device.
# SUBSYSTEMS=="usb", ATTRS{idVendor}=="03eb", ATTRS{idProduct}=="800c", MODE:="0666"
#
# D. G. Adams 2024-Aug-16
#
name: spy-server
services:
  spy-server:
    container_name: spy-server
    image: spy-server:alpine
    restart: unless-stopped
    devices:
      - /dev/bus/usb
    ports:
      - 5555:5555
```
## Ackowledgements
- See: https://airspy.com/airspy-hf-discovery/
