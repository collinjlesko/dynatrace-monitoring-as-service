#!/bin/bash
# usage: ./quicklaunch.sh http://yourserverip

if [ -z "$1" ]; then
  echo "Usage: Arg 1 needs to be the URL or IP of your service that should be tested"
  exit 1
fi

bash ./launch_test.sh SampleNodeJsServiceTest.jmx results $1