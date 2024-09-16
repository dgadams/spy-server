# Spy Server AMD64 Docker Project
A Dockerized Airspy HF+ Discovery server.
This project allows a HF+ to be run remotely.
## Notes:
- Built on an Alpine Linux image to keep the size below 14 MB.
- Build this with "docker buildx build -t spy-server ." 
- For now includes the binary "spyserver" until I
can get around to pulling it from the web.
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
