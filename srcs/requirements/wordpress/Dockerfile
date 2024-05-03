FROM debian:bullseye
ENV test1=${MYSQL_DATABASE}
ENV test2=word_press
RUN apt update
RUN apt upgrade
RUN apt install -y php7.4-fpm php7.4-mysqli php7.4-gd php7.4-curl php7.4-xml php7.4-mbstring php7.4-zip
RUN apt install -y vim wget unzip
RUN wget https://wordpress.org/latest.zip
RUN unzip latest.zip
COPY ./conf/www.conf etc/php/7.4/fpm/pool.d/
COPY ./tools/init.sh docker-entrypoint-initdb.d/
ENTRYPOINT ["/bin/sh", "-c"]
CMD ["chmod +x /docker-entrypoint-initdb.d/init.sh && ./docker-entrypoint-initdb.d/init.sh"]

