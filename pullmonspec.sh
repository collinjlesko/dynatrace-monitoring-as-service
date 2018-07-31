#!/bin/bash
# Will call the Dynatrace CLI in Docker and push deployment information for the host that is specified in monspec/monspec.json
# we assume that Dynatrace CLI is installed in ../dynatrace_cli
# Usage: ./pullmonspec.sh EntityName/Environment [timeframe_inminutes] [timeshift_inminutes]
# Example /pullmonspec.sh MaaSHost/Lab2 5 0  -> will pull metrics from the last 5 minutes for MaaShost/Lab2

if [ -z "$1" ]; then
  echo "Usage: Arg 1 needs to be an EntityName/Environment combination, e.g: MaaSHost/Lab2"
  exit 1
fi
TIMEFRAME=$2
if [ -z "$2" ]; then
  TIMEFRAME=5
fi
TIMESHIFT=$3
if [ -z "$3" ]; then
  TIMESHIFT=0
fi

bash ../dynatrace-cli/dtclidocker.sh monspec pull monspec/monspec.json monspec/pipelineinfo.json $1 $TIMEFRAME $TIMESHIFT