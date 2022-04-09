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

pause() {
    read -s -n 1 -p "Press any key to continue . . ."
    clear
}

enable_grub_menu() {
    # Find & Replace part contributed by: https://github.com/nanna7077
    clear
    banner "Showing the GRUB menu at boot"
    printf "\n\nThe script will change the grub default file."
    printf "\n\nThe file is: /etc/default/grub\n"
    printf "\nIn that file, there will be a line that looks like this:"
    printf "\n\n     GRUB_TIMEOUT=5\n\n"
    printf "\nThe script will change the value of GRUB_TIMEOUT to -1.\n"

    SUBJECT='/etc/default/grub'
    SEARCH_FOR='GRUB_TIMEOUT='
    sudo sed -i "/^$SEARCH_FOR/c\GRUB_TIMEOUT=-1" $SUBJECT
    printf "\n/etc/default/grub file changed.\n"

    banner "Showing the GRUB menu at boot"
    printf "\n\nGenerating the new GRUB configuration\n\n"
    sudo grub-mkconfig -o /boot/grub/grub.cfg

    printf "\n\nGRUB config updated. It will be reflected in the next boot.\n\n"
}

enable_xorg_windowing() {
    # Find & Replace part contributed by: https://github.com/nanna7077
    clear
    banner "Enable Xorg, Disable Wayland"
    printf "\n\nThe script will change the gdm default file."
    printf "\n\nThe file is: /etc/gdm/custom.conf\n"
    printf "\nIn that file, there will be a line that looks like this:"
    printf "\n\n     #WaylandEnable=false\n\n"
    printf "\nThe script will uncomment that line\n"

    SUBJECT='/etc/gdm/custom.conf'
    SEARCH_FOR='#WaylandEnable=false'
    sudo sed -i "/^$SEARCH_FOR/c\WaylandEnable=false" $SUBJECT
    printf "\n/etc/gdm/custom.conf file changed.\n"

    printf "\n\nGDM config updated. It will be reflected in the next boot.\n\n"
}

nf_bash_xclip() {
    banner "Installing: neofetch bash-completion xclip"
    sudo pacman -S --needed --noconfirm neofetch bash-completion xclip
}

gitsetup() {
    banner "Setting up SSH for git and GitHub"

    read -e -p "Enter your GitHub Username                 : " GITHUB_USERNAME
    read -e -p "Enter the GitHub Email Address             : " GITHUB_EMAIL_ID
    read -e -p "Enter the default git editor (vim / nano)  : " GIT_CLI_EDITOR

    if [[ $GITHUB_EMAIL_ID != "" && $GITHUB_USERNAME != "" && $GIT_CLI_EDITOR != "" ]]; then
        printf "\n - Configuring GitHub username as: ${GITHUB_USERNAME}"
        git config --global user.name "${GITHUB_USERNAME}"

        printf "\n - Configuring GitHub email address as: ${GITHUB_EMAIL_ID}"
        git config --global user.email "${GITHUB_EMAIL_ID}"

        printf "\n - Configuring Default git editor as: ${GIT_CLI_EDITOR}"
        git config --global core.editor "${GIT_CLI_EDITOR}"

        printf "\n - Setting up the defaults for git pull"
        git config --global pull.rebase false

        printf "\n - The default branch name for new git repos will be: main"
        git config --global init.defaultBranch main

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
        printf "\nYou have not provided the details correctly for Git Setup."
        if ask_user "Want to try Again ?"; then
            gitsetup
        else
            printf "\nSkipping: Git and GitHub SSH setup..\n"
        fi
    fi
}

audio_tools() {
    banner "Installing: Pulse Audio & Alsa Tools"
    sudo pacman -S --needed --noconfirm pulseaudio pulseaudio-alsa \
        pavucontrol alsa-utils alsa-ucm-conf sof-firmware
}

lampp_stack() {
    banner "Installing: LAMP Stack Packages"
    sudo pacman -S --needed --noconfirm apache mariadb php php-apache \
        php-cgi php-fpm php-gd php-embed php-intl php-imap php-redis \
        php-snmp phpmyadmin
}

