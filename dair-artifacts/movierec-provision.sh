#!/bin/bash

#
# Script to provision a DAIR Ubuntu 18.04 Base Cloud Image instance.
# - Install and setup docker and nvidia-docker.
#

set -e
export DEBIAN_FRONTEND=noninteractive

echo "movierec-provision: Starting"

echo "movierec-provision: Installing docker"
curl -fsSL https://get.docker.com -o get-docker.sh
sh get-docker.sh

echo "movierec-provision: Installing nvidia-docker"
curl -s -L https://nvidia.github.io/nvidia-docker/gpgkey | \
  sudo apt-key add -
distribution=$(. /etc/os-release;echo $ID$VERSION_ID)
curl -s -L https://nvidia.github.io/nvidia-docker/$distribution/nvidia-docker.list | \
  sudo tee /etc/apt/sources.list.d/nvidia-docker.list

apt-get update
apt-get install -y nvidia-docker2 || true
pkill -SIGHUP dockerd || true

echo "movierec-provision: Done"
