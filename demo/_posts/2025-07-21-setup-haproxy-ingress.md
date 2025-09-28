---
title: "HAProxy Deployment on K8s"
subtitle: "Deployment and Configuration on Bare-Metal Cluster"
author: "Lex Zabrovsky"
date: 2025-07-21
---

# Deployment and Configuration of HAProxy Ingress Resourse on Bare-Metal K8s

Tech used:

- HAProxy Ingress Controller for HTTP(S) routing.
- MetalLB for LoadBalancer support.
- TLS and DNS for secure access.


## 1. Prerequisites

- Bare metal Kubernetes cluster.
- `kubectl` access as cluster admin.
- Kubernetes service to expose (Kubernetes Dashboards for this article).
- A range of free IPs on your LAN not used by devices in LAN or DHCP.

## 2. Install MetalLB

Create dedicated namespace:

```shell
kubectl create namespace metallb-system
```

Install MetalLB controller:

```shell
kubectl apply -f https://raw.githubusercontent.com/metallb/metallb/v0.13.12/config/manifests/metallb-native.yaml
```

Create a memberlist secret:

```shell
kubectl create secret generic -n metallb-system memberlist \
     --from-literal=secretkey="$(openssl rand -base64 128)"
```

Create a `metallb-config.yaml` for configuring an IP address pool:

```shell
apiVersion: metallb.io/v1beta1
kind: IPAddressPool
metadata:
  namespace: metallb-system
  name: my-ip-pool
spec:
  addresses:
  - 10.9.9.7-10.9.8.17
---
apiVersion: metallb.io/v1beta1
kind: L2Advertisement
metadata:
  namespace: metallb-system
  name: l2-advertisement
spec: {}
```

Apply configuration with:

```shell
kubectl apply -f metallb-config.yaml
```

Verify MetalLB is running:

```shell
kubectl -n metallb-system get pods
```

## 3. Install HAProxy Ingress Contoller

Install Helm if it is not installed:

```shell
helm repo add haproxy-ingress https://haproxy-ingress.github.io/charts
helm repo update
kubectl create namespace haproxy-controller
helm install haproxy-ingress haproxy-ingress/haproxy-ingress --namespace haproxy-controller
```

Check the service:

```shell
kubectl -n haproxy-controller get svc
```

You should see a `LoadBalancer` service with an `EXTERNAL_IP` from your MetalLB pool.

## 4. Configure DNS

Choose a DNS name. As for example, we use `dashboard.example.com`.

Point the DNS name to your MetalLB IP:

```text
10.9.8.7 dashboard.example.com
```

## 5. Generate a TLS Certificate for the Service

Create an OpenSSL config file `san.cnf`:

```ini
[req]
default_bits       = 2048
prompt             = no
default_md         = sha256
distinguished_name = dn
req_extensions     = req_ext

[dn]
CN = dashboard.example.com

[req_ext]
subjectAltName = @alt_names

[alt_names]
DNS.1 = dashboard.example.com
```

Generate the certificate and key:

```shell
openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
  -keyout dashboard-tls.key -out dashboard-tls.crt \
  -config san.cnf -extensions req_ext
```

Create the Kubernetes TLS secret:

```shell
kubectl -n kubernetes-dashboard create secret tls dashboard-tls \
  --cert=dashboard-tls.crt --key=dashboard-tls.key
```

6. Create the Ingress Resource

Create `dashboard-ingress.yaml`:

```yaml
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: dashboard-ingress
  namespace: kubernetes-dashboard
  annotations:
    kubernetes.io/ingress.class: "haproxy"
    haproxy-ingress.github.io/backend-protocol: "HTTPS"
spec:
  tls:
  - hosts:
    - dashboard.example.com
    secretName: dashboard-tls
  rules:
  - host: dashboard.example.com
    http:
      paths:
      - path: /
        pathType: Prefix
        backend:
          service:
            name: kubernetes-dashboard
            port:
              number: 443
```

Apply the Ingress configuration:

```shell
kubectl apply -f dashboard-ingress.yaml
```

## 7. Access the Service

Visit `https://dashboard.example.com/`.

You may get a browser warning if using a self-signed certificate.

You should see the Service contents.



[← Back to home](index.html)