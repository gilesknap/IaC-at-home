# Setup PXE Boot for the cluster's Heterogenous Nodes 

This is just an experiment to make sure PXE boot is working. This will not
be part of the final solution.

Here we network boot a pi and run it with a networked boot and rootfs.

In a later step I intend to use PXE to bootstrap the install of the OS
to a local drive for raspis and other flavours of node (1 NUC and a VM or two)

Took lots of inspiration from these:

https://linuxhit.com/raspberry-pi-pxe-boot-netbooting-a-pi-4-without-an-sd-card/
https://www.raspberrypi.com/documentation/computers/remote-access.html#network-boot-your-raspberry-pi

# setup your pi(s) to network boot

```bash
sudo raspi-config
Advanced Options -> Boot Order -> Network Boot
sudo reboot
```

# Copy an existing Pi filesystem to an nfs share
My existing pi2 already has k3sagent installed (not sure if this 
is ideal or not but will run with it for now)

Setup an NFS share on the NAS, it will be read write and no squash user ids.

Then create a copy of a working pi's root filesystem in the share like so
```bash
ssh pi2
mkdir /tmp/pxe
sudo mount.nfs4 nas.gkh.net:/share/PXE /tmp/pxe
mkdir /tmp/pxe/pi3
sudo rsync -xa --progress --exclude /nfs / /tmp/pxe/pi3
```

Then recreate the SSH keys in the image by changing the root filesystem 
and using dpkg-reconfigure. You also need to mount in the dev sys and proc
folders to make a valid system image.
```bash
# mount in the special folders
cd /tmp/pxe/pi3
sudo mount --bind /dev dev
sudo mount --bind /sys sys
sudo mount --bind /proc proc

# perform ssh key reconfiguration in the new rootfs
sudo chroot .
dpkg-reconfigure openssh-server
systemctl enable ssh
exit

# tidy up
sudo umount dev sys proc
```

Also create a copy of the boot filesystem (This can be shared by all netbooting
pis)
```bash
mkdir /tmp/pxe/boot
sudo cp -r /boot/* /tmp/pxe/boot
```

Edit the dnsmasq,config file from [dnsmasq](../dnsmasq/README.md)
Add these lines and restart dnsmasq:
```bash
# enable tftp for PXE boot
enable-tftp
# accept PXE boot requrests as a proxy (because we are not the DHCP)
dhcp-range=192.168.86.0,proxy
# root folder for tftf
tftp-root=/boot
# enable PXE
pxe-service=0,"Raspberry Pi Boot"
```

/tmp/pxe/boot/cmdline.txt - change to (use ip of the NAS with NFS shares)
```
console=serial0,115200 console=tty1 root=/dev/nfs nfsroot=192.168.86.32:/share/PXE/pi3 rw ip=dhcp rootwait
```

/tmp/pxe/pi3/etc/fstab add the following and remove any other mounts except proc
so fstab looks like this:
```
proc            /proc           proc    defaults          0       0
192.168.86.32:/share/PXE/boot /boot nfs defaults 0 0
# a swapfile is not a swap partition, no line here
#   use  dphys-swapfile swap[on|off]  for that
``` 



