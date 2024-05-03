FROM debian:bullseye
RUN apt update
RUN apt upgrade
RUN apt install -y vim wget unzip mariadb-server tini
COPY ./conf/50-server.cnf /etc/mysql/mariadb.conf.d/
ENV MYSQL_ROOT_PASSWORD=$MYSQL_ROOT_PASSWORD
ENV MYSQL_DATABASE=$MYSQL_DATABASE
ENV MYSQL_USER=$MYSQL_USER
ENV MYSQL_PASSWORD=$MYSQL_PASSWORD
COPY ./tools/init.sh /docker-entrypoint-initdb.d/
# ENTRYPOINT ["/usr/bin/mariadb", "-c"]
# ENTRYPOINT ["/bin/sh", "-c"]
RUN chmod +x /docker-entrypoint-initdb.d/init.sh
ENTRYPOINT ["/usr/bin/tini", "--", "mysqld"]
# ENTRYPOINT ["/usr/bin/tini", "--", "/docker-entrypoint-initdb.d/init.sh"]
# CMD ["--defaults-file=/etc/mysql/my.cnf", "--daemon off"]
CMD ["./docker-entrypoint-initdb.d/init.sh"]
