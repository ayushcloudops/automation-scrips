import boto3
import sys
import os.path
import os

profile = sys.argv[1]
region = sys.argv[2]
cluster_arg = sys.argv[3]
regions = [str(region)]
# print(regions)

#used this function to list all the clusters in that region
def list_eks_clusters():
    list_clusters = []
    session = boto3.Session(profile_name=profile)
    eks_client = session.client('eks', region_name=region)
    response = eks_client.list_clusters()

    # Print the names of all clusters name in list_clusters list.
    for cluster in response['clusters']:
        list_clusters.append(cluster)
    
    return list_clusters

#used this function to add all the subnets in cluster_all_nodes list for each clusters
def eks_subnet_details(cluster):
    cluster_name = cluster
    session = boto3.Session(profile_name=profile)
    eks_client = session.client('eks', region_name=region)
    #cluster_subnets
    response = eks_client.describe_cluster(name=cluster_name)
    master_subnets = response['cluster']['resourcesVpcConfig']['subnetIds']
    nodegroup_subnets = []
    response = eks_client.list_nodegroups(clusterName=cluster_name)
    nodegroups = response['nodegroups']
    for nodegroup in nodegroups:
        nodegroup_details = eks_client.describe_nodegroup(clusterName=cluster_name, nodegroupName=nodegroup)
        subnets = nodegroup_details['nodegroup']['subnets']
        for subnet in subnets:        
            nodegroup_subnets.append(subnet)

    cluster_mixed_subnets = master_subnets
    cluster_mixed_subnets.extend(nodegroup_subnets)
    cluster_all_subnets = []
    [cluster_all_subnets.append(item) for item in cluster_mixed_subnets if item not in cluster_all_subnets]
    return cluster_all_subnets


#CSV File logic -> To check file already exists or not
file_exists = os.path.exists('subnet_details.csv')
if file_exists:
    # print("File already exists")
    #   os.remove("subnet_details.csv")
    f = open("subnet_details.csv", "a+")
else:
    # print("Creating new file to store subnet details")
    f = open("subnet_details.csv", "a+")
    # print("Subnet ID,Free IPs,Cluster,Region,AWS_PROFILE" , file=f)


#check in each region defined in regions list
for region in regions:
    subnet_details = {}
    session = boto3.Session(profile_name=profile)
    ec2_client = session.client('ec2', region_name=region)
    # print(region)
    # print('-------')
    all_subnets = ec2_client.describe_subnets()
    for sn in all_subnets['Subnets'] :
        subnet_free_ips = sn['AvailableIpAddressCount']
        subnet_id = sn['SubnetId']
        subnet_details.update({subnet_id: subnet_free_ips})
        #subnet details in a dict -> {"subnet-id": free-ips}
    clusters = list_eks_clusters()
    # print("Clusters in this region: {}".format(clusters))

    subnets_with_less_ip = {}
    for subnet, ip in subnet_details.items():
        if int(ip) < 20:
            subnets_with_less_ip.update({subnet: ip})
        # else:
        #     print("Ok! No issue, subnet-id: {},ip: {}".format(subnet,ip))
    for cluster in clusters:
        eks_final_subnets = eks_subnet_details(cluster) 
        # print("EKS Details = {},{}".format(cluster,eks_final_subnets))
        for subnet, ip in subnets_with_less_ip.items():
            if subnet in eks_final_subnets:
                if str(cluster) == str(cluster_arg):
                    print("subnet used in eks cluster ----------- {},{},{},{},{}".format(subnet,ip,cluster,region,profile))
                    print(f"{subnet},{int(ip)},{cluster},{region},{profile}" , file=f)

f.close() 