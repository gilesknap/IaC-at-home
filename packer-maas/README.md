# Packer-MAAS for Raspi Ubuntu based MAAS image ?

Packer MAAS builds images for MAAS. 
- https://github.com/canonical/packer-maas

The main issue is it does not support Arm as yet.

## setup for AMD64 build

``` bash
sudo apt-get install cloud-image-utils
# go here for latest packer https://www.packer.io/downloads
# download the amd64 binary and put in /usr/bin/packer
# don't apt install (at least on focal this gets an old version)

git@github.com:gilesknap/packer-maas.git
cd packer-mass/ubuntu

make custom-ubuntu-lvm.dd.gz
```