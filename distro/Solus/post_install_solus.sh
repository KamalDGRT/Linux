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

pause() {
    read -s -n 1 -p "Press any key to continue . . ."
    clear
}

install_Neofetch() {
    banner "Installing Neofetch"
    sudo eopkg install neofetch -y
    after_install "neofetch"
}

install_Git() {
    banner "Installing Git"
    sudo eopkg install neofetch -y
    after_install "Git - Version Control System"
}

install_Telegram() {
    banner "Installing Telegram"
    sudo eopkg install telegram -y
    after_install "Telegram Desktop"
}

install_MKVToolNix() {
    banner "Installing MKVToolNixGUI"
    sudo eopkg install mkvtoolnix -y
    after_install "MKVToolNixGUI"
}

add_Flatpak_remote() {
    banner "Adding Flatpak remote: flathub"
    sudo flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
}

install_Flatpak_Spotify() {
    banner "Installing Spotify [Flatpak]"
    flatpak install flathub com.spotify.Client -y
}

change_BASH_Prompt() {
    banner "Changing the BASH prompt"

    show_info
    wget -O ~/Downloads/solus_bashrc 'https://raw.githubusercontent.com/KamalDGRT/linux-conf/main/Solus/bashrc'
    wget -O ~/Downloads/rksalias.txt 'https://raw.githubusercontent.com/KamalDGRT/Linux/master/distro/Solus/rksalias.txt'
    mv ~/.bashrc ~/Documents
    mv ~/Downloads/solus_bashrc ~/.bashrc
    mv ~/Downloads/rksalias.txt ~/.rksalias
    after_install "Re-open the shell to see the changes."
}

