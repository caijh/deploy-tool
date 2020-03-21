#!/bin/sh

source ./config/config.ini

kubectl rollout undo deployment.v1.apps/${app_name} -n $k8s_namespace