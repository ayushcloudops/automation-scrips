#!/bin/bash

read -p "Enter Env (Demo/Prod/Stage)" env

ls subnet_details.csv
file_exist=`echo $?`

if [ $file_exist -eq 0 ]
then
    rm -rf subnet_details.csv
fi

if [ $env == "Prod" ]
then
    profile=$(cat ~/.aws/config | grep profile | grep -i prod | tr -d '[]' | sed 's/profile //')
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

elif [ $env == "Demo" ]
then
    profile=$(cat ~/.aws/config | grep profile | grep Demo | tr -d '[]' | sed 's/profile //')
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



fi