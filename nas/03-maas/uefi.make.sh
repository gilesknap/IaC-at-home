#!/bin/bash

ZIPFILE="${1}"
URL="https://github.com/pftf/RPi4/releases/download/v1.32/RPi4_UEFI_Firmware_v1.32.zip"

echo 'Make a UEFI boot disk for raspberry Pi'
if [ -z $ZIPFILE ] ; then 
echo "using the file ${ZIPFILE}"
else
echo "by downloading from ${URL}"
fi
echo 
echo '*** WARNING**** this will delete everything on the target disk'
echo 'use the command lsblk to verify you have the right device name'
echo
read -p "Enter device name of the disk e.g. /dev/sde ($DISK) : " NEWDISK

# will default to the environment variable DISK if it is set and nothing entered above
DISK=${DISK:-$NEWDISK}

if [ ! -b $DISK ] ; then
echo "cant find the disk: $DISK" 
exit 1
fi

PARTITION=${DISK}1

sudo umount $PARTITION

set -e

sudo sfdisk $DISK <<EOT
label: dos
label-id: 0x71d59d14
device: $DISK
unit: sectors

$PARTITION : start=        2048, size=    2000000000, type=c, bootable
EOT

curl -L ${URL} -o uefi.firmware.zip

mkdir -p sdcard
sudo mkfs.fat $PARTITION
sudo mount $PARTITION sdcard

cd sdcard
if [ -z $ZIPFILE ] ; then 
sudo unzip ../$ZIPFILE
else
sudo unzip ../uefi.firmware.zip
fi

cd ..
sudo umount $PARTITION

rmdir sdcard
rm uefi.firmware.zip
