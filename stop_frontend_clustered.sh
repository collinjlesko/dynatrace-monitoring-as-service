#!/bin/bash
cd frontend-app
bash stop_docker.sh

cd ../frontend-loadbalancer
bash stop_docker.sh