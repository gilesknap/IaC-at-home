# IaC-at-home

WORK IN PROGRESS

Documentation and configuration for my attempt to bootstrap and maintain my 
home cluster with MAAS and Cluster API.

See previous work in setting up a k3s cluster here
https://github.com/gilesknap/k3s-minecraft. The goal is to migrate over
all applications from the previous cluster.

## Hardware
- 3 * Raspberry Pi 4 with 4GB RAM +32GB USB3 flash
- 1 * Raspberry Pi 8 with 8GB RAM +32GB USB3 flash
- 1 Intel NUC I7 with 32GB RAM +250GB Nvme + 4TB SSD for backup
- 1 QNAP TS-x53D NAS with RAID 1 pair of SSD 4TB
- 1 Workstation AMD Ryzen 7 8500X 32 GB RAM Nvidia RX 3090 GPU

The NAS will provide storage and any 'outside of the cluster' services needed for 
bootstrapping/management. This will primarily be storage plus one or more VMs to
run the MAAS and cluster API management node(s).

# Steps 
- [Install dnsmasq on the NAS](nas/dnsmasq/README.md)
- TBA ...
- ...
