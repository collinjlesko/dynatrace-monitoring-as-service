#!/bin/bash
# Starts a JMeter test that is passed via command line arguments
# Usage:
# ./run_test.sh testscript.jmx result.jtl http://yourserverip

#!/bin/bash
sudo rm -f -r $2
sudo mkdir $2
sudo docker run --name jmeter-test -v "${PWD}/scripts":/scripts -v "${PWD}/$2":/results --rm -d jmeter ./jmeter/bin/jmeter.sh -n -t /scripts/$1 -e -o /results -l result.tlf -JSERVERIP=$3
