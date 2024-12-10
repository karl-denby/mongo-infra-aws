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

### MAIN

terraform init  # was missing
# need to create a public key for use. should be placed in ~/.ssh/id_rsa.pub
terraform plan

echo "Please check the above plan matches your expectations"
#read -n1 -s -r -p "Press any key to continue... or ctrl+c to exit"
sleep 3
terraform apply -auto-approve

echo "waiting for instances to boot up..."
sleep 90

## preparing hosts for ansible (pre-installing python 3.8)
echo "pre-installing python 3.8 on all servers as preparation for ansible..."

hosts=$(sed -n '2,6p' ansible/inventory.ini)
# Loop through each host
for host in $hosts; do
  if [[ -n $host ]]; then
     ssh  -o StrictHostKeyChecking=no ec2-user@$host -C "sudo dnf install -y python38" > /dev/null
  fi
done
echo "Finished installing python 3.8 on all servers - now running ansible..."

echo "Installing Application Database"
ansible-playbook -i ansible/inventory.ini \
                 -e 'version=db_7_0_latest' \
                 ansible/install-databases.yml 
                 #-vvv

# echo "Installing Ops Manager"
ansible-playbook -i ansible/inventory.ini \
                 -e 'version=om_7_0_latest' \
                 -e 'ldap=false' \
                 ansible/install-om.yml
