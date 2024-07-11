# generate an nginx config file
resource "local_file" "nginx_template" {
  content = templatefile("${path.module}/template/nginx.tpl",
    {
      amd64_backing_opsman = [for vps in aws_instance.amd64_backing_opsman: "server ${vps.public_dns}"]
    }
  )
  filename = "${path.module}/ansible/nginx.conf"
}