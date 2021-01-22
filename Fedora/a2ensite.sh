#!/bin/bash
if test -d /etc/httpd/sites-available && test -d /etc/httpd/sites-enabled  ; then
echo "-----------------------------------------------"
else
mkdir /etc/httpd/sites-available
mkdir /etc/httpd/sites-enabled
fi

avail=/etc/httpd/sites-available/$1.conf
enabled=/etc/httpd/sites-enabled/
site=`ls /etc/httpd/sites-available/`

if [ "$#" != "1" ]; then
                echo "Use script: a2ensite virtual_site"
                echo -e "\nAvailable virtual hosts:\n$site"
                exit 0
else

if test -e $avail; then
sudo ln -s $avail $enabled
else

echo -e "$avail virtual host does not exist! Please create one!\n$site"
exit 0
fi
if test -e $enabled/$1.conf; then

echo "Success!! Now restart Apache server: sudo systemctl restart httpd"
else
echo  -e "Virtual host $avail does not exist!\nPlease see available virtual hosts:\n$site"
exit 0
fi
fi
