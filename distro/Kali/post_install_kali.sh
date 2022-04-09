#!/bin/bash

clear

banner() {
    printf ""
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

gtext() {
    msg="$*"
    printf "\n\e[1;32m${msg}\e[0m\n"
}

enable_grub_menu() {
    # Find & Replace part contributed by: https://github.com/nanna7077
    clear
    banner "Showing the GRUB menu at boot"
    gtext "The script will change the grub default file."
    gtext "The file is: /etc/default/grub"
    gtext "In that file, there will be a line that looks like this:"
    gtext "     GRUB_TIMEOUT=5"
    gtext "The script will change the value of GRUB_TIMEOUT to -1."

    SUBJECT='/etc/default/grub'
    SEARCH_FOR='GRUB_TIMEOUT='
    sudo sed -i "/^$SEARCH_FOR/c\GRUB_TIMEOUT=-1" $SUBJECT
    gtext "/etc/default/grub file changed."

    banner "Showing the GRUB menu at boot"
    gtext "Generating the new GRUB configuration"
    sudo grub-mkconfig -o /boot/grub/grub.cfg

    gtext "GRUB config updated. It will be reflected in the next boot."
}

install_Xclip() {
    banner "Installing xclip"
    gtext "Updating the package cache..."
    sudo apt update

    gtext "Installing: xclip"
    sudo apt install -y xclip
}

install_Figlet() {
    banner "Installing Figlet"
    sudo apt install -y figlet
}

gitsetup() {
    banner "Setting up SSH for git and GitHub"

    read -e -p "Enter your GitHub Username                 : " GITHUB_USERNAME
    read -e -p "Enter the GitHub Email Address             : " GITHUB_EMAIL_ID
    read -e -p "Enter the default git editor (vim / nano)  : " GIT_CLI_EDITOR

    if [[ $GITHUB_EMAIL_ID != "" && $GITHUB_USERNAME != "" && $GIT_CLI_EDITOR != "" ]]; then
        gtext " - Configuring GitHub username as: ${GITHUB_USERNAME}"
        git config --global user.name "${GITHUB_USERNAME}"

        gtext " - Configuring GitHub email address as: ${GITHUB_EMAIL_ID}"
        git config --global user.email "${GITHUB_EMAIL_ID}"

        gtext " - Configuring Default git editor as: ${GIT_CLI_EDITOR}"
        git config --global core.editor "${GIT_CLI_EDITOR}"
        
        gtext " - Configuring Default git branch as main"
        git config --global init.defaultBranch main
        
        gtext "\n - Setting up the defaults for git pull"
        git config --global pull.rebase false

        printf "\n - The default branch name for new git repos will be: main"
        git config --global init.defaultBranch main

        gtext " - Generating a new SSH key for ${GITHUB_EMAIL_ID}"
        gtext "Just press Enter and add passphrase if you'd like to. "
        ssh-keygen -t ed25519 -C "${GITHUB_EMAIL_ID}"

        gtext "Adding your SSH key to the ssh-agent.."

        gtext " - Start the ssh-agent in the background.."
        eval "$(ssh-agent -s)"

        gtext " - Adding your SSH private key to the ssh-agent"
        ssh-add ~/.ssh/id_ed25519

        gtext " - Copying the SSH Key Content to the Clipboard..."

        gtext "Log in into your GitHub account in the browser (if you have not)"
        gtext "Open this link https://github.com/settings/keys in the browser."
        gtext "Clik on New SSH key."
        xclip -selection clipboard <~/.ssh/id_ed25519.pub
        gtext "Give a title for the SSH key."
        gtext "Paste the clipboard content in the textarea box below the title."
        gtext "Click on Add SSH key."
        pause
    else
        gtext "You have not provided the details correctly for Git Setup."
        if ask_user "Want to try Again ?"; then
            gitsetup
        else
            gtext "Skipping: Git and GitHub SSH setup.."
        fi
    fi
}

rks_gnome_themes() {
    banner "Changing the default GNOME theme"
    gtext "Changing the default GNOME theme"

    currentDirectory=$(pwd)

    gtext "Enabling User Themes Extension..."
    gnome-extensions enable user-theme@gnome-shell-extensions.gcampax.github.com

    gtext"Creating a directory to clone the KamalDGRT/rks-gnome-themes repo.."
    if [ -d ~/RKS_FILES/GitRep ]; then
        gtext "Directory exists.Skipping the creation step.."
    else
        mkdir -p ~/RKS_FILES/GitRep
    fi

    gtext "Going inside ~/RKS_FILES/GitRep"
    cd ~/RKS_FILES/GitRep

    gtext "Checking if the KamalDGRT/rks-gnome-themes repository exists..."
    if [ -d ~/RKS_FILES/GitRep/rks-gnome-themes ]; then
        gtext "Repository exists. Skipping the cloning step.."
    else
        gtext "Repository does not exist in the system.."
        gtext "Cloning the GitHub Repo: KamalDGRT/rks-gnome-themes"
        git clone https://github.com/KamalDGRT/rks-gnome-themes.git
    fi

    gtext "Going inside rks-gnome-themes directory..."
    cd rks-gnome-themes

    gtext "Checking if ~/.themes directory exists..."
    if [ -d ~/.themes ]; then
        gtext "\Directory exists. Skipping the creation step.."
    else
        gtext "Directry does not exist in the system.."
        gtext "Creating .themes at location ~/"
        mkdir ~/.themes
    fi

    gtext "Checking if ~/.icons directory exists..."
    if [ -d ~/.icons ]; then
        gtext "\Directory exists. Skipping the creation step.."
    else
        gtext "Directry does not exist in the system.."
        gtext "Creating .icons at location ~/"
        mkdir ~/.icons
    fi

    gtext "Copying the Flat-Remix-Blue-Dark Icon Theme"
    cp -rf Icon/Flat-Remix-Blue-Dark ~/.icons

    gtext "Copying the Mojave-dark-solid-alt Theme"
    cp -rf Theme/Mojave-dark-solid-alt ~/.themes

    gtext "Copying the Kimi-dark Theme"
    cp -rf Theme/Kimi-dark ~/.themes

    gtext "Changing Interface Theme to : Kimi-dark"
    gsettings set org.gnome.desktop.interface gtk-theme "Kimi-dark"

    gtext "Changing WM Theme to : Mojave-dark-solid-alt"
    gsettings set org.gnome.shell.extensions.user-theme name 'Mojave-dark-solid-alt'

    gtext "Changing Icon Theme to : Flat-Remix-Blue-Dark"
    gsettings set org.gnome.desktop.interface icon-theme "Flat-Remix-Blue-Dark"

    gtext "Coming back to th present working directory"
    cd "${currentDirectory}"
}

configure_title_bar() {
    banner "Configure Title Bar"
    gtext "Showing Battery Percentage"
    gsettings set org.gnome.desktop.interface show-battery-percentage true

    gtext "Show Time in 12 hour format"
    gsettings set org.gnome.desktop.interface clock-format 12h

    gtext "Show Date in the top bar"
    gsettings set org.gnome.desktop.interface clock-show-date true

    gtext "Show the seconds in Clock"
    gsettings set org.gnome.desktop.interface clock-show-seconds true

    gtext "Show the Weekday in Clock"
    gsettings set org.gnome.desktop.interface clock-show-weekday true

    gtext "Adding Minimize and Maximize buttons on the left"
    gsettings set org.gnome.desktop.wm.preferences button-layout "close,maximize,minimize:"

    gtext "Enable Tray Icons"
    gnome-extensions enable appindicatorsupport@rgcjonas.gmail.com
}

install_Brave() {
    banner "Installing Brave Browser"

    gtext "Installing Brave Browser"
    gtext "Installing requirements - apt-transport-https, curl"
    sudo apt install apt-transport-https curl -y

    gtext "Downloading Brave Browser keyring"
    sudo curl -fsSLo /usr/share/keyrings/brave-browser-archive-keyring.gpg https://brave-browser-apt-release.s3.brave.com/brave-browser-archive-keyring.gpg

    gtext "Adding source for Brave Browser in apt list"
    echo "deb [signed-by=/usr/share/keyrings/brave-browser-archive-keyring.gpg arch=amd64] https://brave-browser-apt-release.s3.brave.com/ stable main" | sudo tee /etc/apt/sources.list.d/brave-browser-release.list

    gtext "Fetching version to upgrade"
    sudo apt update

    gtext "Installing brave-browser package"
    sudo apt install brave-browser -y
}

install_Discord() {
    banner "Installing discord tar file"

    gtext "Downloading discord tar file"
    cd ~/Downloads
    wget -O discord.tar.gz 'https://discord.com/api/download?platform=linux&format=tar.gz'

    gtext "Extracting discord tar file"
    sudo tar -xvzf discord.tar.gz -C /opt

    gtext "Adding symbolic link on /usr/bin/Discord"
    sudo ln -sf /opt/Discord/Discord /usr/bin/Discord

    gtext "Copying discord.desktop to /usr/share/applications"
    sudo cp -r /opt/Discord/discord.desktop /usr/share/applications

    gtext "Installing libatomic1"
    sudo sudo apt install libatomic1 -y

    gtext "Adding executable file for discord.desktop"
    SUBJECT='/usr/share/applications/discord.desktop'
    SEARCH_FOR='Exec='
    sudo sed -i "/^$SEARCH_FOR/c\Exec=/usr/bin/Discord" $SUBJECT

    gtext "Adding icon for discord.desktop"
    SEARCH_FOR='Icon='
    sudo sed -i "/^$SEARCH_FOR/c\Icon=/opt/Discord/discord.png" $SUBJECT
}

install_Telegram() {
    banner "Installing Telegram"
    gtext " Install Telegram"
    sudo apt install telegram-desktop -y
}

install_snapd() {
    banner "Installing Snap"

    gtext "Installing snapd and apparmor"
    sudo apt install snapd apparmor -y

    gtext "Starting snapd.socket and enabling to start on boot"
    sudo systemctl enable --now snapd.socket

    gtext "Starting apparmor.socket and enabling to start on boot"
    sudo systemctl enable --now apparmor.service

    gtext "Enabling Classic Snap Support by creating the symbolic link"
    sudo ln -s /var/lib/snapd/snap /snap
}

install_NeoFetch() {
    banner "Installing Neofetch"

    gtext "Installing NeoFetch"
    sudo apt-get install neofetch -y
}

install_Audio_Tools() {
    banner "Installing Audio Tools"

    gtext "Installing Audio Tools"
    sudo apt install -y pulseaudio pavucontrol alsa-utils alsa-ucm-conf
}

install_NVIDIA_drivers() {
    banner "Installing NVIDIA drivers"

    gtext "Install NVDIA-Drivers"
    sudo apt install nvidia-driver nvidia-cuda-toolkit -y
}

install_gdebi() {
    banner "Installing gdebi"

    gtext "Install gdebi"
    sudo apt install gdebi -y
}

install_MS_Fonts() {
    banner "Installing MS Fonts"

    gtext "Installing Microsoft Core Fonts"
    sudo apt-get install ttf-mscorefonts-installer -y
}

install_Sublime_Text() {
    banner "Installing Sublime Text"

    gtext "Installing Sublime Text"
    wget -qO - https://download.sublimetext.com/sublimehq-pub.gpg | sudo apt-key add -
    sudo apt-get install apt-transport-https
    echo "deb https://download.sublimetext.com/ apt/stable/" | sudo tee /etc/apt/sources.list.d/sublime-text.list
    sudo apt-get update
    sudo apt-get install sublime-text -y
}

install_Kotlin() {
    banner "Installing Kotlin CLI"

    gtext "Installing kotlin compiler..."
    sudo snap install --classic kotlin
}

install_Django() {
    banner "Installing Django Admin"

    gtext "Installing django-admin..."
    sudo apt install python3 python3-django python3-pip -y
}

install_gh_CLI() {
    banner "Installing gh CLI"
    gtext "Adding gh repository in apt..."
    sudo apt-key adv --keyserver keyserver.ubuntu.com --recv-key C99B11DEB97541F0
    sudo apt-add-repository https://cli.github.com/packages

    gtext "Fetching the packages details..."
    sudo apt update

    gtext "Installing gh CLI using apt..."
    sudo apt install gh -y
}

install_Heroku_CLI() {
    banner "Installing Heroku CLI"
    gtext "Installing Heroku CLI using apt..."
    curl https://cli-assets.heroku.com/install-ubuntu.sh | sh
}

install_VSCode() {
    banner "Installing Visual Studio Code"
    gtext "Installing Microsoft Visual Studio Code..."
    wget -qO- https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor >packages.microsoft.gpg
    sudo install -o root -g root -m 644 packages.microsoft.gpg /etc/apt/trusted.gpg.d/
    sudo sh -c 'echo "deb [arch=amd64,arm64,armhf signed-by=/etc/apt/trusted.gpg.d/packages.microsoft.gpg] https://packages.microsoft.com/repos/code stable main" > /etc/apt/sources.list.d/vscode.list'
    rm -f packages.microsoft.gpg
    sudo apt install apt-transport-https -y
    sudo apt update
    sudo apt install code -y
}

install_PyCharm_Community_Edition() {
    banner "Installing PyCharm Community Edition"
    gtext "Installing IntelliJ PyCharm Community Edition"
    cd ~/Downloads
    wget -O pycharm.tar.gz https://download.jetbrains.com/python/pycharm-community-2021.1.3.tar.gz
    sudo tar xzf pycharm.tar.gz -C /opt/
    sudo mv /opt/pycharm-*/ /opt/pycharm/
    cd /opt/pycharm/bin
    sh pycharm.sh
}

install_Pip() {
    banner "Installing PIP and VENV"
    sudo apt install python3-pip python3-venv -y
}

install_YoutubeDL() {
    banner "Installing Youtube-DL"
    sudo apt install youtube-dl -y
}

install_and_configure_LAMP() {
    banner "Installing and Configuring LAMPP"
    cd ~/Downloads

    gtext "Installing necessary LAMP stack packages"
    sudo apt install -y apache2 mariadb-server mariadb-client php \
        libapache2-mod-php wget php php-cgi php-mysqli php-pear \
        php-mbstring libapache2-mod-php php-common php-xml \
        php-xmlrpc php-soap php-cli php-zip php-bcmath php-tokenizer \
        php-json php-curl php-gd php-phpseclib php-mysql composer xclip

    gtext "Starting apache2.socket and enabling to start on boot"
    sudo systemctl enable --now apache2gtext

    gtext "Starting snapd.socket and enabling to start on boot"
    sudo systemctl enable --now mariadb

    gtext "Enabling basic security measures for the MariaDB database"
    yes | sudo mysql_secure_installation

    gtext "Adding root user with Test@12345 as password"
    sudo mysqladmin -u root password 'Test@12345'

    gtext "Downloading PHP tar file"
    wget -O phpmyadmin.tar.gz 'https://www.phpmyadmin.net/downloads/phpMyAdmin-latest-all-languages.tar.gz'

    gtext "Downloading keyring for phpmyadmin"
    wget 'https://files.phpmyadmin.net/phpmyadmin.keyring'

    gtext "Importing phpmyadmin keyring"
    gpg --import phpmyadmin.keyring

    gtext "Downloading phpmyadmin tar file for integrity check"
    wget -O phpmyadmin.tar.gz.asc 'https://www.phpmyadmin.net/downloads/phpMyAdmin-latest-all-languages.tar.gz.asc'

    gtext "Verifying phpmyadmin tar file"
    gpg --verify phpmyadmin.tar.gz.asc

    gtext "Creating phpmyadmin directory on /var/www/html/"
    sudo mkdir /var/www/html/phpmyadmin/

    gtext "Extracting and exporting phpmyadmin.tar.gz"
    sudo tar xvf phpmyadmin.tar.gz --strip-components=1 -C /var/www/html/phpmyadmin

    gtext "Copying config.sample.inc.php as config.inc.php"
    sudo cp /var/www/html/phpmyadmin/config.sample.inc.php /var/www/html/phpmyadmin/config.inc.php

    gtext "Generating random password and copying to clipboard"
    openssl rand -base64 32 | xclip -selection clipboard
    gtext "Password is copied"
    gtext "Set the passphrase for cfg['blowfish_secret'] with the copied password "
    pause
    sudo nano /var/www/html/phpmyadmin/config.inc.php

    gtext "Giving permission for group and root to read-write and resctricting all permission for others"
    sudo chmod 660 /var/www/html/phpmyadmin/config.inc.php

    gtext "Changing symbolic links ownership "
    sudo chown -R www-data:www-data /var/www/html/phpmyadmin

    gtext "Restarting the apache2 socket"
    sudo systemctl restart apache2

    gtext "Enabling the RewriteEngine"
    sudo a2enmod rewrite

    gtext "Reloading the apache2 service"
    sudo systemctl reload apache2

    gtext "Adding Laravel Installer globally"
    composer global require laravel/installer

    gtext "Getting the updated php.ini"
    wget 'https://raw.githubusercontent.com/KamalDGRT/linux-conf/main/Kali/lampp/php.ini' -P ~/Downloads

    gtext "Creating backup of the current php.ini file..."
    sudo cp /etc/php/7.4/apache2/php.ini /etc/php/7.4/apache2/php.ini.backup

    gtext "Copying the updated php.ini"
    sudo cp ~/Downloads/php.ini /etc/php/7.4/apache2/php.ini

    gtext "Restarting the apache2 service"
    sudo systemctl restart apache2
}

install_qBittorrent() {
    banner "Installing qBittorrent"
    sudo apt install -y qbittorrent
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
    install_Kotlin
    install_Django
    install_gh_CLI
    install_Heroku_CLI
    install_VSCode
    install_and_configure_LAMP
    install_qBittorrent
    install_NVIDIA_drivers
}

gtext "hi there"
