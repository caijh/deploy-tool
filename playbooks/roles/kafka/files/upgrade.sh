#!/bin/sh

source ./config/config.ini

kubectl apply -f config/zookeeper.yaml
kubectl apply -f config/kafka.yaml
kubectl apply -f config/kafka-manager.yaml
