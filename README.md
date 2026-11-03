# Spy Server AMD64 Docker Project
A Dockerized Airspy HF+ Discovery server.
This project allows a HF+ to be run remotely.
## Notes:
- Built on an debian linux.
    - Many unneeded libraries and commands are removed to shrink the footprint.
    - spy-server image size is just under 10 MB.
- Pulls the spyserver binary from Airspy

## Usage:
I generally run this with a docker compose file: see source.

## Ackowledgements
- See: https://airspy.com/airspy-hf-discovery/
