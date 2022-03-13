#~/bin/bash

# thanks to https://github.com/spectrocloud/cluster-api-provider-maas/blob/72873b167450f1c1d50bd44fddb6e460bbf7a7fc/image-generation/buildmaasimage.sh

export vmimage=$1
if [ ! -e ${vmimage} ] ; then
    echo 'usage: tar-vm.sh <qcow2-image-to-tar>'
    exit 1
fi

TMP_DIR=$(mktemp -d /tmp/packer-maas-XXXX)
echo 'Binding packer qcow2 image output to nbd ...'
modprobe nbd max_part=8
qemu-nbd -d /dev/nbd4
qemu-nbd -c /dev/nbd4 -n ${vmimage}

echo 'Waiting for partitions to be created...'
tries=0
maxtries=60
while [ ! -e /dev/nbd4p1 -a ${tries} -lt ${maxtries} ]; do                                                                                                             
    sleep 1
    tries=$((tries+1))                                                                                                                                  
done
if [ ${tries} == ${maxtries} ] ; then
    echo 'partition creation timed out'
    exit 1
fi

echo "mounting image..."
mount /dev/nbd4p1 $TMP_DIR

exit 0

echo 'Tarring up image...'
tar -Sczpf ${vmimage}.tar.gz --selinux -C $TMP_DIR  .       

echo 'Unmounting image...'
umount $TMP_DIR                                                                                                                                         
qemu-nbd -d /dev/nbd4
rmdir $TMP_DIR