#!/bin/bash
if [[ -z ${AWS_ACCESS_KEY_ID+x} ]]; then
  read -r -p "Please provide your AWS Access Key ID: " AWS_ACCESS_KEY_ID
  export AWS_ACCESS_KEY_ID
fi

if [[ -z ${AWS_SECRET_ACCESS_KEY+x} ]]; then
  read -r -p "Please provide your AWS Secret Access Key: " AWS_SECRET_ACCESS_KEY
  export AWS_SECRET_ACCESS_KEY
fi

if [[ -z ${AWS_SESSION_TOKEN+x} ]]; then
  read -r -p "Please provide your AWS Session Token: " AWS_SESSION_TOKEN
  export AWS_SESSION_TOKEN
fi

terraform destroy -auto-approve