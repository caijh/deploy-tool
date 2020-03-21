#!/bin/sh
source ./config/config.ini

function version_gt() { test "$(echo "$@" | tr " " "\n" | sort -V | head -n 1)" != "$1"; }

if ! kubectl get deploy $app_name -n $k8s_namespace &> /dev/null 
then
    echo -n "New"
    exit 0
fi

local old_image_tag=$(kubectl get deploy $app_name -n $k8s_namespace -o wide | grep $app_name | awk '{print $7}' | awk -F: '{print $2}')
if version_gt image_tag old_image_tag
then
    echo -n "Upgrade"
fi
