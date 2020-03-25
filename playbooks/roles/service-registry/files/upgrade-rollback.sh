#!/bin/bash
source ./config/config.ini

kubectl apply -f ./backup/config/eureka-statefulset.yaml -n $k8s_namespace