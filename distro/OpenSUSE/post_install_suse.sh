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

install_NeoFetch() {
    banner "Installing Neofetch"

    printf "\e[1;32m\nInstalling NeoFetch\e[0m"
    sudo zypper install -y neofetch
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

    printf "\e[1;32m\nShow the Weekday in Clock\n\n\e[0m"
    gsettings set org.gnome.desktop.interface clock-show-weekday true

    printf "\e[1;32m\nAdding Minimize and Maximize buttons on the left\n\n\e[0m"
    gsettings set org.gnome.desktop.wm.preferences button-layout "close,maximize,minimize:"

    printf "\e[1;32m\nEnable Tray Icons\n\n\e[0m"
    gnome-extensions enable appindicatorsupport@rgcjonas.gmail.com
}

install_Git() {
    banner "Install Git"
    printf "\e[1;32m\nInstalling Git and Git Related packages...\n\e[0m"
    sudo zypper install -y git
}

install_Microsoft_Fonts() {
    banner "Install Microsoft Fonts"
    printf "\e[1;32m\nInstalling Microsoft Fonts...\n\e[0m"
    sudo zypper install -y fetchmsttfonts
}

install_Fira_Code_Font() {
    # https://github.com/tonsky/FiraCode/wiki/Linux-instructions

    fonts_dir="${HOME}/.local/share/fonts"
    if [ ! -d "${fonts_dir}" ]; then
        echo "mkdir -p $fonts_dir"
        mkdir -p "${fonts_dir}"
    else
        echo "Found fonts dir $fonts_dir"
    fi

    for type in Bold Light Medium Regular Retina SemiBold; do
        file_path="${HOME}/.local/share/fonts/FiraCode-${type}.ttf"
        file_url="https://github.com/tonsky/FiraCode/blob/master/distr/ttf/FiraCode-${type}.ttf?raw=true"
        if [ ! -e "${file_path}" ]; then
            echo "wget -O $file_path $file_url"
            wget -O "${file_path}" "${file_url}"
        else
            echo "Found existing file $file_path"
        fi
    done

    printf "\n\nBuilding the Font Cache...\n"
    echo "fc-cache -f"
    fc-cache -f
}

install_YoutubeDL() {
    banner "Installing Youtube-DL"
    sudo zypper install -y youtube-dl
}

install_GNOME_Shell_Extensions() {
    banner "Installing GNOME Shell extensions"
    sudo zypper install -y gnome-shell-extensions-common gnome-shell-extension-user-theme
}

install_VSCode() {
    banner "Installing Visual Studio Code"
    printf "\e[1;32m\nInstalling Microsoft Visual Studio Code...\e[0m"
    sudo rpm --import https://packages.microsoft.com/keys/microsoft.asc
    sudo zypper addrepo https://packages.microsoft.com/yumrepos/vscode vscode
    sudo zypper refresh
    sudo zypper install code
}

install_Sublime_Text() {
    banner "Installing Sublime Text"
    printf "\e[1;32m\nInstalling Sublime Text\e[0m"
    sudo rpm -v --import https://download.sublimetext.com/sublimehq-rpm-pub.gpg
    sudo zypper addrepo -g -f https://download.sublimetext.com/rpm/stable/x86_64/sublime-text.repo
    sudo zypper install sublime-text
}

install_OPI() {
    banner "Install: OBS Package Installer"
    sudo zypper install opi
}

install_Telegram() {
    banner "Installing Telegram"
    printf "\e[1;32m\n Install Telegram\e[0m"
    sudo zypper install -y telegram-desktop
}

install_snapd() {
    banner "Installing Snap"

    printf "\e[1;32m\n\nInstalling snapd and apparmor\e[0m"
    sudo zypper addrepo --refresh https://download.opensuse.org/repositories/system:/snappy/openSUSE_Leap_15.3 snappy
    sudo zypper dup --from snappy
    sudo zypper install snapd
    sudo systemctl enable --now snapd
}

# reduce_Swappiness() {
#     # sudo nano /etc/sysctl.conf
#     # Append this to the above file.
#     # vm.swappiness=10
# }

