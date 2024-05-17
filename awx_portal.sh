#!/bin/bash

# Set the namespace where AWX is deployed
NAMESPACE="awx"

# Find the AWX deployment
AWX_DEPLOYMENT=$(kubectl get deployments -n $NAMESPACE -o jsonpath='{.items[0].metadata.name}')

if [ -z "$AWX_DEPLOYMENT" ]; then
  echo "No AWX deployment found in the $NAMESPACE namespace."
  exit 1
fi

echo "Found AWX deployment: $AWX_DEPLOYMENT"

# Check if the awx-service already exists
SERVICE_EXISTS=$(kubectl get service awx-service -n $NAMESPACE --ignore-not-found)

# Expose the AWX service if it does not exist
if [ -z "$SERVICE_EXISTS" ]; then
  echo "Exposing AWX service..."
  kubectl expose deployment $AWX_DEPLOYMENT --type=NodePort --name=awx-service -n $NAMESPACE
else
  echo "AWX service already exposed."
fi

# Get the service details
SERVICE_PORT=$(kubectl get service awx-service -n $NAMESPACE -o jsonpath='{.spec.ports[0].nodePort}')

# Get the IP address of the first node
NODE_IP=$(kubectl get nodes -o jsonpath='{.items[0].status.addresses[?(@.type=="InternalIP")].address}')

# Display the URL to access the AWX web page
if [ -n "$SERVICE_PORT" ] && [ -n "$NODE_IP" ]; then
  echo "AWX web page is available at: http://$NODE_IP:$SERVICE_PORT"
else
  echo "Failed to retrieve service port or node IP."
fi

