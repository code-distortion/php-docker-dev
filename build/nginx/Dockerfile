ARG NGINX_IMAGE
FROM ${NGINX_IMAGE}

#RUN apt-get update && apt-get install -y vim

COPY conf/nginx.conf /etc/nginx/nginx.conf
COPY conf/default.conf /etc/nginx/templates/default.conf.template
