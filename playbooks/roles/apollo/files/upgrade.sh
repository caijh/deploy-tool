#!/bin/sh

source ./config/config.ini

kubectl delete service service-apollo-portal-server -n $k8s_namespace

kubectl delete service service-apollo-config-server-dev -n $k8s_namespace

kubectl apply -f config/main.yaml -n $k8s_namespace