# Solus OS (Budgie)

### Neofetch Images

![Solus](https://i.imgur.com/ZtqCyeZ.png)

#### Logs a.k.a. what I did after installing Solus

-   Added keyboard shortcut `Ctrl + Alt + T` for `gnome-terminal`
-   Added keyboard shortcut `Ctrl + Alt + M` for `gnome-system-monitor`
-   Added keyboard shortcut `Super + E` for `nautilus /home/kamal`
-   Changed Gnome Terminal Preferences:
    -   [Text] Custom GNOME font: `Monospace` `16`
    -   [Colors] Unchecked `Use colors from system theme`
    -   [Colors] Selected `GNOME Dark` from the built in themes
    -   [Colors] Reduced the transparency level to the least value.
    -   [Colors] Checked `Show bold text colors in bright colors`
-   Updated the system using `sudo eopkg upgrade -y`
-   Rebooted the system.
-   Applications -> Hardware Drivers -> Selected NVIDIA option. -> Installed it.
-   Rebooted the system.
-   Installed `neofetch` using `sudo eopkg install neofetch -y`
-   Installed _Brave Browser_ using `sudo eopkg it brave -y`
-   ###### Enabled the sound devices:

```sh
    echo 'snd_hda_intel.dmic_detect=0' | sudo tee /etc/kernel/cmdline.d/sound.conf`
```

-   Updated the config so that sound stuff will be enabled in next boot.
    -   `sudo clr-boot-manager update`
-   Rebooted the system.
-   Installed `Git` by `sudo eopkg it git -y`
-   Installed `Discord` by `sudo eopkg it discord -y`
-   Installed `Telegram Desktop` by `sudo eopkg it telegram -y`
-   Installed Flatpak by `sudo eopkg install flatpak xdg-desktop-portal-gtk`
    > It was unnecessary as they were already installed.
-   Added the flapak repo.
    -   `sudo flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo`
-   Installed Flatpak `Zoom` by `flatpak install flathub us.zoom.Zoom -y`
-   Installed Spotify Flatpak: `flatpak install flathub com.spotify.Client -y`
-   Installed xclip: `sudo eopkg it xclip -y`
-   Installed VLC: `sudo eopkg it vlc -y`
-   Installed OBS Studio Flatpak: `flatpak install flathub com.obsproject.Studio -y`
-   Installed Vim: `sudo eopkg it vim -y`
-   Installed VS Code: `sudo eopkg it vscode -y`
-   Installed `xkill`: ` sudo eopkg it xkill -y`
-   Added Keyboard shortcut `Ctrl + Alt + K` for `xkill`
-   Installing budgie-screenshot-applet dependences:
    -   `sudo eopkg it budgie-desktop-devel libgnome-desktop-devel libjson-glib-devel libsoup-devel vala`
-   Installing budgie-screenshot-applet:
    -   `sudo eopkg it budgie-screenshot-applet -y`
-   Rebooted the system.
-   Added `Screenshot` applet to right hand side of the taskbar using `Budgie Desktop Settings`
-   Installed Opera Browser: `sudo eopkg it opera -y`
-   Installed Chrome using `Software Centre` -> `Third Party Apps`
-   Installed Sublime Text using `Software Centre` -> `Third Party Apps`
-   Copied Kali's bashrc to `.bashrc` and changed the prompt.
-   Copied Fedora 34's `rksalias.txt` to `.rksalias` for the list of aliases
-   Configured git setup using `gitsetup` function from my post install scripts.

-   #### Installed Android Studio

    -   Created a folder `Android` at `~/` location.
    -   Downloaded the latest version of Android Studio from the official site.
    -   Extracted the contents of that archive in the Downloads folder first.
    -   In that extracted folder, there is another folder `android-studio`.
    -   I moved `android-studio` to the `~/Android` folder.
    -   So, the directory structure looks somewhat like this

        ```nim
        ~/Android
            └── android-studio
        ```

    -   Executed this command:

        ```
        ~/Android/android-studio/bin/studio.sh
        ```

    -   Went through custom install of Android Studio.
    -   I will add them in a separate repo.
    -   Created a AVD with the following config:
        -   Pixel (with PlayStore)
        -   1080 x 1920 (420 dpi)
        -   API 27
        -   Target: Android 8.1 (Oreo)

-   #### Installed Anydesk

    -   `sudo eopkg bi --ignore-safety https://raw.githubusercontent.com/getsolus/3rd-party/03c0a9ac6de646922ab47ee0e52c303076aefce1/network/util/anydesk/pspec.xml`
    -   `sudo eopkg it anydesk-6.1.1-28-1-x86_64.eopkg`
    -   `rm anydesk-6.1.1-28-1-x86_64.eopkg -y`

-   #### Installed Microsoft Core Fonts

    -   `sudo eopkg bi --ignore-safety https://raw.githubusercontent.com/getsolus/3rd-party/master/desktop/font/mscorefonts/pspec.xml -y`
    -   `sudo eopkg it mscorefonts-1.3-3-1-x86_64.eopkg`
    -   `rm mscorefonts-1.3-3-1-x86_64.eopkg -y`

-   Installed Fira Code Font: `sudo eopkg it font-firacode-ttf -y`
-   Installed Xpad (Linux alternative to StickyNotes): `sudo eopkg it xpad -y`
