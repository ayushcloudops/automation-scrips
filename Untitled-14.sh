#!/bin/bash

# set -x

kubectl config use-context arn:aws:eks:us-west-1:499910905315:cluster/us-west-prod-kakfa-cluster
pod_details=$(kubectl get pods -n kafka --no-headers -o custom-columns="NAMESPACE:.metadata.namespace,NAME:.metadata.name,STATUS:.status.phase" | grep kafka-lambda-connect-cluster-connect)
while IFS= read -r line; do
    pod_name=$(echo "$line" | awk '{print $2}')
    status=$(echo "$line" | awk '{print $3}')
    if [ $status != "Running" ]; then
        kubectl delete po/$pod_name -n kafka
    fi
done <<< "$pod_details"

