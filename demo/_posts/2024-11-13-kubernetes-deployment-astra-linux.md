---
title: "Kubernetes Cluster Deployment on Astra Linux SE 1.7"
subtitle: "Two Nodes Bare-Metal Deployment"
author: "Lex Zabrovsky"
date: 2025-11-13
---

# Two-Nodes Kubernetes Cluster Deployment on Astra Linux SE 1.7

*In this article we consider __a two-nodes Kubernetes cluster deployment__: __control-plane__ and __worker-node__.*

---

## Prerequisites

1. Two __Astra Linux SE 1.7__ hosts
2. It is mandatory to disable __swap__
3. We also use this packages: `kubectl: >=1.24.17, kubeadm: >=1.24.17, kubelet: >=1.7.2, containerd: >=1.7.2`

## OS Environment Settings

It is recommended to update the host:

```shell
sudo apt-get update && sudo apt-get upgrade -y
```

Next check the apt sources:

```shell
sudo nano /etc/apt/sources.list
```

Ensure that entries for __main__, __base__, and __extended__ repositories are set:

```shell
deb https://dl.astralinux.ru/astra/stable/1.7_x86-64/repository-main/     1.7_x86-64 main contrib non-free

deb https://dl.astralinux.ru/astra/stable/1.7_x86-64/repository-base/     1.7_x86-64 main contrib non-free

deb https://dl.astralinux.ru/astra/stable/1.7_x86-64/repository-extended/ 1.7_x86-64 main contrib non-free
```

Install __debian-archive-keyring__:

```shell
sudo apt install debian-archive-keyring
sudo apt update
```

Add __Debian 10 (Buster) apt repository__:

```shell
echo "deb https://deb.debian.org/debian/               buster         main contrib non-free" | sudo tee -a /etc/apt/sources.list.d/debian.list

echo "deb https://security.debian.org/debian-security/ buster/updates main contrib non-free" | sudo tee -a /etc/apt/sources.list.d/debian.list

sudo chmod 644 /etc/apt/sources.list.d/debian.list 

sudo apt-get update
```

Install utilities:

```shell
sudo apt-get install -y apt-transport-https ca-certificates curl gnupg
```

### Disable __OS swap__

For disable __swap__ until the OS reboot, you may run this command:

```shell
sudo swapoff -a
```

To make this persistent, comment out all __swap-related settings__ in `/etc/fstab`.

### Add __br_netfilter__ Kernel Module to the List of Loaded by Default

Load `br_netfilter` into the Kernel:

```shell
sudo modprobe br_netfilter
```

To make this persistent, add this line to `/etc/modules-load.d`:

```shell
echo 'br_netfilter' | sudo tee -a /etc/modules-load.d/k8s.conf
```

### Pass Bridged Traffic Through iptables

Set `bridge-nf-call-iptables` equalt `1`:

```shell
echo 1 | sudo tee /proc/sys/net/bridge/bridge-nf-call-iptables
```

To make this change persistent, run this command:

```shell
echo 'net.bridge.ссссссс=1' | sudo tee -a /etc/sysctl.conf
sudo sysctl -p
```

### Enable IPv4 Forwarding

Update `sysctl` configuration to enable IPv4 forwarding:

```shell
# sysctl params required by setup, params persist across reboots
cat <<EOF | sudo tee /etc/sysctl.d/k8s.conf
net.ipv4.ip_forward = 1
EOF

# Apply sysctl params without reboot
sudo sysctl --system
```

Run this command to be sure that setting was set:

```shell
sysctl net.ipv4.ip_forward
```

It is recommended to set a `hostname` for a host. For example, for a control-plane it may be look like this:

```shell
sudo hostnamectl set-hostname k8s-control-plane
```

If it is needed, you may update `/etc/hosts` records to add `hostname` __IP-address__ of all cluster nodes:

```shell
<ip-address> <hostname>.domain.local.com <hostname>
```

## Installing the Container Runtime

