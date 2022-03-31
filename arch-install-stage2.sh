#!/bin/bash

USER=jakob

# Time zone
ln -sf /usr/share/zoneinfo/Europe/Vienna /etc/localtime
hwclock --systohc

# Localization
sed -i 's/#en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/g' /etc/locale.gen
sed -i 's/#de_AT.UTF-8 UTF-8/de_AT.UTF-8 UTF-8/g' /etc/locale.gen
locale-gen
echo "LANG=en_US.UTF-8" > /etc/locale.conf
echo "KEYMAP=de-latin1" > /etc/vconsole.conf

# Network configuration
echo "arch" > /etc/hostname

# Initramfs
mkinitcpio -P

# Root password
echo "Enter root password:"
passwd

# Boot loader
pacman -S amd-ucode grub efibootmgr
grub-install
grub-mkconfig -o /boot/grub/grub.cfg

# Add user
useradd -mG wheel $USER
echo "Enter user password:"
passwd $USER

# Additional packages
pacman -S base-devel networkmanager vim firefox discord git sudo noto-fonts xorg-server xorg-xinit alacritty pulseaudio pavucontrol man-db man-pages bash-completion awesome
cd /tmp && su $USER -c "git clone https://aur.archlinux.org/yay.git"
cd yay && su $USER -c "makepkg -si"
su $USER -c "yay -S visual-studio-code-bin"

# Grafics
pacman -S nvidia
# su $USER -c "yay -S nvidia-470xx-dkms"

systemctl enable NetworkManager
sed -i 's/# %wheel ALL=(ALL:ALL) NOPASSWD: ALL/%wheel ALL=(ALL:ALL) NOPASSWD: ALL/g' /etc/sudoers
su $USER -c "echo -ne "setxkbmap de\nexec awesome" > /home/$USER/.xinitrc"