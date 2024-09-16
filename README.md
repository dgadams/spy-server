# Spy Server AMD64 Docker Project
A Dockerized Airspy HF+ Discovery server.
This project allows a HF+ to be run remotely.
## Notes:
- Built on an Alpine Linux image.  Size is 11.5 MB.
- Build this with "docker buildx build -t spy-server ."
- PROBLEM
    - This is built with pre-compiled sources contained in
spyserver-linux-x64.tgz.  Most recent builds from Airspy no
longer work with this project.  Likely a glibc problem with 
the Alpine container.  For now (Sept-2024) its good enough.
         
## Usage:
I generally run this with a docker compose file:
```
# spy-server
# this server connects to an Airspy hf+ Discovery  usb device
# and shares it on the network for use with client sdr console
# software like sdr++.
#
# D. G. Adams 2024-Aug-16
#
name: spy-server
services:
  spy-server:
    container_name: spy-server
    image: spy-server:alpine
    restart: unless-stopped
#    init: true
    devices:
      - /dev/bus/usb
    ports:
      - 5555:5555
```
## Ackowledgements
- See: https://airspy.com/airspy-hf-discovery/
