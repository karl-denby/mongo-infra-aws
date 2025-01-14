#!/bin/bash

# The AWS CLI prioritizes SSO profiles for validation, even if environment variables are set.
# If the SSO profile is invalid or expired, the script may fail to authenticate.
clear_invalid_aws_profile() {
  if [[ -n "${AWS_PROFILE}" ]]; then
    if ! aws sts get-caller-identity > /dev/null 2>&1; then
      echo "AWS_PROFILE (${AWS_PROFILE}) is expired or invalid. Unsetting it."
      unset AWS_PROFILE
    fi
  fi
}

verify_aws_connection() {
  if aws sts get-caller-identity > /dev/null 2>&1; then
    return 0
  fi
  return 1
}

setup_aws_auth() {
  clear_invalid_aws_profile

  if ! verify_aws_connection; then
    echo "No valid AWS credentials found. Falling back to manual input."

    unset AWS_PROFILE
    read -r -p "Please provide your AWS Access Key ID: " AWS_ACCESS_KEY_ID
    export AWS_ACCESS_KEY_ID
    read -r -p "Please provide your AWS Secret Access Key: " AWS_SECRET_ACCESS_KEY
    export AWS_SECRET_ACCESS_KEY
    read -r -p "Please provide your AWS Session Token: " AWS_SESSION_TOKEN
    export AWS_SESSION_TOKEN
  fi

  if ! verify_aws_connection; then
    echo "Error: Unable to authenticate with AWS. Please check your credentials and try again."
    exit 1
  fi
}