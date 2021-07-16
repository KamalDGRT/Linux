#!/bin/bash

clear

banner() {
    printf "\n\n\n"
    msg="| $* |"
    edge=$(echo "$msg" | sed 's/./-/g')
    echo "$edge"
    echo "$msg"
    echo "$edge"
}

pause() {
    read -s -n 1 -p "Press any key to continue . . ."
    clear
}

enable_xorg_windowing() {
    # Find & Replace part contributed by: https://github.com/nanna7077
    clear
    banner "Enable Xorg, Disable Wayland"
    printf "\n\nThe script will change the gdm default file."
    printf "\n\nThe file is: /etc/gdm/custom.conf\n"
    printf "\nIn that file, there will be a line that looks like this:"
    printf "\n\n     #WaylandEnable=false\n\n"
    printf "\nThe script will uncomment that line\n"

    SUBJECT='/etc/gdm/custom.conf'
    SEARCH_FOR='#WaylandEnable=false'
    sudo sed -i "/^$SEARCH_FOR/c\WaylandEnable=false" $SUBJECT
    printf "\n/etc/gdm/custom.conf file changed.\n"

    printf "\n\nGDM config updated. It will be reflected in the next boot.\n\n"
}

install_RPM_Fusion_Repos() {
    sudo dnf install https://mirrors.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm https://mirrors.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm -y
}

configure_NVIDIA_Drivers() {
    #  Reference: https://fedoramagazine.org/install-nvidia-gpu/
    # Make sure to upgrade the system
    #  sudo dnf update -y
    #  Update and reboot the system.

    # After reboot, install the Fedora's workstation repositories:
    sudo dnf install fedora-workstation-repositories

    # Next, enable the NVIDIA driver repository:
    sudo dnf config-manager --set-enabled rpmfusion-nonfree-nvidia-driver

    # Reboot again.

    #  After the reboot, verify the addition of the repository via the following command:
    sudo dnf repository-packages rpmfusion-nonfree-nvidia-driver info

    # If several NVIDIA tools and their respective specs are loaded, then proceed to the next step.
    #  If not, you may have encountered an error when adding the new repository and you should give it another shot.

    # Cleaning the remnant packages..
    #  sudo dnf clean packages

    # Installing the NVIDIA related packages.
    sudo dnf install -y akmod-nvidia kmod-nvidia nvidia-modprobe nvidia-persistenced \
        nvidia-settings nvidia-xconfig xorg-x11-drv-nvidia xorg-x11-drv-nvidia-cuda \
        xorg-x11-drv-nvidia-cuda-libs xorg-x11-drv-nvidia-devel xorg-x11-drv-nvidia-kmodsrc xorg-x11-drv-nvidia-libs

    # Blacklist nouveau drivers
    echo -e "blacklist nouveau" | sudo tee -a /etc/modprobe.d/blacklist.conf

    # Reboot the system.
    # Now you can find NVIDIA settings icon in the app menu.
    # Open it and verify the NVIDIA configs.
}
