#!/bin/bash

# Set the namespace where AWX is deployed
NAMESPACE="awx"

# Check if the awx-service already exists
SERVICE_EXISTS=$(kubectl get service awx-service -n $NAMESPACE --ignore-not-found)

# Expose the AWX service if it does not exist
if [ -z "$SERVICE_EXISTS" ]; then
  echo "Exposing AWX service..."
  kubectl expose deployment awx --type=NodePort --name=awx-service -n $NAMESPACE
else
  echo "AWX service already exposed."
fi

# Get the service details
SERVICE_DETAILS=$(kubectl get service awx-service -n $NAMESPACE -o jsonpath='{.spec.ports[0].nodePort}')

# Get the IP address of the first node
NODE_IP=$(kubectl get nodes -o jsonpath='{.items[0].status.addresses[?(@.type=="InternalIP")].address}')

# Display the URL to access the AWX web page
echo "AWX web page is available at: http://$NODE_IP:$SERVICE_DETAILS"
