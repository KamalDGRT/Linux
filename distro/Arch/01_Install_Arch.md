# Arch Linux Install Instructions

### Disclaimer

> The following steps worked on my Laptop. So, when you try to follow these
> steps and ended up bricking your laptop, I am not responsible for it.
> You chose to setup a install on the go distro. Be patient.
> You are experimenting new stuff. That is good. But like all actions,
> they do have consequences. So, I hope you know what are doing.

This file contains the steps that I followed while installing
Arch Linux in my Laptop.

Here's the output of `neofetch` after installation:

`````nim
                   -`                    user@arch
                  .o+`                   -----------
                 `ooo/                   OS: Arch Linux x86_64
                `+oooo:                  Host: TUF Gaming FX505GD_FX505GD 1.0
               `+oooooo:                 Kernel: 5.12.8-arch1-1
               -+oooooo+:                Uptime: 51 mins
             `/:-:++oooo+:               Packages: 984 (pacman)
            `/++++/+++++++:              Shell: js 5.1.8
           `/++++++++++++++:             Resolution: 1920x1080
          `/+++ooooooooooooo/`           DE: GNOME 40.1
         ./ooosssso++osssssso+`          WM: Mutter
        .oossssso-````/ossssss+`         WM Theme: Adwaita
       -osssssso.      :ssssssso.        Theme: Adwaita-dark [GTK2/3]
      :osssssss/        osssso+++.       Icons: Adwaita [GTK2/3]
     /ossssssss/        +ssssooo/-       Terminal: gnome-terminal
   `/ossssso+/:-        -:/+osssso+-     CPU: Intel i5-8300H (8) @ 4.000GHz
  `+sso+:-`                 `.-/+oso:    GPU: Intel UHD Graphics 630
 `++:.                           `-/+/   GPU: NVIDIA GeForce GTX 1050 Mobile
 .`                                 `/   Memory: 984MiB / 7806MiB
`````

---

### Connecting the Laptop to WiFi

Connecting your laptop to a internet source is the very first thing that
you should do when you boot up your Arch Linux Live USB. This is because
you will be downloading various packages from the internet. So, if you
have a good stable internet, you won't be having much trouble
installing Arch.

Here's how I did it when I booted up from the Arch Linux Live USB:

- 1. Type `ip a`. This will list out the network devices.
- 1. Type `ip link set wlan0 up`
- 1. Type `systemctl enable --now dhcpcd.service`
- 1. Type `iwctl` in the Command Line Interface Installation screen.

```js
[root@archiso~] # iwctl
```

```js
[iwd] # device list
```

```js
[iwd] # station wlan0 get-networks
```

```js
[iwd] # station wlan0 connect <WiFi-Name>
```

Replace `<WiFi-Name>` with your WiFi Name.

Type your WiFi password.

```s
[iwd] # exit
```

---

### Partitions

- Here is how I am going to partition my 1TB HDD.

| Partition Name | Partition Size | Partition Type          | Mount Point |
| -------------- | -------------- | ----------------------- | ----------- |
| /dev/sda1      | 500M           | FAT32 Linux EFI Partion | /boot/EFI   |
| /dev/sda2      | 100G           | ext4 Linux File System  | /           |
| /dev/sda3      | 600G           | ext4 Linux File System  | /home       |
| /dev/sda4      | Remaining size | ext4 Linux File System  | /mywin      |

- I am just planning before the actual installation begins.
- I am using `cfdisk` command to partition my disk.
- You can use whatever command suits you.

After creating those partitions you need to create proper
file systems for them.

##### EFI Partition

```js
[root@archiso~] # mkfs.fat -F32 /dev/sda1
```

##### Root Partition

```js
[root@archiso~] # mkfs.ext4 /dev/sda2
```

##### Home Partition

```js
[root@archiso~] # mkfs.ext4 /dev/sda3
```

##### Separate Partition for backups

```js
[root@archiso~] # mkfs.ext4 /dev/sda4
```

---

### Creating Mount Points

```js
[root@archiso~] # mount /dev/sda2 /mnt
```

```js
[root@archiso~] # mkdir -p /mnt/boot/EFI
```

```js
[root@archiso~] # mkdir -p /mnt/home
```

```js
[root@archiso~] # mkdir -p /mnt/mywin
```

```js
[root@archiso~] # mount /dev/sda1 /mnt/boot/EFI
```

