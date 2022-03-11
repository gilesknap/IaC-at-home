# Image Builder
To make clusterAPI work with MAAS we need to build our own OS arm64 image.

I got some fantastic help with this from Saad and Deepak at https://www.spectrocloud.com/


There is a Kubernetes Special Interest Group project for building all kinds of image:
- https://github.com/kubernetes-sigs~/image-builder

At present it does not support arm64 so I'm working on a branch here:
- https://github.com/gilesknap~/image-builder

Most of the tools used by image-builder do have arm64 versions but one exception
is.
- https://github.com/YaleUniversity/packer-provisioner-goss

For the image building procedure we will use an RPI with linux installed,
but any arm64 device would probably work.

We will:
- clone packer-provisioner-goss and build an arm64 version of it
- clone my version image builder
- execute a build - it will fail due to wrong goss architecture

## Building packer-provisioner-goss

You will need docker on the RPI you are using
```bash
curl -fsSL https://get.docker.com -o get-docker.sh
$ sh ./get-docker.sh
```

Perform these tasks an RPI, you will need docker installed to complete this.
The original instructions are here https://github.com/YaleUniversity/packer-provisioner-goss#build
```bash
# get the repo
git clone git@github.com:gilesknap/packer-provisioner-goss.git
# run up a go builder container
docker run --rm -it -v "$PWD":/usr/src/packer-provisioner-goss -w /usr/src/packer-provisioner-goss -e 'VERSION=v1.0.0' golang:1.13 bash
go test ./...
go get -v ./...
go build -v -o packer-provisioner-goss-v3.1.2-pre13-linux-arm64
# start another shell but keep the above container running
mkdir -p ~/.packer.d/plugins/
docker cp 142da6e053f9:/usr/src/packer-provisioner-goss/packer-provisioner-goss-v3.1.2-pre13-linux-arm64 ~/.packer.d/plugins/packer-provisioner-goss
# NOTE: the id is of the running container - you can find this by typing
docker ps
```

## Customize the packer config for arm64 and Build

Packer uses JSON files for configuration. The main file for qemu build JSON
is here:
- image-builder/images/capi/packer/qemu/packer.json

Rather than modifying this file I have added another Variable override file
called
- image-builder/images/capi/packer-vars-raspi64.json

I also made some (hopefully non-breaking) changes to packer.json because there
were some parameters that were needed but not yet given a user variable)

To start a build and use the overrides file:
```bash
git@github.com:gilesknap~/image-builder.git
cd image-builder/images/capi$
PACKER_LOG=1 PACKER_VAR_FILES=packer-vars-raspi64.json make build-qemu-ubuntu-2004-efi
```
# What are Qemu and KVM and qcow2

IMPORTANT : TBA

Building images for bare metal.

Note we installed KVM on arm64 host - document

- Required for the efi version of Ubuntu
  - https://wiki.ubuntu.com/UEFI/OVMF
  - sudo apt-get install virt-manager libvirt-daemon ovmf

# issues

At present I have not been able to launch qemu for raspi. Since we don't have 
UEFI in our emulation we might need to supply a kernel and use a RASPI specific
OS ISO.

Perhaps a good next step is to learn about running Qemu by itself for Pi. Note
there is not official support for Pi4 yet (but there is for Pi2/3)

This might help
- https://stackoverflow.com/questions/67045438/emulating-raspberry-pi-4-with-qemu


Eventually I get this error
- qemu-system-aarch64: no function defined to set boot device list for this architecture

