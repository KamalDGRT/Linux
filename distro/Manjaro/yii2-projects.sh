#!/bin/bash

banner() {
    printf "\n\n\n"
    msg="| $* |"
    edge=$(echo "$msg" | sed 's/./-/g')
    echo "$edge"
    echo "$msg"
    echo "$edge"
}

hr() {
    printf "\n\n-------------------------------------------------\n\n"
}

yii2_project_logo() {

    printf "\n\n
    __   ___ _ ____    ____            _           _       
    \ \ / (_|_)___ \  |  _ \ _ __ ___ (_) ___  ___| |_ ___ 
     \ V /| | | __) | | |_) | '__/ _ \| |/ _ \/ __| __/ __|
      | | | | |/ __/  |  __/| | | (_) | |  __/ (__| |_\__ \\
      |_| |_|_|_____| |_|   |_|  \___// |\___|\___|\__|___/
                                    |__/                   
    \n\n"
}

vhost_content() {
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

    echo "$content"  | sudo tee -a /etc/httpd/conf/extra/httpd-vhosts.conf
    echo -e "\n# 127.0.1.1    $2\n" | sudo tee -a /etc/hosts
}

clone_the_projects() {
    banner "Setting up the Yii2 Projects..."

    printf "\nCreating a directory to store yii2 projects..\n"
    if [ -d /srv/http/yii2 ]; then
        printf "\nDirectory exists.\nSkipping the creation step..\n"
    else
        sudo mkdir -p /srv/http/yii2
        printf "\nChanging the folder permissions...\n"
        sudo chmod 777 -R /srv/http/yii2
    fi

    hr

    printf "\nClone : KamalDGRT/yii2-portfolio\n"
    if [ -d /srv/http/yii2/portfolio ]; then
        printf "\nDirectory exists.\nSkipping the cloning step..\n"
    else
        printf "\nCloning yii2-portfolio\n\n"
        git clone git@github.com:KamalDGRT/yii2-portfolio.git /srv/http/yii2/portfolio
        vhost_content "/srv/http/yii2/portfolio" "yii2-portfolio.kamal"
    fi

    hr

    printf "\nClone : KamalDGRT/grievance\n"
    if [ -d /srv/http/yii2/grievance ]; then
        printf "\nDirectory exists.\nSkipping the cloning step..\n"
    else
        printf "\nCloning grievance\n\n"
        git clone git@github.com:KamalDGRT/grievance.git /srv/http/yii2/grievance
        vhost_content "/srv/http/yii2/grievance" "grievanceprod.kamal"
    fi

    hr

    printf "\nClone : KamalDGRT/myvcard\n"
    if [ -d /srv/http/yii2/myvcard ]; then
        printf "\nDirectory exists.\nSkipping the cloning step..\n"
    else
        printf "\nCloning myvcard\n\n"
        git clone git@github.com:KamalDGRT/myvcard.git /srv/http/yii2/myvcard
        vhost_content "/srv/http/yii2/myvcard" "vcard.kamal"
    fi

    hr

    printf "\nClone : KamalDGRT/technosummit\n"
    if [ -d /srv/http/yii2/technosummit ]; then
        printf "\nDirectory exists.\nSkipping the cloning step..\n"
    else
        printf "\nCloning myvcard\n\n"
        git clone git@github.com:KamalDGRT/technosummit.git /srv/http/yii2/technosummit
        vhost_content "/srv/http/yii2/technosummit" "technosummit.kamal"
    fi

    hr

    printf "\nClone : KamalDGRT/ts2k21\n"
    if [ -d /srv/http/yii2/ts2k21 ]; then
        printf "\nDirectory exists.\nSkipping the cloning step..\n"
    else
        printf "\nCloning ts2k21\n\n"
        git clone git@github.com:KamalDGRT/ts2k21.git /srv/http/yii2/ts2k21
        vhost_content "/srv/http/yii2/ts2k21" "ts2k21.kamal"
    fi

    hr

    printf "\nClone : KamalDGRT/ytclone\n"
    if [ -d /srv/http/yii2/ytclone ]; then
        printf "\nDirectory exists.\nSkipping the cloning step..\n"
    else
        printf "\nCloning ytclone\n\n"
        git clone git@github.com:KamalDGRT/ytclone.git /srv/http/yii2/ytclone
        vhost_content "/srv/http/yii2/ytclone" "ytclone.kamal"
    fi
}

main_menu() {
    yii2_project_logo
    clone_the_projects
}

main_menu