configure_lamp_stack() {
    banner "Configuring: LAMP Stack Packages"

    printf "\nCreating a directory to clone the KamalDGRT/linux-conf repo.."
    if [ -d ~/RKS_FILES/GitRep ]; then
        printf "\nDirectory exists.\nSkipping the creation step..\n"
    else
        mkdir -p ~/RKS_FILES/GitRep
    fi

    printf "\nGoing inside ~/RKS_FILES/GitRep"
    cd ~/RKS_FILES/GitRep

    if [ -d ~/RKS_FILES/GitRep/linux-conf ]; then
        printf "\nRepository exists. \nSkipping the cloning step..\n"
    else
        printf "\nCloning the GitHub Repo\n"
        git clone https://github.com/KamalDGRT/linux-conf.git
    fi

    printf "\nGoing inside linux-conf directory..."
    cd linux-conf

    printf "\n\nCreating backup of the current httpd.conf file..."
    sudo cp /etc/httpd/conf/httpd.conf /etc/httpd/conf/httpd.conf.backup

    printf "\nCreating backup of the current httpd-vhosts.conf file..."
    sudo cp /etc/httpd/conf/extra/httpd-vhosts.conf /etc/httpd/conf/extra/httpd-vhosts.conf.backup

    printf "\nCreating backup of the current php.ini file..."
    sudo cp /etc/php/php.ini /etc/php/php.ini.backup

    printf "\n\nCopying the file from repo: httpd.conf"
    sudo cp ~/RKS_FILES/GitRep/linux-conf/Manjaro/lampp/httpd.conf /etc/httpd/conf/httpd.conf

    printf "\nCopying the file from repo: httpd-vhosts.conf"
    sudo cp ~/RKS_FILES/GitRep/linux-conf/Manjaro/lampp/httpd-vhosts.conf /etc/httpd/conf/extra/httpd-vhosts.conf

    printf "\nCopying the file from repo: php.ini"
    sudo cp ~/RKS_FILES/GitRep/linux-conf/Manjaro/lampp/php.ini /etc/php/php.ini

    printf "\nCopying the file from repo: phpmyadmin.conf"
    sudo cp ~/RKS_FILES/GitRep/linux-conf/Manjaro/lampp/phpmyadmin.conf /etc/httpd/conf/extra/phpmyadmin.conf

    printf "\nCopying the file from repo: index.html"
    sudo cp ~/RKS_FILES/GitRep/linux-conf/Manjaro/lampp/index.html /srv/http/index.html

    printf "\nCopying the file from repo: test.php"
    sudo cp ~/RKS_FILES/GitRep/linux-conf/Manjaro/lampp/test.php /srv/http/test.php

    printf "\n\nInstalling MySQL databases\n"
    sudo mysql_install_db --user=mysql --basedir=/usr --datadir=/var/lib/mysql

    printf "\nEnabling MySQL service to start at boot..."
    sudo systemctl enable mysqld

    printf "\nStarting the MySQL service..."
    sudo systemctl start mysqld

    printf "\n\nSetting MySQL root user password as : Test@12345"
    printf "\nYou can change it later using:"
    printf "\n\n       sudo mysqladmin -u root password '<password>'"
    printf "\n\nReplace <password> with the password that you wanto have."

    yes | sudo mysql_secure_installation
    sudo mysqladmin -u root password 'Test@12345'

    printf "\n\n\nEnabling Apache to start at boot..."
    sudo systemctl enable httpd

    printf "\nRestarting the Apache service..."
    sudo systemctl restart httpd

    printf "\nCreating tmp directory for phpMyAdmin.."
    sudo mkdir -p /usr/share/webapps/phpMyAdmin/tmp/

    printf "\nChanging permissions of the /tmp directory..."
    sudo chmod 777 /usr/share/webapps/phpMyAdmin/tmp/

    printf "\nGenerating & Copying a string to clipboard for the blowfish_secret.."
    openssl rand -base64 32 | xclip -selection clipboard

    printf "\n\nNow, a file will be opened in the nano editor."
    printf "\nPaste the clipboard content in line 16 of that file."

    sudo nano /etc/webapps/phpmyadmin/config.inc.php

    printf "\n\nChecking if the LAMPP packages are installed correctly:"
    printf "\n    Apache    :  http://localhost"
    printf "\n     PHP      :  http://localhost/test.php"
    printf "\n  phpMyAdmin  :  http://localhost/phpmyadmin"
}

