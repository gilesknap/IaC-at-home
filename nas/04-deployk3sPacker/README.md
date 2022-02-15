# Creating an automated machine image for K3S

The MAAS investigation used predefined Canonical machine images for Ubuntu
Server.

The next step is to make an image that will install of K3S.
Hashicorp's packer is the tool to build these images 
https://learn.hashicorp.com/packer.

I'm hoping to use Ansible https://www.ansible.com/ as the provisioner.
Here are some details of using Ansible as the provisioner for packer
https://www.packer.io/plugins/provisioners/ansible/ansible.

It is likely that an image for K3S already exists though, this would make 
things easy and this looks promising:
https://betterprogramming.pub/create-a-self-contained-and-portable-kubernetes-cluster-with-k3s-and-packer-16aa43899e2f

