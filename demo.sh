#Enter Cluster name
echo "Enter cluster name:"
read cluster

#set context
config=`kubectl config get-contexts | grep $cluster | awk '{ print $2 }'`
kubectl config use-context $config
 
# Get the list of all nodes in the cluster
NODES=$(kubectl get nodes -o jsonpath='{range .items[*]}{.metadata.name}{"\n"}{end}')

# Loop through each node and list all the evicted pods
for NODE in $NODES
do
  echo "Node: $NODE"
  kubectl get pods --all-namespaces --field-selector spec.nodeName=$NODE,status.phase=Failed | grep Evicted >> demo.csv
done 



