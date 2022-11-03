#!/bin/bash
set -o errexit

rook_namespace=${4:-"rook-ceph"}

gloo_upstream=${5:-"rook-ceph-rook-ceph-mgr-dashboard-8443"}

rook_dir="rook"

rook_certs_dir=${3:-"rook/certs"}

rook_default_host="ceph.rook.lass.net"

rook_host=${2:-"${rook_default_host}"}

if [ "${1}" == "ssl" ];then

	mkdir -p $rook_certs_dir

	if [ ! -f "${rook_certs_dir}/tls.key" ];then
		echo -e " $rook_certs_dir Automatic certificate generation was not detected"
		openssl req -x509 -nodes -days 365 \
		-newkey rsa:2048 -keyout $rook_certs_dir/tls.key \
		-out $rook_certs_dir/tls.crt \
		-subj "/CN=${rook_host}"

		sed -i "s/${rook_default_host}/${rook_host}/g" $rook_dir/gloo-proxy.yaml
	fi
	

	echo "Create rook-certs tls secret"

	kubectl -n $rook_namespace create \
	secret tls ${rook_namespace}-certs \
	--key $(pwd)/$rook_certs_dir/tls.key \
	--cert $(pwd)/$rook_certs_dir/tls.crt

elif [ "${1}" == "gloo" ];then
	cat > ${rook_dir}/gloo-upstream.yaml << EOF
spec:
  sslConfig:
    secretRef:
      name: ${rook_namespace}-certs
      namespace: ${rook_namespace}
EOF
	kubectl -n gloo-system patch upstream $gloo_upstream --type merge --patch-file ${rook_dir}/gloo-upstream.yaml
	kubectl apply -f ${rook_dir}/gloo-proxy.yaml
else
 
	kubectl apply -f $rook_dir/crds.yaml -f $rook_dir/common.yaml -f $rook_dir/operator.yaml -f $rook_dir/cluster.yaml
fi
