#!/bin/sh

source ./config/config.ini

kubectl -n $k8s_namespace apply -f backup/config/configmap_$app_name.yaml
kubectl -n $k8s_namespace apply -f backup/config/statefulset_$app_name.yaml
kubectl -n $k8s_namespace apply -f backup/config/service_$app_name.yaml
