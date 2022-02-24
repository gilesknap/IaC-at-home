# Cluster API Management Cluster

We are going to need a management cluster to deploy and maintain the
main cluster through the Cluster API.

For this I have used the following resources:

- https://cluster-api.sigs.k8s.io/user/quick-start.html
- https://thenewstack.io/provision-bare-metal-kubernetes-with-the-cluster-api/

On the VM install clusterctl
```bash
curl -L https://github.com/kubernetes-sigs/cluster-api/releases/download/v1.1.2/clusterctl-linux-amd64 -o clusterctl
chmod +x ./clusterctl
sudo mv ./clusterctl /usr/local/bin/clusterctl
clusterctl version
```

First create a cluster which will become the management cluster as per https://k3s.io/.


Transform this 'cluster' (single k3s master node) into a management cluster
for bare metal.

```bash
# make the k3s kube config readable by you and therefore kubectl works
sudo chown >your user id< /etc/rancher/k3s/k3s.yaml
kubectl get nodes
# put the config file where clusterctl can find it 
cp /etc/rancher/k3s/k3s.yaml .kube/config
# enable interesting experimental features
export CLUSTER_TOPOLOGY=true
export EXP_CLUSTER_RESOURCE_SET=true
# setup this cluster as a management cluster
clusterctl init
```

Note that downloading a new version later requires that you update the
management cluster providers to match. e.g.
```
clusterctl upgrade apply --contract v1beta1
```

Install the cluster-api-provider-maas provider:

```bash
kubectl apply -f https://github.com/spectrocloud/cluster-api-provider-maas/releases/download/v0.3.0/infrastructure-components.yaml
```

