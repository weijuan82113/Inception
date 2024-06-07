FROM debian:bullseye
RUN apt update
RUN apt upgrade
RUN apt install -y vim wget unzip mariadb-server
COPY ./conf/50-server.cnf /etc/mysql/mariadb.conf.d/
COPY ./tools/init.sh /docker-entrypoint-initdb.d/
RUN chmod +x /docker-entrypoint-initdb.d/init.sh
RUN chmod +x /etc/mysql
# HEALTHCHECK --interval=10s --timeout=5s --start-period=10s --retries=10 \
# 	CMD mariadb --user user --password 'password'
ENTRYPOINT ["./docker-entrypoint-initdb.d/init.sh"]
CMD ["/usr/sbin/mysqld", "--user=mysql", "--console", "--skip-name-resolve", "--skip-networking=0"]
