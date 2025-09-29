---
title: "OpenSearch Node Deployment Manual"
subtitle: "One Node Cluster Configuration"
author: "Lex Zabrovsky"
date: 2025-07-01
---

# OpenSearch Node Deployment Manual 

_This document delineates the procedure for deploying an OpenSearch instance in a single-node configuration within a GNU/Linux environment. It is presumed that the user possesses a tarball containing precompiled OpenSearch binaries._

---

## **Deployment schema**

The following directory structure outlines the deployment schema for OpenSearch:

```shell
/
├── opt/
│    └── opensearch/
│         ├── config/
│         ├── bin/
│         ├── lib/
│         └── ...
│
├── etc/
│    └── opensearch/ -> /opt/opensearch/config/
│
├── var/
│    ├── lib/
│    │    └── opensearch/
│    └── log/
│         └── opensearch/
│
└── usr/
     └── lib/
          └── systemd/
               └── system/
                    └── opensearch.service

```

## **Prerequisites**

To proceed with the deployment, ensure the following prerequisites are met:

- Tarball with OpenSearch precompiled binaries: `opensearch_ver_linux_arch.tar.gz`
- OpenSearch configuration file: `opensearch.yml`
- Systemd unit specification file: `opensearch.service`
- Deployment Shell script: `opensearch_bootstrap.sh`

!!! note

    The `opensearch_bootstrap.sh`, `opensearch.service`, and `opensearch.yml` files are provided in the Appendix.

## **Before Deployment**

Place the `opensearch_ver_linux_arch.tar.gz`, `opensearch.yml`, and `opensearch.service` files in a designated directory, such as `assets-dir/`:

```shell
mkdir assets-dir/
mv opensearch*tar.gz opensearch*yml opensearch*service assets-dir/
```

## **Deploying Assets and Bootstrapping the Node**

Execute the `opensearch_bootstrap.sh` script, passing assets directory path as a parameter: 

```shell
sudo bash opensearch_bootstrap.sh assets-dir/
```

Alternatively, if assets `opensearch_ver_linux_arch.tar.gz`, `opensearch.yml`, and `opensearch.service` are located in the same directory as the `opensearch_bootstrap.sh`, execute the script without parameters:

```shell
sudo bash opensearch_bootstrap.sh
```

This sctipt will deploy assets with respect to _the Deployment Schema_ and bootstrap the node.

## **Verifying Node Availability**

Run `curl` or `wget` to be sure that node started:

```shell
curl -XGET http://localhost:9200/_cluster/health?pretty
```

## **Troubleshooting Deployment Issues**

To diagnose potential issues with the deployment, utilize the following commands:

```shell
systemctl status opensearch
```

```shell
sudo journalctl -xeu opensearch
```

## **Appendix**

`opensearch_bootstrap.sh`:

