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
    banner "Installing xclip"
    printf"\e[1;32m\n\nUpdating the package cache...\n\e[0m"
    sudo apt update

    printf "\e[1;32m\nInstalling: xclip\n\e[0m"
    sudo apt install -y xclip
}

install_Figlet() {
    banner "\nInstalling Figlet\n"
    sudo apt install figlet
}

gitsetup() {
    banner "Setting up SSH for git and GitHub"

    if [[ $GITHUB_EMAIL_ID != "" && $GITHUB_USERNAME != "" && $GIT_CLI_EDITOR != "" ]]; then
        printf "\e[1;32m\n - Configuring GitHub username as: ${GITHUB_USERNAME}\e[0m"
        git config --global user.name "${GITHUB_USERNAME}"

        printf "\e[1;32m\n - Configuring GitHub email address as: ${GITHUB_EMAIL_ID}\e[0m"
        git config --global user.email "${GITHUB_EMAIL_ID}"

        printf "\e[1;32m\n - Configuring Default git editor as: ${GIT_CLI_EDITOR}\e[0m"
        git config --global core.editor "${GIT_CLI_EDITOR}"

        printf "\e[1;32m\n - Generating a new SSH key for ${GITHUB_EMAIL_ID}\e[0m"
        printf "\e[1;32m\n\nJust press Enter and add passphrase if you'd like to. \n\n\e[0m"
        ssh-keygen -t ed25519 -C "${GITHUB_EMAIL_ID}"

        printf "\e[1;32m\n\nAdding your SSH key to the ssh-agent..\n\e[0m"

        printf "\e[1;32m\n - Start the ssh-agent in the background..\n\e[0m"
        eval "$(ssh-agent -s)"

        printf "\e[1;32m\n\n - Adding your SSH private key to the ssh-agent\n\n\e[0m"
        ssh-add ~/.ssh/id_ed25519

        printf "\e[1;32m\n - Copying the SSH Key Content to the Clipboard...\e[0m"

        printf "\e[1;32m\n\nLog in into your GitHub account in the browser (if you have not)\e[0m"
        printf "\e[1;32m\nOpen this link https://github.com/settings/keys in the browser.\e[0m"
        printf "\e[1;32m\nClik on New SSH key.\e[0m"
        xclip -selection clipboard <~/.ssh/id_ed25519.pub
        printf "\e[1;32m\nGive a title for the SSH key.\e[0m"
        printf "\e[1;32m\nPaste the clipboard content in the textarea box below the title.\e[0m"
        printf "\e[1;32m\nClick on Add SSH key.\n\n\e[0m"
        pause
    else
        printf "\e[1;32m\nYou have not provided the configuration for Git Setup.\e[0m"
        printf "\e[1;32m\nAdd them at the top of this script file and run it again.\e[0m"
    fi
}

