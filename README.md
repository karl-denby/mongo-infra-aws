# mongo-infra-aws

### What problem does this solve
This project does 2 things:
1. Uses `terraform` to create instances, security-groups on AWS and writes an ansible inventory
2. Uses `ansible` to deploy mongodb software onto those AWS instances


### Installation and Setup
This project assumes you have the following installed and in your PATH:
1. `terraform` -  In order to install `terraform` please run: 
```
brew tap hashicorp/tap
brew install hashicorp/tap/terraform
```
1. `ansible` - In order to install the correct version please run:
```
brew install pipx
pipx ensurepath
pipx install --include-deps ansible==8.5.0 --force
```

### Tested on 
1. Apple M2 Pro 16GB running Sonoma 14.7.1
1. `terraform` v1.10.0
1. `ansible` 2.15.13 (8.5.0) with `python` version 3.13.1 

### Before running
1. Make a copy of `settings.template` and call it `settings.tf`
1. Fill in the required values for vpc, cidr, tags, etc
1. Make sure you have a valid, 2048 bit, openssh public key inside your ~/.ssh/ folder named: "id_rsa.pub"
* **If you dont**, please create one with:
```
ssh-keygen -t rsa -b 2048 -f ~/.ssh/id_rsa
```
* This will also create a private key "id_rsa" in our ~/.ssh/ folder which we will be used to log into the instances.

## Usage
### Manual Part A: Deploy VPS Instances
1. Export your AWS KEY/SECRETS so that `terraform` can use them
```
export AWS_ACCESS_KEY_ID="REDACTED"
export AWS_SECRET_ACCESS_KEY="/REDACTEDREDACTED+7rd4"
export AWS_SESSION_TOKEN="REDACTEDREDACTEDREDACTEDREDACTEDREDACTEDREDACTEDREDACTEDREDACTEDREDACTEDREDACTEDREDACTEDREDACTEDREDACTEDREDACTEDREDACTEDREDACTEDREDACTEDREDACTEDREDACTEDREDACTEDREDACTEDREDACTEDREDACTEDREDACTEDREDACTEDREDACTEDREDACTEDREDACTEDREDACTEDREDACTEDREDACTEDREDACTEDREDACTEDREDACTEDREDACTEDREDACTEDREDACTEDREDACTEDREDACTEDREDACTEDREDACTEDREDACTEDREDACTEDREDACTEDREDACTEDREDACTEDREDACTEDREDACTEDREDACTEDREDACTEDREDACTEDREDACTEDREDACTEDREDACTEDREDACTEDREDACTEDREDACTEDREDACTEDREDACTEDREDACTEDREDACTEDREDACTEDREDACTEDREDACTEDREDACTEDREDACTEDREDACTEDREDACTEDREDACTEDREDACTEDREDACTEDREDACTEDREDACTEDREDACTEDREDACTEDREDACTEDREDACTEDREDACTEDREDACTEDREDACTED"
```
1. Run `quick-start.sh`
1. For subsequent runs you can simply use `terraform apply`.

### Manual Part B: Install Software on VPS Instances
0. (Optional) If you want to setup LDAP/Kerberos/Load-Balancer do the following
```
ansible-galaxy collection install ansible.posix
ansible-playbook -i ansible/inventory.ini \
                 -e 'freeipa=install' \
                 ansible/install-extras.yml
```

1. You'll need an AppDB, this will go to AppDB servers or if none exist it will be co-hosted on the Ops Manager server
```
ansible-playbook -i ansible/inventory.ini \
                 -e 'version=db_6_0_latest' \
                 ansible/install-databases.yml
```
2. Then you can setup Ops Manager:
```
ansible-playbook -i ansible/inventory.ini \
                 -e 'version=om_7_0_latest' \
                 -e 'ldap=false' \
                 ansible/install-om.yml
```
3. Then you can setup any Nodes with Agents
```
ansible-playbook -i ansible/inventory.ini \
                 -e 'project_id=11111111111111111111111111' \
                 -e 'api_key=1111111111111111111111111111111111111111111111111111' \
                 -e 'kerberos=false' \
                 -e 'saslauthd=false' \
                 ansible/install-nodes.yml
```

4. When your done and you want to **remove everything** run 'terraform destroy'