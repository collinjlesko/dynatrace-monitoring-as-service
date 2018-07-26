#!/bin/bash
# Starts a JMeter test that is passed via command line arguments
# Usage:
# ./run_test.sh testscript.jmx result.jtl http://yourserverip

#!/bin/bash
sudo docker run --name jmeter-test -d jmeter:latest -v ${PWD}:/jmeter ./jmeter.sh -n -t /jmeter/$1 -l $2 -JSERVERIP=$3