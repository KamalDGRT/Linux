# LAMP Setup

## 1. Apache httpd : Install

Install Apache httpd to configure Web Server.

### [1] Apache httpd : Install

```
[root@www ~]# dnf -y install httpd

# rename or remove welcome page
[root@www ~]# mv /etc/httpd/conf.d/welcome.conf /etc/httpd/conf.d/welcome.conf.org
```

### [2] Configure httpd. Replace Server name to your own environment.

```
[root@www ~]# vi /etc/httpd/conf/httpd.conf

# line 89: change to admin's email address
ServerAdmin root@srv.world

# line 98: change to your server's name
ServerName www.srv.world:80

# line 147: change (remove [Indexes])
Options FollowSymLinks

# line 154: change
AllowOverride All

# line 167: add file name that it can access only with directory's name
DirectoryIndex index.html index.php index.cgi

# add follows to the end
# server's response header
ServerTokens Prod

[root@www ~]# systemctl enable --now httpd
```

### [3] If Firewalld is running, allow HTTP service. HTTP uses 80/TCP.

```
[root@www ~]# firewall-cmd --add-service=http --permanent
success
[root@www ~]# firewall-cmd --reload
success
```

### [4] Create a HTML test page and access to it from client PC with web browser. It's OK if following page is shown.

```
[root@www ~]# vi /var/www/html/index.html
<html>
<body>
<div style="width: 100%; font-size: 40px; font-weight: bold; text-align: center;">
Test Page
</div>
</body>
</html>
```

<hr>

## 2. Install PHP

Apache httpd : Use PHP Scripts <br>

Configure httpd to use PHP scripts.

### [1] Install PHP

```
[root@www ~]# dnf -y install php php-mbstring php-pear
```

### [2] After installing PHP, Restart httpd, it's OK to do it only.

```
[root@www ~]# systemctl restart httpd

# create PHPInfo test page
[root@www ~]# echo '<?php phpinfo(); ?>' > /var/www/html/info.php
```

### [3] Verify to access to PHPInfo test page from any client computer.

<hr>

## 3. Install phpMyAdmin.

Install phpMyAdmin to operate MariaDB on web browser from Clients.

```
[root@www ~]# dnf -y install phpMyAdmin php-mysqlnd php-mcrypt php-php-gettext

[root@www ~]# vi /etc/httpd/conf.d/phpMyAdmin.conf

# line 13: add access permission for your internal nwetwork if you need
Require ip 127.0.0.1 10.0.0.0/24

# line 19: add access permission for your internal nwetwork if you need
Require ip 127.0.0.1 10.0.0.0/24

[root@www ~]# systemctl restart httpd
```

<hr>

## 4. If SELinux is enabled, change policy.

```
[root@www ~]# setsebool -P httpd_can_network_connect on
[root@www ~]# setsebool -P httpd_execmem on
```

### [5] Access to [http://(your hostname or IP address)/phpmyadmin/] with web browser from any Clients which are in the Network you set to allow. Then phpMyAdmin Login form is shown, login with a MariaDB user. It needs you login as a user that password is set because [Unix_Socket] authentication is enabled by default and users with no password are not login.
