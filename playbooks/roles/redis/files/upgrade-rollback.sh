#!/bin/sh

source ./config/config.ini

kubectl apply backup/config/deployment_$app_name.yaml -n $k8s_namespace
