#!/bin/bash

# 必須の環境変数をチェック
if [ -z "$MYSQL_HOST" ] || [ -z "$MYSQL_DATABASE" ] || [ -z "$MYSQL_USER" ] || [ -z "$MYSQL_ROOT_PASSWORD" ]; then
    echo "Error: Missing required environment variables (DB_HOST, DB_NAME, DB_USER, DB_PASSWORD)."
    exit 1
fi

# wp-config-sample.php から wp-config.php を生成
sed -e "s/database_name_here/$MYSQL_DATABASE/g" \
    -e "s/username_here/$MYSQL_USER/g" \
    -e "s/password_here/$MYSQL_ROOT_PASSWORD/g" \
    -e "s/localhost/$MYSQL_HOST/g" \
    /wordpress/wp-config-sample.php > /wordpress/wp-config.php

# 生成されたファイルに適切なパーミッションを設定 (必要に応じて)
chmod 640 /var/www/html/wp-config.php
mv wordpress/* var/www/html/
service php7.4-fpm start
bash