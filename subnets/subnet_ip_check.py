import boto3

def calculate_available_ips(cidr_block, occupied_ips):
    # Calculate the total number of IPs in the subnet
    ip_count = sum(2**(32 - int(cidr.split('/')[1])) for cidr in cidr_block.split(','))

    # Subtract the number of occupied IPs from the total
    available_ips = ip_count - occupied_ips

    return available_ips


def list_subnets_with_less_ips(profile):
    # Create a new session with the specified profile
    session = boto3.Session(profile_name=profile)
    
    # Get all available regions
    ec2_regions = session.get_available_regions('ec2')

    # Iterate through each region
    for region in ec2_regions:
        # Create a new EC2 client for the region
        ec2_client = session.client('ec2', region_name=region)

        # Describe all the subnets in the region
        response = ec2_client.describe_subnets()

        # Iterate through each subnet
        for subnet in response['Subnets']:
            subnet_id = subnet['SubnetId']
            cidr_block = subnet['CidrBlock']

            # Describe the instances in the subnet
            response = ec2_client.describe_instances(
                Filters=[
                    {
                        'Name': 'subnet-id',
                        'Values': [subnet_id]
                    }
                ]
            )

            # Count the number of occupied IPs in the subnet
            occupied_ips = sum(len(reservations['Instances']) for reservations in response['Reservations'])

            # Calculate the number of available IPs in the subnet
            available_ips = calculate_available_ips(cidr_block, occupied_ips)

            # Check if the available IPs are less than 20
            if available_ips < 20:
                print(f"Subnet ID: {subnet_id} in Region: {region} has less than 20 available IPs.")

list_subnets_with_less_ips('your-aws-profile')

