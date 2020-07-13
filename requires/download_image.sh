#!/usr/bin/env bash

bin="${BASH_SOURCE-$0}"
bin_dir="$(cd "$(dirname "$bin")" || exit ; pwd)"
base_dir=$(dirname "$bin_dir")

function download_offline_image() {
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
