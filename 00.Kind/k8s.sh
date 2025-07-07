#!/bin/bash

curl -Lo ./kind https://kind.sigs.k8s.io/dl/v0.17.0/kind-linux-amd64
chmod +x ./kind
sudo mv ./kind /usr/local/bin/kind

kind create cluster --name k8s --config multi_cluter.yaml

curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
chmod +x kubectl
sudo mv kubectl /usr/local/bin/

kubectl version --client
kubectl cluster-info --context kind-k8s
kubectl get nodes

wget https://github.com/derailed/k9s/releases/latest/download/k9s_linux_amd64.deb && apt install ./k9s_linux_amd64.deb && rm k9s_linux_amd64.deb

echo '''
# List current version
k9s version

# To get info about K9s runtime (logs, configs, etc..)
k9s info

# List all available CLI options
k9s help

# To run K9s in a given namespace
k9s -n mycoolns

# Start K9s in an existing KubeConfig context
k9s --context coolCtx

# Start K9s in readonly mode - with all cluster modification commands disabled
k9s --readonly
'''

