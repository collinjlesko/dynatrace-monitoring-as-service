#!/bin/bash
cd frontend-app
bash ./build_docker.sh

cd ../backend-service
bash ./build_docker.sh

cd ../frontend-loadbalancer
bash ./build_docker.sh