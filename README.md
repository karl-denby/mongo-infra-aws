# mongo-infra-aws

### What problem does this solve
This project does 2 things:
1. Uses `terraform` to create instances, security-groups on AWS and writes an ansible inventory
1. Uses `ansible` to deploy mongodb software onto those AWS instances

### Usage
If a script exists called `quick-start.sh` then run `bash quick-start.sh` and follow the prompts.

If you want to do things **manually** you can:
1. Make a copy of `settings.template` and call it `settings.tf`
1. Fill in the required values for vpc, cidr, tags, etc
1. (If its your first time using this run) `terraform init`
1. Run `terraform plan` and check the output matches what you want and not errors are shown
1. Run `terraform apply` if you are happy and wait for the instances to be created
1. You should now be able to ssh to all the target hosts, ansible playbook coming soon 