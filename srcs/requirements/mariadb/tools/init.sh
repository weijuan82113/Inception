#!/bin/bash

#mysqlユーザーがなければ作成する
if ! getent passwd | grep mysql; then
	echo "create the mysql"
	groupadd mysql
	useradd -r -g mysql -s /bin/false mysql
fi

# /run/mysqldディレクトリチェック ※mysqldで起動する際に必要なディレクトリ
if [ -d "/run/mysqld" ]; then
	echo "mysqld is already present, skipping creation"
	chown -R mysql:mysql /run/mysqld
else
	echo "mysqld is not found, creating....."
	mkdir -p /run/mysqld
	chown -R mysql:mysql /run/mysqld
fi

#Mariadb初期化されたか確認
if [ -d /var/lib/mysql/mysql ]; then
	echo "MySQL directory already present, skipping creation"
	chown -R mysql:mysql /var/lib/mysql
else
	echo "MySQL data directory not found creating initial DBs"
	chown -R mysql:mysql /var/lib/mysql
	mysql_install_db --user=mysql > /dev/null

#SQL scrpitのテンプレートファイルを作成する
	tfile=`mktemp`

	if [ ! -f "$tfile" ]; then
		exit 1
	fi

	#必須の環境変数をチェック
	if [ -z "$MYSQL_ROOT_USER" ]; then
		echo "Error: Missing required environment variables (MYSQL_ROOT_USER)."
		exit 1
	fi
	if [ -z "$MYSQL_ROOT_PASSWORD" ]; then
		echo "Error: Missing required environment variables (MYSQL_ROOT_PASSWORD)."
		exit 1
	fi
	#SQL script
	#root userを作る
	cat << EOF > $tfile
USE mysql;
FLUSH PRIVILEGES;
GRANT ALL ON *.* TO '$MYSQL_ROOT_USER'@'%' identified by '$MYSQL_ROOT_PASSWORD' WITH GRANT OPTION;
GRANT ALL ON *.* TO '$MYSQL_ROOT_USER'@'localhost' identified by '$MYSQL_ROOT_PASSWORD' WITH GRANT OPTION;
SET PASSWORD FOR '$MYSQL_ROOT_USER'@'localhost'=PASSWORD('$MYSQL_ROOT_PASSWORD');
DROP DATABASE IF EXISTS test;
FLUSH PRIVILEGES;
EOF

	# databaseを作る
	if [ -z "$MYSQL_DATABASE" ]; then
		echo "Error: Missing required environment variables (MYSQL_DATABASE)."
		exit 1
	else
		echo "CREATE DATABASE IF NOT EXISTS $MYSQL_DATABASE" >> $tfile
		if [ ! -z "$MYSQL_CHARSET" ] && [ ! -z "$MYSQL_COLLATION" ]; then
			echo "[info] with character set [$MYSQL_CHARSET] and collation [$MYSQL_COLLATION]"
			echo "CHARACTER SET $MYSQL_CHARSET COLLATE $MYSQL_COLLATION;" >> $tfile
		else
			echo "[info] with character set: 'utf8mb4' and collation: 'utf8mb4_unicode_ci'"
			echo "CHARACTER SET utf8 COLLATE utf8_general_ci;" >> $tfile
		fi
	fi

	# userを作る
	if [ -z "$MYSQL_USER" i] || [ -z "$MYSQL_PASSWORD" ]; then
		echo "Error: Missing required environment variables (MYSQL_USER, MYSQL_PASSWORD)."
		exit 1
	else
		echo "[info] Creating user: $MYSQL_USER with password"
		echo "CREATE USER IF NOT EXISTS '$MYSQL_USER'@'%' IDENTIFIED BY '$MYSQL_PASSWORD';" >> $tfile
		echo "GRANT ALL PRIVILEGES ON $MYSQL_DATABASE.* TO '$MYSQL_USER'@'%';" >> $tfile
	fi
	echo "FLUSH PRIVILEGES;" >> $tfile

	/usr/sbin/mysqld --user=mysql --bootstrap --verbose=0 --skip-name-resolve --skip-networking=0 < $tfile
	rm -f $tfile

	echo "Database '$MYSQL_DATABASE' created successfully!"
fi

#CMDで渡された引数を$@で引用される
echo "$@"
exec "$@"