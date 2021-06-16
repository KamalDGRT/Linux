# Garuda Soaring Eagle (GNOME)

### Setting up LAMP Stack + VirtualHost for Yii2

This setup guide will walk you through installing and configuring Apache
MySQL, PHP (LAMP) 2021 (PHP Version 8).

LAMP is the the acronym of Linux, Apache, MySQL/MariaDB, PHP/Perl.

###### Tested on

-   Manjaro Linux x86_64
-   Arch Linux x86_64
-   Garuda Soaring Eagle x86_64

---

#### Step 1: Update your system

Run the following command as root user to update your Arch-Based Linux:

```js
sudo pacman -Syyu
```

---

#### Step 2: Install Apache

-   After updating the system, install Apache web server using the command:

```js
sudo pacman -S apache
```

---

-   Edit the `/etc/httpd/conf/httpd.conf` file

```js
sudo nano /etc/httpd/conf/httpd.conf
```

---

-   Search and comment out the following line if it is not already:

```js
[...]
# LoadModule unique_id_module modules/mod_unique_id.so
[...]
```

---

-   Save and close the file.

-   Enable Apache service to start at boot:

```bash
sudo systemctl enable httpd
```

---

-   Restart the Apache service:

```js
sudo systemctl restart httpd
```

---

-   Verify the status of Apache:

```js
sudo systemctl status httpd
```

---

###### Sample Output

```js
● httpd.service - Apache Web Server
     Loaded: loaded (/usr/lib/systemd/system/httpd.service; enabled; vendor preset: disabled)
     Active: active (running) since Thu 2021-06-10 08:12:43 IST; 49min ago
   Main PID: 595 (httpd)
      Tasks: 6 (limit: 9308)
     Memory: 56.4M
        CPU: 107ms
     CGroup: /system.slice/httpd.service
             ├─595 /usr/bin/httpd -k start -DFOREGROUND
             ├─775 /usr/bin/httpd -k start -DFOREGROUND
             ├─776 /usr/bin/httpd -k start -DFOREGROUND
             ├─777 /usr/bin/httpd -k start -DFOREGROUND
             ├─778 /usr/bin/httpd -k start -DFOREGROUND
             └─779 /usr/bin/httpd -k start -DFOREGROUND

Jun 10 08:12:43 titan systemd[1]: Started Apache Web Server.
Jun 10 08:12:50 titan httpd[595]: AH00112: Warning: DocumentRoot [/etc/httpd/docs/dummy-host.example.com] does not exist
Jun 10 08:12:50 titan httpd[595]: AH00112: Warning: DocumentRoot [/etc/httpd/docs/dummy-host2.example.com] does not exist
Jun 10 08:12:50 titan httpd[595]: AH00558: httpd: Could not reliably determine the server's fully qualified domain name, using 127.0.1.1. Set the 'ServerName' directive globally to suppress thi>
```

---

-   ##### Testing Apache

-   Let us create a sample page in the Apache root directory, i.e `/srv/http`.

```bash
sudo nano /srv/http/index.html
```

---

-   Add the following lines:

```html
<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8" />
        <meta name="viewport" content="width=device-width, initial-scale=1" />
        <meta http-equiv="X-UA-Compatible" content="ie=edge" />
        <title>Welcome</title>
    </head>
    <body>
        <h2>Welcome to my Web Server test page</h2>
    </body>
</html>
```

---

-   Now, open your web browser and navigate to `http://localhost`

-   You will be seeing the output of the HTML code that we typed above.

---

#### Step 3: Install MariaDB

-   Run the following command to install MariaDB:

```js
sudo pacman -S mysql
```

```
:: There are 2 providers available for mysql:
:: Repository extra
   1) mariadb
:: Repository community
   2) percona-server

Enter a number (default=1):
```

-   Press `Enter` key in the keyboard.

