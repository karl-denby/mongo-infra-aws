locals {
  # Cloud Manager Infrastructure
  cloudmanager = "https://cloud.mongodb.com"   # Cloud Manager url, if Ops Manager is not used

  # Ops Manager Infrastructure
  amd64_backing_appdb = toset([]) # If 0 use OM, if 1 standalone, if 3 replica set
  amd64_backing_oplog = toset([])
  amd64_backing_blockstore = toset([])

  # Empty for Cloud Manager, Ops Man URL will map to the host named "om1" unless you deploy "services"
  amd64_backing_opsman = toset(["om1"])

  # LDAP/Kerberos/Load-Balancer infrastructure
  aarch64_backing_services = toset(["services"]) # empty or "services"

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

# AMI
data "aws_ami" "backing_amd64" {
    filter {
      name = "image-id" 
      values = [local.om_os == "rhel" ? data.aws_ami.rhel_8_amd64.id : ( local.om_os == "suse" ? data.aws_ami.suse_15_amd64.id : ( local.om_os == "ubuntu" ? data.aws_ami.ubuntu_20_04_amd64.id : data.aws_ami.rhel_8_amd64.id))]
    }
}

data "aws_ami" "ubuntu_20_04_amd64" {
  most_recent = true
  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }
  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
  filter {
    name = "architecture"
    values = ["x86_64"]
  }
  owners = ["099720109477"] # Canonical
}

data "aws_ami" "ubuntu_22_04_amd64" {
  most_recent = true
  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }
  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
  filter {
    name = "architecture"
    values = ["x86_64"]
  }
  owners = ["099720109477"] # Canonical
}

data "aws_ami" "debian_11_amd64" {
  most_recent = true
  filter {
    name   = "name"
    values = ["debian-11-amd64-*"]
  }
  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
  filter {
    name = "architecture"
    values = ["x86_64"]
  }
  owners = ["136693071363"] # Debian
}

data "aws_ami" "rhel_9_amd64" {
  most_recent = true
  filter {
    name   = "name"
    values = ["RHEL-9*"]
  }
  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
  filter {
    name = "architecture"
    values = ["x86_64"]
  }  
  filter {
    name = "architecture"
    values = ["x86_64"]
  }
  owners = ["309956199498"] # RedHat
}

data "aws_ami" "rhel_8_amd64" {
  most_recent = true
  filter {
    name   = "name"
    values = ["RHEL-8*"]
  }
  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
  filter {
    name = "architecture"
    values = ["x86_64"]
  }
  owners = ["309956199498"] # RedHat
}

data "aws_ami" "suse_15_amd64" {
  most_recent = true
  filter{
    name = "name"
    values = ["suse-sles-15-sp?-v????????-hvm-ssd-x86_64"]
  }
  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
  filter {
    name = "architecture"
    values = ["x86_64"]
  }
  owners = ["013907871322"] # Amazon offical SUSE image (we don't want BYOS)
}

data "aws_ami" "rhel_8_arm" {
  most_recent = true
  filter {
    name   = "name"
    values = ["RHEL-8*"]
  }
  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
  filter {
    name = "architecture"
    values = ["arm64"]
  }
  owners = ["309956199498"] # RedHat
}

data "aws_ami" "amazon_linux_2_amd64" {
  most_recent = true
  filter {
    name = "name"
    values = ["amzn2-ami-hvm-2.0.*"]
  }
  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
  owners = ["137112412989"] # Amazon
}

data "aws_ami" "amazon_linux_2_arm" {
  most_recent = true
  filter {
    name = "name"
    values = ["amzn2-ami-hvm-2.0.*"]
  }
  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
  filter {
    name = "architecture"
    values = ["arm64"]
  }
  owners = ["137112412989"] # Amazon
}

# Instances
resource "aws_instance" "amd64_backing_appdb" {
  for_each = local.amd64_backing_appdb
  ami = data.aws_ami.backing_amd64.id 
  instance_type = "t2.small"              
  key_name      = aws_key_pair.terraform-keypair.key_name
  tags = {
    Name = join("-", [local.tag_instance_name_prefix, each.key])
    owner = local.tag_owner
    keep_until = local.tag_keep_until
  }
  vpc_security_group_ids = [aws_security_group.tearraform-firewall.id]
}

