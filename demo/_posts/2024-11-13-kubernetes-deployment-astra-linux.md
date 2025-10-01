---
title: "Kubernetes Cluster Deployment on Astra Linux SE 1.7"
subtitle: "Three Node Bare-Metal Deployment"
author: "Lex Zabrovsky"
date: 2025-11-13
---

# Развертывание кластера Kubernetes на машинах Astra Linux SE 1.7

*В этой статье рассматривается развертывание кластера __Kubernetes__ в конфигурации из двух узлов: __control-plane__ (__master-node__) и __worker-node__ (узел рабочей нагрузки).*

---

## Предварительные требования

1. Две машины с OC **Astra Linux SE 1.7**
2. На машинах должен быть отключен **swap**
3. Доступны версии пакетов `kubectl: >=1.24.17, kubeadm: >=1.24.17, kubelet: >=1.7.2, containerd: >=1.7.2`

## Конфигурация окружения OC

Рекомендуется обновить ОС:

```shell
sudo apt-get update && sudo apt-get upgrade -y
```

Проверить текущие настройки репозитория:

```shell
sudo nano /etc/apt/sources.list
```

Убедиться, что зарегистрированы *основной*, *базовый* и *расширенный репозитории*:

```shell
deb https://dl.astralinux.ru/astra/stable/1.7_x86-64/repository-main/     1.7_x86-64 main contrib non-free

deb https://dl.astralinux.ru/astra/stable/1.7_x86-64/repository-base/     1.7_x86-64 main contrib non-free

deb https://dl.astralinux.ru/astra/stable/1.7_x86-64/repository-extended/ 1.7_x86-64 main contrib non-free
```

Установить `debian-archive-keyring`:

```shell
sudo apt install debian-archive-keyring
sudo apt update
```

Добавить репозиторий **Debian Buster**:

```shell
echo "deb https://deb.debian.org/debian/               buster         main contrib non-free" | sudo tee -a /etc/apt/sources.list.d/debian.list

echo "deb https://security.debian.org/debian-security/ buster/updates main contrib non-free" | sudo tee -a /etc/apt/sources.list.d/debian.list

sudo chmod 644 /etc/apt/sources.list.d/debian.list 

sudo apt-get update
```

Установить необходимые пакеты:

```shell
sudo apt-get install -y apt-transport-https ca-certificates curl gnupg tmux curl
```

### Отключить swap

Отключить **swap** до следующей перезагрузки **GNU/Linux** можно с помощью команды:

```shell
sudo swapoff -a
```

Чтобы сделать это изменение постоянным, необходимо отредактировать файл `/etc/fstab`, закомментировав линии с настройками **swap**.

### Добавить модуль ядра br_netfilter к списку загружаемых

Загрузить модуль ядра **GNU/Linux** `br_netfilter`:

```shell
sudo modprobe br_netfilter
```

Чтобы модуль `br_netfilter` загружался при каждом запуске **GNU/Linux**, добавить его к списку загружаемых модулей ядра `/etc/modules-load.d`:

```shell
echo 'br_netfilter' | sudo tee -a /etc/modules-load.d/k8s.conf
```

### Пустить трафик с мостов через iptables

Установить параметр ядра `bridge-nf-call-iptables` равным `1`, что направит весь трафик с мостов через `iptables`:

```shell
echo 1 | sudo tee /proc/sys/net/bridge/bridge-nf-call-iptables
```

Чтобы сделать это изменения постоянным, обновить настройки `sysctl`:

```shell
echo 'net.bridge.ссссссс=1' | sudo tee -a /etc/sysctl.conf
sudo sysctl -p
```

### Включить проброс кадров IPv4

Чтобы включить проброс кадров **IPv4**, обновить настройки `sysctl`:

```shell
# sysctl params required by setup, params persist across reboots
cat <<EOF | sudo tee /etc/sysctl.d/k8s.conf
net.ipv4.ip_forward = 1
EOF

# Apply sysctl params without reboot
sudo sysctl --system
```

Убедиться, что значение параметра `net.ipv4.ip_forward` равно `1`:

```shell
sysctl net.ipv4.ip_forward
```

Рекомендуется задать `hostname` машины. Например, для мастер-узла это можно сделать с помощью команды ниже:

```shell
sudo hostnamectl set-hostname k8s-control-plane
```

При неоходимости, добавить записи в файл `/etc/hosts` указав `hostname` и **IP-адрес** нод:

```shell
<ip-address> <hostname>.corp.helloworld.com <hostname>
```

## Установка среды выполнения контейнеров

