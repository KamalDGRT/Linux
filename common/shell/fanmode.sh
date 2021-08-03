#!/bin/bash

fbm=`cat /sys/devices/platform/asus-nb-wmi/fan_boost_mode`

if [ $fbm == 0 ]
then
	echo "Fan Mode: Balanced"
elif [ $fbm == 1 ]
then
	echo "Fan Mode: Turbo"
elif [ $fbm == 2 ]
then
	echo "Fan Mode: Silent"
else
	echo "Invalid Fan Mode"
fi
