FROM kuabh2012/centos7-systemd
RUN yum install epel-release -y
RUN yum install nginx net-tools netcat bind-utils  -y 
RUN rm /etc/nginx/nginx.conf
ADD nginx.conf /etc/nginx/
ADD index.html /usr/share/nginx/html/
ADD .htpasswd /etc/nginx/
RUN mkdir -p /var/log/nginx  && chown nginx:nginx /var/log/nginx && touch /var/log/nginx/error.log \
&& chown -R nginx:nginx /var/log/nginx/error.log && \
chmod 640 /var/log/nginx/error.log
EXPOSE 8080/tcp
ENTRYPOINT ["/usr/sbin/nginx", "-g", "daemon off;"]
