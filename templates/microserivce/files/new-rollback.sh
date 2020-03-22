#!/bin/sh
source ./config/config.ini

kubectl delete -f config/main.yaml -n $k8s_namespace