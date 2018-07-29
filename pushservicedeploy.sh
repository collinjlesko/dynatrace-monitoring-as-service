#!/bin/bash
# Will call the Dynatrace CLI in Docker and push deployment information for the host that is specified in monspec/monspec.json
# we assume that Dynatrace CLI is installed in ../dynatrace_cli
bash ../dynatrace-cli/dtclidocker.sh monspec pushdeploy monspec/monspec.json monspec/pipelineinfo.json MaaSHost/Lab2 MyCustomDeployment Version1