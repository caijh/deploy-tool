#!/bin/sh

source ./config/config.ini

if ! kubectl get deploy $app_name -n $k8s_namespace &> /dev/null 
then
    echo -n "New"
    exit 0
fi

app_name=redis
# 对比镜像版本，版本变大，echo -n "Upgrade"
local old_image_tag=$(kubectl get deploy $app_name -n $k8s_namespace -o wide | grep $app_name | awk '{print $7}' | awk -F: '{print $2}')

if [ $old_image_tag = "latest"] 
then
    exit 0
fi

if version_gt image_tag old_image_tag
then
    echo -n "Upgrade"
fi
