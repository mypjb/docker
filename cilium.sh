#!/bin/bash

set -o errexit

image_url=registry.cn-beijing.aliyuncs.com/mypjb

image_version=v1.10.5

image_commands[0]="ctr -n k8s.io image pull ${image_url}/cilium:${image_version} && ctr -n k8s.io image tag ${image_url}/cilium:${image_version} quay.io/solo-io/cilium:${image_version}"

image_commands[1]="ctr -n k8s.io image pull ${image_url}/cilium-operator-generic:${image_version} && ctr -n k8s.io image tag ${image_url}/cilium-operator-generic:${image_version} quay.io/solo-io/operator-generic:${image_version}"

if [ "${1}" == "pull" ];then
	echo "pull images"
	
	for image_command in "${image_commands[@]}";do
		$image_command
	done
	
else
	
	echo "Download and install cilium"
	
	curl -L --remote-name-all https://github.com/cilium/cilium-cli/releases/latest/download/cilium-linux-amd64.tar.gz{,.sha256sum}

	sha256sum --check cilium-linux-amd64.tar.gz.sha256sum

	tar xzvfC cilium-linux-amd64.tar.gz /usr/local/bin

	rm cilium-linux-amd64.tar.gz{,.sha256sum}


	echo "Use the following command to install"

	echo "cilium install --agent-image ${image_url}/cilium:${image_version}  --operator-image ${image_url}/cilium-operator-generic:${image_version}"

fi
