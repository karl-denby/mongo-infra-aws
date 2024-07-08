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