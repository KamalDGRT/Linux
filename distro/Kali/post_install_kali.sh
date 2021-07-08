#!/bin/bash

# Add your GitHub details here:
GITHUB_USERNAME=""
GITHUB_EMAIL_ID=""
GIT_CLI_EDITOR=""

clear

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

install_Xclip() {
    printf"\n\nUpdating the package cache..."
    sudo apt update

    printf "\nInstalling: xclip"
    sudo apt install -y xclip
}

gitsetup() {
    banner "Setting up SSH for git and GitHub"

    if [[ $GITHUB_EMAIL_ID != "" && $GITHUB_USERNAME != "" && $GIT_CLI_EDITOR != "" ]]; then
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

        printf "\n - Start the ssh-agent in the background..\n"
        eval "$(ssh-agent -s)"

        printf "\n\n - Adding your SSH private key to the ssh-agent\n\n"
        ssh-add ~/.ssh/id_ed25519

        printf "\n - Copying the SSH Key Content to the Clipboard..."

        printf "\n\nLog in into your GitHub account in the browser (if you have not)"
        printf "\nOpen this link https://github.com/settings/keys in the browser."
        printf "\nClik on New SSH key."
        xclip -selection clipboard <~/.ssh/id_ed25519.pub
        printf "\nGive a title for the SSH key."
        printf "\nPaste the clipboard content in the textarea box below the title."
        printf "\nClick on Add SSH key.\n\n"
        pause
    else
        printf "\nYou have not provided the configuration for Git Setup."
        printf "\nAdd them at the top of this script file and run it again."
    fi
}

rks_gnome_themes() {
    printf "\n\nChanging the default GNOME theme"

    currentDirectory=$(pwd)

    printf "\n\nEnabling User Themes Extension..."
    gnome-extensions enable user-theme@gnome-shell-extensions.gcampax.github.com

    printf "\nCreating a directory to clone the KamalDGRT/rks-gnome-themes repo.."
    if [ -d ~/RKS_FILES/GitRep ]; then
        printf "\nDirectory exists.\nSkipping the creation step..\n"
    else
        mkdir -p ~/RKS_FILES/GitRep
    fi

    printf "\nGoing inside ~/RKS_FILES/GitRep\n"
    cd ~/RKS_FILES/GitRep

    printf "\nChecking if the KamalDGRT/rks-gnome-themes repository exists..."
    if [ -d ~/RKS_FILES/GitRep/rks-gnome-themes ]; then
        printf "\nRepository exists. \nSkipping the cloning step..\n"
    else
        printf "\nRepository does not exist in the system.."
        printf "\nCloning the GitHub Repo: KamalDGRT/rks-gnome-themes\n"
        git clone https://github.com/KamalDGRT/rks-gnome-themes.git
    fi

    printf "\nGoing inside rks-gnome-themes directory...\n"
    cd rks-gnome-themes

    printf "\n\nChecking if ~/.themes directory exists..."
    if [ -d ~/.themes ]; then
        printf "\Directory exists. \nSkipping the creation step..\n"
    else
        printf "\nDirectry does not exist in the system.."
        printf "\nCreating .themes at location ~/"
        mkdir ~/.themes
    fi

    printf "\n\nChecking if ~/.icons directory exists..."
    if [ -d ~/.icons ]; then
        printf "\Directory exists. \nSkipping the creation step..\n"
    else
        printf "\nDirectry does not exist in the system.."
        printf "\nCreating .icons at location ~/"
        mkdir ~/.icons
    fi

    printf "\n\nCopying the Flat-Remix-Blue-Dark Icon Theme"
    cp -rf Icon/Flat-Remix-Blue-Dark ~/.icons

    printf "\n\nCopying the Mojave-dark-solid-alt Theme"
    cp -rf Theme/Mojave-dark-solid-alt ~/.themes

    printf "\n\nCopying the Kimi-dark Theme"
    cp -rf Theme/Kimi-dark ~/.themes

    printf "\nChanging Interface Theme to : Kimi-dark"
    gsettings set org.gnome.desktop.interface gtk-theme "Kimi-dark"

    printf "\nChanging WM Theme to : Mojave-dark-solid-alt"
    gsettings set org.gnome.shell.extensions.user-theme name 'Mojave-dark-solid-alt'

    printf "\nChanging Icon Theme to : Flat-Remix-Blue-Dark"
    gsettings set org.gnome.desktop.interface icon-theme "Flat-Remix-Blue-Dark"

    printf "\n\nComing back to th present working directory\n\n"
    cd "${currentDirectory}"
}

configure_title_bar() {
    printf "\n\nShowing Battery Percentage"
    gsettings set org.gnome.desktop.interface show-battery-percentage true

    printf "\nShow Time in 12 hour format"
    gsettings set org.gnome.desktop.interface clock-format 12h

    printf "\nShow the seconds in Clock"
    gsettings set org.gnome.desktop.interface clock-show-seconds true

    printf "\nShow the Weekday in Clock"
    gsettings set org.gnome.desktop.interface clock-show-weekday true
}

install_Brave() {
    printf "\n\nInstalling Brave Browser"
    sudo apt install apt-transport-https curl
    sudo curl -fsSLo /usr/share/keyrings/brave-browser-archive-keyring.gpg https://brave-browser-apt-release.s3.brave.com/brave-browser-archive-keyring.gpg
    echo "deb [signed-by=/usr/share/keyrings/brave-browser-archive-keyring.gpg arch=amd64] https://brave-browser-apt-release.s3.brave.com/ stable main" | sudo tee /etc/apt/sources.list.d/brave-browser-release.list
    sudo apt update
    sudo apt install brave-browser
}

