---
title: "RKE2 Kubernetes Cluster Bootstrap on Debian GNU/Linux 12"
subtitle: "Three Node Bare-Metal Deployment"
author: "Lex Zabrovsky"
date: 2025-07-01
---

# RKE2 Kubernetes Cluster Deployment on Debian GNU/Linux 12


## Prerequisites


- Debian GNU/Linux 12 machine with Ethernet access

- It is *better* if no SWAP is present


## OS Environment Setup


!!! Note

    Do the following for all the nodes!


We're working as `root`:

```shell
su -
```

Disable swap if present:

```shell
sudo swapoff -a
sudo sed -i '/ swap / s/^\(.*\)$/#\1/g' /etc/fstab
```

Install dependencies:

```shell
apt update

apt install sudo git curl nfs-common iptables network-manager open-iscsi vim -y
```

Configure dependencies:

```shell
systemctl disable iscsi.service
```

Configure NetworkManager to ignore Calico/Flannel related network interfaces [^1]*:

```shell
cat << EOF >> /etc/NetworkManager/conf.d/rke2-canal.conf
[keyfile]
unmanaged-devices=interface-name:cali*;interface-name:flannel*
EOF

systemctl reload NetworkManager
```

```shell
# Configure legacy iptables
sudo update-alternatives --set iptables /usr/sbin/iptables-legacy
sudo update-alternatives --set ip6tables /usr/sbin/ip6tables-legacy
```

Enable and configure needed kernel modules

```shell
# Configure kernel modules
echo -e "br_netfilter\nip_vs\nip_vs_rr\nip_vs_sh\nnf_conntrack" | sudo tee /etc/modules-load.d/rke2.conf
sudo modprobe br_netfilter ip_vs ip_vs_rr ip_vs_sh nf_conntrack
```

```shell
# Configure sysctl
echo -e "net.bridge.bridge-nf-call-ip6tables=1\nnet.bridge.bridge-nf-call-iptables=1\nnet.ipv4.ip_forward=1" | sudo tee /etc/sysctl.d/90-k8s.conf
sudo sysctl --system
net.bridge.bridge-nf-call-ip6tables=1
net.bridge.bridge-nf-call-iptables=1
net.ipv4.ip_forward=1
```

Disable firefall if present:

```shell
systemctl disable --now ufw
```


!!! Note

    Now reboot the node. You may replicate it now.


## Server Node Setup


Install RKE2 Server:

```shell
curl -sfL https://get.rke2.io | INSTALL_RKE2_TYPE=server sh -
```

Configure RKE2 for the server node:

```shell
# Set the token - create config dir/file
mkdir -p /etc/rancher/rke2/
echo "token: mySecretToken" > /etc/rancher/rke2/config.yaml

# start rke2-server and enable it for restarts -
systemctl enable --now rke2-server.service
```

Congifure access to RKE2 Cluster API via `kubectl` tool:

```shell
# symlink kubectl tool
ln -s $(find /var/lib/rancher/rke2/data/ -name kubectl) /usr/local/bin/kubectl

# add kubectl conf with persistence
echo "export KUBECONFIG=/etc/rancher/rke2/rke2.yaml PATH=$PATH:/usr/local/bin/:/var/lib/rancher/rke2/bin/" >> ~/.bashrc
source ~/.bashrc
```

Check node status:

```shell
kubectl get node
```

Wait until the `Ready` status appear.

Output example:

```shell
NAME              STATUS   ROLES                       AGE   VERSION
rancher01-deb12   Ready    control-plane,etcd,master   52s   v1.31.5+rke2r1
```

!!! Note
 
    Command useful for localizing possible issues with deployment:

    ```shell
    kubectl get pod -n kube-system
    ```


## The Agent Nodes Setup

Expose a variable with the server's IP:

```shell
export RANCHER1_IP=10.9.8.7    # Set server node IP addr here
```

Install RKE2 Agent:

