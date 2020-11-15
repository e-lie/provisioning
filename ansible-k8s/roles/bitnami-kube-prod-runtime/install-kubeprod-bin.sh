#!/bin/bash

BKPR_VERSION=$(curl --silent "https://api.github.com/repos/bitnami/kube-prod-runtime/releases/latest" | jq -r '.tag_name')
curl -LO https://github.com/bitnami/kube-prod-runtime/releases/download/${BKPR_VERSION}/bkpr-${BKPR_VERSION}-linux-amd64.tar.gz
tar xf bkpr-${BKPR_VERSION}-linux-amd64.tar.gz

chmod +x bkpr-${BKPR_VERSION}/kubeprod
sudo mv bkpr-${BKPR_VERSION}/kubeprod /usr/local/bin/