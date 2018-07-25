#!/bin/bash
# The backend service runs as a single instance and is bound to port 9000
sudo docker run --name $INSTANCE_NAME -p 9000:80 -e BUILD_NUMBER=$BUILD_NUMBER -d backend-service:latest