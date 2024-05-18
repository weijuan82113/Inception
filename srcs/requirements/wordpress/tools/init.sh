#!/bin/bash

# wordpressがinstallしたか確認する
if [ ! -e /var/www/html ]; then

    # 必須の環境変数をチェック
    if [ -z "$WORD_PRESS_PATH" ] || [ -z "$MYSQL_DATABASE" ] || [ -z "$MYSQL_USER" ] || [ -z "$MYSQL_HOST" ] || [ -z "$WORD_PRESS_PATH"]; then
        echo "Error: Missing required environment variables (WORD_PRESS_PATH, MYSQL_DATABASE, MYSQL_USER, MYSQL_HOST, WORD_PRESS_PATH)."
        exit 1
    fi
    mkdir -p /var/www/html
    #wordpressをダウンロードする
    wp core download --path=$WORD_PRESS_PATH --locale=ja --allow-root
    # wp-config-sample.php から wp-config.php を生成
    # wp config create \
    #     --force \
    #     --dbname=$MYSQL_DATABASE \
    #     --dbuser=$MYSQL_ROOT_USER \
    #     --dbpass=$MYSQL_ROOT_PASSWORD \
    #     --dbhost=$MYSQL_HOST \
    #     --path=$WORD_PRESS_PATH --allow-root

    sed -e "s/database_name_here/$MYSQL_DATABASE/g" \
        -e "s/username_here/$MYSQL_ROOT_USER/g" \
        -e "s/password_here/$MYSQL_ROOT_PASSWORD/g" \
        -e "s/localhost/$MYSQL_HOST/g" \
        $WORD_PRESS_PATH/wp-config-sample.php > $WORD_PRESS_PATH/wp-config.php

    # 生成されたファイルに適切なパーミッションを設定 (必要に応じて)
    chmod 640 /var/www/html/wp-config.php

    # 必須の環境変数をチェック
    if [ -z "$DOMIAN_NAME" ] || [ -z "$WORD_PRESS_ADMIN_USER" ] || [ -z "$WORD_PRESS_ADMIN_EMAIL" ] || [ -z "$WORD_PRESS_ADMIN_PASSWORD" ] || [ -z "$WORD_PRESS_TITLE"]; then
        echo "Error: Missing required environment variables (DOMIAN_NAME, WORD_PRESS_ADMIN_USER, WORD_PRESS_ADMIN_EMAIL, WORD_PRESS_ADMIN_PASSWORD, WORD_PRESS_TITLE)."
        exit 1
    fi

    #wordpressをインストールする
    wp core install --url=$DOMIAN_NAME \
                    --path=$WORD_PRESS_PATH \
                    --locale=ja \
                    --admin_user=$WORD_PRESS_ADMIN_USER \
                    --admin_email=$WORD_PRESS_ADMIN_EMAIL \
                    --admin_password=$WORD_PRESS_ADMIN_PASSWORD \
                    --title=$WORD_PRESS_TITLE --allow-root

    #wordpressのユーザーを作成する
    wp user create $WORD_PRESS_USER \
                    $WORD_PRESS_USER_EMAIL \
                    --user_pass=$WORD_PRESS_USER_PASSWORD \
                    --role=$WORD_PRESS_USER_ROLE \
                    --path=$WORD_PRESS_PATH --allow-root
fi

if [ -d "/run/php" ]; then
    echo "php already present, skipping creation"
else
    echo "php not found, creating....."
    mkdir -p /run/php
fi
# CMDで渡された引数を$@で引用される（/usr/sbin/php-fpm7.4 --nodaemoniz --fpm-config /etc/php/7.4/fpm/php-fpm.conf）
exec "$@"