#!/bin/bash

# Add your GitHub details here:
GITHUB_USERNAME="KamalDGRT"
GITHUB_EMAIL_ID="kamaldgrt@gmail.com"
GIT_CLI_EDITOR="vim"

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


rks_gnome_themes


