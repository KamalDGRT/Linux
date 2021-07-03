#!bin/bash
# Disable a site, just like a2dissite command, from Apache2.

SITES_AVAILABLE_CONFIG_DIR="/etc/httpd/sites-available"
SITES_ENABLED_CONFIG_DIR="/etc/httpd/sites-enabled"

if [ $1 ]; then
    if [ ! -f "${SITES_ENABLED_CONFIG_DIR}/${1}" ]; then
        echo "Site ${1} was already disabled!"
    elif [ ! -w $SITES_ENABLED_CONFIG_DIR ]; then
        echo "You don't have permission to do this. Try to run the command as root."
    elif [ -f "${SITES_AVAILABLE_CONFIG_DIR}/${1}" ]; then
        echo "Disabling site ${1}..."
        unlink $SITES_ENABLED_CONFIG_DIR/$1
        echo "done!"
    else
        echo "Site not found!"
    fi
else
    echo "Please, inform the name of the site to be enabled."
fi