install_Brave_Browser() {
    banner "Install: Brave Browser"
    sudo zypper install -y curl
    sudo rpm --import https://brave-browser-rpm-release.s3.brave.com/brave-core.asc
    sudo zypper addrepo https://brave-browser-rpm-release.s3.brave.com/x86_64/ brave-browser
    sudo zypper install -y brave-browser
}

install_Discord() {
    banner "Install: Discord"
    sudo zypper install -y libatomic1 discord
}

zoom_app() {
    banner "Installing: Zoom Video Conferencing App"

    printf "\n - Going inside the Downloads folder..."
    cd ~/Downloads

    printf "\n - Downloading the Key for signing"
    wget -O package-signing-key.pub 'https://zoom.us/linux/download/pubkey'

    printf "\n - Signing the new key"
    sudo rpm --import package-signing-key.pub

    printf "\n - Downloading the Zoom application..."
    wget 'https://zoom.us/client/latest/zoom_openSUSE_x86_64.rpm'

    printf "\n - Starting the zoom installation..."
    sudo zypper install -y zoom_openSUSE_x86_64.rpm

    printf "\n - Coming out of the Downloads folder..."
    cd
}

install_qBittorrent() {
    banner "Installing: qBittorrent"
    sudo zypper install -y qbittorrent
}

install_TLP() {
    banner "Installing: TLP"
    sudo zypper install -y tlp tlp-rdw
}

obs_studio() {
    banner "Installing Snap Package: OBS Studio"
    sudo snap install obs-studio
}

installSpotify() {
    banner "Installing Snap Package: Spotify"
    sudo snap install spotify
}

aliases_and_scripts() {
    banner "Installing Aliases and Scripts"

    currentDirectory=$(pwd)
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
    cd ~/RKS_FILES/GitRep/Linux

    printf "\nCreating the file with aliases to the ~/ location.."
    printf "\n\nChecking if the alias file exists..."
    if [ -f ~/RKS_FILES/GitRep/Linux/distro/OpenSUSE/rksalias.txt ]; then
        printf "\nAlias file exists.."
        cp ~/RKS_FILES/GitRep/Linux/distro/OpenSUSE/rksalias.txt ~/.rksalias
    else
        printf "\nAlias file not found.."

        printf "\nMoving into /tmp directoroy.."
        cd /tmp

        printf "\nGetting the file from GitHub"
        wget https://raw.githubusercontent.com/KamalDGRT/Linux/master/distro/OpenSUSE/rksalias.txt

        printf "\nMoving the file to ~/"
        mv ~/tmp/rksalias.txt ~/.rksalias
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

    printf "\n\nComing back to the present working directory\n\n"
    cd "${currentDirectory}"
}

install_and_configure_LAMP() {
    banner "Installing and Configuring LAMPP"

    printf "\e[1;32m\n\nInstalling necessary LAMP stack packages\e[0m"
    sudo zypper install -y apache2 mariadb mariadb-client \
        php php-mysql php-gd php-mbstring apache2-mod_php7 \
        php-xml php-curl php-zip phpMyAdmin

    printf "\e[1;32m\nStarting apache2.socket and enabling to start on boot\e[0m"
    sudo systemctl enable --now apache2

    printf "\e[1;32m\nStarting snapd.socket and enabling to start on boot\e[0m"
    sudo systemctl enable --now mariadb

    printf "\e[1;32m\nAllowing the firewall to access pages...\e[0m"
    sudo firewall-cmd --permanent --add-port=80/tcp
    sudo firewall-cmd --permanent --add-port=443/tcp
    sudo firewall-cmd --reload

    printf "\e[1;32m\nEnabling basic security measures for the MariaDB database\e[0m"
    yes | sudo mysql_secure_installation

    printf "\e[1;32m\nAdding root user with Test@12345 as password\e[0m"
    sudo mysqladmin -u root password 'Test@12345'

    printf "\n\nEnable PHP module\n"
    sudo a2enmod php7

    printf "\n\nRestarting Apache service\n"
    sudo systemctl restart apache2

    printf "\n\nCreating index.html to test apache...\n"
    echo "<h1>Apache2 is running fine on openSUSE Leap</h1>" | sudo tee /srv/www/htdocs/index.html

    printf "\n\nCreating info.php to test PHP...\n"
    echo "<?php phpinfo(); ?>" | sudo tee /srv/www/htdocs/info.php
}

install_and_configure_LAMP
