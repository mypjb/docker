#!/bin/bash

dashboard_dir="dashboard"


dashboard_default_host="ui.k8s.lass.net"

dashboard_host=${2:-"${dashboard_default_host}"}

kubectl create namespace kubernetes-dashboard

sed -i "s/${dashboard_default_host}/${dashboard_host}/g" $dashboard_dir/cert.yaml

kubectl apply -f $dashboard_dir/cert.yaml

kubectl apply -f $dashboard_dir/recommended.yaml

kubectl apply -f $dashboard_dir/userSetting.yaml
