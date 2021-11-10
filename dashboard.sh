#!/bin/bash

image_url=registry.cn-beijing.aliyuncs.com/mypjb

kubectl apply -f https://raw.githubusercontent.com/kubernetes/dashboard/v2.4.0/aio/deploy/recommended.yaml



echo "Use the following command to pull the image in advance"

echo "ctr -n k8s.io image pull ${image_url}/kubernetesui-dashboard:v2.4.0 && ctr -n k8s.io image tag ${image_url}/kubernetesui-dashboard:v2.4.0 kubernetesui/dashboard:v2.4.0"

echo "ctr -n k8s.io image pull ${image_url}/kubernetesui-metrics-scraper:v1.0.7 && ctr -n k8s.io image tag ${image_url}/kubernetesui-metrics-scraper:v1.0.7 kubernetesui/metrics-scraper:v1.0.7"