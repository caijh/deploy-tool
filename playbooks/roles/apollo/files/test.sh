#!/bin/sh

source ./config/config.ini

app_name=deployment-apollo-portal-server

available=$(kubectl get deployment $app_name -n $k8s_namespace | grep $app_name | awk '{print $4}')
try_times=3
while [ $available -le 0 ] && [ $try_times -ge 0 ]
do
    sleep 15s
    available=$(kubectl get deployment $app_name -n $k8s_namespace | grep $app_name | awk '{print $4}')
    try_times=$[ $try_times - 1 ]
done

if [ $available -gt 0 ] 
then
    exit 0
else
    exit 1
fi