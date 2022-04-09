# Solus OS (GNOME) Logs

### August 16, 2021

-   Installed GNOME Edition of Solus.
-   Fresh `neofetch` output:

![Neofetch](https://i.imgur.com/L8KSB9z.png)

-   RAM usage is slightly higher than Budgie.
-   In Budgie, the background image used to be there in the screenshot. It
    is good to see that it is not the same case in `GNOME`.
-   NVIDIA drivers got installed correctly too!

![NVIDIA](https://i.imgur.com/yBqSpJn.png)

-   Audio output switches automatically too.
-   Comes with bunch of extensions pre installed.

![Extensions](https://i.imgur.com/bFxLRre.png)

---

-   Created `zoom.desktop` in `/usr/share/applications/`
-   Had to manually download the icon.
-   Created the Icon folder inside `LEO/zoom`.
-   pasted the downloaded icon to that `Icon` folder.

```conf
[Desktop Entry]
Comment=Zoom Client for Solus
Name=Zoom Client
Exec=/home/kamal/LEO/zoom/ZoomLauncher
Icon=/home/kamal/LEO/zoom/icon/zoom.png
Encoding=UTF-8
Terminal=false
Type=Application
```

![zoom](https://i.imgur.com/sUf9rCf.png)

---

-   Does not have raven by default
-   Pro: Able to go left and right in app switching
-   Con: it is grouping the windows of one app
-   In budgie each window of an app was like an separate app

---

-   Manually installed sublime text.

```
wget 'https://download.sublimetext.com/sublime_text_build_4113_x64.tar.xz'
```

-   Extracted and moved `sublime_text` to `/home/kamal/LEO/` folder.
-   Created `sublime.desktop` in `/usr/share/applications/`.

```conf
[Desktop Entry]
Version=1.0
Type=Application
Name=Sublime Text
GenericName=Text Editor
Comment=Sophisticated text editor for code, markup and prose
Exec=/home/kamal/LEO/sublime_text/sublime_text %F
Terminal=false
MimeType=text/plain;
Icon=/home/kamal/LEO/sublime_text/Icon/256x256/sublime-text.png
Categories=TextEditor;Development;
StartupNotify=true
Actions=new-window;new-file;

[Desktop Action new-window]
Name=New Window
Exec=/home/kamal/LEO/sublime_text/sublime_text --launch-or-new-window
OnlyShowIn=Unity;

[Desktop Action new-file]
Name=New File
Exec=/home/kamal/LEO/sublime_text/sublime_text --command new_file
OnlyShowIn=Unity;
```

-   Created a symbolic link for sublime text

```sh
sudo ln -s /home/kamal/LEO/sublime_text/sublime_text /usr/bin/subl
```

---

-   added the following lines to bashrc

```sh
snap_binaries='/snap/bin'
export PATH="${snap_binaries}:${PATH}"
```

-   Installed spotify using snap

```
sudo snap install spotify
```

-   Added flathub remote for flatpaks

```
sudo flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
```

---

-   Installed OBS studio

```
flatpak install flathub com.obsproject.Studio -y
```

-   Installed Microsoft core fonts:

```
sudo eopkg bi --ignore-safety https://raw.githubusercontent.com/getsolus/3rd-party/master/desktop/font/mscorefonts/pspec.xml -y
```

```
sudo eopkg it mscorefonts-1.3-3-1-x86_64.eopkg
```

```
rm mscorefonts-1.3-3-1-x86_64.eopkg
```

---

-   Installed xkill

```
sudo eopkg it xkill -y
```

-   Installed xclip

```
sudo eopkg it xclip -y
```

-   Installed git

```
sudo eopkg it git -y
```

-   Installed Telegram:

```
sudo eopkg it telegram -y
```

-   Installed VLC

```
sudo eopkg it vlc -y
```

-   Installed vim

```
sudo eopkg it vim -y
```

---

### August 17, 2021

-   Installed Fira Code Font:

```
sudo eopkg it font-firacode-ttf -y
```

-   Installed Xpad (Linux alternative to StickyNotes):

```
sudo eopkg it xpad -y
```

-   Installed VS Code

```
sudo eopkg it vscode -y
```

-   Created a symbolic link:

```
sudo ln -s /usr/bin/code-oss /usr/bin/code
```

-   Ran the `gitsetup` script.

---

### August 18, 2021

-   Installed chrome-gnome-shell

```
sudo eopkg it chrome-gnome-shell -y
```

-   Installing XAMPP

```
wget -O ~/Downloads/xampp-linux.run 'https://www.apachefriends.org/xampp-files/8.0.9/xampp-linux-x64-8.0.9-0-installer.run'
```

-   The remaining instructions are same as Budgie.

-   Installed qBittorrent

```
sudo eopkg it qbittorrent -y
```

---

### August 19, 2021

-   Log: Tested the Zoom and sublime install Script in a freshly
    installed Solus GNOME. Works ✅

-   Installed virtualenv
-   It is a tool to create isolated 'virtual' python environments

```
sudo eopkg install virtualenv -y
```

---

### August 21, 2021

-   Changed root user password

```
sudo su
```

-   Typed in the password for the normal user here.
-   Then it went into root user prompt.

```
passwd
```

-   Then I set the root user password.
-   So, yep. It is changed.

---

-   Removed the xampp files.

```
sudo rm -rf /opt/lampp
```

-   System update was available.

```
sudo eopkg update -y
```

-   Power off.
-   Power on.
-   121 packages updated.

---

-   Installed LAMP setup with phpmyadmin.

Reference taken:
https://www.linuxhelp.com/how-to-install-lamp-on-solus-3-os

-   for phpmyadmin, I look at the LAMP setup in Kali and modified it for
    Solus through trial and error.

-   Added the script to install LAMP stack in `post_install_solus.sh`.
-   Have to test out the yii2 stuff with virtual hosting stuff.
-   Creating a separate file for `mod_rewrite`

```sh
echo "LoadModule rewrite_module lib64/httpd/mod_rewrite.so" | sudo tee /etc/httpd/conf.d/rewrite.conf
```

-   Created symbolic link for `pip3`

```sh
sudo ln -s /usr/bin/pip3 /usr/bin/pip
```

---

### August 22, 2021

-   Log: Tested the LAMP script in Manoj's Solus GNOME. Works ✅

-   Fix npm permission issue or in other words: configure npm

```sh
sudo chown -R $(whoami) ~/.npm

mkdir ~/.npm-global
npm config set prefix '~/.npm-global'
{
    echo -e "nmplocation='~/.npm-global/bin'"
    echo -e 'export PATH="${nmplocation}:${PATH}"'
} | tee -a ~/.bashrc

source ~/.profile
```

-   Add them to a script and exeucte it.
-   Log: Virtual hosting works ✅

---

### August 25, 2021

-   Configuring `phpMyAdmin`

-   Clicked on `Find out why`.

![Step1](https://i.imgur.com/FWaXU4x.png)

-   Clicked on `Create`.

![Step2](https://i.imgur.com/o7QiGmW.png)

-   After clicking the `Create`, got this as output.

![Step3](https://i.imgur.com/gV8yXqH.png)

---

### August 30, 2021

-   Log: VS code keeps crashing today.
-   removing it.

```
sudo eopkg remove vscode -y
```

-   Automation begins now.
-   Archive file download link:

```
https://code.visualstudio.com/sha/download?build=stable&os=linux-x64
```

-   gpg key? maybe.

```
https://packages.microsoft.com/keys/microsoft.asc
```

-   `code.desktop` entry found in the `.deb` file.

```conf
[Desktop Entry]
Name=Visual Studio Code
Comment=Code Editing. Redefined.
GenericName=Text Editor
Exec=/usr/share/code/code --unity-launch %F
Icon=com.visualstudio.code
Type=Application
StartupNotify=false
StartupWMClass=Code
Categories=Utility;TextEditor;Development;IDE;
MimeType=text/plain;inode/directory;application/x-code-workspace;
Actions=new-empty-window;
Keywords=vscode;

[Desktop Action new-empty-window]
Name=New Empty Window
Exec=/usr/share/code/code --new-window %F
Icon=com.visualstudio.code
```

-   Have to edit this for the script :))

-   Installation started

![VSCode1](https://i.imgur.com/9phESO1.png)

-   Extraction complete.

![VSCode](https://i.imgur.com/3w00qjm.png)

-   Creating desktop entry.
-   Done

![VSCode](https://i.imgur.com/io66x4S.png)

-   Able to see the icon.

![VSCode](https://i.imgur.com/riZiiIL.png)

-   Opening the newly installed VSCode. Works.

![VSCode](https://i.imgur.com/AzTuHya.png)

-   Log: VS Code script works ✅

---

### August 31, 2021

-   Log: Model class created from KamalSQL works ✅
-   Now simple ORMs can be built using this model :))
-   ORM = object relational mapping

---

### September 2, 2021

-   Installed GIMP

```
sudo eopkg install gimp -y
```

-   Deployed Festus to Herkou :YayJumpy:

---

### September 6, 2021

-   Installed Inkscape

```
sudo eokpg it inkscape -y
```

-   Installed ansible

```
sudo eopkg it ansible -y
```

---

### September 7, 2021

-   Installed `xinput`

```
sudo eopkg it xinput -y
```

---

### September 10, 2021

-   Setting up KVM in solus.

-   First, ensure `/usr/local/bin/` exists.

```
sudo mkdir -p /usr/local/bin
```

-   Install dependencies for KVM virtualization

```
sudo eopkg install libvirt qemu virt-manager -y
```

-   Add your current user to the `libvirt` group:

```
sudo usermod -a -G libvirt $(whoami)
```

```
newgrp libvirt
```

-   Then start the libvirt daemon to enable the `libvirt`
    virtualization management system:

```
sudo systemctl start libvirtd.service
```

-   If you want to have libvirt daemon start automatically on boot, run:

```
sudo systemctl enable libvirtd.service
```

-   Restart the system.

---

### September 13, 2021

-   Installed tigervnc and remmina

```
sudo eopkg it remmina tigervnc -y
```

---

### September 14, 2021

-   Installed pptp packages

```
sudo eopkg it pptp networkmanager-pptp -y
```

-   Installed Lutris

```
sudo eopkg install lutris -y
```

---

### September 25, 2021

-   Installed GCC and G++ compiler

```
sudo eopkg it g++ gcc -y
```

---

### September 26, 2021

-   Installed and configured DosBox for TurboCPP

```
sudo eopkg it dosbox -y
```

-   Installed Development pacakges

```
sudo eopkg upgrade -y
```

```
sudo eopkg install -c system.devel
```

---

### October 3, 2021

-   Installed Mcomix

```
sudo eopkg it mcomix -y
```

---

### October 5, 2021

-   Installed Shotcut

```
sudo eopkg it shotcut -y
```

---

### October 26, 2021

-   Removed a lot of unused packages.

---

### October 27, 2021

-   Added function to update sublime text

-   To Ungroup the Apps in the GNOME DE,

Go to `Settings` -> `Keyboard` -> `Keyboard Shortcuts` -> `Navigation`
-> `Switch Windows`.

-   Set the `Switch Windows` to `Alt` + `Tab`
-   This will prompt you to replace the existing shortcut.
-   Choose `Replace`.

---

### November 9, 2021

-   Installed ZSH Shell

```
sudo eopkg it zsh zsh-autosuggestions zsh-syntax-highlighting -y
```

-   After doing that, configured the Prompt to look like Kali's.
-   Referred to this link for the same:

```
https://gitlab.com/kalilinux/packages/kali-defaults/-/blob/kali/master/etc/skel/.zshrc
```

---

### November 21, 2021

-   VS Code Setup
-   File Icon Theme -> Bearded Icons - BeardedBear
-   Product Icons -> Minimalist Product Icon Theme - ElAndandKumar
-   Color Theme -> Dracular official (Dracula Soft) - Dracula Theme

#### Extensions

-   indent rainbow - oderwat
-   bracket pair colorizer - coenraads
-   prettier - prettier
-   rainbow brackets - 2gua
-   rainbow csv - mechatroner

-   Created a new GitHub account
-   Configured the newly created account in Solus through the `gitsetup`
-   Added the SSH key in the LeoDGRT GitHub account.
