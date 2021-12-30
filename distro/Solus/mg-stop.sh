#!/bin/bash

echo "Stopping mongodb service"
sudo systemctl stop mongodb

echo "Disabling mongodb service"
sudo systemctl disable mongodb
