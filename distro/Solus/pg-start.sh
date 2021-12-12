#!/bin/bash

echo "Starting Postgres service"
sudo systemctl start postgresql

echo "Enabling Postgres service"
sudo systemctl enable postgresql
