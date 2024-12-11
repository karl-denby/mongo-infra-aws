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

terraform plan

echo "Please check the above plan matches your expectations"
read -n1 -s -r -p "Press any key to continue... or ctrl+c to exit"
terraform apply -auto-approve

echo "waiting for instances to boot up..."
sleep 90
read -n1 -s -r -p "Press any key to continue with automatic config... or ctrl+c to exit"

echo "Bootstrap of RHEL8 hosts"
ansible-playbook -i ansible/inventory.ini \
                 ansible/bootstrap.yml

echo "Installing Application Database"
ansible-playbook -i ansible/inventory.ini \
                 -e 'version=db_6_0_latest' \
                 ansible/install-databases.yml

echo "Installing Ops Manager"
ansible-playbook -i ansible/inventory.ini \
                 -e 'version=om_7_0_latest' \
                 -e 'ldap=false' \
                 ansible/install-om.yml
