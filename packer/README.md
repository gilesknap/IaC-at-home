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