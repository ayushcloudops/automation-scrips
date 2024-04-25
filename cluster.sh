
contexts=$(kubectl config get-contexts | awk '{ print $2 }' | tail -n+2) 
# Loop through each element and print it
for cluster in "$contexts"
do
  kubectl config use-context $cluster
  kubectl get po -A | grep autoscaler
  response=`echo $?`
  if [ $? -gt 0 ]
  then 
    echo $element>>cluster.txt
  fi
done

