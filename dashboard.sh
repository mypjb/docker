#!/bin/bash

image_url=registry.cn-beijing.aliyuncs.com/mypjb

dashboard_dir="dashboard"

dashboard_certs_dir=${3:-"dashboard/certs"}

dashboard_default_host="ui.k8s.lass.net"

dashboard_host=${2:-"${dashboard_default_host}"}

if [ "${1}" == "gloo" ];then

	kubectl apply -f $dashboard_dir/userSetting.yaml

	sed -i "s/Bearer .*/Bearer $(kubectl -n kubernetes-dashboard get secrets $(kubectl -n kubernetes-dashboard get secrets | grep super-admin-token | cut -d ' ' -f 1) -o jsonpath='{.data.token}' | base64 --decode)/g" $dashboard_dir/gloo-proxy.yaml
	
	kubectl apply -f $dashboard_dir/gloo-proxy.yaml
else

	mkdir -p $dashboard_certs_dir

	if [ ! -f "${dashboard_certs_dir}/tls.key" ];then
		echo -e " $dashboard_certs_dir Automatic certificate generation was not detected"
		openssl req -x509 -nodes -days 365 \
		-newkey rsa:2048 -keyout $dashboard_certs_dir/tls.key \
		-out $dashboard_certs_dir/tls.crt \
		-subj "/CN=${dashboard_host}"

		sed -i "s/${dashboard_default_host}/${dashboard_host}/g" $dashboard_dir/gloo-proxy.yaml
	fi
	

	echo "Create kubernetes-dashboard-certs tls secret"
	
	kubectl create namespace kubernetes-dashboard

	kubectl -n kubernetes-dashboard create \
	secret tls kubernetes-dashboard-certs \
	--key $(pwd)/$dashboard_certs_dir/tls.key \
	--cert $(pwd)/$dashboard_certs_dir/tls.crt
	
	kubectl apply -f $dashboard_dir/recommended.yaml
	
	echo "Use the following command to pull the image in advance"

	for image_command in "${image_commands[@]}";do
		echo -e "$image_command\r\n"
	done
fi

