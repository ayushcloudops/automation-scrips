from kubernetes import client, config
import csv

# Load the Kubernetes configuration
config.load_kube_config()

# Initialize the Kubernetes API client
api_client = client.CoreV1Api()

# Retrieve all pods in the cluster
pods = api_client.list_pod_for_all_namespaces(watch=False)

# Create a list to hold the pod CPU usage data
pod_cpu_usage_data = []

# Iterate through the pods and retrieve their CPU usage
for pod in pods.items:
    # Get the pod's name and namespace
    pod_name = pod.metadata.name
    pod_namespace = pod.metadata.namespace
    
    # Get the pod's CPU usage
    pod_metrics = api_client.read_namespaced_pod_metrics(pod_name, pod_namespace)
    cpu_usage = pod_metrics.containers[0].usage.cpu
    
    # Add the pod's CPU usage data to the list
    pod_cpu_usage_data.append((pod_namespace, pod_name, cpu_usage))

# Save the pod CPU usage data to a CSV file
with open('pod_cpu_usage.csv', 'w', newline='') as csvfile:
    csv_writer = csv.writer(csvfile)
    csv_writer.writerow(['Namespace', 'Pod Name', 'CPU Usage'])
    csv_writer.writerows(pod_cpu_usage_data)
