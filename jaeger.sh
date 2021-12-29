#!/bin/bash

set -o errexit

image_url=registry.cn-beijing.aliyuncs.com/mypjb

image_version=v0.8.0

image_commands[0]="ctr -n k8s.io image pull ${image_url}/kube-rbac-proxy:${image_version} && ctr -n k8s.io image tag ${image_url}/kube-rbac-proxy:${image_version} gcr.io/kubebuilder/kube-rbac-proxy:${image_version}"


if [ "${1}" == "pull" ];then
	echo "pull images"
	
	for image_command in "${image_commands[@]}";do
		bash -c "$image_command"
	done
	
else
	
	echo "Install Jaeger operator "
	
	kubectl create namespace observability
	
	kubectl apply -f https://github.com/jaegertracing/jaeger-operator/releases/download/v1.29.0/jaeger-operator.yaml
fi
