#!/usr/bin/env bash

bin="${BASH_SOURCE-$0}"
bin_dir="$(
  cd "$(dirname "$bin")" || exit
  pwd
)"
base_dir=$(dirname "$bin_dir")

if [ -z "$(command -v shyaml)" ]; then
  pip install shyaml
fi

props=$(cat "$base_dir/inventory/group_vars/all.yml")

ETCD_VER=$(echo "${props}" | shyaml get-value "ETCD_VER")
DOCKER_VER=$(echo "${props}" | shyaml get-value "DOCKER_VER")
K8S_VER=$(echo "${props}" | shyaml get-value "K8S_VER")
CNI_VER=$(echo "${props}" | shyaml get-value "CNI_VER")
DOCKER_COMPOSE_VER=$(echo "${props}" | shyaml get-value "DOCKER_COMPOSE_VER")
HARBOR_VER=$(echo "${props}" | shyaml get-value "HARBOR_VER")

echo -e "\n----download ca tools"
if [ ! -d "$base_dir/plugins/cfssl" ]; then
    mkdir "$base_dir/plugins/cfssl"
fi
wget https://pkg.cfssl.org/R1.2/cfssl_linux-amd64 -t 0 --continue -O "$base_dir/plugins/cfssl/cfssl"
wget https://pkg.cfssl.org/R1.2/cfssljson_linux-amd64 -t 0 --continue -O "$base_dir/plugins/cfssl/cfssljson"
wget https://pkg.cfssl.org/R1.2/cfssl-certinfo_linux-amd64 -t 0 --continue -O "$base_dir/plugins/cfssl/cfssl-certinfo"

echo -e "\n----download docker binary at:"
wget "https://download.docker.com/linux/static/stable/x86_64/docker-${DOCKER_VER}.tgz" -t 0 --continue -O "docker-${DOCKER_VER}.tgz"
tar xzvf "docker-${DOCKER_VER}.tgz" -C "$base_dir/plugins"

echo -e "\n----download docker-compose at:"
if [ ! -d "$base_dir/plugins/docker-compose" ]; then
    mkdir "$base_dir/plugins/docker-compose"
fi
wget "https://github.com/docker/compose/releases/download/${DOCKER_COMPOSE_VER}/docker-compose-Linux-x86_64" -t 0 --continue -O "$base_dir/plugins/docker-compose/docker-compose"

echo -e "\n----download etcd binary at:"

if [ ! -d "$base_dir/plugins/etcd" ]; then
  mkdir "$base_dir/plugins/etcd"
fi

wget "https://storage.googleapis.com/etcd/${ETCD_VER}/etcd-${ETCD_VER}-linux-amd64.tar.gz" -t 0 --continue -O "etcd-${ETCD_VER}-linux-amd64.tar.gz"
tar xzvf "etcd-${ETCD_VER}-linux-amd64.tar.gz" --strip-components 1 --exclude=Documentation/ --exclude=*.md -C "$base_dir/plugins/etcd"

if [ ! -d "$base_dir/plugins/kube" ]; then
  mkdir "$base_dir/plugins/kube"
fi

echo -e "\n----download k8s binary"
wget "https://dl.k8s.io/${K8S_VER}/kubernetes-server-linux-amd64.tar.gz" -t 0 --continue -O kubernetes-server-linux-amd64.tar.gz
tar xzvf kubernetes-server-linux-amd64.tar.gz --strip-components 3 --exclude=*.tar --exclude=*.docker_tag -C "$base_dir/plugins/kube"

echo -e "\n----download cni plugins at:"
wget "https://github.com/containernetworking/plugins/releases/download/${CNI_VER}/cni-plugins-linux-amd64-${CNI_VER}.tgz" -t 0 --continue -O "cni-plugins-linux-amd64-${CNI_VER}.tgz"
tar xzvf "cni-plugins-linux-amd64-${CNI_VER}.tgz" -C "$base_dir/plugins/kube"

echo -e "\n----download harbor-offline-installer at:"
wget "https://github.com/goharbor/harbor/releases/download/${HARBOR_VER}/harbor-offline-installer-${HARBOR_VER}.tgz" -t 0 --continue -O "harbor-offline-installer-${HARBOR_VER}.tgz"
