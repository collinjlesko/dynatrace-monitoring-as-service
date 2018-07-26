#!/bin/bash
# Will Run 4 Frontends - 2 with Build 1 and 2 with Build 2
cd frontend-app
bash run_docker.sh 2 8081 1
bash run_docker.sh 2 8083 2

cd ../backend-service
bash run_docker.sh

cd ../frontend-loadbalancer
bash run_docker.sh 4
