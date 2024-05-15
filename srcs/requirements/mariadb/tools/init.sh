#!/bin/bash

# /run/mysqldディレクトリチェック ※mysqldで起動する際に必要なディレクトリ
if [ -d "/run/mysqld"]; then
	echo "mysqld already present, skipping creation"
	chown -R mysql:mysql /run/mysqld
else
	echo "mysqld not found, creating....."
	mkdir -p /run/mysqld
	chown -R mysql:mysql /run/mysqld
fi

# 必須の環境変数をチェック
if [-z "$MYSQL_DATABASE"] || [-z "$MYSQL_USER"] || [-z "$MYSQL_PASSWORD"]; then
	echo "Error: Missing required environment variables (DB_HOST, DB_NAME, DB_USER, DB_PASSWORD)."
    exit 1
fi

#Databaseを作る
/usr/sbin/mysqld --user=user << MYSQL_SCRIPT
CREATE DATABASE IF NOT EXISTS $MYSQL_DATABASE;
CREATE USER IF NOT EXISTS '$MYSQL_USER'@'%' IDENTIFIED BY '$MYSQL_PASSWORD';
GRANT ALL PRIVILEGES ON $MYSQL_DATABASE.* TO '$MYSQL_USER'@'%';
FLUSH PRIVILEGES;
MYSQL_SCRIPT

echo "Database '$MYSQL_DATABASE' created successfully!"

#CMDで渡された引数を$@で引用される（/usr/sbin/mysqld --user=mysql）
exec "$@"