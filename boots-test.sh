#!/bin/bash

# set -x

read -p " Enter bootstrap server url : " input

contexts=$(kubectl config get-contexts | awk '{ print $2 }' | tail -n+2)

echo "Namespace","Cluster","URL" >> url.csv
for cluster in $contexts
do      
    kubectl config use-context $cluster
    kubectl get ing -A | grep $input
    if [ $? -eq 0 ]; then
        namespace=`kubectl get ing -A | grep $input | awk '{ print $1 }'`
        cluster_name=`kubectl config current-context | awk -F '/' '{ print $2 }'`
        echo $namespace,$cluster_name,$input>>url.csv
    else 
        pod_details=$(kubectl get pods --all-namespaces --no-headers -o custom-columns="NAMESPACE:.metadata.namespace,NAME:.metadata.name" | grep kafka)
        while IFS= read -r line; do
            namespace=$(echo "$line" | awk '{print $1}')
            pod_name=$(echo "$line" | awk '{print $2}')
            kubectl describe po/$pod_name -n $namespace | grep $input
            if [ $? -eq 0 ]; then
                cluster_name=`kubectl config current-context | awk -F '/' '{ print $2 }'`
                echo $namespace,$cluster_name,$input>>url.csv
            fi
        done <<< "$pod_details"
    fi
done