The failing command from Makefile is:
```bash
packer build -var-file="/home/ubuntu/image-builder/images/capi/packer/config/kubernetes.json"  -var-file="/home/ubuntu/image-builder/images/capi/packer/config/cni.json"  -var-file="/home/ubuntu/image-builder/images/capi/packer/config/containerd.json"  -var-file="/home/ubuntu/image-builder/images/capi/packer/config/ansible-args.json"  -var-file="/home/ubuntu/image-builder/images/capi/packer/config/goss-args.json"  -var-file="/home/ubuntu/image-builder/images/capi/packer/config/common.json"  -var-file="/home/ubuntu/image-builder/images/capi/packer/config/additional_components.json"  -color=true -var-file="/home/ubuntu/image-builder/images/capi/packer/qemu/qemu-ubuntu-2004-efi.json" -var-file="/home/ubuntu/image-builder/images/capi/packer-vars-raspi64.json"  -except=flatcar packer/qemu/packer.json


/usr/bin/qemu-system-aarch64 "-boot" "once=d" "-machine" "type=virt" "-netdev" "user,id=user.0,hostfwd=tcp::2762-:22" "-m" "2048M" "-device" "virtio-scsi-pci,id=scsi0" "-device" "scsi-hd,bus=scsi0.0,drive=drive0" "-device" "virtio-net,netdev=user.0" "-name" "ubuntu-2004-kube-v1.21.10" "-drive" "if=none,file=output/ubuntu-2004-kube-v1.21.10/ubuntu-2004-kube-v1.21.10,id=drive0,cache=writeback,discard=unmap,format=qcow2" "-drive" "file=/home/ubuntu~/image-builder/images/capi/packer_cache/48e4ec4daa32571605576c5566f486133ecc271f.iso,media=cdrom" "-bios" "OVMF.fd" "-vnc" "127.0.0.1:41"
```

Some info on this:
- https://gitlab.com/qemu-project/qemu/-/issues/45
- 

# Raspberry
potentially we could use these in the packer vars JSON
```
    "iso_url": "https://cdimage.ubuntu.com/releases/20.04/release/ubuntu-20.04.4-preinstalled-server-arm64+raspi.img.xz",
    "iso_checksum": "6aeba20c00ef13ee7b48c57217ad0d6fc3b127b3734c113981d9477aceb4dad7",
```
When I tried there was a VERY long pause with packer eating CPU.
So perhaps I need to extract the ISO first
To Be investigated


# Packer Notes

List all supported cpu types (Raspi is cortex-a72)
```
qemu-system-aarch64 -machine type=virt -cpu help
```

List supported machine types
```
qemu-system-aarch64 -machine help
```


# Running packer inside SpectroC container


Note that the main packer configuration file is here 
- image-builder/images/capi/packer/qemu/packer.json

I made a few generic changes here that should not affect other builds. Then
added a variable override JSON file here
 - packer/qemu/packer-qemu-ubuntu-1804-arm64.json

launching the makefile with following causes it to add the variables to config:
```
PACKER_LOG=1 PACKER_VAR_FILES=packer/qemu/packer-qemu-ubuntu-1804-arm64.json make build-qemu-ubuntu-1804
```

The command I struggle most to get working is 
```bash
# this get the image and starts the VM
packer build -var-file=~/image-builder/images/capi/packer/config/kubernetes.json  -var-file=~/image-builder/images/capi/packer/config/cni.json  -var-file=~/image-builder/images/capi/packer/config/containerd.json  -var-file=~/image-builder/images/capi/packer/config/ansible-args.json  -var-file=~/image-builder/images/capi/packer/config/goss-args.json  -var-file=~/image-builder/images/capi/packer/config/common.json  -var-file=~/image-builder/images/capi/packer/config/additional_components.json  -color=true -var-file=~/image-builder/images/capi/packer/qemu/qemu-ubuntu-1804.json -var-file=~/image-builder/images/capi/packer/qemu/packer-qemu-ubuntu-1804-arm64.json  -except=flatcar packer/qemu/packer.json
```

# then this fails 
/usr/bin/qemu-system-aarch64 -vnc 127.0.0.1:62 -boot once=d -name ubuntu-1804-kube-v1.19.11 -netdev user,id=user.0,hostfwd=tcp::4412-:22 -cpu cortex-a72 -drive if=none,file=output/ubuntu-1804-kube-v1.19.11/ubuntu-1804-kube-v1.19.11,id=drive0,cache=writeback,discard=ignore,format=qcow2 -drive file=~/image-builder/images/capi/packer_cache/828336faf23c191899a8275183a150fe7789fcb1.iso,media=cdrom -machine type=virt -m 2048M -device virtio-scsi-pci,id=scsi0 -device scsi-hd,bus=scsi0.0,drive=drive0 -device virtio-net,netdev=user.0
```