contexts=$(kubectl get po -n alb-ingress-nginx -o wide --no-headers | awk '{ print $1 }')
for cluster in ${contexts[@]};
do
    echo $cluster
    kubectl get po -n alb-ingress-nginx -o wide | grep $cluster
    echo "------------"
done