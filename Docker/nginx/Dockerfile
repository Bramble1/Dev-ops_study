FROM ubuntu
ENV CONFIG_FILE=/etc/nginx/nginx.conf
RUN apt update && apt install -y nginx
COPY index.html /var/www/html/index.html
COPY nginx2.conf /etc/nginx/
EXPOSE 80
#CMD /sbin/nginx -g 'daemon off;'
ENTRYPOINT /sbin/nginx -c $CONFIG_FILE -g 'daemon off;' 

