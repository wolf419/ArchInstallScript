#!/bin/bash

DISK=nvme0n1p

EFI=${DISK}1
SWAP=${DISK}2
LINUX=${DISK}3

# TODO
# loadkeys de-latin1
# fdisk /dev/the_disk_to_be_partitioned

timedatectl set-ntp true

mkfs.fat -F 32 /dev/$EFI
mkswap /dev/$SWAP
mkfs.ext4 /dev/$LINUX
swapon /dev/$SWAP

mount /dev/$LINUX /mnt
mkdir -p /mnt/boot/efi
mount /dev/$EFI /mnt/boot/efi

# Install essential packages
pacstrap /mnt base linux linux-firmware

# Fstab
genfstab -U /mnt >> /mnt/etc/fstab

# Copy stage 2
cp ./arch-install-stage2.sh /mnt

# Chroot
arch-chroot /mnt ./arch-install-stage2.sh