# Zorin OS (GNOME) Logs

### January 30, 2022

-   Installed Zorin OS at 1:30 AM.
    -   Gave: Install along side windows.
    -   Chose the Kingston NVME SSD for the installation
    -   Had to manually allocate and choose
    -   So, I used the previous allocation that I had given while trying
        to install PopOS
    -   Allocated 800MB for EFI
    -   Allocated 200 something GB for Root (/) partition
    -   Allocated the remaining 4GB for the swap partition
-   Removed the apps that were pre-installed through a bunch of commands.
    -   `sudo apt remove aisleriot -y`
    -   `sudo apt remove libreoffice-*`
    -   `sudo apt remove quadrapassel -y`
    -   `sudo apt remove gnome-mines -y`
    -   `sudo apt remove gnome-sudoku -y`
    -   `sudo apt remove gnome-maps gnome-mahjongg -y`
    -   `sudo apt remove pitivi -y`
    -   `sudo apt remove gimp -y`
    -   `sudo apt remove gnome-tour -y`
    -   `sudo apt remove gnome-weather -y`
    -   `sudo apt autoremove -y`
-   Installed Neofetch
    -   `sudo apt install neofetch -y`
-   Installed Xclip
    -   `sudo apt install xclip -y`
-   From the `post_install_solus.sh`, I used these functions:
    -   `install_Discord_Manually`
    -   `install_Sublime_Text`
    -   `setup_Postman_API`
    -   `install_Heroku_CLI`
    -   `install_Telegram_Manually`
    -   `gitsetup`
-   Tried to install Zoom from the same script. But it did not launch.
-   VS Code got installed but the icon did not appear.
-   So, uninstalled Zoom and VSCode which were manually installed.
-   From the `post_install_mint.sh`, I used these functions:
    -   `configure_title_bar`
    -   `install_MS_Fonts`
    -   `install_VSCode`
    -   `install_Pip`
    -   `install_YoutubeDL`
    -   `install_and_configure_LAMP`
    -   `install_qBittorrent`
    -   `aliases_and_scripts`