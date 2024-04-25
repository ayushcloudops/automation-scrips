profile=$(cat ~/.aws/config | grep profile | grep -i prod | tr -d '[]' | sed 's/profile //')
for i in $profile
    do 
        accountid=`echo $i | awk -F '_' '{ print $1 }'`
        #echo $accountid
        configs=$(kubectl config get-contexts | awk '{ print $2 }' | tail -n+2 | grep $accountid)
        for j in $configs
            do
                kubectl config use-context $j
                current_cluster=`kubectl config current-context`
                echo $current_cluster
                cluster_name=`kubectl config current-context | awk -F '/' '{ print $2 }'` >> bad-pods.csv
                echo "Bad Pods below"
                kubectl get pods -A --no-headers | grep -v Running | grep -v Completed
                if [ $? -gt 0 ]
                then 
                    kubectl get pods -A --no-headers | grep -v -E 'Running|Completed' | awk '{print $1","$2","$3","$4}' >> bad-pods.csv
                fi
                echo " --------------------- Next Account ------------------------------"
            done
    done