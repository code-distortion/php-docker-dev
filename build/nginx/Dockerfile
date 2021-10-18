FROM nginx
RUN apt-get update && apt-get install -y vim

COPY conf/nginx.conf /etc/nginx/nginx.conf
COPY conf/default.conf /etc/nginx/templates/default.conf.template
