#!/bin/bash

clear

banner() {
    printf "\n\n\n"
    msg="| $* |"
    edge=$(echo "$msg" | sed 's/./-/g')
    echo "$edge"
    echo "$msg"
    echo "$edge"
}

install_OBS() {
    banner "Installing Snap Package: OBS Studio"
    sudo snap install obs-studio
}

install_Spotify() {
    banner "Installing Snap Package: Spotify"
    sudo snap install spotify
}

install_Opera() {
    banner "Installing Snap Package: Opera"
    sudo snap install opera
}

install_All_Snap_Apps(){
    install_OBS
    install_Spotify
    install_Opera
}