rks_gnome_themes() {
    banner "Changing the default GNOME theme"
    printf "\e[1;32m\n\nChanging the default GNOME theme\e[0m"

    currentDirectory=$(pwd)

    printf "\e[1;32m\n\nEnabling User Themes Extension...\e[0m"
    gnome-extensions enable user-theme@gnome-shell-extensions.gcampax.github.com

    printf "\e[1;32m\nCreating a directory to clone the KamalDGRT/rks-gnome-themes repo..\e[0m"
    if [ -d ~/RKS_FILES/GitRep ]; then
        printf "\e[1;32m\nDirectory exists.\nSkipping the creation step..\n\e[0m"
    else
        mkdir -p ~/RKS_FILES/GitRep
    fi

    printf "\n\e[1;32mGoing inside ~/RKS_FILES/GitRep\n\e[0m"
    cd ~/RKS_FILES/GitRep

    printf "\n\e[1;32mChecking if the KamalDGRT/rks-gnome-themes repository exists...\e[0m"
    if [ -d ~/RKS_FILES/GitRep/rks-gnome-themes ]; then
        printf "\n\e[1;32mRepository exists. \nSkipping the cloning step..\n\e[0m"
    else
        printf "\n\e[1;32mRepository does not exist in the system..\e[0m"
        printf "\n\e[1;32mCloning the GitHub Repo: KamalDGRT/rks-gnome-themes\n\e[0m"
        git clone https://github.com/KamalDGRT/rks-gnome-themes.git
    fi

    printf "\e[1;32m\nGoing inside rks-gnome-themes directory...\n\e[0m"
    cd rks-gnome-themes

    printf "\e[1;32m\n\nChecking if ~/.themes directory exists...\e[0m"
    if [ -d ~/.themes ]; then
        printf "\e[1;32m\Directory exists. \nSkipping the creation step..\n\e[0m"
    else
        printf "\e[1;32m\nDirectry does not exist in the system..\e[0m"
        printf "\e[1;32m\nCreating .themes at location ~/\e[0m"
        mkdir ~/.themes
    fi

    printf "\e[1;32m\n\nChecking if ~/.icons directory exists...\e[0m"
    if [ -d ~/.icons ]; then
        printf "\e[1;32m\Directory exists. \nSkipping the creation step..\n\e[0m"
    else
        printf "\e[1;32m\nDirectry does not exist in the system..\e[0m"
        printf "\e[1;32m\nCreating .icons at location ~/\e[0m"
        mkdir ~/.icons
    fi

    printf "\e[1;32m\n\nCopying the Flat-Remix-Blue-Dark Icon Theme\e[0m"
    cp -rf Icon/Flat-Remix-Blue-Dark ~/.icons

    printf "\e[1;32m\n\nCopying the Mojave-dark-solid-alt Theme\e[0m"
    cp -rf Theme/Mojave-dark-solid-alt ~/.themes

    printf "\e[1;32m\n\nCopying the Kimi-dark Theme\e[0m"
    cp -rf Theme/Kimi-dark ~/.themes

    printf "\e[1;32m\nChanging Interface Theme to : Kimi-dark\e[0m"
    gsettings set org.gnome.desktop.interface gtk-theme "Kimi-dark"

    printf "\e[1;32m\nChanging WM Theme to : Mojave-dark-solid-alt\e[0m"
    gsettings set org.gnome.shell.extensions.user-theme name 'Mojave-dark-solid-alt'

    printf "\e[1;32m\nChanging Icon Theme to : Flat-Remix-Blue-Dark\e[0m"
    gsettings set org.gnome.desktop.interface icon-theme "Flat-Remix-Blue-Dark"

    printf "\e[1;32m\n\nComing back to th present working directory\n\n\e[0m"
    cd "${currentDirectory}"
}

configure_title_bar() {
    banner "Configure Title Bar"
    printf "\e[1;32m\n\nShowing Battery Percentage\e[0m"
    gsettings set org.gnome.desktop.interface show-battery-percentage true

    printf "\e[1;32m\nShow Time in 12 hour format\e[0m"
    gsettings set org.gnome.desktop.interface clock-format 12h

    printf "\e[1;32m\nShow the seconds in Clock\e[0m"
    gsettings set org.gnome.desktop.interface clock-show-seconds true

    printf "\e[1;32m\nShow the Weekday in Clock\e[0m"
    gsettings set org.gnome.desktop.interface clock-show-weekday true
}

install_Brave() {
    banner "Installing Brave Browser"
    printf "\e[1;32m\n\nInstalling Brave Browser\e[0m"
    printf "\e[1;32m\nInstalling requirements - apt-transport-https, curl\e[0m"
    sudo apt install apt-transport-https curl
    printf "\e[1;32m\nDownloading Brave Browser keyring\e[0m"
    sudo curl -fsSLo /usr/share/keyrings/brave-browser-archive-keyring.gpg https://brave-browser-apt-release.s3.brave.com/brave-browser-archive-keyring.gpg
    printf "\e[1;32m\nAdding source for Brave Browser in apt list\e[0m"
    echo "deb [signed-by=/usr/share/keyrings/brave-browser-archive-keyring.gpg arch=amd64] https://brave-browser-apt-release.s3.brave.com/ stable main" | sudo tee /etc/apt/sources.list.d/brave-browser-release.list
    printf "\e[1;32m\nFetching version to upgrade\e[0m"
    sudo apt update
    printf "\nInstalling brave-browser package\e[0m"
    sudo apt install brave-browser
}

