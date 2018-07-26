#!/bin/bash
# Starts a JMeter test that is passed via command line arguments
# Usage:
# ./run_test.sh testscript.jmx result.jtl http://yourserverip

#!/bin/bash
sudo docker run --name jmeter-test -v "${PWD}/scripts":/scripts -rm -t jmeter ./jmeter/bin/jmeter.sh -n -t /scripts/$1 -l /scripts/$2 -JSERVERIP=$3