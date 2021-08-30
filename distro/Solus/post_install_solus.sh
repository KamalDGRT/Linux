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

    show_question "Creating a directory to clone the reop\n\n"
    mkdir -p ~/LEO/unoconv

    show_warning "Cloning the Github repo: dagwieers/unoconv\n\n"
    git clone https://github.com/dagwieers/unoconv.git ~/LEO/unoconv

    show_info "Creating symbolic link for unoconv\n"
    sudo ln -s ~/LEO/unoconv/unoconv /usr/bin/unoconv

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
    sudo tar xvf phpmyadmin.tar.gz --strip-components=1 -C /var/www/phpmyadmin

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

    show_question "\nDownloading the Latest version of Zoom\n"
    wget -O ~/Downloads/vscode.tar.gz 'https://code.visualstudio.com/sha/download?build=stable&os=linux-x64'

    show_info "Downloading keyring for VS Code"
    wget -O ~/Downloads/microsoft.asc 'https://packages.microsoft.com/keys/microsoft.asc'

    show_info "Importing VS Code keyring"
    gpg --import ~/Downloads/microsoft.asc

    show_question "\nCreating a directory to install zoom.."
    if [ -d ~/LEO ]; then
        show_warning "\nDirectory exists.\nSkipping the creation step..\n"
    else
        mkdir -p ~/LEO
    fi

    show_info "\nExtracting the downloaded file...\n"
    tar xvf ~/Downloads/vscode.tar.gz -C ~/LEO

    show_header "\nRenaming the Directory [VSCode-linux-x64 -> vscode]...\n"
    mv ~/LEO/VSCode-linux-x64/ ~/LEO/vscode

    currentUser=$(whoami)

    show_info "\nCreating a Desktop Entry for VS Code\n"
    {
        echo "[Desktop Entry]"
        echo "Name=Visual Studio Code"
        echo "Comment=Code Editing. Redefined."
        echo "GenericName=Text Editor"
        echo "Exec=/home/${currentUser}/LEO/vscode/code --unity-launch %F"
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
        echo "Exec=/home/${currentUser}/LEO/vscode/code --new-window %F"
        echo "Icon=com.visualstudio.code"
    } | sudo tee /usr/share/applications/vscode.desktop

    show_info "Creating Sybmbolic Link for VS Code\n\n"
    sudo ln -s ~/LEO/vscode/bin/code /usr/bin/code

    show_info "Removing the remnant files..."
    rm ~/Downloads/microsoft.asc

    after_install "VS Code Manual"
}

install_Everything() {
    install_Neofetch
    install_Zoom_Client
    install_Xclip
    install_Xkill
    install_Unoconv
    install_Sublime_Text
    install_and_configure_LAMP_Stack
    install_Brave_Browser
    install_Discord
    install_VLC
    install_Vim
    install_VSCode
    install_Opera_Browser
    install_Anydesk
    install_Microsoft_Core_Fonts
}

install_VSCode_manually
