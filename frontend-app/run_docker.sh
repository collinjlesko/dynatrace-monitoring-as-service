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
  INSTANCE_NAME=frontend-app-instance-$i
  echo "$INSTANCE_NAME:$BIND_PORT - BUILD: $BUILD_NUMBER"
  # sudo docker run --name frontend-app-instance-$i -p $BIND_PORT:80 -d frontend-app:latest -e BUILD_NUMBER=$BUILD_NUMBER
  BIND_PORT=$(($BIND_PORT+1))
done