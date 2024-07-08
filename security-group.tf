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
