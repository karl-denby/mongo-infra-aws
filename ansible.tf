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