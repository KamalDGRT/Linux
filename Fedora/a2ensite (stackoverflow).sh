#!bin/bash
# Enable a site, just like the a2ensite command.
# Creating directory to store the output files

SITES_AVAILABLE_CONFIG_DIR="/etc/httpd/sites-available";
SITES_ENABLED_CONFIG_DIR="/etc/httpd/sites-enabled";

if [ $1 ]; then
  if [ -f "${SITES_ENABLED_CONFIG_DIR}/${1}" ]; then
    echo "Site ${1} was already enabled!";
  elif [ ! -w $SITES_ENABLED_CONFIG_DIR ]; then
    echo "You don't have permission to do this. Try to run the command as root."
  elif [ -f "${SITES_AVAILABLE_CONFIG_DIR}/${1}" ]; then
    echo "Enabling site ${1}...";
    ln -s $SITES_AVAILABLE_CONFIG_DIR/$1 $SITES_ENABLED_CONFIG_DIR/$1
    echo "done!"
 else
   echo "Site not found!"
fi
else
  echo "Please, inform the name of the site to be enabled."
fi
