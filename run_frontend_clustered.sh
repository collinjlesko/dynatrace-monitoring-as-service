#!/bin/bash
# will run 2 frontends with build 1
cd frontend-app
bash run_docker.sh 2 8081 1

cd ../backend-service
bash run_docker.sh

cd ../frontend-loadbalancer
bash run_docker.sh 2
