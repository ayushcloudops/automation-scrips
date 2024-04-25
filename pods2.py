import os
import csv

# Run the kubectl top command to retrieve pod CPU usage data
#cmd = "kubectl top pods --all-namespaces --no-headers --use-protocol-buffers --containers | awk '{print $1 \",\" $2 \",\" $3}'"
cmd = "kubectl top pods --all-namespaces --no-headers --use-protocol-buffers --containers | awk '{print $1 "," $2 "," $3}'"
pod_cpu_output = os.popen(cmd).read()

# Parse the output into a list of tuples
pod_cpu_lines = pod_cpu_output.strip().split("\n")
pod_cpu_data = [tuple(line.split(",")) for line in pod_cpu_lines]

# Save the pod CPU usage data to a CSV file
with open('pod_cpu_usage.csv', 'w', newline='') as csvfile:
    csv_writer = csv.writer(csvfile)
    csv_writer.writerow(['Namespace', 'Pod Name', 'CPU Usage'])
    csv_writer.writerows(pod_cpu_data)
