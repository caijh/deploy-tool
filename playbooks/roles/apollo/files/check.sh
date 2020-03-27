#!/bin/sh

source ./config/config.ini

app_name=deployment-apollo-admin-server-dev

# 在命名空间上找到该app_name的deploy, echo -n "New"
if ! kubectl get deploy $app_name -n $k8s_namespace &> /dev/null 
then
    echo -n "New"
    exit 0
fi

echo -n "Upgrade"