#!/bin/bash

#set -x

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
        echo $cluster_name
    fi
done