install_Discord() {
    banner "Installing discord tar file"
    printf "\e[1;32m\n\nDownloading discord tar file\e[0m"
    cd ~/Downloads
    wget -O discord.tar.gz 'https://discord.com/api/download?platform=linux&format=tar.gz'
    printf "\e[1;32m\nExtracting discord tar file\e[0m"
    sudo tar -xvzf discord.tar.gz -C /opt
    printf "\e[1;32m\nAdding symbolic link on /usr/bin/Discord\e[0m"
    sudo ln -sf /opt/Discord/Discord /usr/bin/Discord
    printf "\e[1;32m\nCopying discord.desktop to /usr/share/applications\e[0m"
    sudo cp -r /opt/Discord/discord.desktop /usr/share/applications
    printf "\e[1;32m\nInstalling libatomic1\e[0m"
    sudo sudo apt install libatomic1
    printf "\e[1;32m\nAdding executable file for discord.desktop\e[0m"  
    SUBJECT='/usr/share/applications/discord.desktop'
    SEARCH_FOR='Exec='
    sudo sed -i "/^$SEARCH_FOR/c\/usr/bin/Discord" $SUBJECT
    printf "\e[1;32m\nAdding icon for discord.desktop\e[0m"
    SEARCH_FOR='Icon='
    sudo sed -i "/^$SEARCH_FOR/c\/opt/Discord/discord.png" $SUBJECT
}

install_Telegram() {
    banner "Installing Telegram"
    printf "\e[1;32m\n Install Telegram\e[0m"
    sudo apt install telegram-desktop
}

install_snapd() {
    banner "Installing Snap"
    
    printf "\e[1;32m\n\nInstalling snapd and apparmor\e[0m"
    sudo apt install snapd apparmor
    printf "\e[1;32m\nStarting snapd.socket and enabling to start on boot\e[0m"
    sudo systemctl enable --now snapd.socket
    printf "\e[1;32m\nStarting apparmor.socket and enabling to start on boot\e[0m"
    sudo systemctl enable --now apparmor.service
    sudo ln -s /var/lib/snapd/snap /snap
}

install_NeoFetch() {
    banner "Installing Neofetch"
    printf "\e[1;32m\nInstalling NeoFetch\e[0m"
    sudo apt-get install neofetch
}

install_Audio_Tools() {
    banner "Installing Audio Tools"
    printf "\e[1;32m\nInstalling Audio Tools\e[0m"
    sudo apt install -y pulseaudio pavucontrol alsa-utils alsa-ucm-conf
}

install_NVIDIA_drivers() {
    banner "Installing NVIDIA drivers"
    printf "\e[1;32m\nInstall NVDIA-Drivers\e[0m"
    sudo apt install nvidia-driver nvidia-cuda-toolkit
}

install_gdebi() {
    banner "Installing gdebi"

    printf "\e[1;32m\nInstall gdebi\e[0m"
    sudo apt install gdebi
}

install_MS_Fonts() {
    banner "Installing MS Fonts"

    printf "\e[1;32m\n\nInstalling Microsoft Core Fonts\e[0m"
    sudo apt-get install ttf-mscorefonts-installer
}

install_Sublime_Text() {
    banner "Installing Sublime Text"

    printf "\e[1;32m\nInstalling Sublime Text\e[0m"
    wget -qO - https://download.sublimetext.com/sublimehq-pub.gpg | sudo apt-key add -
    sudo apt-get install apt-transport-https
    echo "deb https://download.sublimetext.com/ apt/stable/" | sudo tee /etc/apt/sources.list.d/sublime-text.list
    sudo apt-get update
    sudo apt-get install sublime-text
}

install_VSCode() {
    banner "Installing Visual Studio Code"
    printf "\e[1;32m\nInstalling Microsoft Visual Studio Code...\e[0m"
    wget -qO- https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor >packages.microsoft.gpg
    sudo install -o root -g root -m 644 packages.microsoft.gpg /etc/apt/trusted.gpg.d/
    sudo sh -c 'echo "deb [arch=amd64,arm64,armhf signed-by=/etc/apt/trusted.gpg.d/packages.microsoft.gpg] https://packages.microsoft.com/repos/code stable main" > /etc/apt/sources.list.d/vscode.list'
    rm -f packages.microsoft.gpg
    sudo apt install apt-transport-https
    sudo apt update
    sudo apt install code
}

