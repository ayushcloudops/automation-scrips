#!/bin/bash

# Prompt for instance name
read -p "Enter instance name: " instance_name

# Prompt for AMI ID
read -p "Enter AMI ID: " ami_id

# Prompt for instance type
read -p "Enter instance type: " instance_type

# Prompt for keypair name
read -p "Enter keypair name: " keypair_name

# Prompt for VPC ID
read -p "Enter VPC ID: " vpc_id

# Prompt for subnet ID
read -p "Enter subnet ID: " subnet_id

# Prompt for private IP address
read -p "Enter private IP address: " private_ip

# Prompt for security groups (comma separated)
read -p "Enter security groups (comma separated): " security_groups

#Add IAM
read -p "iam role needs to be added: " iam_role

#Add Tag
read -p "tag key to be add: " tag_key
read -p "tag Value to be add: " tag_value

#Add termination protection

read -p "termination protection (true/false): " termination

# Create the instance
# instance_id=$(aws ec2 run-instances --image-id "$ami_id" --count 1 --instance-type "$instance_type" --key-name "$keypair_name" --subnet-id "$subnet_id" --private-ip-address "$private_ip" --security-group-ids "$security_groups" --query 'Instances[0].InstanceId' --output text)
instance_id=$(aws ec2 run-instances --image-id "$ami_id" --count 1 --instance-type "$instance_type" --key-name "$keypair_name" --subnet-id "$subnet_id" --private-ip-address "$private_ip" --security-group-ids "$security_groups" --iam-instance-profile Name="$iam_role" --tag-specifications 'ResourceType=instance,Tags=[{Key=Name,Value=$instance_name},{Key="$tag_key",Value="$tag_value"}]' --disable-api-termination "$termination"
)
# Add name tag to the instance
aws ec2 create-tags --resources "$instance_id" --tags Key=Name,Value="$instance_name"

echo "Instance $instance_name created with ID $instance_id"