resource "aws_instance" "amd64_backing_oplog" {
  for_each = local.amd64_backing_oplog
  
  ami = data.aws_ami.backing_amd64.id
  instance_type = "t2.medium"
  key_name      = aws_key_pair.terraform-keypair.key_name
  tags = {
    Name = join("-", [local.tag_instance_name_prefix, each.key])
    owner = local.tag_owner
    keep_until = local.tag_keep_until
  }
  vpc_security_group_ids = [aws_security_group.tearraform-firewall.id]
}

resource "aws_instance" "amd64_backing_blockstore" {
  for_each = local.amd64_backing_blockstore

  ami = data.aws_ami.backing_amd64.id
  instance_type = "t2.medium"              
  key_name      = aws_key_pair.terraform-keypair.key_name
  tags = {
    Name = join("-", [local.tag_instance_name_prefix, each.key])
    owner = local.tag_owner
    keep_until = local.tag_keep_until
  }
  vpc_security_group_ids = [aws_security_group.tearraform-firewall.id]
}

resource "aws_instance" "amd64_backing_opsman" {
  for_each = local.amd64_backing_opsman

  ami           = data.aws_ami.backing_amd64.id
  instance_type = "t2.xlarge"
  key_name      = aws_key_pair.terraform-keypair.key_name
  tags = {
    Name = join("-", [local.tag_instance_name_prefix, each.key])
    owner = local.tag_owner
    keep_until = local.tag_keep_until
  }
  vpc_security_group_ids = [aws_security_group.tearraform-firewall.id]

  root_block_device {
    volume_size = 16
    volume_type = "gp2"
  }

}

resource "aws_instance" "amd64_amazon_linux_2" {
  for_each = local.amd64_amazon_linux_2
  ami = data.aws_ami.amazon_linux_2_amd64.id
  instance_type = "t2.small"
  key_name      = aws_key_pair.terraform-keypair.key_name
  tags = {
    Name = join("-", [local.tag_instance_name_prefix, each.key])
    owner = local.tag_owner
    keep_until = local.tag_keep_until
  }
  vpc_security_group_ids = [aws_security_group.tearraform-firewall.id]
}

resource "aws_instance" "aarch64_amazon_linux_2" {
  for_each = local.aarch64_amazon_linux_2
  ami = data.aws_ami.amazon_linux_2_arm.id
  instance_type = "m6g.medium"          
  key_name      = aws_key_pair.terraform-keypair.key_name
  tags = {
    Name = join("-", [local.tag_instance_name_prefix, each.key])
    owner = local.tag_owner
    keep_until = local.tag_keep_until
  }
  vpc_security_group_ids = [aws_security_group.tearraform-firewall.id]
}

resource "aws_instance" "amd64_rhel_8" {
  for_each = local.amd64_rhel_8

  ami           = data.aws_ami.rhel_8_amd64.id # rhel_88, centos82
  instance_type = "t2.small"               # t2.small (is enough to run an agent/deployment)
  key_name      = aws_key_pair.terraform-keypair.key_name
  tags = {
    Name = join("-", [local.tag_instance_name_prefix, each.key])
    owner = local.tag_owner
    keep_until = local.tag_keep_until
  }
  vpc_security_group_ids = [aws_security_group.tearraform-firewall.id]
}

resource "aws_instance" "aarch64_rhel_8" {
  for_each = local.aarch64_rhel_8

  ami           = data.aws_ami.rhel_8_arm.id
  instance_type = "m6g.medium"           
  key_name      = aws_key_pair.terraform-keypair.key_name
  tags = {
    Name = join("-", [local.tag_instance_name_prefix, each.key])
    owner = local.tag_owner
    keep_until = local.tag_keep_until
  }
  vpc_security_group_ids = [aws_security_group.tearraform-firewall.id]
}

