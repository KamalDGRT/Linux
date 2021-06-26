#!/bin/bash

# Add your GitHub details here:
GITHUB_USERNAME=""
GITHUB_EMAIL_ID=""
GIT_CLI_EDITOR=""

CHOICE=1

banner() {
    printf "\n\n\n"
    msg="| $* |"
    edge=$(echo "$msg" | sed 's/./-/g')
    echo "$edge"
    echo "$msg"
    echo "$edge"
}


pause() {
    read -s -n 1 -p "Press any key to continue . . ."
    clear
}


nf_bash_xclip() {
    banner "Installing: neofetch bash-completion xorg-xclip"
    yes | sudo pacman -S neofetch bash-completion xorg-xclip
}


gitsetup() {
    banner "Setting up SSH for git and GitHub"
    
    printf "\n - Configuring GitHub username as: ${GITHUB_USERNAME}"
    git config --global user.name "${GITHUB_USERNAME}"
    
    printf "\n - Configuring GitHub email address as: ${GITHUB_EMAIL_ID}"
    git config --global user.email "${GITHUB_EMAIL_ID}"
    
    printf "\n - Configuring Default git editor as: ${GIT_CLI_EDITOR}"
    git config --global core.editor "${GIT_CLI_EDITOR}"
    
    printf "\n - Generating a new SSH key for ${GITHUB_EMAIL_ID}"
    printf "\n\nJust press Enter and add passphrase if you'd like to. \n\n"
    ssh-keygen -t ed25519 -C "${GITHUB_EMAIL_ID}"
    
    printf "\n\nAdding your SSH key to the ssh-agent..\n"
    
    printf "\n - Start the ssh-agent in the background.."
    eval "$(ssh-agent -s)"
    
    print "\n\n - Adding your SSH private key to the ssh-agent"
    ssh-add ~/.ssh/id_ed25519
    
    printf "\n - Copying the SSH Key Content to the Clipboard..."
    
    printf "\n\nLog in into your GitHub account in the browser (if you have not)"
    printf "\nOpen this link https://github.com/settings/keys in the browser."
    printf "\nClik on New SSH key."
    xclip -selection clipboard < ~/.ssh/id_ed25519.pub
    printf "\nGive a title for the SSH key."
    printf "\nPaste the clipboard content in the textarea box below the title."
    printf "\nClick on Add SSH key."
}


audio_tools() {
    banner "Installing: Pulse Audio & Alsa Tools"
    yes | sudo pacman -S pulseaudio pulseaudio-alsa pavucontrol alsa-utils \
    alsa-ucm-conf sof-firmware
}


lampp_stack() {
    banner "Installing: LAMP Stack Packages"
    yes | sudo pacman -S php php-apache php-cgi php-fpm php-gd php-embed php-intl php-imap \
    php-redis php-snmp phpmyadmin
}


package_managers() {
    banner "Installing Package Managers: composer npm yay snapd"
    yes | sudo pacman -S composer nodejs npm yay snapd
    
    printf "\nEnabling the snap daemon..."
    sudo systemctl enable --now snapd.socket
    
    printf "\nEnabling classic snap support by creating the symlink..."
    sudo ln -s /var/lib/snapd/snap /snap
}


brave_tel_vlc_discord() {
    banner "Installing: Brave Browser, Telegram, VLC & Discord"
    yes | sudo pacman -S brave telegram-desktop vlc discord
}


obs_studio() {
    banner "Installing Snap Package: OBS Studio"
    sudo snap install obs-studio
}


s_spotify() {
    banner "Installing Snap Package: Spotify"
    sudo snap install spotify
    pause
}


vscode() {
    banner "Installing Snap Package: Microsoft Visual Studio Code"
    sudo snap install code --classic
}


sublime_text() {
    banner "Installing: Sublime Text"
    
    printf "\n\nInstall the GPG key:\n"
    printf "\nGetting the GPG key using curl..."
    curl -O https://download.sublimetext.com/sublimehq-pub.gpg
    
    printf "\nAdding the GPG key using pacman-key ..."
    sudo pacman-key --add sublimehq-pub.gpg
    
    printf "\nSigning the GPG key..."
    sudo pacman-key --lsign-key 8A8F901A
    
    printf "\nRemoving the GPG key obtained from curl ..."
    rm sublimehq-pub.gpg
    
    printf "\nChoosing the Stable x86_64 channel for install..."
    echo -e "\n[sublime-text]\nServer = https://download.sublimetext.com/arch/stable/x86_64" \
    | sudo tee -a /etc/pacman.conf
    
    printf "\nUpdatig pacman and installing Sublime Text..."
    yes | sudo pacman -Syu sublime-text
}


