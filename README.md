# IaC-at-home

UPDATE for Oct 2024

Moving on to a second attempt at this here https://github.com/gilesknap/IaC-at-home2

PROJECT STALLED

I got bogged down in creating a kubernetes image for raspberry pi and have
moved on to other projects for the time being.

I did get as far as making a MAAS deployed cluster and helping to write this
[tutorial for Canoncial](https://maas.io/tutorials/build-your-own-bare-metal-cloud-using-a-raspberry-pi-cluster-with-maas#1-overview)

WORK IN PROGRESS

Documentation and configuration for my attempt to bootstrap and maintain my 
home cluster with MAAS and Cluster API.

See previous work in setting up a k3s cluster here
https://github.com/gilesknap/k3s-minecraft. The goal is to migrate over
all applications from the previous cluster.

## Hardware
- 3 * Raspberry Pi 4 with 4GB RAM +32GB USB3 flash
- 1 * Raspberry Pi 4 with 8GB RAM +32GB USB3 flash
- 3 * Raspberry Pi 4 with 2GB RAM +32GB USB3 flash
- 1 Intel NUC I7 with 32GB RAM +250GB Nvme + 4TB SSD for backup
- 1 QNAP TS-x53D NAS with RAID 1 pair of SSD 4TB
- 1 Workstation AMD Ryzen 7 8500X 32 GB RAM Nvidia RX 3090 GPU

The NAS will provide storage and any 'outside of the cluster' services needed for 
bootstrapping/management. This will primarily be storage plus one or more VMs to
run the MAAS and cluster API management node(s).

# Steps 

I did some investigation into PXE booting for Raspberry Pi. However, all of 
this is superseded by MAAS and UEFI for Raspberry Pi.

- [01 set up dnsmasq](nas/01-dnsmasq/README.md)
- [02 configure PXE boot on Pi 4](nas/02-pxe/README.md)

Next I set up Canonical MAAS and a cluster management cluster.

- [03 Canonical MAAS](nas/03-maas/README.md)
  - [03.1 Raspberry Pi MAAS](nas/03-maas/RaspiMASS.md)
  - [03.2 Raspberry Pi UEFI boot](nas/03-maas/MakeUefiSd.md)
  - [03.3 Raspberry Pi Power Supply](nas/03-maas/PowerSupply.md)
- 04 is only required if building a VM for KVM and this is probably not the
  best approach for the resource limited RPIs.
  - [04 K3S packer image](nas/04-deployk3sPacker/README.md)
- [05 Management Cluster](nas/05-k3sManagement/README.md)

At present (Mar 2022) I have Canonical MAAS deploying focal to the PIs 
(and an Intel NUC).
I'm able to kick off deployment using the ClusterAPI and SpectroCloud's 
MAAS provider but the deploy fails because focal needs a min
kernel and the provider does not yet expose control of that.

A few things could fix this:
- SpectroCloud may add min-kernel configuration
- Deploying impish instead of focal would work as it has newer kernel, but 
  this is not currently working either - Canonical may be able to fix this.
- The next LTS is out soon. If that just works then all will be well.

In the meantime, I'm looking into how to uplift a ubuntu machine to a
Kubernetes node.
- [06 Cluster Deployment](cluster/README.md)



