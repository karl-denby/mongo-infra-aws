resource "aws_instance" "amd64_backing_appdb" {
  for_each = local.amd64_backing_appdb
  ami = data.aws_ami.backing_amd64.id 
  instance_type = "t2.micro"              
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
  instance_type = "t2.large"
  key_name      = aws_key_pair.terraform-keypair.key_name
  tags = {
    Name = join("-", [local.tag_instance_name_prefix, each.key])
    owner = local.tag_owner
    keep_until = local.tag_keep_until
  }
  vpc_security_group_ids = [aws_security_group.tearraform-firewall.id]
}

resource "aws_instance" "amd64_amazon_linux_2" {
  for_each = local.amd64_amazon_linux_2
  ami = data.aws_ami.amazon_linux_2_amd64.id
  instance_type = "t2.micro"
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
  instance_type = "t2.micro"               # t2.micro (is enough to run an agent/deployment)
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

resource "aws_instance" "amd64_rhel_9" {
  for_each = local.amd64_rhel_9

  ami           = data.aws_ami.rhel_9_amd64.id
  instance_type = "t2.micro"
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
  instance_type = "t2.micro"
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
  instance_type = "t2.micro"                 # t2.micro (is enough to run an agent/deployment)
  key_name      = aws_key_pair.terraform-keypair.key_name
  tags = {
    Name = join("-", [local.tag_instance_name_prefix, each.key])
    owner = local.tag_owner
    keep_until = local.tag_keep_until
  }
  vpc_security_group_ids = [aws_security_group.tearraform-firewall.id]
}