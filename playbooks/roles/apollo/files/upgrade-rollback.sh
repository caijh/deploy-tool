#!/bin/sh

source ./config/config.ini

kubectl apply -n $k8s_namespace -f backup/config/deployment-apollo-portal-server.yaml

kubectl apply -n $k8s_namespace -f backup/config/deployment-apollo-admin-server-dev.yaml

kubectl apply -n $k8s_namespace -f backup/config/service-apollo-portal-server.yaml

kubectl apply -n $k8s_namespace -f backup/config/service-apollo-config-server-dev.yaml