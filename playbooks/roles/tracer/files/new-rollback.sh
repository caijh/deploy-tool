#!/bin/sh

source ./config/config.ini

kubectl delete -f config/main.yaml