```js
resolving dependencies...
looking for conflicting packages...

Packages (1) mariadb-10.5.10-1

Total Installed Size:  235.54 MiB

:: Proceed with installation? [Y/n]
```

-   Press `y` or `Y`.

-   And then it goes on to show an output something like the one below:

```js
:: Proceed with installation? [Y/n] y
(1/1) checking keys in keyring        [---------------------] 100%
(1/1) checking package integrity      [---------------------] 100%
(1/1) loading package files           [---------------------] 100%
(1/1) checking for file conflicts     [---------------------] 100%
(1/1) checking available disk space   [---------------------] 100%
:: Processing package changes...
(1/1) installing mariadb              [---------------------] 100%

:: You need to initialize the MariaDB data directory prior to starting
   the service. This can be done with mariadb-install-db command, e.g.:
   mariadb-install-db --user=mysql --basedir=/usr --datadir=/var/lib/mysql
Optional dependencies for mariadb
    cracklib: for cracklib plugin [installed]
    curl: for ha_s3 plugin [installed]
    galera: for MariaDB cluster with Galera WSREP
    python-mysqlclient: for myrocks_hotbackup
    perl-dbd-mariadb: for mariadb-hotcopy, mariadb-convert-table-format and mariadb-setpermission
:: Running post-transaction hooks...
( 1/10) Syncing all file systems...
( 2/10) Creating system user accounts...
( 3/10) Reloading system manager configuration...
( 4/10) Creating temporary files...
Failed to write file "/sys/module/pcie_aspm/parameters/policy": Operation not permitted
error: command failed to execute correctly
( 5/10) Arming ConditionNeedsUpdate...
( 6/10) Foreign/AUR package notification
snapd 2.51-1
( 7/10) Orphaned package notification...
botan 2.18.1-1
cmake 3.20.3-1
electron 12.0.9-1
go 2:1.16.5-1
go-tools 4:0.1.2-1
gtkspell3 3.0.10-2
kfiredragonhelper 5.0.6-1
libcurl-gnutls 7.77.0-1
libzip 1.7.3-2
lua51 5.1.5-9
mujs 1.1.2-1
oniguruma 6.9.7.1-1
python-docutils 0.16-4
python-flask-compress 1.8.0-1
python-flask-gravatar 0.5.0-5
python-flask-migrate 3.0.0-1
python-flask-paranoid 0.2-6
python-flask-security-too 4.0.1-1
python-gssapi 1.6.12-2
python-ldap3 2.9-1
python-pexpect 4.8.0-3
python-simplejson 3.17.2-4
python-sqlparse 0.4.1-3
python-sshtunnel 0.4.0-1
qtkeychain-qt5 0.12.0-1
ripgrep 12.1.1-1
rnnoise 0.4.1-1
stunnel 5.59-1
swig 4.0.2-2
wireplumber 0.3.96-1
xosd 2.2.14-10
( 8/10) Checking for .pacnew and .pacsave files...
.pac* files found:
/etc/httpd/conf/httpd.conf.pacsave
/etc/httpd/conf/extra/httpd-vhosts.conf.pacsave
/etc/pacman.conf.pacnew
/etc/pacman.d/mirrorlist.pacnew
/etc/paru.conf.pacnew
/etc/systemd/system.conf.pacnew
/etc/systemd/user.conf.pacnew
Please check and merge
( 9/10) Updating pkgfile database...
(10/10) Syncing all file systems...
```

---

-   You need to initialize the MariaDB data directory prior to starting
    the service. This can be done with `mariadb-install-db` command:

```js
sudo mysql_install_db --user=mysql --basedir=/usr --datadir=/var/lib/mysql
```

---

-   The above command will show an output similar to this:

