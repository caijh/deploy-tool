#!/bin/sh

source ./config/config.ini

if [ ! -d backup/config ] 
then
    mkdir -p backup/config
fi

kubectl get configmap $app_name -n $k8s_namespace -o yaml --export > backup/config/configmap_$app_name.yaml
kubectl get statefulset $app_name -n $k8s_namespace -o yaml --export > backup/config/statefulset_$app_name.yaml
kubectl get service $app_name -n $k8s_namespace -o yaml --export > backup/config/service_$app_name.yaml
