# MAAS allows us to provision an OS on bare metal

I used these resources

- https://thenewstack.io/provision-bare-metal-kubernetes-with-the-cluster-api/
- https://maas.io/docs/snap/3.0/ui/maas-installation?utm_source=thenewstack&utm_medium=website&utm_campaign=platform
- https://discourse.maas.io/t/raspberry-pi-4-provisioning-and-kvm-pod-setup/3607
- https://github.com/pftf/RPi4

A great place to put the MAAS and mangement cluster is in a VM on the NAS. 
This can then be backed up easily with facilities in QNAP Virtualization Station.

Using https://www.qnap.com/en-uk/software/virtualization-station I have 
created an Ubuntu 20.04 Server VM called gkvm.

This machine will become the DHCP Server so will require a fixed IP.
https://www.linuxtechi.com/assign-static-ip-address-ubuntu-20-04-lts/

You will need to generate an SSH key and configure it for GitHub access:
```bash
ssh-keygen 
cat .ssh/id_rsa.pub
# now go to https://github.com/settings/keys and add this public key 
```

Now install Canonical's MASS:
```bash
# install MAAS
sudo snap install --channel=3.0/stable maas

# install a postgres DB with MAAS-ready database instantiation
sudo snap install maas-test-db
# install both the region and rack locally (accept default MAAS URL)
sudo maas init region+rack --database-uri maas-test-db:///
# setup a local account for MAAS admin 
# When asked for 'Import SSH keys' use gh:<your github account (not email)>)
sudo maas createadmin
```
if the SSH import fails you can complete this below

Now the Web UI should be accessible at `http://gkvm:5240/MAAS/` substitute the name or IP of your VM.

- login with the admin account set up above
- pick the architectures of your target machines
- IF the SSH import above failed:
  - provide your github ID (not email) to import the github SSH keys
  - for the above to work you must have added your public id key to github

Select the distros you want to install.

Now enable DHCP on your subnet. Make sure you disable the existing DHCP first.
Goto the subnets tab, select the VLAN of your subnet, give it a name and 
click enable DHCP
![alt text](../../images/subnets.png)

# Get EFI boot for RASPI

Format an SD Card with these instructions 

- https://www.stephenwagner.com/2020/03/21/create-boot-partition-layout-raspberry-pi/

Unzip a release of the UEFI firware and copy to the card. Get it from

- https://github.com/pftf/RPi4

Boot the pi with this card to get PXE. On first boot go into advanced settings
and remove the 3GB memory limit (if you pi has >2GB)

# Patch the commissioning version of ubuntu with later release

I selected for download 20.04 LTS and 21.10 impish.

Only an LTS version can be used for commissioning (initial network boot). But 
Raspi needs a kernel 5.8 and that is not available until 20.10. So use a soft link
to pretend that 21.04 is 20.04 as follows:

```
cd /var/snap/maas/common/maas/boot-resources/current/ubuntu/arm64/ga-20.04/focal
sudo mv stable/ stable-20.40
sudo ln -s ../../ga-21.04/hirsute/stable/ .
```

Then in MAAS UI set 
Settings->Configuration->Commissioning->Default minimum kernel version 
to focal(ga-20.04). This ensures the patched kernel version is used.

I expect the above issue to be resolved once 22.04 LTS is available in 
MAAS.

# commission and deploy your machines

TODO - mostly just PXE boot and then click Deploy in the MAAS GUI
(following https://maas.io/docs/snap/3.0/ui/maas-installation?utm_source=thenewstack&utm_medium=website&utm_campaign=platform)
got this working with RASPI and Intel NUC

# log in to the CLI

```bash
sudo maas apikey --username admin
maas login admin http://localhost:5240/MAAS

# see all the stuff you can now do!
mass admin --help
```

Assuming the machine you are on has the private key for one of your github
ssh keys then you can 
ssh ubuntu@192.168.0.43