```js
Installing MariaDB/MySQL system tables in '/var/lib/mysql' ...
OK

To start mysqld at boot time you have to copy
support-files/mysql.server to the right place for your system


Two all-privilege accounts were created.
One is root@localhost, it has no password, but you need to
be system 'root' user to connect. Use, for example, sudo mysql
The second is mysql@localhost, it has no password either, but
you need to be the system 'mysql' user to connect.
After connecting you can set the password, if you would need to be
able to connect as any of these users with a password and without sudo

See the MariaDB Knowledgebase at https://mariadb.com/kb or the
MySQL manual for more instructions.

You can start the MariaDB daemon with:
cd '/usr' ; /usr/bin/mysqld_safe --datadir='/var/lib/mysql'

You can test the MariaDB daemon with mysql-test-run.pl
cd '/usr/mysql-test' ; perl mysql-test-run.pl

Please report any problems at https://mariadb.org/jira

The latest information about MariaDB is available at https://mariadb.org/.
You can find additional information about the MySQL part at:
https://dev.mysql.com
Consider joining MariaDB's strong and vibrant community:
https://mariadb.org/get-involved/
```

---

-   Enable MySQL service to start at boot:

```bash
sudo systemctl enable mysqld
```

---

-   Start the MySQL service:

```js
sudo systemctl start mysqld
```

---

-   You can verify whether MariaDB is running or not using command:

```js
sudo systemctl status mysqld
```

---

-   The above command will show an output similar to this:

```js
● mariadb.service - MariaDB 10.5.10 database server
     Loaded: loaded (/usr/lib/systemd/system/mariadb.service; enabled; vendor preset: disabled)
     Active: active (running) since Sat 2021-06-12 00:10:17 IST; 1min 17s ago
       Docs: man:mariadbd(8)
             https://mariadb.com/kb/en/library/systemd/
    Process: 345550 ExecStartPre=/bin/sh -c systemctl unset-environment _WSREP_START_POSITION (code=exited, status=0/SUCCESS)
    Process: 345618 ExecStartPre=/bin/sh -c [ ! -e /usr/bin/galera_recovery ] && VAR= ||   VAR=`cd /usr/bin/..; /usr/bin/galera_recovery`; [ $? -eq 0 ]   && systemctl set-environment _WSREP_START_POSITION=$VAR || exit 1 (code=exited>
    Process: 345749 ExecStartPost=/bin/sh -c systemctl unset-environment _WSREP_START_POSITION (code=exited, status=0/SUCCESS)
   Main PID: 345656 (mariadbd)
     Status: "Taking your SQL requests now..."
      Tasks: 8 (limit: 9308)
     Memory: 68.8M
        CPU: 182ms
     CGroup: /system.slice/mariadb.service
             └─345656 /usr/bin/mariadbd

Jun 12 00:10:17 titan mariadbd[345656]: 2021-06-12  0:10:17 0 [Note] InnoDB: File './ibtmp1' size is now 12 MB.
Jun 12 00:10:17 titan mariadbd[345656]: 2021-06-12  0:10:17 0 [Note] InnoDB: 10.5.10 started; log sequence number 45106; transaction id 20
Jun 12 00:10:17 titan mariadbd[345656]: 2021-06-12  0:10:17 0 [Note] InnoDB: Loading buffer pool(s) from /var/lib/mysql/ib_buffer_pool
Jun 12 00:10:17 titan mariadbd[345656]: 2021-06-12  0:10:17 0 [Note] InnoDB: Buffer pool(s) load completed at 210612  0:10:17
Jun 12 00:10:17 titan mariadbd[345656]: 2021-06-12  0:10:17 0 [Note] Server socket created on IP: '::'.
Jun 12 00:10:17 titan mariadbd[345656]: 2021-06-12  0:10:17 0 [Note] Reading of all Master_info entries succeeded
Jun 12 00:10:17 titan mariadbd[345656]: 2021-06-12  0:10:17 0 [Note] Added new Master_info '' to hash table
Jun 12 00:10:17 titan mariadbd[345656]: 2021-06-12  0:10:17 0 [Note] /usr/bin/mariadbd: ready for connections.
Jun 12 00:10:17 titan mariadbd[345656]: Version: '10.5.10-MariaDB'  socket: '/run/mysqld/mysqld.sock'  port: 3306  Arch Linux
Jun 12 00:10:17 titan systemd[1]: Started MariaDB 10.5.10 database server.
```

