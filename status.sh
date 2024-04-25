#!/bin/sh

#Collect the details
echo "Enter Cluster ARN"
read arn
echo "Enter node_group name"
read node_group
#Switch the context
kubectl config use-context $arn
cluster_name=`kubectl config current-context | awk -F '/' '{ print $2 }'`
echo $cluster_name
echo "NAME","READY","STATUS" >> pods__status.csv
#List all nodes and save it in array
ng=(`kubectl get nodes --selector=eks.amazonaws.com/nodegroup=$node_group --no-headers | awk '{ print $1 }'`)
for N in "${ng[@]}"; do
    kubectl get po --all-namespaces -o wide | grep $N | awk '{ print $2,",", $3,",", $4 }' >> pods__status.csv
done