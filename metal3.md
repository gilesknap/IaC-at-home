# Metal3

Metal3 looks like a good alternative to MAAS and already has a Cluster API
provider. https://metal3.io/. The server definitions themselves are 
custom resources in the management cluster. 

If I understand correctly then instead of using PXE it uses BMC with the list
of supported BMC types here.
https://github.com/metal3-io/baremetal-operator/blob/main/docs/api.md

This makes it much less intrusive as it need not own DHCP/DNS. However it 
also makes it inappropriate for my home network since I have no devices 
with BMC.

