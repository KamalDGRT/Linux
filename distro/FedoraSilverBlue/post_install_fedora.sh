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
    sudo grub2-mkconfig -o /boot/grub2/grub.cfg

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

enable_grub_menu
gitsetup

