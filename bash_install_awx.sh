#!/bin/bash

# Function to install AWX Operator using Helm
install_awx_operator() {
  echo "Creating namespace for AWX..."
  kubectl create namespace awx

  echo "Adding AWX Operator Helm repository..."
  helm repo add awx-operator https://ansible.github.io/awx-operator/
  helm repo update

  echo "Installing AWX Operator in 'awx' namespace..."
  helm install awx-operator awx-operator/awx-operator -n awx

  echo "AWX Operator installed successfully."
}

# Function to create an AWX Custom Resource
create_awx_instance() {
  echo "Creating AWX instance..."

  cat <<EOF | kubectl apply -f -
apiVersion: awx.ansible.com/v1beta1
kind: AWX
metadata:
  name: awx
  namespace: awx
spec:
  service_type: loadbalancer
  ingress_type: none
  hostname: awx.example.com  # Change this to your desired hostname
  postgres_resource_requirements:
    requests:
      memory: 1Gi
      cpu: 500m
    limits:
      memory: 2Gi
      cpu: 1
  redis_resource_requirements:
    requests:
      memory: 1Gi
      cpu: 500m
    limits:
      memory: 2Gi
      cpu: 1
  web_resource_requirements:
    requests:
      memory: 1Gi
      cpu: 500m
    limits:
      memory: 2Gi
      cpu: 1
  task_resource_requirements:
    requests:
      memory: 1Gi
      cpu: 500m
    limits:
      memory: 2Gi
      cpu: 1
EOF

  echo "AWX instance created successfully."
}

# Main script execution
main() {
  install_awx_operator
  create_awx_instance

  echo "Monitoring AWX deployment..."
  kubectl get pods -n awx
  kubectl get svc -n awx

  echo "AWX setup completed. Please check the services to get the external IP for accessing AWX."
}

# Run the main function
main
