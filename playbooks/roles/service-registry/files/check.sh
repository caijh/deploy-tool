#!/bin/bash
# curl and resolve version, then compare
source ./config/config.ini

function version_gt() { test "$(echo "$@" | tr " " "\n" | sort -V | head -n 1)" != "$1"; }

app_name=eureka

if ! kubectl get statefulset $app_name -n $k8s_namespace &> /dev/null 
then
    echo -n "New"
    exit 0
fi

installed_versioon=$(kubectl get statefulset eureka -n $k8s_namespace -o=jsonpath='{.spec.template.spec.containers[0].image}' | awk -F ':' '{print $NF}')

if version_gt $version $installed_versioon
then
    echo -n "Upgrade"
fi