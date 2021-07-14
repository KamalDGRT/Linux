#!/bin/bash

remove_Discord() {
    printf "\n\nRemoving Configuration files ..."
    rm -r ~/.config/discord

    printf "\n\nRemoving the Discord directory from the /opt directory ...\n"
    sudo rm -rf /opt/Discord

    printf "\n\nDeleting the symbolic link for Discord ...\n"
    sudo rm /usr/bin/Discord

    printf "\n\nLast step, removing the desktop file ...\n"
    sudo rm /usr/share/applications/discord.desktop
}

remove_Discord