```shell
#!/bin/bash


working_dir=""


if [ -z "$1" ]; then
    working_dir="."
else
    path_to_os_tgz="$1"
fi


create_user()
{
    user=$1
    group=$user

    sudo groupadd --system $group

    sudo useradd --system \
      --no-create-home \
      --home-dir /tmp/.$user \
      --gid $group \
      --shell /sbin/nologin \
      $user
}


configure_user()
{
    dir=$1

    if [ -z "$2" ]; then
        user=$USER
        group=$GROUP
    else
        user=$2
        group=$2
    fi

    sudo chown -R $user:$group $dir
}


create_yml_config()
{
    os_config_dir='/etc/opensearch'
    yml_draft_path=""

    if [ -z "$1" ]; then
        yml_draft_path="."
    else
        yml_draft_path="$1"
    fi

    sudo rm $os_config_dir/opensearch.yml
    sudo cp ${yml_draft_path}/opensearch.yml $os_config_dir
}


create_systemd_config()
{
    systemd_draft_path=""
    systemd_config_dir='/usr/lib/systemd/system'

    if [ -z "$1" ]; then
        systemd_draft_path="."
    else
        systemd_draft_path="$1"
    fi

    if [ ! -d $systemd_config_dir ]; then
        mkdir $systemd_config_dir
    fi

    sudo cp ${systemd_draft_path}/opensearch.service $systemd_config_dir
}


unpack_distro()
{
    os_working_dir='/opt/opensearch'
    os_repo=""

    if [ -z "$1" ]; then
        os_repo="."
    else
        os_repo=$1
    fi

    mkdir -p $os_working_dir
    tar -xf $os_repo/*.gz --strip-components=1 -C $os_working_dir
}


configure_service()
{
    service_name=$1
    service_action=$2

    if [[ -z $service_name ]]; then
      echo "[Error] mandatory arg 1 <service_name> is empty!"
      exit 1
    fi

    # Force systemd init system to read descriptions
    # in unit files.
    sudo systemctl daemon-reload

    if [[ $service_action == "--start" ]]; then
      sudo systemctl enable ${service_name}.service
      sudo systemctl start ${service_name}.service
    fi

    if [[ $service_action == "--stop" ]]; then
      sudo systemctl stop ${service_name}.service
    fi

    if [[ $service_action == "--restart" ]]; then
      sudo systemctl restart ${service_name}.service
    fi
}


configure_os()
{
    yml_draft_path=$1
    systemd_draft_path=$2

    os_working_dir='/opt/opensearch'
    os_config_dir='/etc/opensearch'
    os_data_dir='/var/lib/opensearch'
    os_log_dir='/var/log/opensearch'


    log "[Info] Now Configuring OpenSearch ..."

    # Swap Elastic bundled JRE for Installers-JRE
    #sudo rm -rf $os_working_dir/jdk
    #sudo ln -s $JAVA_HOME $os_working_dir/jdk

    # Create necessary dirs
    sudo ln -s $os_working_dir/config $os_config_dir
    sudo mkdir $os_data_dir
    sudo mkdir $os_log_dir

    # Configure permissions on created dirs
    configure_user $os_working_dir opensearch
    configure_user $os_config_dir opensearch
    configure_user $os_data_dir opensearch
    configure_user $os_log_dir opensearch

    # Create opensearch config yml
    create_yml_config $yml_draft_path
    create_systemd_config $systemd_draft_path

    configure_service opensearch --start
}


echo "[Info] Now Installing OpenSearch ..."

create_user opensearch
unpack_distro $path_to_os_tgz
configure_os

echo "[Done] Installing OpenSearch."
```


`opensearchsearch.yml`:

