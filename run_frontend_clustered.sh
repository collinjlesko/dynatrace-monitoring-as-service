#!/bin/bash
cd frontend-app
bash run_docker.sh 2

cd ../frontend-loadbalancer
bash run_docker.sh 2
