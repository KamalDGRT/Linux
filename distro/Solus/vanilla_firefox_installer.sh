#!/bin/bash

{
    printf "\n[INFO] Downloading Firefox\n\n"
    wget -O firefox.tar.bz2 'https://download.mozilla.org/?product=firefox-latest-ssl&os=linux64&lang=en-US'
    wait
    printf "\n[INFO] Download Complete\n\n"
    wait
    printf "\n[INFO] Preparing to extract firefox.tar.bz2\n\n"
    sudo tar -xf firefox.tar.bz2 -C /opt/
    printf "\n[TASK] Creating a new desktop entry: Firefox (Manual)\n\n"
    wait
    {
        echo "[Desktop Entry]"
        echo "Encoding=UTF-8"
        echo "Type=Application"
        echo "Terminal=False"
        echo "Exec=/opt/firefox/firefox"
        echo "Name=Firefox (Manual)"
        echo "Icon=/opt/firefox/browser/chrome/icons/default/default128.png"
    } | sudo tee /usr/share/applications/firefox-manual.desktop
    printf "\n\n[SUCCESS] Firefox installed successfully"
} ||
    {
        printf "\n\n[ERROR] Could not install firefox. Exiting..."
    }