package_managers() {
    banner "Installing Package Managers: composer npm yay snapd"
    sudo pacman -S --needed --noconfirm composer nodejs npm yay snapd

    printf "\nEnabling the snap daemon..."
    sudo systemctl enable --now snapd.socket

    printf "\nEnabling classic snap support by creating the symlink..."
    sudo ln -s /var/lib/snapd/snap /snap
}

brave_tel_vlc_discord() {
    banner "Installing: Brave Browser, Telegram, VLC & Discord"
    sudo pacman -S --needed --noconfirm brave telegram-desktop vlc discord
}

obs_studio() {
    banner "Installing Snap Package: OBS Studio"
    sudo snap install obs-studio
}

installSpotify() {
    banner "Installing Snap Package: Spotify"
    sudo snap install spotify
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
    echo -e "\n[sublime-text]\nServer = https://download.sublimetext.com/arch/stable/x86_64" |
        sudo tee -a /etc/pacman.conf

    printf "\nUpdatig pacman and installing Sublime Text..."
    sudo pacman -Syu --needed --noconfirm sublime-text
}

zoom_app() {
    banner "Installing: Zoom Video Conferencing App"

    printf "\n - Going inside the Downloads folder..."
    cd Downloads

    printf "\n - Downloading the Zoom application..."
    wget https://zoom.us/client/latest/zoom_x86_64.pkg.tar.xz

    printf "\n - Starting the zoom installation..."
    sudo pacman -U --noconfirm --needed zoom_x86_64.pkg.tar.xz

    printf "\n - Coming out of the Downloads folder..."
    cd
}

mkvtoolnix_gui() {
    banner "Installing: MKVToolNix GUI"
    sudo pacman -S --needed --noconfirm mkvtoolnix-gui
}

s_qbittorrent() {
    banner "Installing: qBittorrent"
    sudo pacman -S --needed --noconfirm qbittorrent
}

fira_code_vim() {
    banner "Installing: Fira Code Font and Vim Editor"
    sudo pacman -S --needed --noconfirm ttf-fira-code vim
}

aliases_and_scripts() {
    banner "Installing Aliases and Scripts"

    aliasfile="\n"
    aliasfile+="if [ -f ~/.rksalias ]; then\n"
    aliasfile+=". ~/.rksalias\n"
    aliasfile+="fi\n"

    printf "\nCreating a directory to clone the KamalDGRT/Linux repo.."
    if [ -d ~/RKS_FILES/GitRep ]; then
        printf "\nDirectory exists.\nSkipping the creation step..\n"
    else
        mkdir -p ~/RKS_FILES/GitRep
    fi

    printf "\nGoing inside ~/RKS_FILES/GitRep"
    cd ~/RKS_FILES/GitRep

    if [ -d ~/RKS_FILES/GitRep/Linux ]; then
        printf "\nRepository exists. \nSkipping the cloning step..\n"
    else
        printf "\nCloning the GitHub Repo\n"
        git clone https://github.com/KamalDGRT/Linux.git
    fi

    printf "\nGoing inside Linux directory..."
    cd Linux

    printf "\nCreating the file with aliases to the ~/ location.."
    printf "\n\nChecking if the alias file exists..."
    if [ -f ~/RKS_FILES/GitRep/Linux/distro/Manjaro/rksalias.txt ]; then
        printf "\nAlias file exists.."
        cp distro/Manjaro/rksalias.txt ~/.rksalias
    else
        printf "\nAlias file not found.."

        printf "\nMoving into /tmp directoroy.."
        cd /tmp

        printf "\nGetting the file from GitHub"
        wget https://raw.githubusercontent.com/KamalDGRT/Linux/master/distro/Manjaro/rksalias.txt

        printf "\nMoving the file to ~/"
        mv rksalias.txt ~/.rksalias
    fi

    printf "\n\nAdding the aliases to the fish conf.."
    if [ -f ~/.config/fish/config.​fish ]; then
        ~/.config/fish/config.​fish >>printf "${aliasfile}"
        printf "\nAliases added successfully to fish shell."
    else
        printf "\nYour OS does not have fish shell.\nSkipping..."
    fi

    printf "\n\nAdding the aliases to the BASH shell.."
    if [ -f ~/.bashrc ]; then
        printf "${aliasfile}" >>~/.bashrc
        printf "\nAliases added successfully to BASH"
    else
        printf "\nYour OS does not have BASH shell.\nSkipping..."
    fi

    printf "\n\nAdding the aliases to the ZSH shell.."
    if [ -f ~/.zshrc ]; then
        printf "${aliasfile}" >>~/.zshrc
        printf "\nAliases added successfully to ZSH"
    else
        printf "\nYour OS does not have ZSH shell.\nSkipping..."
    fi

    printf "\n\nTo make the aliases work, close and reopen the "
    printf "terminals that are using those shells.\n"
}

