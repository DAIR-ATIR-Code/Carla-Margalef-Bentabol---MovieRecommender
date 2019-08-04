#!/bin/bash

#
# Script to run movierec. Run server with trained model and enable command-line client.
# - To run on a provisioned DAIR Ubuntu 18.04 Base Cloud Image instance (see movierec-provision.sh).
# - Download model and client code.
# - Run inferece server and create container for testing command line client.
#

set -e
export DEBIAN_FRONTEND=noninteractive

echo "movierec-run-server: Get code and models"
cd /home/ubuntu/
wget --no-check-certificate  https://code.cloud.canarie.ca:3000/carlamb/MovieRecommender/archive/master.zip
unzip master.zip
cd movierecommender/modelstrt
unzip movierec.zip
rm movierec.zip

# stop if already running
docker ps -q --filter "name=trtserver" | grep -q . && docker stop trtserver

# run inference server with heath check that verifies api status
# and wait until server is healthy to exit the command
echo "movierec-run-server: Run inference server"

nvidia-docker run -d --rm --name trtserver \
  --shm-size=1g --ulimit memlock=-1 --ulimit stack=67108864 \
  -p8000:8000 -p8001:8001 -p8002:8002 \
  -v/home/ubuntu/movierecommender/modelstrt:/models \
  --health-cmd='curl localhost:8000/api/status | grep "ready_state: SERVER_READY" || exit 1' \
  --health-timeout=10s \
  --health-interval=1s  \
  nvcr.io/nvidia/tensorrtserver:19.02-py3 \
  trtserver --model-store=/models && \
  c=0 && sleep 2 && \
  until docker inspect --format "{{json .State.Health.Status }}" trtserver | \
   grep -m 1 '"healthy"'; do
     ((c++)) && ((c>50)) && break
     sleep 2
  done

# stop if already running
docker ps -q --filter "name=trtclient" | grep -q . && docker stop trtclient

# run docker for client
echo "movierec-run-server: Run docker for client command line"

nvidia-docker run --rm -d -it --net=host --name trtclient \
 --shm-size=1g --ulimit memlock=-1 --ulimit stack=67108864 \
 -v /home/ubuntu/movierecommender/movierec:/workspace/movierec \
 nvcr.io/nvidia/tensorflow:19.02-py3  \
 /bin/bash -c "cd /workspace/ && mkdir clients && cd clients && \
  wget https://github.com/NVIDIA/tensorrt-inference-server/releases/download/v0.11.0/v0.11.0.clients.tar.gz && \
  tar xzf v0.11.0.clients.tar.gz && apt-get update && apt-get -y install python3-pip libcurl3 && \
  pip3 install --user --upgrade python/tensorrtserver-*.whl pillow && cd .. && bash"

# for return status
docker inspect --format "{{json .State.Health.Status }}" trtserver | \
  grep -m 1 '"healthy"'
