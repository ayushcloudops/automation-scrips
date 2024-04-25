Ng=(`aws eks list-nodegroups --cluster-name test-vady-dont-delete --profile 484221128929_BV-Stage-Devops-All --region us-east-1 --query nodegroups[] --output text`)
for Ng in "${Ng[@]}"; do
  capacity=`aws eks --region us-east-1 describe-nodegroup --nodegroup-name $Ng --cluster-name test-vady-dont-delete --profile 484221128929_BV-Stage-Devops-All --query "nodegroup.capacityType" --output text`
  echo "$Ng,$capacity" >> ng_capacity.csv
done