---

-   ##### Setup MySQL/MariaDB root user password

As you may know, it is recommended to setup a password for database root user.

Run the following command to setup MariaDB root user password:

```js
sudo mysql_secure_installation
```

---

-   The above command will result in something like this:

```js
NOTE: RUNNING ALL PARTS OF THIS SCRIPT IS RECOMMENDED FOR ALL MariaDB
      SERVERS IN PRODUCTION USE!  PLEASE READ EACH STEP CAREFULLY!

In order to log into MariaDB to secure it, we'll need the current
password for the root user. If you've just installed MariaDB, and
haven't set the root password yet, you should just press enter here.

Enter current password for root (enter for none):
```

-   Like the above message in the terminal says: Press `Enter`.

```js
OK, successfully used password, moving on...

Setting the root password or using the unix_socket ensures that nobody
can log into the MariaDB root user without the proper authorisation.

You already have your root account protected, so you can safely answer 'n'.

Switch to unix_socket authentication [Y/n]
```

-   Press `Enter`.

```js
Enabled successfully!
Reloading privilege tables..
 ... Success!


You already have your root account protected, so you can safely answer 'n'.

Change the root password? [Y/n]
```

-   Press `Enter`.

```js
New password:
```

-   Enter a new password for the MySQL. You will be using this
    for the `phpMyAdmin` too. So, remember it.

```js
Re-enter new password:
```

-   Re-enter the password that you have typed above.

```js
Password updated successfully!
Reloading privilege tables..
 ... Success!


By default, a MariaDB installation has an anonymous user, allowing anyone
to log into MariaDB without having to have a user account created for
them.  This is intended only for testing, and to make the installation
go a bit smoother.  You should remove them before moving into a
production environment.

Remove anonymous users? [Y/n]
```

-   Press `Enter`.

```js
 ... Success!

Normally, root should only be allowed to connect from 'localhost'.  This
ensures that someone cannot guess at the root password from the network.

Disallow root login remotely? [Y/n]
```

-   Press `Enter`.

```js
 ... Success!

By default, MariaDB comes with a database named 'test' that anyone can
access.  This is also intended only for testing, and should be removed
before moving into a production environment.

Remove test database and access to it? [Y/n]
```

-   Press `Enter`.

```js
 - Dropping test database...
 ... Success!
 - Removing privileges on test database...
 ... Success!

Reloading the privilege tables will ensure that all changes made so far
will take effect immediately.

Reload privilege tables now? [Y/n]
```

-   Press `Enter`.

```js
 ... Success!

Cleaning up...

All done!  If you've completed all of the above steps, your MariaDB
installation should now be secure.

Thanks for using MariaDB!
```

---

### Step 4: Intalling PHP + PHP Extensions + phpMyAdmin

-   PHP

```js
sudo pacman -S php php-apache
```

---

-   PHP Extensions

```js
sudo pacman -S php-cgi php-fpm php-gd php-embed php-intl php-imap php-redis php-snmp
```

---

-   phpMyAdmin

```js
sudo pacman -S phpmyadmin
```

---

-   Composer: PHP Package manager

```js
sudo pacman -S composer
```

---

-   Now let us edit the configurations to make it all work.

-   After PHP is installed, we need to configure Apache PHP module.
    To do so, edit `/etc/httpd/conf/httpd.conf` file,

---

```js
sudo nano /etc/httpd/conf/httpd.conf
```

-   Find the following line and comment it out:

```js
[...]
# LoadModule mpm_event_module modules/mod_mpm_event.so
[...]
```

-   Uncomment or add the line:

