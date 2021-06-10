# Garuda Soaring Eagle (GNOME)

### Setting up LAMP Stack + VirtualHost for Yii2

This setup guide will walk you through installing and configuring Apache
MySQL, PHP (LAMP) 2021 (PHP Version 8).

LAMP is the the acronym of Linux, Apache, MySQL/MariaDB, PHP/Perl.

###### Tested on

- Manjaro Linux x86_64
- Arch Linux x86_64
- Garuda Soaring Eagle x86_64

#### Step 1: Update your system

Run the following command as root user to update your Arch-Based Linux:

```js
sudo pacman -Syyu
```

#### Step 2: Install Apache

- After updating the system, install Apache web server using the command:

```js
sudo pacman -S apache
```

- Edit the `/etc/httpd/conf/httpd.conf` file

```js
sudo nano /etc/httpd/conf/httpd.conf
```

- Search and comment out the following line if it is not already:

```js
[...]
# LoadModule unique_id_module modules/mod_unique_id.so
[...]
```

- Save and close the file.

- Enable Apache service to start at boot:

```bash
sudo systemctl enable httpd
```

- Restart the Apache service:

```js
sudo systemctl restart httpd
```

- Verify the status of Apache:

```js
sudo systemctl status httpd
```

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

- ##### Testing Apache

- Let us create a sample page in the Apache root directory, i.e `/srv/http`.

```bash
sudo nano /srv/http/index.html
```

- Add the following lines:

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

- Now, open your web browser and navigate to `http://localhost`

- You will be seeing the output of the HTML code that we typed above.
