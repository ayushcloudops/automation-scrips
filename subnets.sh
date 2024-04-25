#!/bin/bash

echo "Enter cluster name: "
read cluster
echo "Enter profile name: "
read profile
echo "Enter region : "
read region

python3 subnets.py $profile $region $cluster

cat subnet_details.csv >> subnets.csv

