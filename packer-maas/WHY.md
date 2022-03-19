# Intro

Right now I'm trying to get the fan working on my PoE RPI Hat.
I've decided that PoE is the way for cluster to go and have added 
my PoE switch to maaspower here 
https://gilesknap.github.io/maaspower/main/how-to/web_ui.html

The fan does not work with Ubuntu Generic and we need the proper DTBO to make it
work. 
- https://github.com/raspberrypi/firmware/blob/master/boot/overlays/rpi-poe-plus.dtbo

The driver itself is already in the upstream kernel:
- https://github.com/torvalds/linux/blob/master/drivers/pwm/pwm-raspberrypi-poe.c

I could just get some external cooling. But I would like the RPI hardware to
be fully supported and that really needs the RPI flavour of Ubuntu.

There is a concern that this wont work with UEFI. We need UEFI to make the PXE
boot work so that could be a showstopper.

Some possible evidence that UEFI and raspi version of kernel do not get on:
```
apt install linux-raspi
```
All is well with install and then on reboot:

![uefi](../images/uefifail.png)