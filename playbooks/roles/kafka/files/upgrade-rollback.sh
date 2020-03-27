#!/bin/sh

source ./config/config.ini

kubectl -n $k8s_namespace apply -f backup/config/statefulfet_$app_name.yaml
kubectl -n $k8s_namespace apply -f backup/config/service_$app_name.yaml

kubectl -n $k8s_namespace apply -f backup/config/deploy_kafka-manager.yaml
kubectl -n $k8s_namespace apply -f backup/config/service_kafka-manager.yaml
