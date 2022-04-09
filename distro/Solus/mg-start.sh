#!/bin/bash

echo "Starting mongodb service"
sudo systemctl start mongodb

echo "Enabling mongodb service"
sudo systemctl enable mongodb
