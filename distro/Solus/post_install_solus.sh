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

    currentUser=$(whoami)

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

install_Xclip() {
    banner "Installing xclip"
    sudo eopkg install xclip -y
    after_install "xclip"
}

install_Xkill() {
    banner "Installing xkill"
    sudo eopkg install xkill -y
    after_install "xkill"
}

install_Sublime_Text() {
    banner "Installing Sublime Text"
    show_question "\nDownloading Sublime Text Build 4113\n"
    wget -O ~/Downloads/sublime.tar.xz 'https://download.sublimetext.com/sublime_text_build_4113_x64.tar.xz'

    show_question "\nCreating a directory to install Sublime Text.."
    if [ -d ~/LEO ]; then
        show_warning "\nDirectory exists.\nSkipping the creation step..\n"
    else
        mkdir -p ~/LEO
    fi

    show_info "\nExtracting the downloaded file...\n"
    tar -xf ~/Downloads/sublime.tar.xz -C ~/LEO

    currentUser=$(whoami)

    show_info "\nCreating a Desktop Entry for Sublime Text.\n"
    {
        echo "[Desktop Entry]"
        echo "Version=1.0"
        echo "Type=Application"
        echo "Name=Sublime Text"
        echo "GenericName=Text Editor"
        echo "Comment=Sophisticated text editor for code, markup and prose"
        echo "Exec=/home/${currentUser}/LEO/sublime_text/sublime_text %F"
        echo "Terminal=false"
        echo "MimeType=text/plain;"
        echo "Icon=/home/${currentUser}/LEO/sublime_text/Icon/256x256/sublime-text.png"
        echo "Categories=TextEditor;Development;"
        echo "StartupNotify=true"
        echo "Actions=new-window;new-file;"

        echo "[Desktop Action new-window]"
        echo "Name=New Window"
        echo "Exec=/home/${currentUser}/LEO/sublime_text/sublime_text --launch-or-new-window"
        echo "OnlyShowIn=Unity;"

        echo "[Desktop Action new-file]"
        echo "Name=New File"
        echo "Exec=/home/${currentUser}/LEO/sublime_text/sublime_text --command new_file"
        echo "OnlyShowIn=Unity;"
    } | sudo tee /usr/share/applications/sublime-text.desktop

    show_info "Creating Sybmbolic Link for Sublime Text\n\n"
    sudo ln -s ~/LEO/sublime_text/sublime_text /usr/bin/subl

    after_install "Sublime Text"
}

install_Unoconv() {
    banner "Installing unoconv"
    
    show_info "This scripts needs libreoffice"
    
    mkdir -p ~/LEO/unoconv
    git clone https://github.com/dagwieers/unoconv.git ~/LEO/unoconv
    sudo ln -s ~/LEO/unoconv/unoconv /usr/bin/unoconv
    
    after_install "unoconv"
}


install_Everything() {
    install_Neofetch
    install_Zoom_Client
    install_Xclip
    install_Xkill
    install_Unoconv
    install_Sublime_Text
}
