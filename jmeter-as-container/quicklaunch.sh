#!/bin/bash
# usage: ./quicklaunch.sh <yourserverip> [MyLoadTestName]

if [ -z "$1" ]; then
  echo "Usage: Arg 1 needs to be the URL or IP of your service that should be tested"
  exit 1
fi
DT_LTN=$2
if [ -z "$2" ]; then
  DT_LTN=MyLoadTestName
fi

./launch_test.sh SampleNodeJsServiceTest.jmx results $1 $DT_LTN