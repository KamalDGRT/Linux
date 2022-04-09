#!/bin/sh

main() {
    ask_user
}

trap ctrl_c INT

function ctrl_c() {

    msg="$*"
    edge="#~~~~~~~~~~~~#"
    printf "\n${msg}\n"

    printf "    ${edge}\n"
    printf "    | 1.) Continue?                 |\n"
    printf "    | 2.) Exit                      |\n"
    printf "    ${edge}\n"

    read -e -p "Please enter your choice :   " choice

    if [ "$choice" == "1" ]; then
        ask_user
    elif [ "$choice" == "2" ]; then
        clear && exit 0
    else
        echo "Please enter your choice.." && sleep 3
        clear && ctrl_c ""
    fi
}

ask_user() {
    msg="$*"
    edge="#~~~~~~~~~~~~#"
    printf "\n${msg}\n"
    printf "\n Service Manager\n"

    printf "    ${edge}\n"
    printf "    | 1.) Enable Service?               |\n"
    printf "    | 2.) Disable Service?              |\n"
    printf "    | 3.) Get Running Services?         |\n"
    printf "    | 4.) Find Running Service?         |\n"
    printf "    | 5.) Get Disabled Services?        |\n"
    printf "    | 6.) Find Disabled Service?        |\n"
    printf "    | 7.) Exit                          |\n"
    printf "    ${edge}\n"

    read -e -p "Please enter your choice :   " choice

    if [ "$choice" == "1" ]; then
        ask_service_name_enable
        ask_user
    elif [ "$choice" == "2" ]; then
        ask_service_name_disable
        ask_user
    elif [ "$choice" == "3" ]; then
        show_running_services
        ask_user
    elif [ "$choice" == "4" ]; then
        find_running_service
        ask_user
    elif [ "$choice" == "5" ]; then
        show_disabled_services
        ask_user
    elif [ "$choice" == "6" ]; then
        find_disabled_service
        ask_user
    elif [ "$choice" == "7" ]; then
        clear && exit 0
    else
        echo "Please enter your choice.." && sleep 3
        clear && ask_user ""
    fi
}

ask_service_name_enable() {
    read -e -p "Enter Service name : " service_name
    enable_service ${service_name}
}

ask_service_name_disable() {
    read -e -p "Enter Service name : " service_name
    disable_service ${service_name}
}

disable_service() {
    sudo systemctl stop ${1}.service
    sudo systemctl disable ${1}.service
}

enable_service() {
    sudo systemctl enable ${1}.service
    sudo systemctl start ${1}.service
}

show_running_services(){
    sudo systemctl --type=service
}

find_running_service(){
    read -e -p "Enter Service name : " service_name
    sudo systemctl --type=service | grep ${service_name}
}

show_disabled_services(){
    sudo systemctl list-unit-files --type=service --state=disabled
}

find_disabled_service(){
    read -e -p "Enter Service name : " service_name
    sudo systemctl list-unit-files --type=service --state=disabled | grep ${service_name}
}

main
