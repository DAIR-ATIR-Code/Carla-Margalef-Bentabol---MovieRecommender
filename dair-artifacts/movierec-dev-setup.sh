#!/bin/bash

#
# Script to setup an instance for movierec development.
# - To run on a provisioned DAIR Ubuntu 18.04 Base Cloud Image instance (see movierec-provision.sh).
# - Run docker container with tensorflow.
#

echo "movierec-dev-setup: Running tensorflow docker container"

nvidia-docker run -d -it --name tensorflow \
  --shm-size=1g --ulimit memlock=-1 --ulimit stack=67108864 \
  nvcr.io/nvidia/tensorflow:19.02-py3 bash

echo "movierec-dev-setup: Tensorflow container running. To attach to it for development, run: 'sudo docker attach tensorflow' and then hit 'enter' if it seems to hang (a bash terminal should be ready for you)"

echo "movierec-dev-setup: You can get sample code from https://code.cloud.canarie.ca:3000/carlamb/MovieRecommender"

echo "movierec-dev-setup: Done"

