# mongo-infra-aws

### What problem does this solve
This project does 2 things:
1. Uses `terraform` to create instances, security-groups on AWS and writes an ansible inventory
2. Uses `ansible` (must be 2.16 or earlier) to deploy mongodb software onto those AWS instances

## Usage
### Automatically deploy everything for me, don't ask me much

1. Run `quick-start.sh` and provide any missing values
2. When finished run `bash clean-up.sh` to remove all resources

### Manual Part A: Deploy VPS Instances 
If you want to do things **manually** you can:
1. Make a copy of `settings.template` and call it `settings.tf`
2. Fill in the required values for vpc, cidr, tags, etc
3. Export your AWS KEY/SECRETS so that `terraform` can use them
```
export AWS_ACCESS_KEY_ID="REDACTED"
export AWS_SECRET_ACCESS_KEY="/REDACTEDREDACTED+7rd4"
export AWS_SESSION_TOKEN="REDACTEDREDACTEDREDACTEDREDACTEDREDACTEDREDACTEDREDACTEDREDACTEDREDACTEDREDACTEDREDACTEDREDACTEDREDACTEDREDACTEDREDACTEDREDACTEDREDACTEDREDACTEDREDACTEDREDACTEDREDACTEDREDACTEDREDACTEDREDACTEDREDACTEDREDACTEDREDACTEDREDACTEDREDACTEDREDACTEDREDACTEDREDACTEDREDACTEDREDACTEDREDACTEDREDACTEDREDACTEDREDACTEDREDACTEDREDACTEDREDACTEDREDACTEDREDACTEDREDACTEDREDACTEDREDACTEDREDACTEDREDACTEDREDACTEDREDACTEDREDACTEDREDACTEDREDACTEDREDACTEDREDACTEDREDACTEDREDACTEDREDACTEDREDACTEDREDACTEDREDACTEDREDACTEDREDACTEDREDACTEDREDACTEDREDACTEDREDACTEDREDACTEDREDACTEDREDACTEDREDACTEDREDACTEDREDACTEDREDACTEDREDACTEDREDACTEDREDACTEDREDACTEDREDACTEDREDACTED"
```
4. (Optional: If its your first time using this run) `terraform init` so that the aws provide gets installed
5. Run `terraform plan` and check the summary output matches what you want and not errors are shown
6. Run `terraform apply` if you are happy with the plan and wait for the instances to be created

### Manual Part B: Install Software on VPS Instances
0. (Optional) If you want to setup LDAP/Kerberos/Load-Balancer do the following
```
ansible-galaxy collection install ansible.posix
ansible-playbook -i ansible/inventory.ini \
                 -e 'freeipa=install' \
                 ansible/install-extras.yml
```

0. (RHEL Users) If you are using ansible >= 2.17 you need to run this or they plays will fail
```
ansible-playbook -i ansible/inventory.ini \
                 ansible/bootstrap.yml
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
