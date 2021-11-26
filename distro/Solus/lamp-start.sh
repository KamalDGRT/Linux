#!/bin/bash

echo "Starting Apache HTTPD service"
sudo systemctl start httpd

echo "Enabling Apache HTTPD service"
sudo systemctl enable httpd

echo ""
echo "Starting PHP-FPM service"
sudo systemctl start php-fpm

echo "Enabling PHP-FPM service"
sudo systemctl enable php-fpm

echo ""
echo "Starting MariaDB service"
sudo systemctl start mariadb

echo "Enabling MariaDB service"
sudo systemctl enable mariadb
echo ""
