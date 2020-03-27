#!/bin/sh

kubectl delete -f config/zookeeper.yaml
kubectl delete -f config/kafka.yaml
kubectl delete -f config/kafka-manager.yaml
