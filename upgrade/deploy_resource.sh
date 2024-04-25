#!/bin/bash

# set -x

configs=$(kubectl config get-contexts | grep prod | awk '{ print $2 }')
for cluster in $configs
do 
    kubectl config use-context $cluster
    echo $cluster | awk -F '/' '{ print $2 }'
    pod_details=$(kubectl get deployments -o custom-columns="deployment:.metadata.name,deployment_resource_request_cpu:.spec.template.spec.containers[0].resources.requests.cpu,deployment_resource_limit_cpu:.spec.template.spec.containers[0].resources.limits.cpu,deployment_resource_request_memory:.spec.template.spec.containers[0].resources.requests.memory,deployment_resource_limit_memory:.spec.template.spec.containers[0].resources.limits.memory" -A)
    while IFS= read -r line; do
        deploy_name=$(echo "$line" | awk '{print $1}')
        deployment_resource_request_cpu=$(echo "$line" | awk '{print $2}')
        deployment_resource_limit_cpu=$(echo "$line" | awk '{print $3}')
        deployment_resource_request_memory=$(echo "$line" | awk '{print $4}')
        deployment_resource_limit_memory=$(echo "$line" | awk '{print $5}')
        if [[ $deployment_resource_request_cpu == "<none>" ]]; then
            echo ,$deploy_name
        fi
    done <<< "$pod_details"
    echo "------------------------------- Next Cluster --------------------------------------"
done

