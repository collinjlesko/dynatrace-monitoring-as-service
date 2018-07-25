#!/bin/bash
# stop the prevoius load balancer first

# Based on number of frontend instances ($1) update the local conf.d/default.conf - using base port ($2)
if [ -z "$1" ]; then
  export NO_INSTANCES=1
else
  export NO_INSTANCES=$1
fi
if [ -z "$2" ]; then
  export BASE_PORT=8081
else
  export BASE_PORT=$2
fi

echo "upstream my-frontend {" > ${PWD}/conf.d/default.conf
for (( i=1; i<=$NO_INSTANCES; i++))
do
  echo "  server 172.17.0.1:$BIND_PORT weight=1;" >> ${PWD}/conf.d/default.conf
  BIND_PORT=$(($BIND_PORT+1))
done
echo "}server {location / {proxy_pass http://my-frontend;}}" > ${PWD}/conf.d/default.conf

#!/bin/bash
sudo bash ./stop_docker.sh
sudo docker run --name frontend-loadbalancer-nginx -v ${PWD}/conf.d/default.conf:/etc/nginx/conf.d/default.conf:ro -p 80:80 -d frontend-loadbalancer-nginx