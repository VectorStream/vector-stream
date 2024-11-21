#!/bin/bash

# Check if token is provided as argument
if [ $# -ne 1 ]; then
    echo "Usage: $0 <hugging_face_token>"
    echo "Example: $0 hf_xxxxxxxxxxxxx"
    exit 1
fi

HUGGING_FACE_TOKEN=$1
DEPLOYMENT_NAME="vllm"
NAMESPACE="vllm-gpu"

# Update the environment variable
echo "Updating HUGGING_FACE_HUB_TOKEN in deployment $DEPLOYMENT_NAME..."
oc set env deployment/$DEPLOYMENT_NAME -n $NAMESPACE HUGGING_FACE_HUB_TOKEN=$HUGGING_FACE_TOKEN

# Verify the update
echo -e "\nVerifying environment variables:"
oc set env deployment/$DEPLOYMENT_NAME --list -n $NAMESPACE
oc get deployment/$DEPLOYMENT_NAME -n $NAMESPACE
