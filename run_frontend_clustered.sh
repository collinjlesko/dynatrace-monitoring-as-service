#!/bin/bash
cd frontend-app
bash run_docker.sh 2

cd ../backend-service
bash run_docker.sh

cd ../frontend-loadbalancer
bash run_docker.sh 2
