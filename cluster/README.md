# Final Stage - creating a Kubernetes Cluster

There may be a few of ways to do this as I understand it.
- Let MAAS install the OS and have clusterAPI do bootstrapping via 
  kubeadm
- Use a cloud init user script in MAAS
- Probably a combination of both is required with MAAS at least installing
  kubeadm and a Container Runtime.

# Customizing Ubuntu with cloud init

This looks very useful
- https://ubuntu.com/blog/customising-maas-installs