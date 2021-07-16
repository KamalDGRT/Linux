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

install_RPM_Fusion_Repos() {
    sudo dnf install https://mirrors.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm https://mirrors.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm -y
}

configure_NVIDIA_Drivers() {
    #  Reference: https://fedoramagazine.org/install-nvidia-gpu/
    # Make sure to upgrade the system
    #  sudo dnf update -y
    #  Update and reboot the system.

    # After reboot, install the Fedora's workstation repositories:
    sudo dnf install fedora-workstation-repositories

    # Next, enable the NVIDIA driver repository:
    sudo dnf config-manager --set-enabled rpmfusion-nonfree-nvidia-driver

    # Reboot again.

    #  After the reboot, verify the addition of the repository via the following command:
    sudo dnf repository-packages rpmfusion-nonfree-nvidia-driver info

    # If several NVIDIA tools and their respective specs are loaded, then proceed to the next step.
    #  If not, you may have encountered an error when adding the new repository and you should give it another shot.

    # Cleaning the remnant packages..
    #  sudo dnf clean packages

    # Installing the NVIDIA related packages.
    sudo dnf install -y akmod-nvidia kmod-nvidia nvidia-modprobe nvidia-persistenced \
        nvidia-settings nvidia-xconfig xorg-x11-drv-nvidia xorg-x11-drv-nvidia-cuda \
        xorg-x11-drv-nvidia-cuda-libs xorg-x11-drv-nvidia-devel xorg-x11-drv-nvidia-kmodsrc xorg-x11-drv-nvidia-libs

    # Blacklist nouveau drivers
    echo -e "blacklist nouveau" | sudo tee -a /etc/modprobe.d/blacklist.conf

    # Reboot the system.
    # Now you can find NVIDIA settings icon in the app menu.
    # Open it and verify the NVIDIA configs.
}

install_Neofetch() {
    sudo dnf install -y neofetch
}

install_Brave_Browser() {
    sudo dnf install dnf-plugins-core -y
    sudo dnf config-manager --add-repo https://brave-browser-rpm-release.s3.brave.com/x86_64/
    sudo rpm --import https://brave-browser-rpm-release.s3.brave.com/brave-core.asc
    sudo dnf install brave-browser
}

install_Xclip() {
    sudo dnf install -y xclip
}

gitsetup() {
    banner "Setting up SSH for git and GitHub"

    read -e -p "Enter GitHub Username: " GITHUB_USERNAME
    read -e -p "Enter GitHub EmailId: " GITHUB_EMAIL_ID
    read -e -p "Enter Default git editor (vim / nano): " GIT_CLI_EDITOR

    if [[ $GITHUB_EMAIL_ID != "" && $GITHUB_USERNAME != "" && $GIT_CLI_EDITOR != "" ]]; then
        printf "\n - Configuring GitHub username as: ${GITHUB_USERNAME}"
        git config --global user.name "${GITHUB_USERNAME}"

        printf "\n - Configuring GitHub email address as: ${GITHUB_EMAIL_ID}"
        git config --global user.email "${GITHUB_EMAIL_ID}"

        printf "\n - Configuring Default git editor as: ${GIT_CLI_EDITOR}"
        git config --global core.editor "${GIT_CLI_EDITOR}"

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

add_Flatpak_remote() {
    sudo flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
}

install_Flatpak_Discord() {
    flatpak install flathub com.discordapp.Discord -y
}

install_Flatpak_Zoom_Meet() {
    flatpak install flathub us.zoom.Zoom -y
}

install_VSCode() {
    sudo rpm --import https://packages.microsoft.com/keys/microsoft.asc
    sudo sh -c 'echo -e "[code]\nname=Visual Studio Code\nbaseurl=https://packages.microsoft.com/yumrepos/vscode\nenabled=1\ngpgcheck=1\ngpgkey=https://packages.microsoft.com/keys/microsoft.asc" > /etc/yum.repos.d/vscode.repo'
    sudo dnf check-update
    sudo dnf install code -y
}

install_Sublime_Text() {
    sudo rpm -v --import https://download.sublimetext.com/sublimehq-rpm-pub.gpg
    sudo dnf config-manager --add-repo https://download.sublimetext.com/rpm/stable/x86_64/sublime-text.repo
    sudo dnf install sublime-text -y
}

install_Vim_Editor() {
    sudo dnf install vim -y
}

install_Evolution_Mail_Client() {
    sudo dnf install -y evolution evolution-ews
}

install_htop() {
    sudo dnf install -y htop
}

install_GNOME_Shell_Themes() {
    sudo dnf install -y arc-theme moka-icon-theme gnome-tweaks \
        gnome-shell-extension-appindicator \
        gnome-shell-extension-user-theme \
        gnome-extensions-app
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

    printf "\e[1;32m\nShow the seconds in Clock\e[0m"
    gsettings set org.gnome.desktop.interface clock-show-seconds true

    printf "\e[1;32m\nShow the Weekday in Clock\n\n\e[0m"
    gsettings set org.gnome.desktop.interface clock-show-weekday true

    printf "\e[1;32m\nAdding Minimize and Maximize buttons on the left\n\n\e[0m"
    gsettings set org.gnome.desktop.wm.preferences button-layout "close,maximize,minimize:"
}

install_Telegram_Desktop() {
    sudo dnf install telegram-desktop -y
}

install_VLC_Media_Player() {
    sudo dnf install -y vlc
}

install_Flatpak_OBS() {
    flatpak install flathub com.obsproject.Studio -y
}

install_Xampp() {
    cd ~/Downloads/
    wget 'https://www.apachefriends.org/xampp-files/8.0.8/xampp-linux-x64-8.0.8-0-installer.run'
    ls
    ll
    chmod +x xampp-linux-x64-8.0.8-0-installer.run
    sudo ./xampp-linux-x64-8.0.8-0-installer.run
}

install_Discord_RPM() {
    sudo dnf install -y discord
}
