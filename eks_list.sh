#!/bin/bash

# Get a list of all available regions
regions=$(aws ec2 describe-regions --profile 677163682080_Demo-Devops-All --output text | awk '{print $NF}')

# Loop through the list of regions
for region in $regions
do
  echo "Region: $region"
  
  # Get a list of EKS clusters in the current region
  clusters=$(aws eks list-clusters --region $region --profile 677163682080_Demo-Devops-All)
  
  # Loop through the list of clusters in the current region
  for cluster in $(echo $clusters | jq -r '.clusters[]')
  do
    echo "  Cluster Name: $cluster"
  done
done

