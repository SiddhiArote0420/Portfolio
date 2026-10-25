#!/bin/sh
set -e

# If external DB_URL is not provided, start built-in MariaDB server
if [ -z "$DB_URL" ]; then
    service mariadb start
    mysql -u root -e "CREATE DATABASE IF NOT EXISTS portfolio_db CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci; ALTER USER 'root'@'localhost' IDENTIFIED VIA mysql_native_password USING PASSWORD(''); GRANT ALL PRIVILEGES ON *.* TO 'root'@'localhost' WITH GRANT OPTION; FLUSH PRIVILEGES;"
    mysql -u root portfolio_db < /docker-entrypoint-initdb.sql
fi

exec catalina.sh run
