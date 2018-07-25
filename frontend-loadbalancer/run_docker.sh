

sudo docker run --name frontend-loadbalancer-nginx -p 8080:80 -v conf.d:/etc/nginx/conf.d:ro -d frontend-loadbalancer-nginx