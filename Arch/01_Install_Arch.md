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
[iwd] 
```

### Partitions

Here is how I am going to partition my 1TB HDD.

| Partition Name | Partition Size | Mount Point |
| -------------- | -------------- | ----------- |
| /dev/sda1      | 500M           | /boot/EFI   |
| /dev/sda2      | 100G           | /           |
| /dev/sda3      | 600G           | /home       |
| /dev/sda4      | Remaining size | /mywin      |

I am just planning before the actual installation begins.