**Kubernetes** поддерживает ряд [**сред выполнения контейнеров** (**Container Runtime**)](https://kubernetes.io/docs/setup/production-environment/container-runtimes/). Для использования **Docker Engine** см. [эту статью](https://www.notion.so/zabrovsky-alex/Docker-Installation-7f79e613a9eb4455bc412bfba0bf1c67?pvs=4).

!!! Note "Примечание"
    В этой статье в качестве среды выполнения контейнеров используется **containerd** версии выше 1.7.2. Работоспособность для версий ниже указанной не гарантируется.

### Установить containerd

Чтобы установить **containerd** выполнить команду:

```shell
sudo apt-get install -y containerd
sudo systemctl enable containerd
```

### Настроить containerd

Создать файл конфигурации для **containerd**:

```shell
sudo mkdir -p /etc/containerd && \
sudo containerd config default | sudo tee /etc/containerd/config.toml > /dev/null
```

Указать `systemd` в качестве **cgroup**-драйвера. Для этого в файлe `/etc/containerd/config.toml`, найти секцию `[plugins."io.containerd.grpc.v1.cri".containerd.runtimes.runc.options]` и выставить `SystemdCgroup = true`:

```shell
[plugins."io.containerd.grpc.v1.cri".containerd.runtimes.runc]
  ...
    [plugins."io.containerd.grpc.v1.cri".containerd.runtimes.runc.options]
      SystemdCgroup = true
```

Перезагрузить **containerd**, чтобы применить настройки:

```shell
sudo systemctl restart containerd && \
sudo systemctl enable containerd
```

## Установка Kubernetes

Создать директорию для хранения открытых ключей для apt:

```shell
sudo mkdir /etc/apt/keyrings
```

Добавить открытый ключ репозитория **Kubernetes**:

```shell
curl -fsSL https://pkgs.k8s.io/core:/stable:/v1.24/deb/Release.key | sudo gpg --dearmor -o /etc/apt/keyrings/kubernetes-apt-keyring.gpg
```

Настроить необходимые права для файла отрытого ключа:

```shell
sudo chmod 644 /etc/apt/keyrings/kubernetes-apt-keyring.gpg
```

Добавить репозиторий **Kubernetes**:

```shell
echo 'deb [signed-by=/etc/apt/keyrings/kubernetes-apt-keyring.gpg] https://pkgs.k8s.io/core:/stable:/v1.24/deb/ /' | sudo tee /etc/apt/sources.list.d/kubernetes.list
```

Настроить необходимые права для файла с адресом репозитория:

```shell
sudo chmod 644 /etc/apt/sources.list.d/kubernetes.list
```

Установить пакет `cri-tools`:

```shell
sudo apt-get update && sudo apt-get install -y cri-tools=1.26.0-1.1
```

Установить компоненты **Kubernetes**:

```shell
sudo apt-get install -y kubelet kubeadm kubectl
```

Отключить автоматическое обновление установленных компонентов:

```shell
sudo apt-mark hold kubelet kubeadm kubectl
```

## Инициализировать мастер-узел кластера

Для инициализации кластера и его мастер-узла использовать команду:

```shell
sudo kubeadm init --pod-network-cidr=10.244.0.0/16
```

!!! Note "Примечание"
    `10.244.0.0/16` is an example of CIDR notation, which specifies a block of IP addresses. In this case, it allows for 65,536 IP addresses (from `10.244.0.0` to `10.244.255.255`), providing ample address space for Pods in the cluster.

Настроить доступ `kubectl` к кластеру:

```shell
mkdir -p $HOME/.kube
sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config
```

Развернуть подсеть для подов:

```shell
kubectl apply -f https://docs.projectcalico.org/manifests/calico.yaml
```

Убедиться, что узел `control-plane` находится в состоянии `Ready`:

```shell
kubectl get nodes
```

## Инициализировать узел рабочей нагрузки

На мастер-узле сгенерировать команду для включения узла в кластер:

```shell
kubeadm token create --print-join-command
```

На узле рабочей нагрузки выполнить сгенерированную команду.

На мастер-узле проверить, что узел рабочей нагрузки подключился к кластеру:

```shell
kubectl get nodes
```

## Проверка работоспособности

На мастер-узле выполнить команду деплоя пода `mybusybox`:

```shell
kubectl run mybusybox --restart=Never --image=busybox
```

Убедиться, что под имеет статус `Completed`:

```shell
kubectl get pod mybusybox
```



## Следующие шаги

Рекомендуется установить один из Storage Provision операторов, [например, OpenEBS](../openebs_installation/index.md).

[← Back to home](index.html)