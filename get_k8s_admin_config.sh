
export KUBE1_DOMAIN=kube1.k8slab.dopl.uk

ssh-add ~/.ssh/id_stagiaire

scp root@$KUBE1_DOMAIN:/etc/kubernetes/admin.conf hobby-kube-connection.yaml

export KUBE1_NODE_IP=$(dig +short $KUBE1_DOMAIN)

sed -i "s/10.0.1.1/$KUBE1_NODE_IP/g" hobby-kube-connection.yaml

export KUBECONFIG=./hobby-kube-connection.yaml
export K8S_AUTH_KUBECONFIG=../hobby-kube-connection.yaml