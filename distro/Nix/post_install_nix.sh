#!/run/current-system/sw/bin/bash

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

gitsetup
