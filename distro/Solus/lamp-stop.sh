#!/bin/bash

echo "Stopping Apache HTTPD service"
sudo systemctl stop httpd

echo "Disabling Apache HTTPD service"
sudo systemctl disable httpd

echo ""
echo "Stopping PHP-FPM service"
sudo systemctl stop php-fpm

echo "disabling PHP-FPM service"
sudo systemctl disable php-fpm

echo ""
echo "Stopping MariaDB service"
sudo systemctl stop mariadb

echo "disabling MariaDB service"
sudo systemctl disable mariadb
echo ""
