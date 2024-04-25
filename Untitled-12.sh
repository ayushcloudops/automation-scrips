#!/bin/bash

# Function to describe a pod
describe_pod() {
  local pod_name=$1
  local namespace=$2
  echo "Describing pod: $pod_name in namespace: $namespace"
  kubectl describe pod "$pod_name" -n "$namespace"
}

# Main script

# Check if kubectl is installed
if ! command -v kubectl >/dev/null 2>&1; then
  echo "kubectl command not found. Please make sure it is installed and in the system PATH."
  exit 1
fi

# Check if a search word is provided as an argument
if [ -z "$1" ]; then
  echo "Please provide a search word."
  echo "Usage: ./script.sh <search_word>"
  exit 1
fi

search_word=$1

# Fetch pod names and their namespaces, and grep for the search word
pod_details=$(kubectl get pods --all-namespaces --no-headers -o custom-columns="NAMESPACE:.metadata.namespace,NAME:.metadata.name" | grep "$search_word")

# Iterate over each pod and describe it
while IFS= read -r line; do
  namespace=$(echo "$line" | awk '{print $1}')
  pod_name=$(echo "$line" | awk '{print $2}')
  describe_pod "$pod_name" "$namespace"
done <<< "$pod_details"