rks_gnome_themes() {
    banner "Changing the default GNOME theme"

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
    banner "Configure Title Bar"
    printf "\e[1;32m\n\nShowing Battery Percentage\e[0m"
    gsettings set org.gnome.desktop.interface show-battery-percentage true

    printf "\e[1;32m\nShow Time in 12 hour format\e[0m"
    gsettings set org.gnome.desktop.interface clock-format 12h

    printf "Show Date in the top bar"
    gsettings set org.gnome.desktop.interface clock-show-date true

    printf "\e[1;32m\nShow the seconds in Clock\e[0m"
    gsettings set org.gnome.desktop.interface clock-show-seconds true

    printf "\e[1;32m\nShow the Weekday in Clock\n\n\e[0m"
    gsettings set org.gnome.desktop.interface clock-show-weekday true

    printf "\e[1;32m\nAdding Minimize and Maximize buttons on the left\n\n\e[0m"
    gsettings set org.gnome.desktop.wm.preferences button-layout "close,maximize,minimize:"

    printf "\e[1;32m\nEnable Tray Icons\n\n\e[0m"
    gnome-extensions enable appindicatorsupport@rgcjonas.gmail.com
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
    printf "\nInstall: Fira Code Font and Vim Editor\n\n"
}

install_all() {
    sudo pacman -S --needed --noconfirm neofetch bash-completion pulseaudio \
        pulseaudio-alsa pavucontrol alsa-utils alsa-ucm-conf sof-firmware \
        php php-apache php-cgi php-fpm php-gd php-embed php-intl php-imap \
        php-redis php-snmp phpmyadmin brave telegram-desktop vlc discord \
        mkvtoolnix-gui qbittorrent ttf-fira-code vim fakeroot base-devel \
        gtk-engine-murrine gtk-engines apache mariadb

    enable_grub_menu
    enable_xorg_windowing
    gitsetup
    aliases_and_scripts
    sublime_text
    package_managers
    configure_lamp_stack
    rks_gnome_themes
    zoom_app
    obs_studio
    installSpotify
    vscode
}

menu_logo() {
    printf "\n\n
    ░█▀▀█ █▀▀█ █▀▀ ▀▀█▀▀ 　 ▀█▀ █▀▀▄ █▀▀ ▀▀█▀▀ █▀▀█ █── █──
    ░█▄▄█ █──█ ▀▀█ ──█── 　 ░█─ █──█ ▀▀█ ──█── █▄▄█ █── █──
    ░█─── ▀▀▀▀ ▀▀▀ ──▀── 　 ▄█▄ ▀──▀ ▀▀▀ ──▀── ▀──▀ ▀▀▀ ▀▀▀
    \n\n"
}

