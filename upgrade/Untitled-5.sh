profile=$(cat ~/.aws/config | grep profile | grep Prod | tr -d '[]' | sed 's/profile //')
#echo $profile

for i in $profile
do 
    accountid=`echo $i | awk -F '_' '{ print $1 }'`
        #echo $accountid
    configs=$(kubectl config get-contexts | awk '{ print $2 }' | tail -n+2 | grep $accountid)
    for j in $configs
        do
            cluster=`echo $j | awk -F '/' '{ print $2 }'`
            region=`echo $j | awk -F ':' '{ print $4 }'`
            Kubectl config use-context $j
            # echo $i
            # echo $region
            # echo $cluster
            python3 subnets.py $i $region $cluster
            echo "---------- Next Cluster ----------------------"
        done
    echo " --------------------- Next Account ------------------------------"

done

    
Jenkins node - which has access to all cluster -- ``hal-node``


W!fip@ss#tTn