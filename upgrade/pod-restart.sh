#!/bin/bash

pods=$(kubectl get po -n kafka | grep kafka-connect-cluster-connect | awk '{ print $1 }')

for i in $pods
do
    kubectl delete pod $i -n kafka
done