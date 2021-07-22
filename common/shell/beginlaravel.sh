#!/bin/bash

# Script to setup Laravel in Linux distros.
# This script has to be executed from the project root directory.

composer update
cp .env.example .env
php artisan key:generate
php artisan migrate
chmod 777 -R storage/logs/
chmod 777 -R storage/framework/
