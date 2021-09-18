#!/bin/bash
echo "Only Works in GNOME"

NIGHT_MODE_ENABLED=$(gsettings get org.gnome.settings-daemon.plugins.color night-light-enabled) 

if [ $NIGHT_MODE_ENABLED = true ]; then
	gsettings set org.gnome.settings-daemon.plugins.color night-light-enabled false
else
	gsettings set org.gnome.settings-daemon.plugins.color night-light-enabled true
fi
