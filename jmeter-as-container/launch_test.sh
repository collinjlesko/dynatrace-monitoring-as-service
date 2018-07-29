#!/bin/bash
# Starts a JMeter test that is passed via command line arguments
# Usage:
# ./run_test.sh testscript.jmx result.jtl http://yourserverip

if [ -z "$1" ]; then
  echo "Usage: Arg 1 needs to be valid <yourtestscript>.jmx"
  exit 1
fi
if [ -z "$2" ]; then
  echo "Usage: Arg 2 needs to be a valid path for a <result>.jtl"
  exit 1
fi
if [ -z "$3" ]; then
  echo "Usage: Arg 3 needs to be the URL or IP of your service that should be tested"
  exit 1
fi

sudo rm -f -r $2
sudo mkdir $2
sudo docker run --name jmeter-test -v "${PWD}/scripts":/scripts -v "${PWD}/$2":/results --rm -d jmeter ./jmeter/bin/jmeter.sh -n -t /scripts/$1 -e -o /results -l result.tlf -JSERVERIP="$3"
