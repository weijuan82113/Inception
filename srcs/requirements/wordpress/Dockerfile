FROM debian:bullseye
RUN apt update
RUN apt upgrade
RUN apt install -y php7.4-fpm php7.4-mysqli php7.4-gd php7.4-curl php7.4-xml php7.4-mbstring php7.4-zip
RUN apt install -y vim wget unzip sendmail mariadb-client
RUN ser -eux; \
	wget https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar; \
	chmod +x wp-cli.phar; \
	mv wp-cli.phar /usr/local/bin/wp; \
	wp --allow-root --version
COPY ./conf/www.conf etc/php/7.4/fpm/pool.d/
COPY ./tools/init.sh docker-entrypoint-initdb.d/
RUN chmod +x /docker-entrypoint-initdb.d/init.sh
ENTRYPOINT ["./docker-entrypoint-initdb.d/init.sh"]
CMD ["/usr/sbin/php-fpm7.4", "--nodaemonize", "--fpm-config", "/etc/php/7.4/fpm/php-fpm.conf"]
