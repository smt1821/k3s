#!/bin/bash

# Update the package list
sudo apt-get update

# Install curl if not already installed
if ! command -v curl &> /dev/null
then
    echo "curl not found, installing..."
    sudo apt-get install -y curl
fi

# Install K3s with --write-kubeconfig-mode option
echo "Installing K3s..."
curl -sfL https://get.k3s.io | INSTALL_K3S_EXEC="--write-kubeconfig-mode 644" sh -

# Wait for K3s to start
echo "Waiting for K3s to start..."
sleep 30

# Verify K3s installation
sudo k3s kubectl get nodes

# Set up kubectl for the current user
echo "Setting up kubectl..."
KUBECONFIG=/etc/rancher/k3s/k3s.yaml
mkdir -p $HOME/.kube
sudo cp /etc/rancher/k3s/k3s.yaml $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config

# Test kubectl configuration
echo "Testing kubectl configuration..."
kubectl get nodes

echo "K3s installation and setup complete."