#!/bin/sh
set -e

kubeadm init --config /tmp/master-configuration.yml \
  --ignore-preflight-errors=Swap,NumCPU

kubeadm token create ${token}

[ -d $HOME/.kube ] || mkdir -p $HOME/.kube
ln -s /etc/kubernetes/admin.conf $HOME/.kube/config

until nc -z localhost 6443; do
  echo "Waiting for API server to respond"
  sleep 5
done

# Add some config NO_MASQ_LOCAL=0 to use with metallb : https://metallb.universe.tf/configuration/weave/ 
kubectl apply -f "https://cloud.weave.works/k8s/net?k8s-version=$(kubectl version | base64 | tr -d '\n')&env.NO_MASQ_LOCAL=0"

# See: https://kubernetes.io/docs/admin/authorization/rbac/
kubectl create clusterrolebinding permissive-binding \
  --clusterrole=cluster-admin \
  --user=admin \
  --user=kubelet \
  --group=system:serviceaccounts
