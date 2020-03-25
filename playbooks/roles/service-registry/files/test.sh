#!/bin/bash
source ./config/config.ini

app_name=eureka

available=$(kubectl get statefulset $app_name -n $k8s_namespace | grep $app_name | awk '{print $2}' | awk 'BEGIN{FS="/"}{print $1}')
try_times=3
while [ $available -le 0 ] && [ $try_times -ge 0 ]
do
    sleep 30s
    available=$(kubectl get statefulset $app_name -n $k8s_namespace | grep $app_name | awk '{print $2}' | awk 'BEGIN{FS="/"}{print $1}')
    try_times=$[ $try_times - 1 ]
done

if [ $available -gt 0 ] 
then
    exit 0
else
    exit 1
fi