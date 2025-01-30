#!/bin/bash

source aws-auth-helper.sh

setup_aws_auth

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
                 -e 'version=db_7_0_latest' \
                 ansible/install-databases.yml

echo "Installing Ops Manager"
ansible-playbook -i ansible/inventory.ini \
                 -e 'version=om_8_0_latest' \
                 -e 'ldap=false' \
                 ansible/install-om.yml
