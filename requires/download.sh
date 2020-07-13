#!/usr/bin/env bash

bin="${BASH_SOURCE-$0}"
bin_dir="$(cd "$(dirname "$bin")" || exit ; pwd)"
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
CONTAINERD_VER=1.2.6

echo -e "\n----download ca tools"
wget https://pkg.cfssl.org/R1.2/cfssl_linux-amd64 -t 0 --continue -O "$base_dir/plugins/cfssl/cfssl"
wget https://pkg.cfssl.org/R1.2/cfssljson_linux-amd64 -t 0 --continue -O "$base_dir/plugins/cfssl/cfssljson"
wget https://pkg.cfssl.org/R1.2/cfssl-certinfo_linux-amd64 -t 0 --continue -O "$base_dir/plugins/cfssl/cfssl-certinfo"

echo -e "\n----download docker binary at:"
wget "https://download.docker.com/linux/static/stable/x86_64/docker-${DOCKER_VER}.tar.tgz" -t 0 --continue

echo -e "\n----download etcd binary at:"
wget "https://github.com/etcd-io/etcd/releases/download/${ETCD_VER}/etcd-${ETCD_VER}-linux-amd64.tar.gz" -t 0 --continue
# 解压文件至plugins/etcd

echo -e "\n----download k8s binary"
wget https://dl.k8s.io/${K8S_VER}/kubernetes-server-linux-amd64.tar.gz
#tar  xzvf kubernetes-server-linux-amd64.tar.gz


echo -e "\n----download cni plugins at:"
wget https://github.com/containernetworking/plugins/releases/download/${CNI_VER}/cni-plugins-linux-amd64-${CNI_VER}.tgz

# echo -e "\n----download docker-compose at:"
# echo -e https://github.com/docker/compose/releases/download/${DOCKER_COMPOSE_VER}/docker-compose-Linux-x86_64

# echo -e "\n----download harbor-offline-installer at:"
# echo -e https://storage.googleapis.com/harbor-releases/harbor-offline-installer-${HARBOR_VER}.tgz



# echo -e "\n----download containerd at:"
# echo -e  https://storage.googleapis.com/cri-containerd-release/cri-containerd-${CONTAINERD_VER}.linux-amd64.tar.gz

function download_offline_image() {
  # images needed by k8s cluster
  corednsVer=1.6.6
  metricsVer="v0.3.6"
  dashboardVer=v2.0.0
  dashboardMetricsScraperVer=v1.0.4
  flannelVer=v0.12.0-amd64
  pauseVer=3.1

  imageDir="$base_dir/requires"
  [[ -d "$imageDir" ]] || { echo "[ERROR] $imageDir not existed!"; exit 1; }

  echo -e "[INFO] \033[33mdownloading offline images\033[0m"

  if [[ ! -f "$imageDir/pause_$pauseVer.docker" ]];then
    docker pull mirrorgooglecontainers/pause-amd64:${pauseVer} && \
    docker save -o "${imageDir}/pause_${pauseVer}.docker" mirrorgooglecontainers/pause-amd64:${pauseVer}
  fi
  if [[ ! -f "$imageDir/flannel_$flannelVer.docker" ]];then
    docker pull quay.mirrors.ustc.edu.cn/coreos/flannel:${flannelVer} && \
    docker save -o "${imageDir}/flannel_${flannelVer}.docker" quay.mirrors.ustc.edu.cn/coreos/flannel:${flannelVer}
  fi
  if [[ ! -f "$imageDir/coredns_$corednsVer.docker" ]];then
    docker pull coredns/coredns:${corednsVer} && \
    docker save -o "${imageDir}/coredns_${corednsVer}.docker" coredns/coredns:${corednsVer}
  fi
  if [[ ! -f "$imageDir/metrics-server_$metricsVer.docker" ]];then
    docker pull mirrorgooglecontainers/metrics-server-amd64:${metricsVer} && \
    docker save -o "${imageDir}/metrics-server_${metricsVer}.docker" mirrorgooglecontainers/metrics-server-amd64:${metricsVer}
  fi
  if [[ ! -f "$imageDir/dashboard_$dashboardVer.docker" ]];then
    docker pull kubernetesui/dashboard:${dashboardVer} && \
    docker save -o "${imageDir}/dashboard_${dashboardVer}.docker" kubernetesui/dashboard:${dashboardVer}
  fi
  if [[ ! -f "$imageDir/metrics-scraper_$dashboardMetricsScraperVer.docker" ]];then
    docker pull kubernetesui/metrics-scraper:${dashboardMetricsScraperVer} && \
    docker save -o "${imageDir}/metrics-scraper_${dashboardMetricsScraperVer}.docker" kubernetesui/metrics-scraper:${dashboardMetricsScraperVer}
  fi
}


download_offline_image
