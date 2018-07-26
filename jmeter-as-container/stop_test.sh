#!/bin/bash
# Stops the current test
# Usage:
# ./stop_test.sh

#!/bin/bash
sudo docker exec -d jmeter-test ./jmeter/bin/shutdown.sh

# lets wait u ntil the results are done - then zip em
waitCycles=10
while [ ! -f ./results/index.html ] && [ $waitCycles -gt 0 ] ;
do
  sleep 5s
  echo "waiting 5 more s"
  waitCycles=$(($waitCycles-1))
done

if [ ! -f /results/index.html ]; then
  sudo zip -q results.zip results
fi