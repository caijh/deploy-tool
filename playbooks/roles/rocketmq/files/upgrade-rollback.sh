#!/bin/sh

source ./config/config.ini

kubectl apply -f backup/config/statefulfet_$app.yaml -n $k8s_namespace
kubectl apply -f backup/config/statefulfet_rmqbroker.yaml -n $k8s_namespace