resource "aws_instance" "aarch64_backing_services" {
  for_each = local.aarch64_backing_services

  ami           = data.aws_ami.rhel_8_arm.id
  instance_type = "m6g.medium"           
  key_name      = aws_key_pair.terraform-keypair.key_name
  tags = {
    Name = join("-", [local.tag_instance_name_prefix, each.key])
    owner = local.tag_owner
    keep_until = local.tag_keep_until
  }
  vpc_security_group_ids = [aws_security_group.tearraform-firewall.id]
}

resource "aws_instance" "amd64_rhel_9" {
  for_each = local.amd64_rhel_9

  ami           = data.aws_ami.rhel_9_amd64.id
  instance_type = "t2.small"
  key_name      = aws_key_pair.terraform-keypair.key_name
  tags = {
    Name = join("-", [local.tag_instance_name_prefix, each.key])
    owner = local.tag_owner
    keep_until = local.tag_keep_until
  }
  vpc_security_group_ids = [aws_security_group.tearraform-firewall.id]
}

resource "aws_instance" "amd64_ubuntu_20_04" {
  for_each = local.amd64_ubuntu_20_04
  ami           = data.aws_ami.ubuntu_20_04_amd64.id
  instance_type = "t2.small"
  key_name      = aws_key_pair.terraform-keypair.key_name
  tags = {
    Name = join("-", [local.tag_instance_name_prefix, each.key])
    owner = local.tag_owner
    keep_until = local.tag_keep_until
  }
  vpc_security_group_ids = [aws_security_group.tearraform-firewall.id]
}

resource "aws_instance" "amd64_ubuntu_22_04" {
  for_each = local.amd64_ubuntu_22_04

  ami = data.aws_ami.ubuntu_22_04_amd64.id # ubuntu1804, ubuntu2004
  instance_type = "t2.small"                 # t2.small (is enough to run an agent/deployment)
  key_name      = aws_key_pair.terraform-keypair.key_name
  tags = {
    Name = join("-", [local.tag_instance_name_prefix, each.key])
    owner = local.tag_owner
    keep_until = local.tag_keep_until
  }
  vpc_security_group_ids = [aws_security_group.tearraform-firewall.id]
}

# Security Group
# Firewall Access / Security Group
resource "aws_security_group" "tearraform-firewall" {
  name        = "terraform-${local.tag_instance_name_prefix}"
  description = "Allow OM and client traffic"
  vpc_id      =  local.default_vpc_id    

  ingress {
    description = "ssh"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = local.cidr_blocks
  }

  ingress {
    description = "http"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = setunion(local.cidr_blocks,["0.0.0.0/0"])
  }

  ingress {
    description = "https"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "ldap"
    from_port   = 389
    to_port     = 389
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "ldaps"
    from_port   = 636
    to_port     = 636
    protocol    = "tcp"
    cidr_blocks = setunion(local.cidr_blocks,["0.0.0.0/0"])
  }

  ingress {
    description = "kerberos 88"
    from_port   = 88
    to_port     = 88
    protocol    = "tcp"
    cidr_blocks = setunion(local.cidr_blocks,["0.0.0.0/0"])
  }

  ingress {
    description = "kerberos 464"
    from_port   = 464
    to_port     = 464
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "dns"
    from_port   = 53
    to_port     = 53
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "ntp"
    from_port   = 123
    to_port     = 123
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "OM http"
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = setunion(local.cidr_blocks,["172.31.0.0/16"])
  }

  ingress {
    description = "OM https / k8s api"
    from_port   = 8443
    to_port     = 8443
    protocol    = "tcp"
    cidr_blocks = setunion(local.cidr_blocks,["172.31.0.0/16"])
  }

  ingress {
    description = "Load-Balancer"
    from_port   = 3000
    to_port     = 3000
    protocol    = "tcp"
    cidr_blocks = setunion(local.cidr_blocks,["172.31.0.0/16"])
  }

  ingress {
    description = "cockpit"
    from_port   = 9090
    to_port     = 9090
    protocol    = "tcp"
    cidr_blocks = local.cidr_blocks
  }

  ingress {
    description = "mongod"
    from_port   = 27000
    to_port     = 28000
    protocol    = "tcp"
    cidr_blocks = setunion(local.cidr_blocks,["172.31.0.0/16"])
  }

  ingress {
    description = "ephemeral"
    from_port   = 49152
    to_port     = 65535
    protocol    = "tcp"
    cidr_blocks = setunion(local.cidr_blocks,["172.31.0.0/16"])
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${local.tag_instance_name_prefix}-firewall"
    owner = local.tag_owner
    keep_until = local.tag_keep_until
  }
}

