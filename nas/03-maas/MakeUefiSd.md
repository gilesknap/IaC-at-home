Make a UEFI SD Card
===================

The script here [uefi.make.sh](uefi.make.sh) will create a UEFI SD card. It 
downloads v1.32 from the git repo, formats the SD card and copies in the files.

If there are more recent versions of UEFI then you will find them here:

- https://github.com/pftf/RPi4/releases

You will need to tell the script which drive you have the sdcard plugged into.

You should be able to see this using the command `lsblk` which lists all the
block devices (disks) attached to your PC.

The script will run on any linux machine that has an SD Reader. It can also
be run on a Raspberry Pi with Raspi OS (or any linux) installed.


Now set up UEFI and do a PXE boot. Unfortunately this step requires a keyboard
and monitor connected to your Raspberry Pi. But this need only be done once for
each Pi.

IMPORTANT: after this procedure there is a binary firmware file that contains 
the MAC address of the Pi. So this procedure must be applied to each Pi
and you cannot just copy the SD Card.

By default your Pi will boot from SD but if you have ever changed this before then
you will need to boot a Raspi OS and use the utility raspi-config, go into
Advanced Options -> Boot Order and choose the 1st option. Then reboot.

Steps:
- Insert the SDCard created above
- reboot. When you see the Raspberry slash screen, hit ESC to go into settings
- Go to DEVICE->RaspberryPi  Configuration-> Advanced and set Limit RAM to 3 GB to Disabled
- I also went into Boot Options -> Delete Boot Options and removed all boot options 
  except PXE boot over IPv4.
- Now hit escape until you are at the root menu and choose the reset option.
- This will reboot the Pi should come up with PXE network boot. MAAS should see
  this and automatically start commissioning

Backup:

I recommend backing up the SDCard for each of your Pis. If a mistake is made in the
deployment step then the SDCard can get overwritten and it is nice to be able to
recreate the card without hooking the Pi to a screen.

To do this take the power off after the Pi starts to boot in the last step above.
Remove the SD card and put it in your linux machine that has the card reader and
the uefi.make.sh script. If your Pi is called RPI1 and the mounted partition
is called /dev/sde1 then the commands are 

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

