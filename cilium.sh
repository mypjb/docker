#!/bin/bash

set -o errexit

image_url=docker.io/cilium

image_version=v1.11.7
	
if [ "${1}" == "install" ];then

	cilium install --version ${image_version} --agent-image ${image_url}/cilium:${image_version}  --operator-image ${image_url}/operator-generic:${image_version}

else
	cilium_install_file=cilium-linux-amd64.tar.gz
	
	if [ -f "${cilium_install_file}" ];then
	
		echo "cilium install package exist"
	
	else
	
		echo "Download and install cilium"
	
		curl -L --remote-name-all https://github.com/cilium/cilium-cli/releases/latest/download/cilium-linux-amd64.tar.gz
	fi
	
	tar xzvfC cilium-linux-amd64.tar.gz /usr/local/bin
	
	cilium completion bash > /etc/bash_completion.d/cilium
	
	source /etc/bash_completion.d/cilium
	
	echo "Use the following command to install"
fi	
	
