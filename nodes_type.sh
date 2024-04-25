# Replace the placeholder "my-cluster-name" with the actual name of the cluster you want to list node groups for
CLUSTER_NAME="neura-sapi"

# Set the region to us-west-1
REGION="us-west-1"

# Use the AWS CLI to describe the node groups for the specified cluster and region, filtered by on-demand instance type
aws eks --region $REGION describe-nodegroup --cluster-name $CLUSTER_NAME --profile 484221128929_BV-Stage-Devops-All --nodegroup-name paraxel-demo-1-22
