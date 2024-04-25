#!/bin/bash

echo "Enter cluster name: "
read cluster
echo "Enter profile name: "
read profile
echo "Enter region : "
read region
echo "Cluster ARN"
read arn

kubectl config use-context $arn
current_context=`kubectl config current-context`
echo $current_context

echo " Calculating subnet "

#run python script 
python3 subnets.py $profile $region $cluster


echo "----------------------------------------------------------------------------"

echo " Capturing current response of ingress hosts "

#URLs List
URLS=(`kubectl get ing --all-namespaces | awk '{ print $4 }' | tail -n +2`)

#Declaration of csv file
OUTPUT_FILE="status_codes.csv"

#Remove the file if it already exists
rm -rf $OUTPUT_FILE

#Initialization of csv file
echo "HOST,Status_Codes" >> $OUTPUT_FILE

#Capture the status
for URL in "${URLS[@]}"; do
  STATUS_CODE=$(curl -I "$URL" -o /dev/null -w "%{http_code}\n")
  echo "$URL,$STATUS_CODE" >> "$OUTPUT_FILE"
done

echo "-----------------------------------------------------------------------------"

echo " Capturing current Node Type "

Ng=(`aws eks list-nodegroups --cluster-name $cluster --profile $profile --region $region --query nodegroups[] --output text`)
for Ng in "${Ng[@]}"; do
  capacity=`aws eks --region $region describe-nodegroup --nodegroup-name $Ng --cluster-name $cluster --profile $profile --query "nodegroup.capacityType" --output text`
  echo "$Ng,$capacity" >> ng_capacity.csv
done

echo " ------------------------------------------------------------------------------ "

#install csv module
pip3 install pyexcel pyexcel-xlsx
python3 pando.py


echo "------------------------ Removing CSV Files -------------------------------"
#remove all csv file
rm -rf ng_capacity.csv status_codes.csv subnet_details.csv

echo " Please check output excel file and Happy Cluster Upgrade "