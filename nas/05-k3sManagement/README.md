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
# THIS IS BROKEN?
kubectl apply -f https://github.com/spectrocloud/cluster-api-provider-maas/releases/download/v0.3.0/infrastructure-components.yaml
# use fixed version from this repo
kubectl apply -f infrastructure-components.yaml
```

There appeared to be an issue with the above yaml. My local copy
changes one of the API versions so that it works. [see](../../code/)

Add your MAAS cluster credentials to a management cluster secret
using [maas_secret.yaml](../../code/maas_secret.yaml)


Next prepare a YAML file that describes the required cluster.

Mine is [here](../../code/mycluster.yaml)

Note that when copying this from (here)[https://thenewstack.io/provision-bare-metal-kubernetes-with-the-cluster-api/]
It is important to update any API versions to their current version.
This command will tell you the API versions in the management cluster:

```
kubectl api-versions
```

Now apply the cluster definition and monitor progress:
```
kubectl apply -f mycluster.yaml
clusterctl describe cluster my-cluster --show-conditions all

```

UPDATE - I also found this which is likely needed to set things up?
or maybe this is the old way?
```
clusterctl init --infrastructure maas:v0.3.0
```

I also did these
```
sudo snap install helm --classic
sudo snap install kubeadm --classic
```


# NEW instructions - get the versions right !

(MAAS not compatible with latest cluster api)

```
curl -sfL https://get.k3s.io | INSTALL_K3S_VERSION=v1.20.2+k3s1 sh -
curl -L https://github.com/kubernetes-sigs/cluster-api/releases/download/v0.4.7/clusterctl-linux-amd64 -o clusterctl
(copy to usr/bin/local)
sudo chown giles /etc/rancher/k3s/k3s.yaml
cp /etc/rancher/k3s/k3s.yaml ~/.kube/config


kubectl apply -f mycluster.yaml
clusterctl describe cluster my-cluster --show-conditions all

```


# links
- spectro cloud maas provider https://github.com/spectrocloud/cluster-api-provider-maas
