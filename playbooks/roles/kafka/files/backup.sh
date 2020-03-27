#!/bin/sh

source ./config/config.ini

if [ ! -d backup/config ] 
then
    mkdir -p backup/config
fi

kubectl get statefulfet $app_name -n $k8s_namespace -o yaml --export > backup/config/statefulfet_$app_name.yaml
kubectl get service $app_name -n $k8s_namespace -o yaml --export > backup/config/service_$app_name.yaml

kubectl get deploy kafka-manager -n $k8s_namespace -o yaml --export > backup/config/deploy_kafka-manager.yaml
kubectl get service kafka-manager -n $k8s_namespace -o yaml --export > backup/config/service_kafka-manager.yaml
