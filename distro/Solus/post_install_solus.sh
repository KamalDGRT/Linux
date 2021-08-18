#!/bin/bash

#----- Fancy Messages -----#
#  Credits: snwh/solus-post-install

show_error() {
    echo -e "\033[1;31m$@\033[m" 1>&2
}

show_info() {
    echo -e "\033[1;32m$@\033[0m"
}

show_warning() {
    echo -e "\033[1;33m$@\033[0m"
}

show_question() {
    echo -e "\033[1;34m$@\033[0m"
}

show_success() {
    echo -e "\033[1;35m$@\033[0m"
}

show_header() {
    echo -e "\033[1;36m$@\033[0m"
}

show_listitem() {
    echo -e "\033[0;37m$@\033[0m"
}

after_install() {
    show_success "\n\n$* : Installed Successfully\n"
    echo -e "------------------------------------------\n\n"
}

banner() {
    printf "\n\n\n"
    msg="| $* |"
    edge=$(echo "$msg" | sed 's/./-/g')
    show_error "$edge"
    show_info "$msg"
    show_error "$edge"
}

install_Neofetch() {
    banner "Installing Neofetch"
    sudo eopkg install neofetch -y
    after_install "neofetch"
}

install_Zoom_Client() {
    banner "Installing Zoom Client"

    show_question "\nDownloading the Latest version of Zoom\n"
    wget -O ~/Downloads/zoom.tar.xz 'https://zoom.us/client/latest/zoom_x86_64.tar.xz'

    show_question "\nCreating a directory to install zoom.."
    if [ -d ~/LEO ]; then
        show_warning "\nDirectory exists.\nSkipping the creation step..\n"
    else
        mkdir -p ~/LEO
    fi

    show_info "\nExtracting the downloaded file...\n"
    tar -xf ~/Downloads/zoom.tar.xz -C ~/LEO

    show_question "\nCreating a directory to download Zoom Icon"
    if [ -d ~/LEO/zoom/icon ]; then
        show_warning "\nDirectory exists.\nSkipping the creation step..\n"
    else
        mkdir -p ~/LEO/zoom/icon
    fi

    show_info "\nDownloading the Zoom Client Icon\n"
    wget -O ~/LEO/zoom/icon/zoom.png 'https://i.imgur.com/0zk7xXE.png'

    currentUser=`whoami`

    show_info "\nCreating a Desktop Entry for Zoom Client.\n"
    {
        echo "[Desktop Entry]"
        echo "Comment=Zoom Client for Solus"
        echo "Name=Zoom Client"
        echo "Exec=/home/${currentUser}/LEO/zoom/ZoomLauncher"
        echo "Icon=/home/${currentUser}/LEO/zoom/icon/zoom.png"
        echo "Encoding=UTF-8"
        echo "Terminal=false"
        echo "Type=Application"
    } | sudo tee /usr/share/applications/zoom-client.desktop

    after_install "Zoom Client"
}

install_Everything() {
    install_Neofetch
}

# install_Everything
install_Zoom_Client
