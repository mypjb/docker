#!/bin/bash
set -o errexit

image_url=registry.cn-beijing.aliyuncs.com/mypjb

image_version=1.11.0

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

        gloo_install_file=glooctl

        if [ -f "${gloo_install_file}" ];then
		echo "gloo bash file exist"
	else	
		echo "Download and install glooctl"
	
		curl -Lo ${gloo_install_file} https://github.com/solo-io/gloo/releases/download/v${image_version}/glooctl-linux-amd64
	fi

	chmod 111 ${gloo_install_file}
	
	mv ${gloo_install_file} /usr/bin/
	
	${gloo_install_file} version
	
	${gloo_install_file} completion bash > /etc/bash_completion.d/${gloo_install_file}
	
	source /etc/bash_completion.d/${gloo_install_file}
	
	echo "Use the following command to install"

	echo "glooctl install (gateway or ingress or knative)"
        
	echo "OR use => kubectl apply -f gloo/gloo.yaml"

	echo "Use the following command to pull the image in advance"
	
	for image_command in "${image_commands[@]}";do
		echo -e "$image_command\r\n"
	done	
fi


