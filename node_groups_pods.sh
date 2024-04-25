#!/bin/sh

echo "Enter cluster name: "
read cluster
echo "Enter profile name: "
read profile
echo "Enter region : "
read region
echo "Cluster ARN"
read arn

#switch to current arn
kubectl config use-context $arn
current_context=`kubectl config current-context`
echo $current_context

#List all node groups and save it in array
node_groups=(`aws eks list-nodegroups --cluster-name $cluster --profile $profile --region $region --query nodegroups --output text`)

#List all pods logs
for i in "${node_groups[@]}"; do
    #List all nodes in a node group
    nodes=(`kubectl get nodes --selector=eks.amazonaws.com/nodegroup=$i --no-headers | awk '{ print $1 }'`)
    for N in "${nodes[@]}"; do
        pods=`kubectl get po --all-namespaces -o wide | grep $N | awk '{ print $2,"-",$3,"-",$4 }'`
        echo "$pods" >> status.txt
    done

done