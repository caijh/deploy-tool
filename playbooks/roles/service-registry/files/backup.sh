#!/bin/bash
source ./config/config.ini

if [ ! -d ./backup/config ] 
then
    mkdir ./backup/config -p   
fi

kubectl get statefulset eureka -n $k8s_namespace -o yaml --export > ./backup/config/eureka-statefulset.yaml