__Kubernetes__ supports several [__Container Runtimes__](https://kubernetes.io/docs/setup/production-environment/container-runtimes/). If you interested in using __Docker Engine__ look for [this article](https://www.notion.so/zabrovsky-alex/Docker-Installation-7f79e613a9eb4455bc412bfba0bf1c67?pvs=4).

!!! Note "Please, note"
    In this article we use __containerd__ >= 1.7.2.

### Install __containerd__ Runtime

Run this command to install __containerd__ using `apt-get`:

```shell
sudo apt-get install -y containerd
sudo systemctl enable containerd
```

### __containerd__ Settings

Create a configuration file for __containerd__:

```shell
sudo mkdir -p /etc/containerd && \
sudo containerd config default | sudo tee /etc/containerd/config.toml > /dev/null
```

Set `systemd` as a __cgroup-driver__. For doing so, in `/etc/containerd/config.toml` file, find `[plugins."io.containerd.grpc.v1.cri".containerd.runtimes.runc.options]` and set it as `SystemdCgroup = true`:

```shell
[plugins."io.containerd.grpc.v1.cri".containerd.runtimes.runc]
  ...
    [plugins."io.containerd.grpc.v1.cri".containerd.runtimes.runc.options]
      SystemdCgroup = true
```

Restart __containerd.service__ to apply configuration:

```shell
sudo systemctl restart containerd && \
sudo systemctl enable containerd
```

## Kubernetes Installation

Create a directory for storing Apt public keys:

```shell
sudo mkdir /etc/apt/keyrings
```

Add the public key of the __Kubernetes-repository__:

```shell
curl -fsSL https://pkgs.k8s.io/core:/stable:/v1.24/deb/Release.key | sudo gpg --dearmor -o /etc/apt/keyrings/kubernetes-apt-keyring.gpg
```

Set permissions for the public key file:

```shell
sudo chmod 644 /etc/apt/keyrings/kubernetes-apt-keyring.gpg
```

Add __Kubernetes apt repository__:

```shell
echo 'deb [signed-by=/etc/apt/keyrings/kubernetes-apt-keyring.gpg] https://pkgs.k8s.io/core:/stable:/v1.24/deb/ /' | sudo tee /etc/apt/sources.list.d/kubernetes.list
```

Set permissions for sources list file:

```shell
sudo chmod 644 /etc/apt/sources.list.d/kubernetes.list
```

Install `cri-tools`:

```shell
sudo apt-get update && sudo apt-get install -y cri-tools=1.26.0-1.1
```

Install __Kubernetes-components__:

```shell
sudo apt-get install -y kubelet kubeadm kubectl
```

Disable automatic updates for this apt packages:

```shell
sudo apt-mark hold kubelet kubeadm kubectl
```

## Initialize the Contorl Plane

Run this command to initialize the control-plane:

```shell
sudo kubeadm init --pod-network-cidr=10.244.0.0/16
```

!!! Note "Note"
    `10.244.0.0/16` is an example of CIDR notation, which specifies a block of IP addresses. In this case, it allows for 65,536 IP addresses (from `10.244.0.0` to `10.244.255.255`), providing ample address space for Pods in the cluster.

Set access permissions for `kubectl`:

```shell
mkdir -p $HOME/.kube
sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config
```

Deploy pod subnet using __calico operator__:

```shell
kubectl apply -f https://docs.projectcalico.org/manifests/calico.yaml
```

Ensure that `control-plane` node has `Ready` status:

```shell
kubectl get nodes
```

## Initialize the Worker Node

Use `kubeadm` on the Control Plane Node to generate a token for joining the cluster:

```shell
kubeadm token create --print-join-command
```

`kubeadm` outputs a command to your Shell. Use it on the Worker Node to join it in the cluster.

Use `kubeclt` on the Control Plane Node to check that Worker Node joined successfully:

```shell
kubectl get nodes
```

## Verifying Cluster Deployment

Run this command to schedule a `mybusybox` deployment:

```shell
kubectl run mybusybox --restart=Never --image=busybox
```

Make sure that pod get status `Completed`:

```shell
kubectl get pod mybusybox
```

## What to do next

You may want to introduce one of the several Dynamic Storage Provisioners. For example, [OpenEBS](../openebs_installation/index.md).

[← Back to home](index.html)