ask_user() {
    msg="$*"
    edge="#~~~~~~~~~~~~#"
    printf "\n${msg}\n"

    printf "    ${edge}\n"
    printf "    | 1.) Yes    |\n"
    printf "    | 2.) No     |\n"
    printf "    | 3.) Quit   |\n"
    printf "    ${edge}\n"

    read -e -p "Please select 1, 2, or 3 :   " choice

    if [ "$choice" == "1" ]; then
        printf "\n\n"
        return 0

    elif [ "$choice" == "2" ]; then
        printf "\n\n\n"
        return 1

    elif [ "$choice" == "3" ]; then
        clear && exit 0

    else
        echo "Please select 1, 2, or 3." && sleep 3
        clear && ask_user ""
    fi
}

prompt_each_install() {

    if ask_user "Enable GRUB menu ?"; then
        enable_grub_menu
    else
        printf "\nSkipping: Enable GRUB menu..\n"
    fi

    if ask_user "Install: neofetch bash-completion xorg-xclip ?"; then
        nf_bash_xclip
    else
        printf "\nSkipping: neofetch bash-completion xorg-clip..\n"
    fi

    if ask_user "\nInstall: Fira Code Font and Vim Editor"; then
        fira_code_vim
    else
        printf "\nSkipping: Vim & Fira Code Font Installation..\n"
    fi

    if ask_user "Add Aliases and Scripts?"; then
        aliases_and_scripts
    else
        printf "\nSkipping: Aliases and Scripts..\n"
    fi

    if ask_user "Set up SSH for git and GitHub ?"; then
        gitsetup
    else
        printf "\nSkipping: Git and GitHub SSH setup..\n"
    fi

    if ask_user "Install: Pulse Audio & Alsa Tools ?"; then
        audio_tools
    else
        printf "\nSkipping: Audio Tools installation..\n"
    fi

    if ask_user "Do you want to change the GNOME themes?"; then
        rks_gnome_themes
    else
        printf "\nSkipping: Configuring GNOME thmes...\n"
    fi

    if ask_user "Install: LAMP Stack Packages ?"; then
        lampp_stack
        configure_lamp_stack
    else
        printf "\nSkipping: LAMP Stack Installtion..\n"
    fi

    if ask_user "Install: Package Managers: composer npm yay snapd"; then
        package_managers
    else
        printf "\nSkipping: Package Managers: composer npm yay snapd.\n"
    fi

    if ask_user "Install: Brave Browser, Telegram, VLC & Discord"; then
        brave_tel_vlc_discord
    else
        printf "\nSkipping: Brave Browser, Telegram, VLC & Discord..\n"
    fi

    if ask_user "Install: Sublime Text"; then
        sublime_text
    else
        printf "\nSkipping: Sublime Text Installation..\n"
    fi

    if ask_user "Install: Zoom Video Conferencing App"; then
        zoom_app
    else
        printf "\nSkipping: Zoom App Installation..\n"
    fi

    if ask_user "Install: MKVToolNix GUI"; then
        mkvtoolnix_gui
    else
        printf "\nSkipping: MKVToolNix GUI Installation..\n"
    fi

    if ask_user "Install: qBittorrent"; then
        s_qbittorrent
    else
        printf "\nSkipping: qBittorrent Installation..\n"
    fi

    if ask_user "Install: Snap Package: OBS Studio"; then
        obs_studio
    else
        printf "\nSkipping: Snap Package OBS Studio..\n"
    fi

    if ask_user "Install: Snap Package: Spotify"; then
        installSpotify
    else
        printf "\nSkipping: Snap Package: Spotify.\n"
    fi

    if ask_user "Install: Snap Package: Microsoft Visual Studio Code"; then
        vscode
    else
        printf "\nSkipping: VS Code Installation..\n"
    fi
}

main_menu_content() {
    clear
    menu_logo

    printf "\n This script will install and configure some stuff for you."
    printf "\n How you want it to install, it is upto you."
    printf "\n\n 1. You can install everything it provides."
    printf "\n    This is best suited for fresh OS installs."
    printf "\n\n 2. Install selectively."
    printf "\n    Here, the script will prompt you for each install.\n\n"
}

main_menu() {
    main_menu_content
    if ask_user "So, do you want to install everything?"; then
        install_all_menu
        install_all
    elif ask_user "So I guess you want to be prompted for each install?"; then
        printf "\nBeginning Install With Prompt\n"
        prompt_each_install
    fi
}

main_menu
