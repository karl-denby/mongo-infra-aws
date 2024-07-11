locals {
  # Cloud Manager Infrastructure
  cloudmanager = "https://cloud.mongodb.com"   # Cloud Manager url, if Ops Manager is not used

  # Ops Manager and backing database Operating System Selector
  om_os = "suse" # rhel/suse/ubuntu

  # Ops Manager Infrastructure
  amd64_backing_appdb = toset([]) # If 0 use OM, if 1 standalone, if 3 replica set
  amd64_backing_oplog = toset([])
  amd64_backing_blockstore = toset([])

  # Empty for Cloud Manager, Ops Man URL will map to the host named "om1" unless you deploy "services"
  amd64_backing_opsman = toset(["om1"])

  # LDAP/Kerberos/Load-Balancer infrastructure
  aarch64_rhel_8_services = toset([]) # blank or "services"

  # amd64 Deployments
  amd64_amazon_linux_2 = toset([])
  amd64_debian_11      = toset([])
  amd64_rhel_8         = toset(["node1","node2","node3"])
  amd64_rhel_9         = toset([])
  amd64_ubuntu_22_04   = toset([])
  amd64_ubuntu_20_04   = toset([])

  # aarch64 Deployments
  aarch64_amazon_linux_2 = toset([])
  aarch64_rhel_8         = toset([])
}

# We should check for an SSH key that has id_rsa_${local.tag_instance_name_prefix}.pub and use it, if not existing default to ~/.ssh/id_rsa.pub
resource "aws_key_pair" "terraform-keypair" {
  key_name   = "${local.tag_owner}-${local.tag_instance_name_prefix}-sshkey"
  public_key = fileexists("~/.ssh/id_rsa_${local.tag_instance_name_prefix}.pub") ? file("~/.ssh/id_rsa_${local.tag_instance_name_prefix}.pub") : file("~/.ssh/id_rsa.pub")
}

provider "aws" {
  # If you change region you will need to update each AMI-id
  region = "eu-west-1" # If you change this you may need to update owners of the AMI's in ami.tf
}