```shell
# use INSTALL_RKE2_TYPE=agent for agent install
curl -sfL https://get.rke2.io | INSTALL_RKE2_TYPE=agent sh -

# create config dir/file
mkdir -p /etc/rancher/rke2/

# change the ip to reflect your RANCHER1_IP ip
cat << EOF >> /etc/rancher/rke2/config.yaml
server: https://$RANCHER1_IP:9345
token: mySecretToken
EOF

# enable and start
systemctl enable --now rke2-agent.service
```

On the SERVER NODE, check that the new node joined the cluster:

```shell
# On the SERVER NODE check that the node joined the cluster
kubectl get node -o wide
```

Example Output:

```shell
NAME              STATUS     ROLES                       AGE     VERSION          INTERNAL-IP   EXTERNAL-IP   OS-IMAGE                         KERNEL-VERSION   CONTAINER-RUNTIME
rancher01-deb12   Ready      control-plane,etcd,master   8m54s   v1.31.5+rke2r1   10.9.8.7     <none>        Debian GNU/Linux 12 (bookworm)   6.1.0-31-amd64   containerd://1.7.23-k3s2
rancher02-deb12   NotReady   <none>                      11s     v1.31.5+rke2r1   10.9.8.76     <none>        Debian GNU/Linux 12 (bookworm)   6.1.0-31-amd64   containerd://1.7.23-k3s2

```

Wait until nodes `Ready` status appear.

## Install Rancher

Install Helm binary on the SERVER NODE:

```shell
curl -L https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3 | bash
```

Add Rancher and JetStack repoes:
 
```shell
helm repo add rancher-latest \
  https://releases.rancher.com/server-charts/latest \
  --force-update

helm repo add jetstack https://charts.jetstack.io --force-update
```

Install Cert Manager:

```shell
helm upgrade -i cert-manager jetstack/cert-manager \
  --create-namespace --namespace cert-manager \
  --set crds.enabled=true
```

Install Rancher:

```shell
export RANCHER1_IP=10.9.8.7
export ADMIN_PASS='adminP@$$W0rd'

helm upgrade -i rancher rancher-latest/rancher \
  --create-namespace --namespace cattle-system \
  --set hostname=rancher.$RANCHER1_IP.sslip.io \
  --set bootstrapPassword="${ADMIN_PASS}" \
  --set replicas=1
```

Now Rancher GUI should be available at `https://rancher.$RANCHER1_IP.sslip.io`, users name is `admin`.

## Install Longhorn Distributed Storage

Add Longhorn Helm repo and install it:

```shell
helm repo add longhorn https://charts.longhorn.io --force-update

# install Longhorn
helm upgrade -i longhorn longhorn/longhorn \
  --create-namespace  --namespace longhorn-system
```

## Install Harbor Registry

```shell
helm repo add harbor https://helm.goharbor.io

kubectl create secret generic harbor-tls \
  --from-file=tls.crt=harbor.crt \
  --from-file=tls.key=harbor.key \
  --from-file=ca.crt=server-ca.crt -n harbor-system

kubectl create secret generic harbor-internal-tls \
  --from-file=tls.crt=harbor.crt \
  --from-file=tls.key=harbor.key \
  --from-file=ca.crt=server-ca.crt -n harbor-system

helm install harbor harbor/harbor \
  --namespace harbor-system \
  --set expose.tls.enabled=true \
  --set expose.tls.certSource=secret \
  --set expose.tls.secret.secretName=harbor-tls \
  --set expose.tls.secret.notarySecretName=harbor-tls \
  --set expose.ingress.hosts.core=harbor."${RANCHER1_IP}".sslip.io \
  --set externalURL=https://harbor."${RANCHER1_IP}".sslip.io
```

## Referencies

[^1]. [RKE2: Known Issues and Limitations](https://docs.rke2.io/known_issues#networkmanager)

[← Back to home](index.html)