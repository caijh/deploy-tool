#!/bin/sh
source ./config/config.ini

if ! kubectl get statefulset $app_name -n $k8s_namespace &> /dev/null 
then
    echo -n "New"
    exit 0
fi
echo -n "Upgrade"
