#!/bin/bash
# This script will start 1 or more instances of the frontend-app. It will launch it with a specific BUILD_NUMBER and starts mapping these instances to a certain port range
# You can pass these input values as arguments:
# $1: Number of Instances, Default: 1
# $2: Base Port, Default: 8081
# $3: Build Number, Default: 1
if [ -z "$1" ]; then
  export NO_INSTANCES=1
else
  export NO_INSTANCES=$1
fi
if [ -z "$2" ]; then
  export BASE_PORT=8081
else
  export BASE_PORT=$2
fi
if [ -z "$3" ]; then
  export BUILD_NUMBER=1
else
  export BUILD_NUMBER=$3
fi

echo "NO_INSTANCES: $NO_INSTANCES"
echo "BASE_PORT: $BASE_PORT"
echo "BUILD_NUMBER: $BUILD_NUMBER"

BIND_PORT=$BASE_PORT
for (( i=1; i<=$NO_INSTANCES; i++))
do
  INSTANCE_NAME=frontend-app-instance-$BIND_PORT
  echo "$INSTANCE_NAME:$BIND_PORT - BUILD: $BUILD_NUMBER"

  # RAW: This is the "plain" regular launch of a container - nothing specific to Dynatrace OneAgent
  sudo docker run --name $INSTANCE_NAME -p $BIND_PORT:80 -e BUILD_NUMBER=$BUILD_NUMBER -d frontend-app:latest

  # Step 1: the following line is to ENABLE Dynatrace OneAgent Custom Tagging and Custom Meta Data Passing
  # sudo docker run --name $INSTANCE_NAME -p $BIND_PORT:80 -e BUILD_NUMBER=$BUILD_NUMBER -e DT_TAGS="SERVICE_TYPE=FRONTEND" -e DT_CUSTOM_PROP="SERVICE_TYPE=FRONTEND BUILD_NUMBER=$BUILD_NUMBER BIND_PORT=$BIND_PORT" -d frontend-app:latest

  # Step 2: the following line leverages DT_NODE_ID to differentiate each individual container instance as its own Process Group Instance
  # sudo docker run --name $INSTANCE_NAME -p $BIND_PORT:80 -e BUILD_NUMBER=$BUILD_NUMBER -e DT_NODE_ID=$BUILD_NUMBER -e DT_TAGS="SERVICE_TYPE=FRONTEND" -e DT_CUSTOM_PROP="SERVICE_TYPE=FRONTEND BUILD_NUMBER=$BUILD_NUMBER BIND_PORT=$BIND_PORT" -d frontend-app:latest

  BIND_PORT=$(($BIND_PORT+1))
done