#!/bin/sh

contexts=(`kubectl config get-contexts --no-headers | awk '{print $2}'`)
for cluster in ${contexts[@]};
do
    # echo $cluster
    kubectl config use-context $cluster
    current_cluster=`kubectl config current-context`
    echo $current_cluster
    cluster_name=`kubectl config current-context | awk -F '/' '{ print $2 }'`
    kubectl get po -A | grep autoscaler
    if [ $? -gt 0 ]
    then 
        echo $cluster_name>>cluster.txt
    fi
done