install_PyCharm_Community_Edition() {
    banner "Installing PyCharm Community Edition"
    printf "\e[1;32m\nInstalling IntelliJ PyCharm Community Edition\e[0m"
    cd ~/Downloads
    wget -O pycharm.tar.gz https://download.jetbrains.com/python/pycharm-community-2021.1.3.tar.gz
    sudo tar xzf pycharm.tar.gz -C /opt/
    sudo mv /opt/pycharm-*/ /opt/pycharm/
    cd /opt/pycharm/bin
    sh pycharm.sh
}

install_Pip() {
    banner "Installing PIP"
    sudo apt install python3-pip
}

install_YoutubeDL() {
    banner "Installing Youtube-DL"
    sudo apt install youtube-dl
}

install_and_configure_LAMP() {
    banner "Installing and Configuring LAMPP"
    cd ~/Downloads
    printf "\e[1;32m\n\nInstalling necessary LAMP stack packages\e[0m"
    sudo apt install -y apache2 mariadb-server mariadb-client php \
        libapache2-mod-php wget php php-cgi php-mysqli php-pear \
        php-mbstring libapache2-mod-php php-common \
        php-phpseclib php-mysql composer xclip

    printf "\e[1;32m\nStarting apache2.socket and enabling to start on boot\e[0m"
    sudo systemctl enable --now apache2
    
    printf "\e[1;32m\nStarting snapd.socket and enabling to start on boot\e[0m"
    sudo systemctl enable --now mariadb
    
    printf "\e[1;32m\nEnabling basic security measures for the MariaDB database\e[0m"
    yes | sudo mysql_secure_installation
    
    printf "\e[1;32m\nAdding root user with Test@12345 as password\e[0m"
    sudo mysqladmin -u root password 'Test@12345'
    
    printf "\e[1;32m\nDownloading PHP tar file\e[0m"
    wget -O phpmyadmin.tar.gz 'https://www.phpmyadmin.net/downloads/phpMyAdmin-latest-all-languages.tar.gz'
    
    printf "\e[1;32m\nDownloading keyring for phpmyadmin\e[0m"
    wget 'https://files.phpmyadmin.net/phpmyadmin.keyring'

    printf "\e[1;32m\nImporting phpmyadmin keyring\e[0m"
    gpg --import phpmyadmin.keyring

    printf "\e[1;32m\nDownloading phpmyadmin tar file\e[0m"
    wget -O phpmyadmin.tar.gz.asc 'https://www.phpmyadmin.net/downloads/phpMyAdmin-latest-all-languages.tar.gz.asc'
    
    printf "\e[1;32m\nVerifyiny phpmyadmin tar file\e[0m"
    gpg --verify phpmyadmin.tar.gz.asc
    
    printf "\e[1;32m\nCreating phpmyadmin directory on /var/www/html/\e[0m"
    sudo mkdir /var/www/html/phpmyadmin/
    
    printf "\e[1;32m\nExtracting and exporting phpmyadmin.tar.gz\e[0m"
    sudo tar xvf phpmyadmin.tar.gz --strip-components=1 -C /var/www/html/phpmyadmin
    
    printf "\e[1;32m\nCopying config.sample.inc.php as config.inc.php\e[0m"
    sudo cp /var/www/html/phpmyadmin/config.sample.inc.php /var/www/html/phpmyadmin/config.inc.php

    printf "\e[1;32m\nGenerating random password and copying to clipboard\e[0m"
    openssl rand -base64 32 | xclip -selection clipboard
    printf "\e[1;32mPassword is copied"
    printf "\e[1;32m\nSet the passphrase for cfg['blowfish_secret'] with the copied password \e[0m"
    pause
    sudo nano /var/www/html/phpmyadmin/config.inc.php
    
    printf "\e[1;32m\nGiving permission for group and root to read-write and resctricting all permission for others\e[0m"
    sudo chmod 660 /var/www/html/phpmyadmin/config.inc.php

    printf "\e[1;32m\nChanging symbolic links ownership \e[0m"
    sudo chown -R www-data:www-data /var/www/html/phpmyadmin
    
    printf "\e[1;32m\nRestarting the apache2 socket\e[0m"
    sudo systemctl restart apache2
}

install_Everything() {
    gitsetup

    install_Xclip
    install_NeoFetch
    install_Figlet
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
    install_NVIDIA_drivers
}
