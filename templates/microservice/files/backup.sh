#!/bin/sh

source .config/config.ini

if [ ! -d backup/config ] 
then
    mkdir -p backup/config
fi

kubectl get deploy $app_name -n $k8s_namespace -o yaml --export > backup/config/deployment_$app_name.yaml

kubectl get service $app_name -n $k8s_namespace -o yaml --export > backup/config/service_$app_name.yaml