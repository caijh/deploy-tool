#!/bin/sh

source ./config/config.ini

if [ ! -d backup/config ] 
then
    mkdir -p backup/config
fi

kubectl get deploy deployment-apollo-portal-server -n $k8s_namespace -o yaml --export > backup/config/deployment-apollo-portal-server.yaml

kubectl get deploy deployment-apollo-admin-server-dev -n $k8s_namespace -o yaml --export > backup/config/deployment-apollo-admin-server-dev.yaml

kubectl get service service-apollo-portal-server -n $k8s_namespace -o yaml --export > backup/config/service-apollo-portal-server.yaml

kubectl get service service-apollo-config-server-dev -n $k8s_namespace -o yaml --export > backup/config/service-apollo-config-server-dev.yaml