# Packer, Anisble and image builder
To make clusterAPI work with MAAS it looks like we need to build our own
arm64 image.

SpectroCloud have been very helpful in TBA TBA

The upstream image builder is here
- https://github.com/kubernetes-sigs/image-builder

SpectroCloud's fork and branch for MAAS are here
```
git clone --depth 1 -b restore https://github.com/spectrocloud/image-builder.git && cd image-builder && git checkout a4f37d4088b4273ead8e980750186526c8737383
```
SpectroCloud's use of the image builder fork is here
- https://github.com/spectrocloud/cluster-api-provider-maas/tree/main/image-generation

Here is documentation on the The Qemu Packer builder that we use in the above
- https://www.packer.io/plugins/builders/qemu

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
packer build -var-file="/image-builder/images/capi/packer/config/kubernetes.json"  -var-file="/image-builder/images/capi/packer/config/cni.json"  -var-file="/image-builder/images/capi/packer/config/containerd.json"  -var-file="/image-builder/images/capi/packer/config/ansible-args.json"  -var-file="/image-builder/images/capi/packer/config/goss-args.json"  -var-file="/image-builder/images/capi/packer/config/common.json"  -var-file="/image-builder/images/capi/packer/config/additional_components.json"  -color=true -var-file="/image-builder/images/capi/packer/qemu/qemu-ubuntu-1804.json" -var-file="/image-builder/images/capi/packer/qemu/packer-qemu-ubuntu-1804-arm64.json"  -except=flatcar packer/qemu/packer.json

# then this fails 
/usr/bin/qemu-system-aarch64 -vnc 127.0.0.1:62 -boot once=d -name ubuntu-1804-kube-v1.19.11 -netdev user,id=user.0,hostfwd=tcp::4412-:22 -cpu cortex-a72 -drive if=none,file=output/ubuntu-1804-kube-v1.19.11/ubuntu-1804-kube-v1.19.11,id=drive0,cache=writeback,discard=ignore,format=qcow2 -drive file=/image-builder/images/capi/packer_cache/828336faf23c191899a8275183a150fe7789fcb1.iso,media=cdrom -machine type=virt -m 2048M -device virtio-scsi-pci,id=scsi0 -device scsi-hd,bus=scsi0.0,drive=drive0 -device virtio-net,netdev=user.0
```