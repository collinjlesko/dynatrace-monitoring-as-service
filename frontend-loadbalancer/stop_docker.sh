#!/bin/bash
# This script will remove all running containers of the passed image name in $1

if [ -z "$1" ]; then
  export IMAGE_NAME="frontend-loadbalancer-nginx"
else
  export IMAGE_NAME=$1
fi

echo "Deleting all containers from image: $IMAGE_NAME"
sudo docker rm -f $(sudo docker ps -a -q -f "ancestor=$IMAGE_NAME")