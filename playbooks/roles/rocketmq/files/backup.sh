#!/bin/sh

source ./config/config.ini

if [ -d backup/config] 
then
    mkdir backup/config -p
fi

kubectl get statefulfet $app_name -n $k8s_namespace -o yaml --export > backup/config/statefulfet_$app_name.yaml
kubectl get statefulfet rmqbroker -n $k8s_namespace -o yaml --export > backup/config/statefulfet_rmqbroker.yaml
