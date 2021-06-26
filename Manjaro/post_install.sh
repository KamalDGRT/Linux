#!/bin/bash

# Add your GitHub details here:
GITHUB_USERNAME=""
GITHUB_EMAIL_ID=""

printf "\n-------------------------------------------------------------\n"
printf "| Installing: neofetch bash-completion xorg-xclip           |"
printf "\n-------------------------------------------------------------\n"

sudo pacman -S neofetch bash-completion xorg-xclip

read  -n 1 -p "Press any Key to continue..."
clear

printf "\n-------------------------------------------------------------\n"
printf "| Setting up SSH for git and GitHub                         |"
printf "\n-------------------------------------------------------------\n"

printf "\n Configuring GitHub username as: ${GITHUB_USERNAME}"
git config --global user.name "${GITHUB_USERNAME}"

printf "\n Configuring GitHub email address as: ${GITHUB_EMAIL_ID}"
git config --global user.email "${GITHUB_EMAIL_ID}"

printf "\n Generating a new SSH key for ${GITHUB_EMAIL_ID}"
printf "\n\nJust press Enter and add passphrase if you'd like to. \n\n"
ssh-keygen -t ed25519 -C "${GITHUB_EMAIL_ID}"

printf "\n\nAdding your SSH key to the ssh-agent..\n"

printf "\nStart the ssh-agent in the background.."
eval "$(ssh-agent -s)"

print "\n\nAdding your SSH private key to the ssh-agent"
ssh-add ~/.ssh/id_ed25519

printf "\nCopying the SSH Key Content to the Clipboard..."

printf "\n\nLog in into your GitHub account in the browser (if you have not)"
printf "\nOpen this link https://github.com/settings/keys in the browser."
printf "\nClik on New SSH key."
xclip -selection clipboard < ~/.ssh/id_ed25519.pub
printf "\nGive a title for the SSH key."
printf "\nPaste the clipboard content in the textarea box below the title."
printf "\nClick on Add SSH key."

read  -n 1 -p "Press any Key to continue..."
clear

printf "\n-------------------------------------------------------------\n"
printf "| Installing: Pulse Audio & Alsa Tools                      |"
printf "\n-------------------------------------------------------------\n"


sudo pacman -S pulseaudio pulseaudio-alsa pavucontrol alsa-utils \
    alsa-ucm-conf sof-firmware

read  -n 1 -p "Press any Key to continue..."
clear

printf "\n-------------------------------------------------------------\n"
printf "| Installing: LAMP Stack Packages                           |"
printf "\n-------------------------------------------------------------\n"


sudo pacman -S php php-apache php-cgi php-fpm php-gd php-embed php-intl php-imap \
    php-redis php-snmp phpmyadmin

read  -n 1 -p "Press any Key to continue..."
clear

printf "\n-------------------------------------------------------------\n"
printf "| Installing Package Managers: composer npm yay snapd       |"
printf "\n-------------------------------------------------------------\n"

sudo pacman -S composer nodejs npm yay snapd

read  -n 1 -p "Press any Key to continue..."
clear
