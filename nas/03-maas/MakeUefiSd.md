Make a UEFI SD Card
===================

Intro
-----

The script here [uefi.make.sh](uefi.make.sh) will create a UEFI SD card. It 
downloads v1.32 from the git repo, formats the SD card and copies the files to
the SD card.

If there are more recent versions of the UEFI firmware then you 
will find them at the URL below. 
You would need to change the line beginning 'URL=' in the script
uefi.make.sh, if you want to use a more recent version.

- https://github.com/pftf/RPi4/releases

Requirements
------------

For this procedure you will require:

- A 'builder' machine. This can be any linux
  machine with an SD Card reader You can use an
  RPI that is booted into linux for this. You could also use 
  a WSL2 instance.
- Any number of target RPIs - these will need a keyboard and screen
  connected to complete the process
- One SD Card per target RPI, you only need 5MB of space so any cards will do.
- the zip tool needs to be installed on the builder machine
  - `sudo apt -y install zip`


Step 1 Create the UEFI SD Cards
--------------------------------

Perform this step on the builder machine.

Plug in an SD card and use the command

```
lsblk
```

You will see output that looks like this
```

NAME        MAJ:MIN RM   SIZE RO TYPE MOUNTPOINT
sda           8:0    0   1.8T  0 disk 
├─sda1        8:1    0   512M  0 part 
└─sda2        8:2    0   1.8T  0 part /
sdb           8:16   0 223.6G  0 disk 
└─sdb1        8:17   0 223.6G  0 part 
sdc           8:32   0   1.8T  0 disk 
└─sdc1        8:33   0   1.8T  0 part /mnt/Data
sde           8:64   1   3.7G  0 disk 
└─sde1        8:65   1   3.7G  0 part 
nvme0n1     259:0    0 931.5G  0 disk 
├─nvme0n1p1 259:1    0   499M  0 part 
├─nvme0n1p2 259:2    0    99M  0 part /boot/efi
├─nvme0n1p3 259:3    0    16M  0 part 
└─nvme0n1p4 259:4    0 930.9G  0 part /mnt/803A7CB83A7CACB2
```

From the above I see that there is a device called sde which is 3.7G,
this corresponds to the 4GB SD card I have plugged in. In my case the
card already has 1 partition configured called sde1. The data and 
partitions on the card will be overwritten by this process.

Now download the script uefi.make.sh, set the SDCard device name and 
execute the script
``` bash
curl -LO https://raw.githubusercontent.com/gilesknap/IaC-at-home/main/nas/03-maas/uefi.make.sh
export DISK=/dev/XXXX # where XXXX is the device name identified above
bash ./uefi.make.sh
```

Now repeat this step for each of the cards you want to make.

Step 2 Change UEFI settings on each RPI
---------------------------------------

Repeat theses steps for each of your target RPIS for which you prepared a
card in step 1.

- put the SDCard in the RPI 
- connect a keyboard and screen
- power up the RPI
- When you see the UEFI Raspberry splash screen hit ESC, this will take you to 
  settings
- you need to change 2 settings:

  - Go to DEVICE->RaspberryPi  Configuration-> Advanced and set 
    `Limit RAM to 3 GB` to Disabled. Save the change.
  - Go to Boot Options -> Delete Boot Options and removed the first boot option
    making sure that the top option is now `PXEv4`. Save the change
- Hit ESC a few times to return to the root menu and choose `reset`, this will
  commit the changes and reboot the RPI.
- When the RPI boots now it will try to network boot, if you do not yet have 
  MAAS configured then this will fail as expected.


Step 3 backup the configured cards
----------------------------------

Configuring the UEFI will commit a binary firmware image to the SD Card,
the firmware includes the RPI's MAC address so each card is unique to
each RPI and copying cards wont work. For this reason it can be helpful to
keep a backup of each SD Card after doing Step 2.

To backup:

- power off the RPI and remove the SD card
- place the card back in your 'builder' machine
- back up with the following commands

```bash
mkdir sdcard
sudo mount /dev/sde1 sdcard
cd sdcard
zip -r ../RPI1.zip .
cd ..
sudo umount sdcard
```

You now have a zip file RPI1.zip and you can pass this as a cmdline parameter
to the script uefi.make.sh in order to recreate a PXE boot SD card for RPI1.

