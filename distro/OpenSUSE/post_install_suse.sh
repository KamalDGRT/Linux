#!/bin/bash

# Add your GitHub details here:
GITHUB_USERNAME=""
GITHUB_EMAIL_ID=""
GIT_CLI_EDITOR=""

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

reduce_Swappiness() {
    # sudo nano /etc/sysctl.conf
    # Append this to the above file.
    # vm.swappiness=10
}

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
