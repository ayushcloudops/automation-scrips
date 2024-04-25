kubectl config use-context arn:aws:eks:ap-southeast-1:484221128929:cluster/hh-ce-staging-ap-southeast-1
pod_details=$(kubectl get pods --all-namespaces --no-headers -o custom-columns="NAMESPACE:.metadata.namespace,NAME:.metadata.name" | grep kafka)
        # Iterate over each pod and describe it
        while IFS= read -r line; do
        namespace=$(echo "$line" | awk '{print $1}')
        pod_name=$(echo "$line" | awk '{print $2}')
        kubectl describe po/pod_name -n $namespace
        # if [ $? -eq 0 ]; then
        #     # namespace=`kubectl get ing -A | grep $input | awk '{ print $1 }'`
        #     cluster_name=`kubectl config current-context | awk -F '/' '{ print $2 }'`
        #     echo $namespace,$cluster_name,$input>>url123.csv
        # fi
        done