zoom_app() {
    banner "Installing: Zoom Video Conferencing App"
    
    printf "\n - Going inside the Downloads folder..."
    cd Downloads
    
    printf "\n - Downloading the Zoom application..."
    wget https://zoom.us/client/latest/zoom_x86_64.pkg.tar.xz
    
    printf "\n - Starting the zoom installation..."
    yes | sudo pacman -U zoom_x86_64.pkg.tar.xz
    
    printf "\n - Coming out of the Downloads folder..."
    cd
}


mkvtoolnix_gui() {
    banner "Installing: MKVToolNix GUI"
    yes | sudo pacman -S mkvtoolnix-gui
}


s_qbittorrent() {
    banner "Installing: qBittorrent"
    yes | sudo pacman -S qbittorrent
}


fira_code_vim() {
    banner "Installing: Fira Code Font and Vim Editor"
    yes | sudo pacman -S ttf-fira-code vim
}


aliases_and_scripts(){
    banner "Installing Aliases and Scripts"
    
    aliasfile="\n"
    aliasfile+="if [ -f ~/.rksalias ]; then\n"
    aliasfile+=". ~/.rksalias\n"
    aliasfile+="fi\n"
}


install_all_menu() {
    printf "\nThis will do the following:\n"
    printf "\nInstall: neofetch bash-completion xorg-xclip"
    printf "\nSet up SSH for git and GitHub"
    printf "\nInstall: Pulse Audio & Alsa Tools"
    printf "\nInstall: LAMP Stack Packages"
    printf "\nInstall: Package Managers: composer npm yay snapd"
    printf "\nInstall: Brave Browser, Telegram, VLC & Discord"
    printf "\nInstall: Snap Package: OBS Studio"
    printf "\nInstall: Snap Package: Spotify"
    printf "\nInstall: Snap Package: Microsoft Visual Studio Code"
    printf "\nInstall: Sublime Text"
    printf "\nInstall: Zoom Video Conferencing App"
    printf "\nInstall: MKVToolNix GUI"
    printf "\nInstall: qBittorrent"
    printf "\nInstall: Fira Code Font and Vim Editor"
}

install_all() {
    yes | sudo pacman -S neofetch bash-completion xorg-xclip pulseaudio \
    pulseaudio-alsa pavucontrol alsa-utils alsa-ucm-conf sof-firmware \
    php php-apache php-cgi php-fpm php-gd php-embed php-intl php-imap \
    php-redis php-snmp phpmyadmin brave telegram-desktop vlc discord \
    mkvtoolnix-gui qbittorrent ttf-fira-code vim fakeroot

    gitsetup
    sublime_text
    package_managers
    obs_studio
    spotify
    vscode
    zoom_app
}

menu_logo() {
    printf "\n
    ░█▀▀█ █▀▀█ █▀▀ ▀▀█▀▀ 　 ▀█▀ █▀▀▄ █▀▀ ▀▀█▀▀ █▀▀█ █── █──
    ░█▄▄█ █──█ ▀▀█ ──█── 　 ░█─ █──█ ▀▀█ ──█── █▄▄█ █── █──
    ░█─── ▀▀▀▀ ▀▀▀ ──▀── 　 ▄█▄ ▀──▀ ▀▀▀ ──▀── ▀──▀ ▀▀▀ ▀▀▀
    \n\n"
}

ask_user() {    
    msg="$*"
    
    printf "\n${msg}\n"
    printf "
    #~~~~~~~~~~~~#
    | 1.) Yes    |
    | 2.) No     |
    | 3.) Quit   |
    #~~~~~~~~~~~~#\n\n"

    read -e -p "Please select 1, 2, or 3 :   " choice

    if [ "$choice" == "1" ]; then
        return 0

    elif [ "$choice" == "2" ]; then
        return 1

    elif [ "$choice" == "3" ]; then
        clear && exit 0

    else
        echo "Please select 1, 2, or 3." && sleep 3
        clear && ask_user
    fi
}


main_menu() {
    menu_logo

    if ask_user "Wanna install everything?"; then
        printf "\nInstalling All\n"
    else
        printf "\nNothing done\n"
    fi
}


main_menu
