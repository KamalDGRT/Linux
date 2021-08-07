#!/bin/sh
if [[ $(id -u) -ne 0 ]] ; then echo "[ERROR] Script needs to be run as root." ; exit 1 ; fi
{
printf "\n[INFO] Downloading Firefox\n\n"
wget https://download.mozilla.org/?product=firefox-latest-ssl&os=linux64&lang=en-US
wait
printf "\n[INFO] Download Complete\n\n"
mv firefox-latest-ssl&os=linux64&lang=en-US firefox.tar.bz2
wait
tar -xf firefox.tar.bz2
wait
mv firefox /opt/
wait
{
	echo "[Desktop Entry]"
	echo "Encoding=UTF-8"
	echo "Type=Application"
	echo "Terminal=False"
	echo "Exec=/opt/firefox/firefox"
	echo "Name=Firefox"
	echo "Icon=/opt/firefox/browser/chrome/icons/default/default128.png"
} >> /usr/share/applications/firefox.desktop &&
printf "\n\n[SUCCESS] Firefox installed successfully"
} || 
{
printf "\n\n[ERROR] Could not install firefox. Exiting..."
}