# nginx
resource "local_file" "nginx_template" {
  content = templatefile("${path.module}/template/nginx.tpl",
    {
      amd64_backing_opsman = [for vps in aws_instance.amd64_backing_opsman: "server ${vps.public_dns}"]
    }
  )
  filename = "${path.module}/ansible/nginx.conf"
}

# ansible helpers
# generate inventory file for Ansible in .ini format
resource "local_file" "ansible_inventory" {
  content = templatefile("${path.module}/template/inventory.tpl",
    {
      all_hosts = [
        for vps in merge(
          aws_instance.amd64_backing_appdb, 
          aws_instance.amd64_backing_opsman,
          aws_instance.amd64_backing_oplog,
          aws_instance.amd64_backing_blockstore, 
          aws_instance.aarch64_backing_services,
          aws_instance.amd64_amazon_linux_2,
          aws_instance.amd64_rhel_8,
          aws_instance.amd64_rhel_9,
          aws_instance.amd64_ubuntu_20_04,
          aws_instance.amd64_ubuntu_22_04,
          aws_instance.aarch64_amazon_linux_2,
          aws_instance.aarch64_rhel_8
        ) : vps.public_dns ]
      amd64_backing_appdb = (length(aws_instance.amd64_backing_appdb) > 0 ? [for vps in aws_instance.amd64_backing_appdb: vps.public_dns] : [for vps in aws_instance.amd64_backing_opsman: vps.public_dns] )
      amd64_backing_opsman = [for vps in aws_instance.amd64_backing_opsman: vps.public_dns]
      amd64_backing_oplog = [for vps in aws_instance.amd64_backing_oplog: vps.public_dns]
      amd64_backing_blockstore = [for vps in aws_instance.amd64_backing_blockstore: vps.public_dns]
      aarch64_backing_services = [for vps in aws_instance.aarch64_backing_services: vps.public_dns]
      amd64_rhel_8 = [for vps in aws_instance.amd64_rhel_8: vps.public_dns]
      amd64_rhel_9 = [for vps in aws_instance.amd64_rhel_9: vps.public_dns]      
      amd64_ubuntu_20_04 = [for vps in aws_instance.amd64_ubuntu_20_04: vps.public_dns]
      amd64_ubuntu_22_04 = [for vps in aws_instance.amd64_ubuntu_22_04: vps.public_dns]
      amd64_amazon_linux_2 = [for vps in aws_instance.amd64_amazon_linux_2: vps.public_dns]      
      aarch64_amazon_linux_2 = [for vps in aws_instance.aarch64_amazon_linux_2: vps.public_dns]      
      aarch64_rhel_8 = [for vps in aws_instance.aarch64_rhel_8: vps.public_dns]
      user = (local.om_os=="ubuntu" ? "ubuntu" : "ec2-user")
    }
  )
  filename = "${path.module}/ansible/inventory.ini"
}

# generate vars file for Ansible in .yaml format
resource "local_file" "ansible_vars" {
  content = templatefile("${path.module}/template/om-vars.tpl",
    {
      appdb = (length(aws_instance.amd64_backing_appdb) > 0 ? [for vps in aws_instance.amd64_backing_appdb: vps.private_ip] : [for vps in aws_instance.amd64_backing_opsman: vps.private_ip]) 
      om_url = ((length(aws_instance.amd64_backing_opsman) > 0) ? "http://${aws_instance.amd64_backing_opsman["om1"].public_dns}:8080" : local.cloudmanager)
      amd64_backing_private = [for vps in aws_instance.aarch64_backing_services: vps.private_dns]
      amd64_backing_public = [for vps in aws_instance.aarch64_backing_services: vps.public_dns]
    }
  )
  filename = "${path.module}/ansible/vars/om-vars.yaml"
}