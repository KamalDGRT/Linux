#!/bin/bash

write_vhost_content() {
    printf "\nDocument Root:$1\nServer Name:$2\n\n"

    content="
<VirtualHost *:80>
ServerName $2
DocumentRoot \"$1\"

    <Directory \"$1\">
        # use mod_rewrite for pretty URL support
        RewriteEngine on
        # If a directory or a file exists, use the request directly
        RewriteCond %{REQUEST_FILENAME} !-f
        RewriteCond %{REQUEST_FILENAME} !-d
        # Otherwise forward the request to index.php
        RewriteRule . index.php
        # use index.php as index file
        DirectoryIndex index.php
        # ...other settings...
        # Apache 2.4
        Require all granted

        ## Apache 2.2
        # Order allow,deny
        # Allow from all
    </Directory>

</VirtualHost>


"

    echo "$content" | sudo tee -a /etc/httpd/conf.d/httpd-vhosts.conf
    echo -e "\n# 127.0.0.1    $2\n" | sudo tee -a /etc/hosts
}

if [[ "$1" == "--help" ]]; then
    echo "Usage: genvhost <DocumentRoot> <ServerName>"
    exit 0
else
    write_vhost_content "$1" "$2"
    sudo systemctl restart httpd
fi
