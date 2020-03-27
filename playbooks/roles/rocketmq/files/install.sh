#!/bin/sh
source config/config.ini

kubectl apply -f config/main.yaml -n $k8s_namespace
