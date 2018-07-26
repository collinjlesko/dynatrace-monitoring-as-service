#!/bin/bash
# Stops the current test 
# Usage:
# ./stop_test.sh

#!/bin/bash
sudo docker exec -d jmeter-test ./jmeter/bin/shutdown.sh
sudo docker rm -f $(sudo docker ps -a -q -f "ancestor=jmeter)