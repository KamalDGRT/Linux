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
            `/++++/+++++++:              Shell: bash 5.1.8
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

```bash
[root@archiso~] # iwctl
```

```bash
[iwd] # device list
```

```bash
[iwd] # station wlan0 get-networks
```

```bash
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

```bash
[root@archiso~] # mkfs.fat -F32 /dev/sda1
```

##### Root Partition

```bash
[root@archiso~] # mkfs.ext4 /dev/sda2
```

##### Home Partition

```bash
[root@archiso~] # mkfs.ext4 /dev/sda3
```

##### Separate Partition for backups

```bash
[root@archiso~] # mkfs.ext4 /dev/sda4
```

---

### Creating Mount Points

```bash
[root@archiso~] # mount /dev/sda2 /mnt
```

```bash
[root@archiso~] # mkdir -p /mnt/boot/EFI
```

```bash
[root@archiso~] # mkdir -p /mnt/home
```

```bash
[root@archiso~] # mkdir -p /mnt/mywin
```

```bash
[root@archiso~] # mount /dev/sda1 /mnt/boot/EFI
```

```bash
[root@archiso~] # mount /dev/sda3 /home
```

```bash
[root@archiso~] # mount /dev/sda4 /mywin
```

### Installing Base packages.

```bash
[root@archiso~] # pacstrap /mnt base linux linux-firmware nano
```

```bash
[root@archiso~] # genfstab -U /mnt >> /mnt/etc/fstab
```

```bash
[root@archiso~] # cat /mnt /etc/fstab
```

```bash
[root@archiso~] # arch-chroot /mnt
```

```bash
[root@archiso /] # fallocate -l 4GB /swapfile
```

```bash
[root@archiso /] # chmod 600 /swapfile
```

```bash
[root@archiso /] # mkswap /swapfile
```

```bash
[root@archiso /] # swapon /swapfile
```

```bash
[root@archiso /] # nano /etc/fstab
```

Add this in the end of the file:

```t
/swapfile    none    swap    0    0
```

```bash
[root@archiso /] # ln -sf /user/share/zoneinfo/Asia/Kolkata /etc/localtime
```

```bash
[root@archiso /] # hwclock --systohc
```

```bash
[root@archiso /] # nano /etc/locale.gen
```

Uncomment the locale that you want. I will be uncommenting:

```s
en_US.UTF-8 UTF-8
```

```bash
[root@archiso /] # locale-gen
```

```bash
[root@archiso /] # nano /etc/locale.conf
```

```s
LANG=en_US.UTF-8
```

```bash
[root@archiso /] # nano /etc/hostname
```

```s
titan
```

```bash
[root@archiso /] # nano /etc/hosts
```

```s
127.0.0.1        localhost
::1              localhost
127.0.1.1        titan.localdomain titan
```

---

```bash
[root@archiso /] # pacman -S grub efibootmgr networkmanager network-manager-applet wireless_tools wpa_supplicant dialog os-prober mtools dosfstools base-devel linux-headers
```

```bash
[root@archiso /] # grub-install --target=x86_64-efi --efi-directory=/boot/EFI --bootloader-id=GRUB
```

```bash
[root@archiso /] # grub-mkconfig -o /boot/grub/grub.cfg
```

```bash
[root@archiso /] # passwd
```

```bash
[root@archiso /] # exit
```

```bash
[root@archiso ~] # umount -a
```

```bash
[root@archiso ~] # reboot
```

---

Login as root user.

```bash
[root@titan /] # systemctl start NetworkManager
```

```bash
[root@titan /] # nmtui
```

Scroll down and activate a connection.

```bash
[root@titan /] # useradd -m -G wheel kamal
```

```bash
[root@titan /] # passwd kamal
```

```bash
[root@titan /] # EDITOR=nano visudo
```

Uncomment the line that contains this:

```t
%wheel ALL=(ALL) ALL
```

```bash
[root@titan /] # pacman -S nvidia nvidia-utils nvidia-settings
```

```bash
[root@titan /] # pacman -S xorg xterm xorg-init
```

```bash
[root@titan /] # pacman -S gnome gnome-extra
```

```bash
[root@titan /] # pacman -S neofetch bash-completion
```

```bash
[root@titan /] # pacman -S pulseaudio pulseaudo-alsa pavucontrol alsa-utils alsa-ucm-conf sof-firmware
```

```bash
[root@titan /] # pacman -S gdm
```

```bash
[root@titan /] # systemctl enable gdm
```

```bash
[root@titan /] # systemctl start gdm
```

---

Login into the normal user.

```bash
[kamal@titan ~] # sudo pacman -Syyu
```

```bash
[kamal@titan ~] # reboot
```

---
