#!/bin/sh
source ./config/config.ini

function version_gt() { test "$(echo "$@" | tr " " "\n" | sort -V | head -n 1)" != "$1"; }
# 在命名空间上找到该app_name的deploy, echo -n "New"
if ! kubectl get deploy $app_name -n $k8s_namespace &> /dev/null 
then
    echo -n "New"
    exit 0
fi

# 对比镜像版本，版本变大，echo -n "Upgrade"
local old_image_tag=$(kubectl get deploy $app_name -n $k8s_namespace -o wide | grep $app_name | awk '{print $7}' | awk -F: '{print $2}')
if version_gt image_tag old_image_tag
then
    echo -n "Upgrade"
fi