install_Discord() {
    cd ~/Downloads
    wget -O discord.tar.gz 'https://discord.com/api/download?platform=linux&format=tar.gz'
    sudo tar -xvzf discord.tar.gz -C /opt
    sudo ln -sf /opt/Discord/Discord /usr/bin/Discord
    sudo cp -r /opt/Discord/discord.desktop /usr/share/applications
    sudo sudo apt install libatomic1
    SUBJECT='/usr/share/applications/discord.desktop'
    SEARCH_FOR='Exec='
    sudo sed -i "/^$SEARCH_FOR/c\/usr/bin/Discord" $SUBJECT

    SEARCH_FOR='Icon='
    sudo sed -i "/^$SEARCH_FOR/c\/opt/Discord/discord.png" $SUBJECT
}

install_Telegram() {
    printf "\n Install Telegram"
    sudo apt install telegram-desktop
}

install_snapd() {
    sudo apt install snapd apparmor
    sudo systemctl enable --now snapd.socket
    sudo systemctl enable --now apparmor.service
    sudo ln -s /var/lib/snapd/snap /snap
}

install_NeoFetch() {
    printf "\nInstalling NeoFetch"
    sudo apt-get install neofetch
}

install_Audio_Tools() {
    printf "\nInstalling Audio Tools"
    sudo apt install -y pulseaudio pavucontrol alsa-utils alsa-ucm-conf
}

install_NVDIA_drivers() {
    printf "\nInstall NVDIA-Drivers"
    sudo apt install nvidia-driver nvidia-cuda-toolkit
}

install_gdebi() {
    printf "\nInstall gdebi"
    sudo apt install gdebi
}

install_MS_Fonts() {
    printf "\n\nInstalling Microsoft Core Fonts"
    sudo apt-get install ttf-mscorefonts-installer
}

install_Sublime_Text() {
    printf "\nInstalling Sublime Text"
    wget -qO - https://download.sublimetext.com/sublimehq-pub.gpg | sudo apt-key add -
    sudo apt-get install apt-transport-https
    echo "deb https://download.sublimetext.com/ apt/stable/" | sudo tee /etc/apt/sources.list.d/sublime-text.list
    sudo apt-get update
    sudo apt-get install sublime-text
}

install_VSCode() {
    printf "\nInstalling Microsoft Visual Studio Code..."
    wget -qO- https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor >packages.microsoft.gpg
    sudo install -o root -g root -m 644 packages.microsoft.gpg /etc/apt/trusted.gpg.d/
    sudo sh -c 'echo "deb [arch=amd64,arm64,armhf signed-by=/etc/apt/trusted.gpg.d/packages.microsoft.gpg] https://packages.microsoft.com/repos/code stable main" > /etc/apt/sources.list.d/vscode.list'
    rm -f packages.microsoft.gpg
    sudo apt install apt-transport-https
    sudo apt update
    sudo apt install code
}

install_PyCharm_Community_Edition() {
    printf "\nInstalling IntelliJ PyCharm Community Edition"
    cd ~/Downloads
    wget -O pycharm.tar.gz https://download.jetbrains.com/python/pycharm-community-2021.1.3.tar.gz
    sudo tar xzf pycharm.tar.gz -C /opt/
    sudo mv /opt/pycharm-*/ /opt/pycharm/
    cd /opt/pycharm/bin
    sh pycharm.sh
}

install_Pip() {
    printf "\nInstalling Pip..."
    sudo apt install python3-pip
}

install_YoutubeDL() {
    printf "\nInstalling Youtube-DL CLI"
    sudo apt install youtube-dl
}

install_and_configure_LAMP() {
    cd ~/Downloads

    sudo apt install -y apache2 mariadb-server mariadb-client php \
        libapache2-mod-php wget php php-cgi php-mysqli php-pear \
        php-mbstring libapache2-mod-php php-common \
        php-phpseclib php-mysql composer xclip

    sudo systemctl enable --now apache2

    sudo systemctl enable --now mariadb

    yes | sudo mysql_secure_installation

    sudo mysqladmin -u root password 'Test@12345'

    wget -O phpmyadmin.tar.gz 'https://www.phpmyadmin.net/downloads/phpMyAdmin-latest-all-languages.tar.gz'

    wget 'https://files.phpmyadmin.net/phpmyadmin.keyring'

    gpg --import phpmyadmin.keyring

    wget -O phpmyadmin.tar.gz.asc 'https://www.phpmyadmin.net/downloads/phpMyAdmin-latest-all-languages.tar.gz.asc'

    gpg --verify phpmyadmin.tar.gz.asc

    sudo mkdir /var/www/html/phpmyadmin/

    sudo tar xvf phpmyadmin.tar.gz --strip-components=1 -C /var/www/html/phpmyadmin

    sudo cp /var/www/html/phpmyadmin/config.sample.inc.php /var/www/html/phpmyadmin/config.inc.php

    openssl rand -base64 32 | xclip -selection clipboard

    sudo nano /var/www/html/phpmyadmin/config.inc.php

    sudo chmod 660 /var/www/html/phpmyadmin/config.inc.php

    sudo chown -R www-data:www-data /var/www/html/phpmyadmin

    sudo systemctl restart apache2
}

install_Everything() {
    gitsetup

    install_Xclip
    install_NeoFetch
    install_Audio_Tools
    install_MS_Fonts

    install_gdebi
    install_Pip
    install_YoutubeDL
    install_snapd

    rks_gnome_themes
    configure_title_bar

    install_Brave
    install_Discord
    install_Telegram
    install_Sublime_Text
    install_VSCode
    install_and_configure_LAMP
    install_NVDIA_drivers
}
