#!/usr/bin/bash
fbm=`cat /sys/devices/platform/faustus/fan_boost_mode`
if [ $fbm == 0 ]
then
	echo "Fan Mode: Normal"
elif [ $fbm == 1 ]
then
	echo "Fan Mode: Overboost"
elif [ $fbm == 2 ]
then
	echo "Fan Mode: Silent"
else
	echo "Invalid Fan Mode"
fi
