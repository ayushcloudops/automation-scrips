#!/bin/sh

contexts=(`kubectl config get-contexts --no-headers | grep prod | awk '{print $2}'`)
for cluster in ${contexts[@]};
do
    # echo $cluster
    kubectl config use-context $cluster
    current_cluster=`kubectl config current-context`
    echo $current_cluster
    cluster_name=`kubectl config current-context | awk -F '/' '{ print $2 }'`
    echo "Bad Pods below"
    kubectl get pods -A --no-headers | grep -v Running | grep -v Completed
    if [ $? -gt 0 ]
    then 
        kubectl get pods -A --no-headers | grep -v -E 'Running|Completed' | awk '{print $1","$2","$3","$4}'
    fi
done
echo " -------------------------- Next cluster ------------------------------"