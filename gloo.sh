#!/bin/bash
set -o errexit

image_url=registry.cn-beijing.aliyuncs.com/mypjb

image_version=1.9.1

image_commands[0]="ctr -n k8s.io image pull ${image_url}/gloo-certgen:${image_version} && ctr -n k8s.io image tag ${image_url}/gloo-certgen:${image_version} quay.io/solo-io/certgen:${image_version}"

image_commands[1]="ctr -n k8s.io image pull ${image_url}/gloo-discovery:${image_version} && ctr -n k8s.io image tag ${image_url}/gloo-discovery:${image_version} quay.io/solo-io/discovery:${image_version}"

image_commands[2]="ctr -n k8s.io image pull ${image_url}/gloo-gateway:${image_version} && ctr -n k8s.io image tag ${image_url}/gloo-gateway:${image_version} quay.io/solo-io/gateway:${image_version}"

image_commands[3]="ctr -n k8s.io image pull ${image_url}/gloo-envoy-wrapper:${image_version} && ctr -n k8s.io image tag ${image_url}/gloo-envoy-wrapper:${image_version} quay.io/solo-io/gloo-envoy-wrapper:${image_version}"

image_commands[4]="ctr -n k8s.io image pull ${image_url}/gloo:${image_version} && ctr -n k8s.io image tag ${image_url}/gloo:${image_version} quay.io/solo-io/gloo:${image_version}"

if [ "${1}" == "pull" ];then

	echo "pull images"
	
	for image_command in "${image_commands[@]}";do
		bash -c "$image_command"
	done	
else
	echo "Download and install glooctl"
	
	curl -Lo glooctl https://github.com/solo-io/gloo/releases/download/v1.9.1/glooctl-linux-amd64
	
	chmod 111 glooctl
	
	mv glooctl  /usr/bin/
	
	glooctl version
	
	glooctl completion bash > /etc/bash_completion.d/glooctl
	
	source <(glooctl completion bash)
	
	echo "Use the following command to install"

	echo "glooctl install (gateway or ingress or knative)"
        
	echo "OR use => kubectl apply -f gloo/gloo.yaml"

	echo "Use the following command to pull the image in advance"
	
	for image_command in "${image_commands[@]}";do
		echo -e "$image_command\r\n"
	done	
fi


