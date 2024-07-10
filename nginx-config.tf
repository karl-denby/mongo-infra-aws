# generate an nginx config file
resource "local_file" "nginx_template" {
  content = templatefile("${path.module}/template/nginx.tpl",
    {
      amd64_rhel_8_opsman = [for vps in aws_instance.amd64_rhel_8_opsman: "server ${vps.public_dns}"]
      amd64_suse_15_opsman = [for vps in aws_instance.amd64_suse_15_opsman: "server ${vps.public_dns}"]
    }
  )
  filename = "${path.module}/ansible/nginx.conf"
}