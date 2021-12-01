#!/bin/bash

image_url=registry.cn-beijing.aliyuncs.com/mypjb

dashboard_certs_dir=${3:-"dashboard/certs"}

dashboard_host=${2:-"ui.k8s.lass.net"}

image_commands[0]="ctr -n k8s.io image pull ${image_url}/kubernetesui-dashboard:v2.4.0 && ctr -n k8s.io image tag ${image_url}/kubernetesui-dashboard:v2.4.0 kubernetesui/dashboard:v2.4.0"

image_commands[1]="ctr -n k8s.io image pull ${image_url}/kubernetesui-metrics-scraper:v1.0.7 && ctr -n k8s.io image tag ${image_url}/kubernetesui-metrics-scraper:v1.0.7 kubernetesui/metrics-scraper:v1.0.7"

if [ "${1}" == "pull" ];then

	echo "pull images"

	for image_command in "${image_commands[@]}";do
		bash -c "$image_command"
	done	
else

	mkdir -p $dashboard_certs_dir

	if [ ! -f "${dashboard_certs_dir}/tls.key" ];then
		echo -e " $dashboard_certs_dir Automatic certificate generation was not detected"
		openssl req -x509 -nodes -days 365 \
		-newkey rsa:2048 -keyout $dashboard_certs_dir/tls.key \
		-out $dashboard_certs_dir/tls.crt \
		-subj "/CN=${dashboard_host}"
	fi
	
	echo "Create kubernetes-dashboard-certs tls secret"
	
	kubectl -n kubernetes-dashboard create secret tls kubernetes-dashboard-certs --from-file $dashboard_certs_dir
	
	kubectl apply -f dashboard/recommended.yaml
	
	echo "Use the following command to pull the image in advance"

	for image_command in "${image_commands[@]}";do
		echo -e "$image_command\r\n"
	done
fi