```js
LoadModule mpm_prefork_module modules/mod_mpm_prefork.so
```

-   Then, add the following lines at the bottom for php8:

```js
LoadModule php_module modules/libphp.so
AddHandler php-script php
Include conf/extra/php_module.conf
```

-   To Enable the rewrite module in `httpd.conf`
    uncomment / add this line:

```js
LoadModule rewrite_module modules/mod_rewrite.so
```

-   Find the config that starts like `<Directory "/srv/http">`.
-   In that config, make the changes like this:

```java
AllowOverride All
```

![Image](https://i.imgur.com/NpB3XMM.png)

-   Save and close the file.

-   Restart the `httpd` service

```js
sudo systemctl restart httpd
```

---

-   ###### Test PHP

Now create a `test.php` file in the Apache root directory.

```js
sudo nano /srv/http/test.php
```

---

-   Add the following lines:

```php
<?php
phpinfo();
?>
```

-   Restart the `httpd` service.

```js
sudo systemctl restart httpd
```

-   Open up your web browser and navigate to `http://localhost/test.php`.

---

-   ##### Configuring phpMyAdmin

-   `phpMyAdmin` is a graphical MySQL/MariaDB administration tool
    that can be used to create, edit and delete databases.

-   Lets configure that. Edit `php.ini` file:

```js
sudo nano /etc/php/php.ini
```

-   Make sure the following lines are uncommented.

```js
[...]
extension=bz2
extension=gd
extension=iconv
extension=mysqli
extension=pdo_mysql
[...]
```

-   Save and close the file.

---

-   Next, create a configuration file for `phpMyAdmin`:

```js
sudo nano /etc/httpd/conf/extra/phpmyadmin.conf
```

-   Add the following lines:

```xml
Alias /phpmyadmin "/usr/share/webapps/phpMyAdmin"
<Directory "/usr/share/webapps/phpMyAdmin">
DirectoryIndex index.php
AllowOverride All
Options FollowSymlinks
Require all granted
</Directory>
```

---

-   Then, open Apache configuration file:

```js
sudo nano /etc/httpd/conf/httpd.conf
```

-   Add the following line at the end:

```nim
Include conf/extra/phpmyadmin.conf
```

-   Save and close the file.

-   Restart the `httpd` service again.

```js
sudo systemctl restart httpd
```

---

-   ##### Test phpMyAdmin

-   Open your browser and navigate to `http://localhost/phpmyadmin`.

-   You might see an error that says "The configuration file now needs
    a secret passphrase (blowfish_secret)" at the bottom of phpMyAdmin
    dashboard.

-   To get rid of this error, edit
    `/etc/webapps/phpmyadmin/config.inc.php` file.

```js
sudo nano /etc/webapps/phpmyadmin/config.inc.php
```

-   Find the following line and specify bluefish secret passphrase:

```php
$cfg['blowfish_secret'] = '`MyP@$S`';
/*
    YOU MUST FILL IN THIS FOR COOKIE AUTH!
    Length of the passphrase: 32 Characters is preferred.
/*
```

-   Save and close the file. Restart Apache service.

```
sudo systemctl restart httpd
```

-   The error will be gone now.

> That’s all for now. At this stage, you have a working
> LAMP stack, and is ready to host your websites.

---

### Step 5: Virtual Hosting of Yii2 project

-   Open `httpd.conf` file.

```js
sudo nano /etc/httpd/conf/httpd.conf
```

-   Uncomment the line that has the `httpd-vhosts.conf`

```js
[...]
# Virtual hosts
Include conf/extra/httpd-vhosts.conf
[...]
```

-   Restart the `httpd` service.

```js
sudo systemctl restart httpd
```

-   Open the `httpd-vhosts.conf` file.

```js
sudo nano /etc/httpd/conf/extra/httpd-vhosts.conf
```

-   Remove the default hosting configurations. It will look
    something like this:

```xml
<VirtualHost *:80>
    ServerAdmin webmaster@dummy-host.example.com
    DocumentRoot "/etc/httpd/docs/dummy-host.example.com"
    ServerName dummy-host.example.com
    ServerAlias www.dummy-host.example.com
    ErrorLog "/var/log/httpd/dummy-host.example.com-error_log"
    CustomLog "/var/log/httpd/dummy-host.example.com-access_log" common
</VirtualHost>

<VirtualHost *:80>
    ServerAdmin webmaster@dummy-host2.example.com
    DocumentRoot "/etc/httpd/docs/dummy-host2.example.com"
    ServerName dummy-host2.example.com
    ErrorLog "/var/log/httpd/dummy-host2.example.com-error_log"
    CustomLog "/var/log/httpd/dummy-host2.example.com-access_log" common
</VirtualHost>
```

---

-   #### Setting up the First Virtual Host: localhost

-   Add these at the end of the `httpd-vhosts.conf` file.
-   We are adding these lines to allow us to run the normal PHP project/stuff.

```xml
<VirtualHost *:80>
ServerName localhost
DocumentRoot "/srv/http"

    <Directory "/srv/http">
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
```

---

-   #### Setting up the Second Virtual Host

-   In Windows, we add the PHP stuff in the `xampp\htdocs` folder. In
    Arch Based distros, we add it in `/srv/http` directory.

-   Create a folder in that location with administrative permissions.

```js
sudo mkdir myproject
```

-   Now change the permissions for that folder.

```js
sudo chmod 777 -R myproject
```

-   Go inside that folder .

```js
cd myproject
```

-   Clone the yii2 project from GitHub or any other source.

-   I prefer the SSH way, so I am cloning this way. If you are comfortable
    with the HTTPS way, feel free to do the same.

```js
git clone git@github.com:KamalDGRT/yii2-portfolio.git
```

-   Now this will create a new folder inside `/srv/http/myproject/`.

-   So, we need to bring them all one step outside into the `myproject`.

-   This command will move all the normal files one step outside.

```js
mv -vf yii2-portfolio/* .
```

-   This command will move the hidden files one step outside.

```js
mv -vf yii2-portfolio/.* .
```

-   We now no longer the empty folder. So, lets remove that.

```js
rmdir yii2-portfolio
```

-   Do the usual steps for setting up the Yii2 Project

    -   Initialize it in either Production / Development mode
    -   `composer update`
    -   Change the database configuration in `common/config/main-local.php`
    -   `php yii migrate`

-   Lets change permissions for the runtime folders.

-   Open the terminal at the root directory of the project and execute:

```js
chmod 777 -R assets/
```

```js
chmod 777 -R admin/assets/
```

```js
chmod 777 -R frontend/runtime
```

```js
chmod 777 -R backend/runtime
```

---

-   Now let's add the virtual host for the project in `httpd-vhosts.conf`.

```xml
<VirtualHost *:80>
ServerName mynewyii2project.testing
DocumentRoot "/srv/http/myproject"

    <Directory "/srv/http/myproject">
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
```

-   Replace `mynewyii2project.testing` in `ServerName` with the URL that you would like
    to execute yii2 project.

-   Replace `myproject` with the project folder name.

-   Save and close the `httpd-vhosts.conf` file.

---

-   #### Adding the URL to hosts

-   Open `/etc/hosts` file and add your project URL.

```js
sudo nano /etc/hosts
```

-   In that add this line below the line that has this IP: `127.0.1.1`:

```
127.0.1.1     mynewyii2project.testing
```

-   You can notice that it is the same URL that we gave in `httpd-vhosts.conf`.

-   So, yeah. It should be the same one in order to make the virtual host work.

-   Restart the `httpd` service.

```js
sudo systemctl restart httpd
```

---

-   Now, open your web browser and navigate to `http://mynewyii2project.testing`

-   You will be seeing the output of the yii2 project code in that URL.

---
