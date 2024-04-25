#!/bin/sh
#Fetch context-Name
contexts=(`kubectl config get-contexts --no-headers | awk '{print $2}'`)
echo "CLUSTER","NAMESPACE","VALUE">single_csv.csv
for cluster in ${contexts[@]};
do
    # echo $cluster
    kubectl config use-context $cluster
    current_cluster=`kubectl config current-context`
    echo $current_cluster
    cluster_name=`kubectl config current-context | awk -F '/' '{ print $2 }'`
    #echo " ">>single_csv.csv
    #echo $cluster_name>>single_csv.csv 
    kubectl get pods -o yaml -A | egrep "namespace:|:443" | egrep -v "ownerReferences|--|monit|prometheus|kubesystem|linkerd|resourceVersion|security_protocol|check_hostname|False" | awk '{ if ($1 == "namespace:") { namespace = $2 } else if ($1 == "value:") { printf('$cluster_name',"%-30s %-50s\n", namespace, $2) } }'>>single_csv.csv

# kubectl config use-context $cluster 2>&1 > /dev/null
# kubectl get pods -o yaml -A | egrep "namespace:|:443" | egrep -v "ownerReferences|--|monit|prometheus|kubesystem|linkerd|resourceVersion|security_protocol|check_hostname|False" | awk 'BEGIN { printf("%-30s %-50s\n", "NAMESPACE", "VALUE") } { if ($1 == "namespace:") { namespace = $2 } else if ($1 == "value:") { printf("%-30s %-50s\n", namespace, $2) } }' 2>&1 > /dev/null
# #kubectl config current-context
done