install_Zoom_Client() {
    banner "Installing Zoom Client"

    show_question "\nDownloading the Latest version of Zoom\n"
    wget -O ~/Downloads/zoom.tar.xz 'https://zoom.us/client/latest/zoom_x86_64.tar.xz'

    show_question "\nCreating a directory to install zoom.."
    if [ -d ~/.LEO ]; then
        show_warning "\nDirectory exists.\nSkipping the creation step..\n"
    else
        mkdir -p ~/.LEO
    fi

    show_info "\nExtracting the downloaded file...\n"
    tar -xf ~/Downloads/zoom.tar.xz -C ~/.LEO

    show_question "\nCreating a directory to download Zoom Icon"
    if [ -d ~/.LEO/zoom/icon ]; then
        show_warning "\nDirectory exists.\nSkipping the creation step..\n"
    else
        mkdir -p ~/.LEO/zoom/icon
    fi

    show_info "\nDownloading the Zoom Client Icon\n"
    wget -O ~/.LEO/zoom/icon/zoom.png 'https://i.imgur.com/0zk7xXE.png'

    currentUser=$(whoami)

    show_info "Creating Symbolic Link for Zoom Client"
    sudo ln -s /home/${currentUser}/.LEO/zoom/ZoomLauncher /usr/bin/zoom

    show_info "\nCreating a Desktop Entry for Zoom Client.\n"
    {
        echo "[Desktop Entry]"
        echo "Name=Zoom"
        echo "Comment=Zoom Client for Solus"
        echo "Exec=/usr/bin/zoom %U"
        echo "Icon=/home/${currentUser}/.LEO/zoom/icon/zoom.png"
        echo "Terminal=false"
        echo "Type=Application"
        echo "Encoding=UTF-8"
        echo "Categories=Network;Application;"
        echo "StartupWMClass=zoom"
        echo "MimeType=x-scheme-handler/zoommtg;x-scheme-handler/zoomus;x-scheme-handler/tel;x-scheme-handler/callto;x-scheme-handler/zoomphonecall;application/x-zoom"
        echo "X-KDE-Protocols=zoommtg;zoomus;tel;callto;zoomphonecall;"
        echo "Name[en_US]=Zoom"
    } | sudo tee /usr/share/applications/zoom-client.desktop

    show_warning "Updating the desktop file MIME type cahce ..."
    xdg-mime default zoom-client.desktop x-scheme-handler/zoommtg

    show_info "Cleaning out the remnant files.."
    rm ~/Downloads/zoom.tar.xz

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

install_Sublime_Text() {
    banner "Installing Sublime Text"
    show_question "\nDownloading Sublime Text Build 4113\n"
    wget -O ~/Downloads/sublime.tar.xz 'https://download.sublimetext.com/sublime_text_build_4113_x64.tar.xz'

    show_question "\nCreating a directory to install Sublime Text.."
    if [ -d ~/.LEO ]; then
        show_warning "\nDirectory exists.\nSkipping the creation step..\n"
    else
        mkdir -p ~/.LEO
    fi

    show_info "\nExtracting the downloaded file...\n"
    tar -xf ~/Downloads/sublime.tar.xz -C ~/.LEO

    currentUser=$(whoami)

    show_info "\nCreating a Desktop Entry for Sublime Text.\n"
    {
        echo "[Desktop Entry]"
        echo "Version=1.0"
        echo "Type=Application"
        echo "Name=Sublime Text"
        echo "GenericName=Text Editor"
        echo "Comment=Sophisticated text editor for code, markup and prose"
        echo "Exec=/home/${currentUser}/.LEO/sublime_text/sublime_text %F"
        echo "Terminal=false"
        echo "MimeType=text/plain;"
        echo "Icon=/home/${currentUser}/.LEO/sublime_text/Icon/256x256/sublime-text.png"
        echo "Categories=TextEditor;Development;"
        echo "StartupNotify=true"
        echo "Actions=new-window;new-file;"

        echo "[Desktop Action new-window]"
        echo "Name=New Window"
        echo "Exec=/home/${currentUser}/.LEO/sublime_text/sublime_text --launch-or-new-window"
        echo "OnlyShowIn=Unity;"

        echo "[Desktop Action new-file]"
        echo "Name=New File"
        echo "Exec=/home/${currentUser}/.LEO/sublime_text/sublime_text --command new_file"
        echo "OnlyShowIn=Unity;"
    } | sudo tee /usr/share/applications/sublime-text.desktop

    show_info "Creating Sybmbolic Link for Sublime Text\n\n"
    sudo ln -s ~/.LEO/sublime_text/sublime_text /usr/bin/subl

    show_info "Cleaning out the remnant files.."
    rm ~/Downloads/sublime.tar.xz

    after_install "Sublime Text"
}

install_Unoconv() {
    banner "Installing unoconv"

    show_info "This scripts needs libreoffice"

    show_question "Creating a directory to clone the reop\n\n"
    mkdir -p ~/.LEO/unoconv

    show_warning "Cloning the Github repo: dagwieers/unoconv\n\n"
    git clone https://github.com/dagwieers/unoconv.git ~/.LEO/unoconv

    show_info "Creating symbolic link for unoconv\n"
    sudo ln -s ~/.LEO/unoconv/unoconv /usr/bin/unoconv

    after_install "unoconv"
}

upgrade_the_System() {
    banner "Upgrading the system..."
    show_info "Get the latest the Solus repository info..."
    sudo eopkg update-repo

    show_info "Updating the system..."
    sudo eopkg upgrade -y
}

install_Apache_Server_Stuff() {
    banner "Installing and configuring Apache Server Stuff"

    show_header "Installing package: httpd"
    sudo eopkg install httpd -y

    show_question "Creating a directory for the configs from the user side..."
    sudo mkdir -p /etc/httpd/conf.d/

    show_info "Starting httpd service and enabling to start on boot"
    sudo systemctl enable --now httpd

    show_info "Creating test page for the localhost..."
    {
        echo "Welcome to the httpd Default Server page! <br>"

        echo "If you are seeing this page, then it means the <br>"
        echo "httpd module is successfully loaded and the <br>"
        echo "apache server is working :)) <br>"
    } | sudo tee /var/www/index.html

    show_warning "\nRestarting httpd service..\n"
    sudo systemctl restart httpd
}

install_MySQL_Stuff() {
    banner "Installing MySQL stuff..."

    show_header "\nInstall package: mariadb-server\n"
    sudo eopkg install mariadb-server -y

    show_info "Starting the mariadb service..."
    sudo systemctl start mariadb

    show_info "Enabling the mariadb service..."
    sudo systemctl enable mariadb

    show_info "Enabling basic security measures for the MariaDB database"
    yes | sudo mysql_secure_installation

    show_info "Adding root user with Test@12345 as password"
    sudo mysqladmin -u root password 'Test@12345'
}

install_PHP_Stuff() {
    banner "Installing PHP Stuff..."

    show_header "\n\nInstalling Package: php"
    sudo eopkg install php -y

    show_info "Starting the php-fpm service..."
    sudo systemctl start php-fpm

    show_warning "\nCreating the php configuration with this: \n\n"

    {
        echo 'LoadModule proxy_module lib64/httpd/mod_proxy.so'
        echo 'LoadModule proxy_fcgi_module lib64/httpd/mod_proxy_fcgi.so'
        echo '<FilesMatch \.php$>'
        echo 'SetHandler "proxy:fcgi://127.0.0.1:9000"'
        echo '</FilesMatch>'
        echo '<IfModule dir_module>'
        echo 'DirectoryIndex index.php index.html'
        echo '</IfModule>'
    } | sudo tee /etc/httpd/conf.d/php.conf

    show_info "Enabling the php-fpm service..."
    sudo systemctl enable php-fpm

    show_info "\Creating test.php file ..\n"
    {
        echo "Welcome to the PHP Testing page! <br>"
        echo "If you are seeing this page, then it means the <br>"
        echo "PHP stuff is successfully configured."
    } | sudo tee /var/www/test.php

    show_warning "\nRestarting httpd service..\n"
    sudo systemctl restart httpd

    show_warning "\nRestarting php-fm service..\n"
    sudo systemctl restart php-fpm
}

configure_phpMyAdmin() {
    banner "Configuring phpMyAdmin"

    show_question "Going inside ~/Downloads"
    cd ~/Downloads

    show_info "Downloading PHP tar file"
    wget -O phpmyadmin.tar.gz 'https://www.phpmyadmin.net/downloads/phpMyAdmin-latest-all-languages.tar.gz'

    show_info "Downloading keyring for phpmyadmin"
    wget 'https://files.phpmyadmin.net/phpmyadmin.keyring'

    show_info "Importing phpmyadmin keyring"
    gpg --import phpmyadmin.keyring

    show_info "Downloading phpmyadmin tar file for integrity check"
    wget -O phpmyadmin.tar.gz.asc 'https://www.phpmyadmin.net/downloads/phpMyAdmin-latest-all-languages.tar.gz.asc'

    show_info "Verifying phpmyadmin tar file"
    gpg --verify phpmyadmin.tar.gz.asc

    show_info "Creating phpmyadmin directory on /var/www/"
    sudo mkdir /var/www/phpmyadmin/

    show_info "Extracting and exporting phpmyadmin.tar.gz"
    sudo tar xf phpmyadmin.tar.gz --strip-components=1 -C /var/www/phpmyadmin

    show_info "Copying config.sample.inc.php as config.inc.php"
    sudo cp /var/www/phpmyadmin/config.sample.inc.php /var/www/phpmyadmin/config.inc.php

    show_info "Generating random password and copying to clipboard"
    openssl rand -base64 32 | xclip -selection clipboard
    show_info "Password is copied"
    show_info "Set the passphrase for cfg['blowfish_secret'] with the copied password "
    pause
    sudo nano /var/www/phpmyadmin/config.inc.php

    show_info "Changing permission for the config.inc.php [644]"
    sudo chmod 644 /var/www/phpmyadmin/config.inc.php

    show_info "Changing permission for /var/html/phpmyadmin [755]"
    sudo chmod 755 -R /var/www/phpmyadmin/

    show_info "Creating a tmp directory for phpmyadmin"
    sudo mkdir -p /var/www/phpmyadmin/tmp/

    show_info "Make the tmp folder accessible"
    sudo chmod 777 -R /var/www/phpmyadmin/tmp/

    show_info "Restarting the httpd service"
    sudo systemctl restart httpd

    show_info "Cleaning out the remnant files.."
    rm ~/Downloads/phpmyadmin.*

    show_question "Coming back to the present working directory"
    cd "${currentDirectory}"
}

install_Composer() {
    banner "Installing Composer"

    show_header "\n\nInstalling Package: composer"
    sudo eopkg install composer -y

    show_info "Updating composer to version 2"
    sudo composer self-update --2

    show_info "Adding Laravel Installer globally"
    composer global require laravel/installer
}

enable_Rewrite_Module() {

    banner "Enabling Rewrite Module for the httpd"
    {
        echo -e "LoadModule rewrite_module lib64/httpd/mod_rewrite.so"
    } | sudo tee /etc/httpd/conf.d/rewrite.conf

    show_info "Restarting the httpd service"
    sudo systemctl restart httpd
}

write_vhost_content() {
    printf "\nDocument Root:$1\nServer Name:$2\n\n"

    content="<VirtualHost *:80>
ServerName $2
DocumentRoot \"$1\"

    <Directory \"$1\">
        # use mod_rewrite for pretty URL support
        RewriteEngine on
        # If a directory or a file exists, use the request directly
        RewriteCond %{REQUEST_FILENAME} !-f
        RewriteCond %{REQUEST_FILENAME} !-d
        # Otherwise forward the request to index.php
        RewriteRule . index.php
        # use index.php as index file
        DirectoryIndex index.php
        # ...other settings...
        # Apache 2.4
        Require all granted

        ## Apache 2.2
        # Order allow,deny
        # Allow from all
    </Directory>

</VirtualHost>


"

    echo "$content" | sudo tee -a /etc/httpd/conf.d/httpd-vhosts.conf
    echo -e "\n# 127.0.0.1    $2\n" | sudo tee -a /etc/hosts
}

setup_Virtual_Hosts() {
    write_vhost_content "/var/www" "localhost"
}

install_and_configure_LAMP_Stack() {
    # Reference: https://www.linuxhelp.com/how-to-install-lamp-on-solus-3-os
    banner "Installing and Configuring LAMP Stack"

    upgrade_the_System
    install_Apache_Server_Stuff
    install_MySQL_Stuff
    install_PHP_Stuff
    configure_phpMyAdmin
    install_Composer
    enable_Rewrite_Module
    setup_Virtual_Hosts
}

install_Brave_Browser() {
    banner "Installing Brave Browser"
    sudo eopkg install brave -y
    after_install "brave"
}

install_Discord() {
    banner "Installing Discord Client"
    sudo eopkg install discord -y
    after_install "discord"
}

install_VLC() {
    banner "Installing VLC Media Player"
    sudo eopkg install vlc -y
    after_install "vlc"
}

install_Vim() {
    banner "Installing Vim"
    sudo eopkg install vim -y
    after_install "vim"
}

install_VSCode() {
    banner "Installing VS Code"
    sudo eopkg install vscode -y
    after_install "vscode"
}

install_Opera_Browser() {
    banner "Installing Opera Browser"
    sudo eopkg install opera-stable -y
    after_install "opera-stable"
}

install_Anydesk() {
    banner "Installing Anydesk"

    show_info "Downloading the Anydesk Setup File"
    sudo eopkg bi --ignore-safety https://raw.githubusercontent.com/getsolus/3rd-party/03c0a9ac6de646922ab47ee0e52c303076aefce1/network/util/anydesk/pspec.xml -y

    show_info "Installing the setup file..."
    sudo eopkg it anydesk-6.1.1-28-1-x86_64.eopkg

    show_info "Cleaning the remnant files..."
    sudo rm anydesk-6.1.1-28-1-x86_64.eopkg

    after_install "anydesk"
}

install_Microsoft_Core_Fonts() {
    banner "Installing Microsoft Core Fonts"

    show_info "Downloading the Setup File..."
    sudo eopkg bi --ignore-safety https://raw.githubusercontent.com/getsolus/3rd-party/master/desktop/font/mscorefonts/pspec.xml -y

    show_info "Installing the setup file..."
    sudo eopkg it mscorefonts-1.3-3-1-x86_64.eopkg

    show_info "Cleaning the remnant files..."
    sudo rm mscorefonts-1.3-3-1-x86_64.eopkg

    after_install "mscorefonts"
}

install_VSCode_manually() {
    banner "Installing VS Code manually"

    show_question "\nDownloading the Latest version of VS Code\n"
    wget -O ~/Downloads/vscode.tar.gz 'https://code.visualstudio.com/sha/download?build=stable&os=linux-x64'

    show_info "Downloading keyring for VS Code"
    wget -O ~/Downloads/microsoft.asc 'https://packages.microsoft.com/keys/microsoft.asc'

    show_info "Importing VS Code keyring"
    gpg --import ~/Downloads/microsoft.asc

    show_question "\nCreating a directory to install VS Code.."
    if [ -d ~/.LEO ]; then
        show_warning "\nDirectory exists.\nSkipping the creation step..\n"
    else
        mkdir -p ~/.LEO
    fi

    show_info "\nExtracting the downloaded file...\n"
    tar xf ~/Downloads/vscode.tar.gz -C ~/.LEO

    show_header "\nRenaming the Directory [VSCode-linux-x64 -> vscode]...\n"
    mv ~/.LEO/VSCode-linux-x64/ ~/.LEO/vscode

    currentUser=$(whoami)

    show_info "\nCreating a Desktop Entry for VS Code\n"
    {
        echo "[Desktop Entry]"
        echo "Name=Visual Studio Code"
        echo "Comment=Code Editing. Redefined."
        echo "GenericName=Text Editor"
        echo "Exec=/home/${currentUser}/.LEO/vscode/code --unity-launch %F"
        echo "Icon=com.visualstudio.code"
        echo "Type=Application"
        echo "StartupNotify=false"
        echo "StartupWMClass=Code"
        echo "Categories=Utility;TextEditor;Development;IDE;"
        echo "MimeType=text/plain;inode/directory;application/x-code-workspace;"
        echo "Actions=new-empty-window;"
        echo "Keywords=vscode;"
        echo ""
        echo "[Desktop Action new-empty-window]"
        echo "Name=New Empty Window"
        echo "Exec=/home/${currentUser}/.LEO/vscode/code --new-window %F"
        echo "Icon=com.visualstudio.code"
    } | sudo tee /usr/share/applications/vscode.desktop

    show_info "Creating Sybmbolic Link for VS Code\n\n"
    sudo ln -s ~/.LEO/vscode/bin/code /usr/bin/code

    show_info "Removing the remnant files..."
    rm ~/Downloads/microsoft.asc
    rm ~/Downloads/vscode.tar.gz

    after_install "VS Code Manual"
}

configure_VS_Code() {

    # Editor & Theme related
    code --install-extension 2gua.rainbow-brackets
    code --install-extension oderwat.indent-rainbow
    code --install-extension BeardedBear.beardedicons
    code --install-extension dracula-theme.theme-dracula
    code --install-extension ElAnandKumar.el-vsc-product-icon-theme

    # Highliters
    code --install-extension mechatroner.rainbow-csv
    code --install-extension mikestead.dotenv
    code --install-extension vincaslt.highlight-matching-tag

    # Formatters
    code --install-extension esbenp.prettier-vscode
    code --install-extension foxundermoon.shell-format
    code --install-extension formulahendry.auto-rename-tag
    code --install-extension silvenon.mdx

    # Viewers
    code --install-extension qwtel.sqlite-viewer
    code --install-extension tomoki1207.pdf

    # JS related
    code --install-extension ambar.bundle-size
    code --install-extension dsznajder.es7-react-js-snippets
    code --install-extension eg2.vscode-npm-script
    code --install-extension herrmannplatz.npm-dependency-links
    code --install-extension WallabyJs.quokka-vscode

    # Svelte related
    code --install-extension svelte.svelte-vscode
    code --install-extension ardenivanov.svelte-intellisense
    code --install-extension fivethree.vscode-svelte-snippets

    # PHP related
    code --install-extension bmewburn.vscode-intelephense-client

    # Python related
    code --install-extension ms-python.python
    code --install-extension ms-python.vscode-pylance
    code --install-extension ms-toolsai.jupyter

    # CPP related
    code --install-extension ms-vscode.cpptools
}

update_VS_Code() {
    banner "Updating VS Code :D"

    show_info "Removing the existing VS Code Installation"
    rm -rf ~/.LEO/vscode

    show_question "\nDownloading the Latest version of VS Code\n"
    wget -O ~/Downloads/vscode.tar.gz 'https://code.visualstudio.com/sha/download?build=stable&os=linux-x64'

    show_question "\nCreating a directory to install VS Code.."
    if [ -d ~/.LEO ]; then
        show_warning "\nDirectory exists.\nSkipping the creation step..\n"
    else
        mkdir -p ~/.LEO
    fi

    show_info "\nExtracting the downloaded file...\n"
    tar xf ~/Downloads/vscode.tar.gz -C ~/.LEO

    show_header "\nRenaming the Directory [VSCode-linux-x64 -> vscode]...\n"
    mv ~/.LEO/VSCode-linux-x64/ ~/.LEO/vscode

    show_info "Removing the remnant files..."
    rm ~/Downloads/vscode.tar.gz

    after_install "VS Code Manual"
}

uninstall_VS_Code() {
    banner "Uninstalling VS Code..."

    show_info "Deleting VS Code Config files..."
    rm -rf ~/.config/Code
    rm -rf ~/.vscode

    show_info "Removing all VS Code application files..."
    rm -rf ~/.LEO/vscode

    show_info "Removing the symbolic for the VSCode binary file..."
    sudo rm /usr/bin/code

    show_info "Removing the desktop shortcut from the system..."
    sudo rm /usr/share/applications/vscode.desktop

    show_success "\n\n$*VS Code : Uninstalled Successfully\n"
    echo -e "------------------------------------------\n\n"
}

install_Discord_Manually() {
    banner "Installing discord tar file"

    show_info "Downloading discord tar file"
    wget -O ~/Downloads/discord.tar.gz 'https://discord.com/api/download?platform=linux&format=tar.gz'

    show_question "\nCreating a directory to install Discord"
    if [ -d ~/.LEO ]; then
        show_warning "\nDirectory exists.\nSkipping the creation step..\n"
    else
        mkdir -p ~/.LEO
    fi

    show_info "Extracting discord tar file"
    tar -xzf ~/Downloads/discord.tar.gz -C ~/.LEO

    show_info "Adding symbolic link on /usr/bin/Discord"
    sudo ln -sf ~/.LEO/Discord/Discord /usr/bin/Discord

    show_info "Copying discord.desktop to /usr/share/applications"
    sudo cp -r ~/.LEO/Discord/discord.desktop /usr/share/applications

    show_info "Adding executable file for discord.desktop"
    SUBJECT='/usr/share/applications/discord.desktop'
    SEARCH_FOR='Exec='
    sudo sed -i "/^$SEARCH_FOR/c\Exec=/usr/bin/Discord" $SUBJECT

    currentUser=$(whoami)
    show_info "Adding icon for discord.desktop"
    SEARCH_FOR='Icon='
    sudo sed -i "/^$SEARCH_FOR/c\Icon=/home/${currentUser}/.LEO/Discord/discord.png" $SUBJECT

    show_info "Removing the remnant files..."
    rm ~/Downloads/discord.tar.gz
}

uninstall_Discord() {
    banner "Uninstalling Discord..."

    show_info "Deleting Discord Config files..."
    sudo rm -r ~/.config/discord

    show_info "Removing all Discord application files..."
    sudo rm -rf ~/.LEO/Discord

    show_info "Removing the symbolic for the Discord binary file..."
    sudo rm /usr/bin/Discord

    show_info "Removing the desktop shortcut from the system..."
    sudo rm /usr/share/applications/discord.desktop

    show_success "\n\n$*Discord : Uninstalled Successfully\n"
    echo -e "------------------------------------------\n\n"
}

update_Zoom_Video_Conferencing() {
    banner "Updating Zoom Video Conferencing App :D"

    show_info "Removing the existing Zoom Installation"
    rm -rf ~/.LEO/zoom

    show_question "\nDownloading the Latest version of Zoom\n"
    wget -O ~/Downloads/zoom.tar.xz 'https://zoom.us/client/latest/zoom_x86_64.tar.xz'

    show_question "\nCreating a directory to install zoom.."
    if [ -d ~/.LEO ]; then
        show_warning "\nDirectory exists.\nSkipping the creation step..\n"
    else
        mkdir -p ~/.LEO
    fi

    show_info "\nExtracting the downloaded file...\n"
    tar -xf ~/Downloads/zoom.tar.xz -C ~/.LEO

    show_question "\nCreating a directory to download Zoom Icon"
    if [ -d ~/.LEO/zoom/icon ]; then
        show_warning "\nDirectory exists.\nSkipping the creation step..\n"
    else
        mkdir -p ~/.LEO/zoom/icon
    fi

    show_info "\nDownloading the Zoom Client Icon\n"
    wget -O ~/.LEO/zoom/icon/zoom.png 'https://i.imgur.com/0zk7xXE.png'

    show_info "Cleaning out the remnant files.."
    rm ~/Downloads/zoom.tar.xz

    after_install "Zoom Video Conferencing App"
}

install_Fira_Code_Font() {
    banner "Installing Fira Code Font"
    sudo eopkg it font-firacode-ttf -y
    after_install "Fira Code Font"
}

install_Xpad() {
    banner "Installing Xpad(Linux alternative to StickyNotes)"
    sudo eopkg it xpad -y
    after_install "Xpad"
}

install_Chrome_GNOME_Shell() {
    banner "Installing Chrome GNOME Shell"
    sudo eopkg it chrome-gnome-shell -y
    after_install "Chrome GNOME Shell"
}

install_Qbittorrent() {
    banner "Installing Qbittorrent"
    sudo eopkg it qbittorrent -y
    after_install "Qbittorrent"
}

install_VirtualEnv() {
    banner "Installing Python VirtualEnv"
    show_info "It is a tool to create isolated 'virtual' python environments"

    sudo eopkg install virtualenv -y
    after_install "VirtualEnv"
}

create_SymLink_Pip3() {
    show_info "Creating symbolic link for pip3"
    sudo ln -s /usr/bin/pip3 /usr/bin/pip
}

install_NPM() {
    banner "Installing Node Package Manager (npm)"

    show_question "\nDownloading the Latest version of nodejs\n"
    sudo eopkg it nodejs -y

    mkdir ~/.npm
    mkdir ~/.npm-global
    npm config set prefix '~/.npm-global'
}

install_TigerVNC() {
    banner "Installing TigerVNC"
    sudo eopkg it tigervnc -y
    after_install "TigerVNC"
}

install_Remmina() {
    banner "Installing Remmina"
    sudo eopkg it remmina -y
    after_install "Remmina"
}

install_Lutris() {
    banner "Installing Lutris"
    sudo eopkg it lutris -y
    after_install "Lutris"
}

install_GIMP() {
    banner "Installing GIMP"
    sudo eopkg it gimp -y
    after_install "GIMP"
}

install_Inkscape() {
    banner "Installing Inkscape"
    sudo eopkg it inkscape -y
    after_install "Inkscape"
}

install_Ansible() {
    banner "Installing Ansible"
    sudo eopkg it ansible -y
    after_install "Ansible"
}

install_Xinput() {
    banner "Installing Xinput"
    sudo eopkg it xinput -y
    after_install "Xinput"
}

install_PPTP_packages() {
    banner "Setting up PPTP packages..."
    sudo eopkg it pptp networkmanager-pptp -y
    after_install "PPTP"
}

install_GCC_GPP_Compilers() {
    banner "Setting up GNU C and C++ Compilers..."
    sudo eopkg it g++ gcc -y
    after_install "g++ and gcc"
}

install_MComix() {
    banner "Installing MComix Reader app..."
    sudo eopkg it mcomix -y
    after_install "Mcomix"
}

install_Development_Packages() {
    show_banner "Installing Development pacakges"

    show_info "Upgrading the system"
    sudo eopkg upgrade -y

    show_info "Installing the necessary packages"
    sudo eopkg install -c system.devel

    after_install "Development Packages"
}

install_Shotcut() {
    banner "Installing Shotcut..."
    sudo eopkg it shotcut -y
    after_install "Shotcut"
}

install_KDenLive() {
    banner "Installing KDenLive..."
    sudo eopkg it kdenlive -y
    after_install "KDenLive"
}

install_DosBox() {
    banner "Installing DOSBox..."
    sudo eopkg it dosbox -y
    after_install "DosBox"
}

install_OBS() {
    banner "Installing Open Broadcaster Software"
    sudo eopkg it obs-studio -y
    after_install "OBS Studio"
}

setup_KVM_Solus() {
    banner "Setting up KVM in Solus"

    show_info "First, ensure /usr/local/bin/ exists."
    sudo mkdir -p /usr/local/bin

    show_info "Install dependencies for KVM virtualization"
    sudo eopkg install libvirt qemu virt-manager -y

    show_info "Add your current user to the libvirt group:"
    sudo usermod -a -G libvirt $(whoami)
    newgrp libvirt

    show_info "Starting the libvirt daemon..."
    show_question "This enable the libvirt virtualization management system"
    sudo systemctl start libvirtd.service

    show_info "Enabling libvirt daemon to start automatically on boot:"
    sudo systemctl enable libvirtd.service

    show_question "Restart the system now."
}

update_Sublime_Text() {
    # Have to get the latest download link from the official website
    # https://www.sublimetext.com/download
    banner "Updating Sublime Text"

    show_info "Removing the existing Sublime Text Installation"
    rm -rf ~/.LEO/sublime_text/

    show_question "\nDownloading Sublime Text Build 4113\n"
    wget -O ~/Downloads/sublime.tar.xz 'https://download.sublimetext.com/sublime_text_build_4121_x64.tar.xz'

    show_info "\nExtracting the downloaded file...\n"
    tar -xf ~/Downloads/sublime.tar.xz -C ~/.LEO

    show_info "Cleaning out the remnant files.."
    rm ~/Downloads/sublime.tar.xz

    after_install "Sublime Text"
}

setup_Postman_API() {
    # References:
    # 1. https://morioh.com/p/e256fd7a2811
    # 2. https://www.tecmint.com/install-postman-on-linux-desktop/
    banner "Installing Postman API Desktop Client"

    show_question "\nDownloading the Latest version of Postman API\n"
    wget -O ~/Downloads/postman.tar.gz 'https://dl.pstmn.io/download/latest/linux64'

    show_question "\nCreating a directory to install Postman API.."
    if [ -d ~/.LEO ]; then
        show_warning "\nDirectory exists.\nSkipping the creation step..\n"
    else
        mkdir -p ~/.LEO
    fi

    show_info "\nExtracting the downloaded file...\n"
    tar -xzf ~/Downloads/postman.tar.gz -C ~/.LEO

    show_info "Creating Sybmbolic Link for Postman API\n\n"
    sudo ln -s ~/.LEO/Postman/Postman /usr/bin/postman

    currentUser=$(whoami)

    show_info "\nCreating a Desktop Entry for Postman\n"
    {
        echo "[Desktop Entry]"
        echo "Name=Postman"
        echo "GenericName=API Client"
        echo "X-GNOME-FullName=Postman API Client"
        echo "Comment=Make and view REST API calls and responses"
        echo "Keywords=api;"
        echo "Exec=/home/${currentUser}/.LEO/Postman/Postman"
        echo "Terminal=false"
        echo "Type=Application"
        echo "Icon=/home/${currentUser}/.LEO/Postman/app/resources/app/assets/icon.png"
        echo "Categories=Development;Utilities;"
    } | sudo tee /usr/share/applications/postman-client.desktop

    show_info "Removing the remnant files..."
    rm ~/Downloads/postman.tar.gz

    after_install "Postman API Client"
}

uninstall_Postman() {
    banner "Uninstalling Postman API Client..."

    show_info "Deleting Postman Config files..."
    sudo rm -r ~/.config/Postman

    show_info "Removing all application files..."
    sudo rm -rf ~/.LEO/Postman

    show_info "Removing the symbolic for the Postman Client binary file..."
    sudo rm /usr/bin/Postman

    show_info "Removing the desktop shortcut from the system..."
    sudo rm /usr/share/applications/postman-client.desktop

    show_success "\n\n$*Postman Client : Uninstalled Successfully\n"
    echo -e "------------------------------------------\n\n"
}

install_Heroku_CLI() {
    banner "Installing Heroku CLI"
    show_info "Getting the latest build using wget.."
    wget -O ~/Downloads/heroku.tar.gz 'https://cli-assets.heroku.com/heroku-linux-x64.tar.gz'

    show_question "\nCreating a directory to install heroku.."
    if [ -d ~/.LEO ]; then
        show_warning "\nDirectory exists.\nSkipping the creation step..\n"
    else
        mkdir -p ~/.LEO
    fi

    show_info "\nExtracting the downloaded file...\n"
    tar xf ~/Downloads/heroku.tar.gz -C ~/.LEO

    show_info "Creating symbolic link for heroku\n"
    sudo ln -s ~/.LEO/heroku/bin/heroku /usr/bin/heroku

    show_info "Cleaning out the remnant files.."
    rm ~/Downloads/heroku.tar.gz
}

uninstall_Heroku_CLI() {
    banner "Uninstalling Heroku CLI ..."

    show_info "Deleting Heroku CLI Config files..."
    rm -rf ~/.local/share/heroku/

    show_info "Deleting Heroku CLI cache files..."
    rm -rf ~/.cache/heroku/

    show_info "Removing all application files..."
    sudo rm -rf ~/.LEO/heroku

    show_info "Removing the symbolic for the Heroku CLI binary file..."
    sudo rm /usr/bin/heroku

    show_success "\n\n$* Heroku CLI : Uninstalled Successfully\n"
    echo -e "------------------------------------------\n\n"
}

configure_title_bar() {
    banner "Configure Title Bar"
    show_info "Showing Battery Percentage"
    gsettings set org.gnome.desktop.interface show-battery-percentage true

    show_success "Show Time in 12 hour format"
    gsettings set org.gnome.desktop.interface clock-format 12h

    show_success "Show Date in the top bar"
    gsettings set org.gnome.desktop.interface clock-show-date true

    show_success "Show the seconds in Clock"
    gsettings set org.gnome.desktop.interface clock-show-seconds true

    show_success "Show the Weekday in Clock"
    gsettings set org.gnome.desktop.interface clock-show-weekday true

    show_success "Adding Minimize and Maximize buttons on the left"
    gsettings set org.gnome.desktop.wm.preferences button-layout "close,maximize,minimize:"
}

install_ZSH() {
    banner "Installing New Shell : ZSH"

    show_success "Installing required packages"
    sudo eopkg it zsh zsh-autosuggestions zsh-syntax-highlighting -y

    show_success "Changing the shell"
    sudo chsh -s /bin/zsh
    after_install "Z Shell"
}

configure_GNOME_Stuff() {
    install_ZSH
    install_Chrome_GNOME_Shell
    change_BASH_Prompt
    install_Neofetch
    install_Xclip
    install_Xkill
    install_Fira_Code_Font
    install_PPTP_packages
}

install_PostgreSQL() {
    banner "Installing PostgreSQL"

    show_info "Installing required packages"
    sudo eopkg it postgresql postgresql-contrib postgresql-dbginfo psycopg2 -y

    after_install "PostgreSQL"
}

configure_Pgadmin4() {
    banner "Configuring Pgadmin4"

    show_info "Creating directory: /var/lib/pgadmin"
    sudo mkdir /var/lib/pgadmin

    show_info "Creating directory for logs: /var/log/pgadmin"
    sudo mkdir /var/log/pgadmin

    show_info "Changing ownership to $USER for /var/lib/pgadmin"
    sudo chown $USER /var/lib/pgadmin

    show_info "Changing ownership to $USER for /var/log/pgadmin"
    sudo chown $USER /var/log/pgadmin

    show_info "Creating a new Python Virtual Environment: pgadmin4"
    python3 -m venv pgadmin4

    show_info "Activating the Python Virtual Environment: pgadmin"
    source pgadmin4/bin/activate

    show_info "Installing python package: simple-websocket"
    pip3 install simple-websocket

    show_info "Installing python package: pgadmin4"
    pip3 install pgadmin4

    show_info "Deactivating the Python Virtual Environment"
    deactivate

    after_install "PgAdmin4"
}

install_Python_Dev_Stuff() {
    banner "Installing Python related Stuff"

    create_SymLink_Pip3

    install_VirtualEnv
    pip3 install --user virtualenv

    show_info "Installing Development files for python3"
    sudo eopkg it python3-devel -y

    show_info "Installing Development files for PostgreSQL"
    sudo eopkg it postgresql-devel -y
}

install_Telegram_Manually() {
    banner "Installing Telegram Desktop"

    show_question "\nDownloading the Latest version of Telegram\n"
    wget -O ~/Downloads/tsetup.tar.xz 'https://telegram.org/dl/desktop/linux'

    show_question "\nCreating a directory to install Telegram.."
    if [ -d ~/.LEO ]; then
        show_warning "\nDirectory exists.\nSkipping the creation step..\n"
    else
        mkdir -p ~/.LEO
    fi

    show_info "\nExtracting the downloaded file...\n"
    tar -xJf ~/Downloads/tsetup.tar.xz -C ~/.LEO

    currentUser=$(whoami)

    show_info "Creating Symbolic Link for Telegram Desktop"
    sudo ln -s /home/${currentUser}/.LEO/Telegram/Telegram /usr/bin/telegram-desktop

    show_info "\nCreating a Desktop Entry for Telegram Desktop.\n"
    {
        echo "[Desktop Entry]"
        echo "Version=1.0"
        echo "Name=Telegram Desktop"
        echo "Comment=Official desktop version of Telegram messaging app"
        echo "TryExec=telegram-desktop"
        echo "Exec=telegram-desktop -- %u"
        echo "Icon=telegram"
        echo "Terminal=false"
        echo "StartupWMClass=TelegramDesktop"
        echo "Type=Application"
        echo "Categories=Chat;Network;InstantMessaging;Qt;"
        echo "MimeType=x-scheme-handler/tg;"
        echo "Keywords=tg;chat;im;messaging;messenger;sms;tdesktop;"
        echo "Actions=Quit;"
        echo "X-GNOME-UsesNotifications=true"
        echo "X-GNOME-SingleWindow=true"
        echo ""
        echo "[Desktop Action Quit]"
        echo "Exec=telegram-desktop -quit"
        echo "Name=Quit Telegram"
        echo "Icon=application-exit"
    } | tee ~/.local/share/applications/telegramdesktop.desktop

    show_info "Cleaning out the remnant files.."
    rm ~/Downloads/tsetup.tar.xz

    after_install "Telegram Desktop"
}

uninstall_Telegram() {
    banner "Uninstalling Telegram..."

    show_info "Deleting Telegram Config Files..."
    rm -rf ~/.local/share/TelegramDesktop/

    show_info "Removing all Telegram application files..."
    rm -rf ~/.LEO/Telegram

    show_info "Removing the symbolic for the Telegram binary file..."
    sudo rm /usr/bin/telegram-desktop

    show_info "Removing the desktop shortcut from the system..."
    rm ~/.local/share/applications/telegramdesktop.desktop

    show_success "\n\n$*Telegram Desktop : Uninstalled Successfully\n"
    echo -e "------------------------------------------\n\n"
}

install_Manual_Applications() {
    # Frequent Apps
    install_Discord_Manually
    install_Zoom_Client

    # 3rd Party Stuff
    install_Microsoft_Core_Fonts
    install_Anydesk

    # CoderStuff
    gitsetup
    install_Sublime_Text
    install_VSCode_manually
    install_Heroku_CLI
    setup_Postman_API
    install_and_configure_LAMP_Stack
}

configure_Coder_Stuff() {
    install_Vim
    install_Git

    install_Python_Dev_Stuff

    install_GCC_GPP_Compilers
    install_Development_Packages
    install_NPM

    install_PostgreSQL
    configure_Pgadmin4
}

install_Frequent_Apps() {
    install_MKVToolNix
    install_Telegram
    install_Brave_Browser
    install_Opera_Browser
    install_Qbittorrent
    install_OBS
}

install_Everything() {
    upgrade_the_System
    configure_GNOME_Stuff
    configure_Coder_Stuff
    install_Frequent_Apps
    install_Manual_Applications
}

install_Everything