```yml
# ========================= OpenSearch Configuration ===========================
#
# The primary way of configuring a node is via this file. This template lists
# the most important settings you may want to configure for a production cluster.
#
#
# ---------------------------------- Cluster -----------------------------------
#
# Use a descriptive name for your cluster:
cluster.name: os-cluster
#
# ------------------------------------ Node ------------------------------------
#
# Use a descriptive name for the node:
node.name: node-1
node.roles: [ data, master ]
#
# Add custom attributes to the node:
#node.attr.rack: r1
#
# ----------------------------------- Paths ------------------------------------
#
# Path to directory where to store the data (separate multiple locations by comma):
path.data: /var/lib/opensearch
#
# Path to log files:
path.logs: /var/log/opensearch
#
# ----------------------------------- Memory -----------------------------------
#
# Lock the memory on startup:
bootstrap.memory_lock: false
#
# Make sure that the heap size is set to about half the memory available
# on the system and that the owner of the process is allowed to use this
# limit.
#
# OpenSearch performs poorly when the system is swapping the memory.
#
# ---------------------------------- Network -----------------------------------
#
# Set the bind address to a specific IP (IPv4 or IPv6):
network.host: 127.0.0.1
#
http.host: 0.0.0.0
#
# Set a custom port for HTTP:
http.port: 9200
#
# For more information, consult the network module documentation.
#
# --------------------------------- Discovery ----------------------------------
#
discovery.type: single-node
#
# Pass an initial list of hosts to perform discovery when this node is started:
# The default list of hosts is ["127.0.0.1", "[::1]"]
#
#discovery.seed_hosts: ["host1", "host2"]
#
# Bootstrap the cluster using an initial set of cluster-manager-eligible nodes:
#cluster.initial_cluster_manager_nodes: ["node-1", "node-2"]
#
# For more information, consult the discovery and cluster formation module document>
#
# ---------------------------------- Gateway -----------------------------------
#
# Block initial recovery after a full cluster restart until N nodes are started:
#gateway.recover_after_nodes: 3
#
# For more information, consult the gateway module documentation.
#
# ---------------------------------- Various -----------------------------------
#
# Require explicit names when deleting indices:
action.destructive_requires_name: true
#
search.allow_expensive_queries: true
#
indices.id_field_data.enabled: true
#
# ---------------------------------- Remote Store --------------------------------->
# Controls whether cluster imposes index creation only with remote store enabled
# cluster.remote_store.enabled: true
#
# Repository to use for segment upload while enforcing remote store for an index
# node.attr.remote_store.segment.repository: my-repo-1
#
# Repository to use for translog upload while enforcing remote store for an index
# node.attr.remote_store.translog.repository: my-repo-1
#
# ---------------------------------- Experimental Features ------------------------>
#
#opensearch.experimental.feature.segment_replication_experimental.enabled: false
#
# Gates the functionality of a new parameter to the snapshot restore API
# that allows for creation of a new index type that searches a snapshot
# directly in a remote repository without restoring all index data to disk
# ahead of time.
#
#opensearch.experimental.feature.searchable_snapshot.enabled: false
#
#
# Gates the functionality of enabling extensions to work with OpenSearch.
# This feature enables applications to extend features of OpenSearch outside of
# the core.
#
#opensearch.experimental.feature.extensions.enabled: false
#
#
# Gates the concurrent segment search feature. This feature enables concurrent segm>
# index searcher threadpool.
#
#opensearch.experimental.feature.concurrent_segment_search.enabled: false

# ----------------- Start OpenSearch Security Demo Configuration -----------------
#
plugins.security.disabled: true
#
# WARNING: revise all the lines below before you go into production
#
#plugins.security.ssl.transport.pemcert_filepath: esnode.pem
#plugins.security.ssl.transport.pemkey_filepath: esnode-key.pem
#plugins.security.ssl.transport.pemtrustedcas_filepath: root-ca.pem
#plugins.security.ssl.transport.enforce_hostname_verification: false
#plugins.security.ssl.http.enabled: true
#plugins.security.ssl.http.pemcert_filepath: esnode.pem
#plugins.security.ssl.http.pemkey_filepath: esnode-key.pem
#plugins.security.ssl.http.pemtrustedcas_filepath: root-ca.pem
#plugins.security.allow_unsafe_democertificates: true
#plugins.security.allow_default_init_securityindex: true
#plugins.security.authcz.admin_dn:
#  - CN=kirk,OU=client,O=client,L=test, C=de
#
#plugins.security.audit.type: internal_opensearch
#plugins.security.enable_snapshot_restore_privilege: true
#plugins.security.check_snapshot_restore_write_privileges: true
#plugins.security.restapi.roles_enabled: ["all_access", "security_rest_api_access"]
#plugins.security.system_indices.enabled: true
#plugins.security.system_indices.indices: [".plugins-ml-config", ".plugins-ml-connec>
#node.max_local_storage_nodes: 3
#
# ------------------ End OpenSearch Security Demo Configuration ------------------

```

`opensearch.service`:

```service
[Unit]
Description=OpenSearch
Wants=network-online.target
After=network-online.target

[Service]
Type=forking
RuntimeDirectory=data

WorkingDirectory=/opt/opensearch
ExecStart=/opt/opensearch/bin/opensearch -d

User=opensearch
Group=opensearch
StandardOutput=journal
StandardError=inherit

# Specifies the maximum file descriptor number that can be opened by this process
LimitNOFILE=65535

# Specifies the maximum number of processes
LimitNPROC=4096

# Specifies the maximum size of virtual memory
LimitAS=infinity

# Specifies the maximum file size
LimitFSIZE=infinity

# Disable timeout logic and wait until process is stopped
TimeoutStopSec=0

# SIGTERM signal is used to stop the Java process
KillSignal=SIGTERM

# Send the signal only to the JVM rather than its control group
KillMode=process

# Java process is never killed
SendSIGKILL=no

# When a JVM receives a SIGTERM signal it exits with code 143
SuccessExitStatus=143

# Allow a slow startup before the systemd notifier module kicks in to extend the timeout
TimeoutStartSec=75

[Install]
WantedBy=multi-user.target
```
