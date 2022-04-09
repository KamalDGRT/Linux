#!/bin/bash

echo "Stopping Postgres service"
sudo systemctl stop postgresql

echo "Disabling Postgres service"
sudo systemctl disable postgresql
