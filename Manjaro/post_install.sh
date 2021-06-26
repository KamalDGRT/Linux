#!/bin/bash

# Add your GitHub details here:
GITHUB_USERNAME=""
GITHUB_EMAIL_ID=""

banner() {
    msg="| $* |"
    edge=$(echo "$msg" | sed 's/./-/g')
    echo "$edge"
    echo "$msg"
    echo "$edge"
}

function pause(){
    read -s -n 1 -p "Press any key to continue . . ."
    clear
}

banner "Installing: neofetch bash-completion xorg-xclip"
yes | sudo pacman -S neofetch bash-completion xorg-xclip
pause


banner "Setting up SSH for git and GitHub"

printf "\n - Configuring GitHub username as: ${GITHUB_USERNAME}"
git config --global user.name "${GITHUB_USERNAME}"

printf "\n - Configuring GitHub email address as: ${GITHUB_EMAIL_ID}"
git config --global user.email "${GITHUB_EMAIL_ID}"

printf "\n - Generating a new SSH key for ${GITHUB_EMAIL_ID}"
printf "\n\nJust press Enter and add passphrase if you'd like to. \n\n"
ssh-keygen -t ed25519 -C "${GITHUB_EMAIL_ID}"

printf "\n\nAdding your SSH key to the ssh-agent..\n"

printf "\n - Start the ssh-agent in the background.."
eval "$(ssh-agent -s)"

print "\n\n - Adding your SSH private key to the ssh-agent"
ssh-add ~/.ssh/id_ed25519

printf "\n - Copying the SSH Key Content to the Clipboard..."

printf "\n\nLog in into your GitHub account in the browser (if you have not)"
printf "\nOpen this link https://github.com/settings/keys in the browser."
printf "\nClik on New SSH key."
xclip -selection clipboard < ~/.ssh/id_ed25519.pub
printf "\nGive a title for the SSH key."
printf "\nPaste the clipboard content in the textarea box below the title."
printf "\nClick on Add SSH key."

pause


banner "Installing: Pulse Audio & Alsa Tools"
yes | sudo pacman -S pulseaudio pulseaudio-alsa pavucontrol alsa-utils \
alsa-ucm-conf sof-firmware
pause


banner "Installing: LAMP Stack Packages"
yes | sudo pacman -S php php-apache php-cgi php-fpm php-gd php-embed php-intl php-imap \
php-redis php-snmp phpmyadmin
pause


banner "Installing Package Managers: composer npm yay snapd"
yes | sudo pacman -S composer nodejs npm yay snapd

printf "\nEnabling the snap daemon..."
sudo systemctl enable --now snapd.socket

printf "\nEnabling classic snap support by creating the symlink..."
sudo ln -s /var/lib/snapd/snap /snap

pause


banner "Installing: Brave Browser, Telegram, VLC & Discord"
yes | sudo pacman -S brave telegram-desktop vlc discord
pause


banner "Installing Snap Package: OBS Studio"
sudo snap install obs-studio
pause


banner "Installing Snap Package: Spotify"
sudo snap install spotify
pause


banner "Installing Snap Package: Microsoft Visual Studio Code"
sudo snap install code --classic
pause


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
echo -e "\n[sublime-text]\nServer = https://download.sublimetext.com/arch/stable/x86_64" \
| sudo tee -a /etc/pacman.conf

printf "\nUpdatig pacman and installing Sublime Text..."

yes | sudo pacman -Syu sublime-text

pause
