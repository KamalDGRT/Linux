#!/bin/bash

main(){
    clear
    display_logo

    bold_font=$(tput bold)
    normal_font=$(tput sgr0)
    printf "\n${bold_font}This script will Increase/Decrease Brightness for Dual Monitor.\n\n"

    # ALL_MONITORS="COMMAND OUTPUT"
    # monitor1="COMMAND OUTPUT"
    # monitor2="COMMAND OUTPUT"
    # monitorChoosed="USER INPUT"
    # level="USER INPUT"
    
    ALL_MONITORS="$(xrandr --listactivemonitors)"
	
    echo $ALL_MONITORS | awk '{print $1,$2;}'
 
    monitor1=$(echo $ALL_MONITORS | awk '{print $6;}')
    monitor2=$(echo $ALL_MONITORS | awk '{print $10;}')

    printf "\n${normal_font}1: ${monitor1}\n"
    printf "2: ${monitor2}\n\n"

    read -p "Choose 1 or 2: " monitorChoosed
    printf "\n"
    read -p "Enter brightness level from 0 to 2: " level
    
    if [ $monitorChoosed == 1 ]
    then 
        xrandr --output ${monitor1} --brightness ${level}
    else
        xrandr --output ${monitor2} --brightness ${level}
    fi
}

display_logo(){
    echo "
           _____       .___    __                __    __________        .__       .__     __                               
          /  _  \    __| _/   |__|__ __  _______/  |_  \______   \_______|__| ____ |  |___/  |_  ____   ____   ______ ______
         /  /_\  \  / __ |    |  |  |  \/  ___/\   __\  |    |  _/\_  __ \  |/ ___\|  |  \   __\/    \_/ __ \ /  ___//  ___/
        /    |    \/ /_/ |    |  |  |  /\___ \  |  |    |    |   \ |  | \/  / /_/  >   Y  \  | |   |  \  ___/ \___ \ \___ \ 
        \____|__  /\____ |/\__|  |____//____  > |__|    |______  / |__|  |__\___  /|___|  /__| |___|  /\___  >____  >____  >
                \/      \/\______|          \/                 \/          /_____/      \/          \/     \/     \/     \/ 
    "
}
main
