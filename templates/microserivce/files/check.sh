#!/bin/sh
source ./config/config.ini

if ! kubectl get deploy $app_name -n $k8s_namespace &> /dev/null 
then
    echo -n "New"
    exit 0
fi

local image_tag=$(kubectl get deploy $app_name -n $k8s_namespace -o wide | grep $app_name | awk '{print $7}' | awk -F: '{print $2}')
if condition 
then
    echo -n "Upgrade"
fi
