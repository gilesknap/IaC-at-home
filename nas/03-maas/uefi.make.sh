#!/bin/bash

sudo sfdisk /dev/mmcblk0 <<EOT
label: dos
label-id: 0x71d59d14
device: /dev/mmcblk0
unit: sectors

/dev/mmcblk0p1 : start=        2048, size=    62331904, type=c, bootable
EOT

mkdir -p sdcard
sudo mkfs.fat /dev/mmcblk0p1
sudo mount /dev/mmcblk0p1 sdcard

curl -L  https://github.com/pftf/RPi4/releases/download/v1.32/RPi4_UEFI_Firmware_v1.32.zip > uefi.zip
cd sdcard
sudo unzip ../uefi.zip

cd ..
sudo umount /dev/mmcblk0p1