```js
[root@archiso~] # mount /dev/sda3 /home
```

```js
[root@archiso~] # mount /dev/sda4 /mywin
```

---

### Installing Base packages

```js
[root@archiso~] # pacstrap /mnt base linux linux-firmware nano
```

---

### Generating the `fstab` file

```js
[root@archiso~] # genfstab -U /mnt >> /mnt/etc/fstab
```

```js
[root@archiso~] # cat /mnt /etc/fstab
```

---

### Changing the mount point

```js
[root@archiso~] # arch-chroot /mnt
```

---

### Creating a Swap partition


```js
[root@archiso /] # fallocate -l 4GB /swapfile
```

```js
[root@archiso /] # chmod 600 /swapfile
```

```js
[root@archiso /] # mkswap /swapfile
```

```js
[root@archiso /] # swapon /swapfile
```

```js
[root@archiso /] # nano /etc/fstab
```

Add this in the end of the file:

```t
/swapfile    none    swap    0    0
```

---

### Adding Local TimeZone

```js
[root@archiso /] # ln -sf /usr/share/zoneinfo/Asia/Kolkata /etc/localtime
```

---

### Syncing the hardware and software clock


```js
[root@archiso /] # hwclock --systohc
```

---

### Generating locale(s)


```js
[root@archiso /] # nano /etc/locale.gen
```

Uncomment the locale that you want. I will be uncommenting:

```s
en_US.UTF-8 UTF-8
en_US  ISO-8859-1
```

```js
[root@archiso /] # locale-gen
```

```js
[root@archiso /] # nano /etc/locale.conf
```

```s
LANG=en_US.UTF-8
```

---

### Setting up the host configurations

```js
[root@archiso /] # nano /etc/hostname
```

```s
titan
```

```js
[root@archiso /] # nano /etc/hosts
```

```s
127.0.0.1        localhost
::1              localhost
127.0.1.1        titan.localdomain titan
```

---

### Installing GRUB and other important packages


```js
[root@archiso /] # pacman -S grub efibootmgr networkmanager network-manager-applet wireless_tools wpa_supplicant dialog os-prober mtools dosfstools base-devel linux-headers
```

```js
[root@archiso /] # grub-install --target=x86_64-efi --efi-directory=/boot/EFI --bootloader-id=GRUB
```

```js
[root@archiso /] # grub-mkconfig -o /boot/grub/grub.cfg
```

---

### Creating the root user password


```js
[root@archiso /] # passwd
```

---

### Exiting the mount point


```js
[root@archiso /] # exit
```

---

### Unmounting all the mount points


```js
[root@archiso ~] # umount -a
```

---

### Rebooting


```js
[root@archiso ~] # reboot
```

---

### Setting up the newly installed Arch Linux

Login as root user.

```js
[root@titan /] # systemctl enable --now NetworkManager
```

```js
[root@titan /] # nmtui
```

Scroll down and activate a connection.

---

#### Creating the normal user and giving him the sudo permissions


```js
[root@titan /] # useradd -m -G wheel kamal
```

```js
[root@titan /] # passwd kamal
```

```js
[root@titan /] # EDITOR=nano visudo
```

Uncomment the line that contains this:

```t
%wheel ALL=(ALL) ALL
```

---

#### Installing graphic driver packages

Do this step if you have NVIDIA graphic card in your system.

```js
[root@titan /] # pacman -S nvidia nvidia-utils nvidia-settings
```

---

#### Installing XORG windowing system

```js
[root@titan /] # pacman -S xorg xterm xorg-init
```

---

#### Installing GNOME Deskop Environment

```js
[root@titan /] # pacman -S gnome gnome-extra
```

```js
[root@titan /] # pacman -S gdm
```

```js
[root@titan /] # systemctl enable gdm
```

```js
[root@titan /] # systemctl start gdm
```

#### Updating the system and installing packages for audio

Login into the normal user.

```js
[kamal@titan ~] $ sudo pacman -Syyu
```

```js
[kamal@titan ~] $ sudo pacman -S neofetch bash-completion
```

```js
[kamal@titan ~] $ sudo pacman -S pulseaudio pulseaudio-alsa pavucontrol alsa-utils alsa-ucm-conf sof-firmware
```

```js
[kamal@titan ~] $ reboot
```

---
