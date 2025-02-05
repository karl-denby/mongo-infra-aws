#!/bin/bash

source aws-auth-helper.sh

setup_aws_auth
terraform destroy -auto-approve