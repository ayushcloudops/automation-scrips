#!/usr/bin/env python3

import subprocess

input_url = input("Enter bootstrap server url: ")
contexts = subprocess.run(['kubectl', 'config', 'get-contexts', '-o', 'name'], capture_output=True, text=True).stdout.split("\n")

with open('url.csv', 'w') as file:
    file.write("Namespace,Cluster,URL\n")

    for context in contexts:
        if not context:
            continue

        subprocess.run(['kubectl', 'config', 'use-context', context], check=True)

        ing_output = subprocess.run(['kubectl', 'get', 'ing', '-A'], capture_output=True, text=True).stdout
        if input_url in ing_output:
            namespace = ing_output.split(input_url)[0].split()[-1]
            cluster_name = subprocess.run(['kubectl', 'config', 'current-context'], capture_output=True, text=True).stdout.split('/')[1].strip()
            file.write(f"{namespace},{cluster_name},{input_url}\n")
        else:
            kafka_pods = subprocess.run(['kubectl', 'get', 'po', '-A', '-o', 'custom-columns=:metadata.namespace,:metadata.name', '--no-headers'], capture_output=True, text=True).stdout
            for kafka_pod in kafka_pods.split('\n'):
                if not kafka_pod:
                    continue

                namespace, pod_name = kafka_pod.split()
                pod_description = subprocess.run(['kubectl', 'describe', f'po/{pod_name}', '-n', namespace], capture_output=True, text=True).stdout
                if input_url in pod_description:
                    cluster_name = subprocess.run(['kubectl', 'config', 'current-context'], capture_output=True, text=True).stdout.split('/')[1].strip()
                    file.write(f"{namespace},{cluster_name},{input_url},{pod_name}\n")
