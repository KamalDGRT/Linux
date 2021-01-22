#!/bin/bash
avail=/etc/httpd/sites-enabled/$1.conf
enabled=/etc/httpd/sites-enabled
site=`ls /etc/httpd/sites-enabled/`

if [ "$#" != "1" ]; then
                echo "Use script: a2dissite virtual_site"
                echo -e "\nAvailable virtual hosts: \n$site"
                exit 0
else

if test -e $avail; then
sudo rm  $avail
else
echo -e "$avail virtual host does not exist! Exiting!"
exit 0
fi

if test -e $enabled/$1.conf; then
echo "Error!! Could not remove $avail virtual host!"
else
echo  -e "Success! $avail has been removed!\nPlease restart Apache: sudo systemctl restart httpd"
exit 0
fi
fi
