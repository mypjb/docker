#!/bin/bash

cert_manager_dir="cert-manager"

kubectl apply -f $cert_manager_dir/cert-manager.yaml

kubectl apply -f $cert_manager_dir/selfsigned-ca.yaml
