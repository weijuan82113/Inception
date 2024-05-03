FROM debian:bullseye
ENV OPENSSL_CONF="/etc/ssl/openssl-config"
RUN apt update
RUN apt upgrade
RUN apt install -y nginx vim openssl tini
COPY ./conf/openssl-config /etc/ssl/
COPY ./conf/default /etc/nginx/sites-available/
COPY ./conf/self-signed.conf /etc/nginx/snippets/
COPY ./conf/ssl-params.conf /etc/nginx/snippets/
COPY ./tools/init.sh /docker-entrypoint-initdb.d/
RUN openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout /etc/ssl/private/nginx-selfsigned.key -out /etc/ssl/certs/nginx-selfsigned.crt
RUN openssl dhparam -out /etc/nginx/dhparam.pem 4096
# RUN chmod +x /docker-entrypoint-initdb.d/init.sh
ENTRYPOINT ["/usr/bin/tini", "--"]
CMD ["nginx", "-g", "daemon off;"]
# CMD ["chmod +x /docker-entrypoint-initdb.d/init.sh && ./docker-entrypoint-initdb.d/init.sh"]
# ENTRYPOINT ["/usr/sbin/nginx", "nginx"]
# ENTRYPOINT ["/bin/sh", "-c"]