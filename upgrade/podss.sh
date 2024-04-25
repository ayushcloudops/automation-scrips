#!/bin/bash

set -x

read -p " context : " context

kubectl config use-context $context

pod_details=$(kubectl get pods --all-namespaces --no-headers -o custom-columns="NAMESPACE:.metadata.namespace,NAME:.metadata.name")
while IFS= read -r line; do
    namespace=$(echo "$line" | awk '{print $1}')
    pod_name=$(echo "$line" | awk '{print $2}')
    status=`kubectl get po/uptycs-osquery-sc6l2 -n uptycs | awk '{ print $3 }' | grep -v "STATUS"`
    if [ $status != "Running" ]; then
        echo $pod_name >> new-status.txt
    fi
done <<< "$pod_details"
