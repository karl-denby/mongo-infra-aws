[all_hosts]
%{ for host in all_hosts ~}
${host}
%{ endfor ~}

[amd64_backing_appdb]
%{ for app in amd64_backing_appdb ~}
${app} ansible_user=${user} ansible_ssh_common_args='-o StrictHostKeyChecking=no'
%{ endfor ~}

[amd64_backing_opsman]
%{ for ops in amd64_backing_opsman ~}
${ops} ansible_user=${user} ansible_ssh_common_args='-o StrictHostKeyChecking=no'
%{ endfor ~}

[amd64_backing_oplog]
%{ for op in amd64_backing_oplog ~}
${op} ansible_user=${user} ansible_ssh_common_args='-o StrictHostKeyChecking=no'
%{ endfor ~}

[amd64_backing_blockstore]
%{ for block in amd64_backing_blockstore ~}
${block} ansible_user=${user} ansible_ssh_common_args='-o StrictHostKeyChecking=no'
%{ endfor ~}

[aarch64_backing_services]
%{ for block in aarch64_backing_services ~}
${block} ansible_user=ec2-user ansible_ssh_common_args='-o StrictHostKeyChecking=no'
%{ endfor ~}

[amd64_rhel_8]
%{ for x in amd64_rhel_8 ~}
${x} ansible_user=ec2-user ansible_ssh_common_args='-o StrictHostKeyChecking=no'
%{ endfor ~}

[amd64_rhel_9]
%{ for x in amd64_rhel_9 ~}
${x} ansible_user=ec2-user ansible_ssh_common_args='-o StrictHostKeyChecking=no'
%{ endfor ~}

[aarch64_rhel_8]
%{ for x in aarch64_rhel_8 ~}
${x} ansible_user=ec2-user ansible_ssh_common_args='-o StrictHostKeyChecking=no'
%{ endfor ~}

[amd64_ubuntu_22_04]
%{ for y in amd64_ubuntu_22_04 ~}
${y} ansible_user=ubuntu ansible_ssh_common_args='-o StrictHostKeyChecking=no' ansible_python_interpreter=/usr/bin/python3
%{ endfor ~}

[amd64_ubuntu_20_04]
%{ for y in amd64_ubuntu_20_04 ~}
${y} ansible_user=ubuntu ansible_ssh_common_args='-o StrictHostKeyChecking=no' ansible_python_interpreter=/usr/bin/python3
%{ endfor ~}

[amd64_amazon_linux_2]
%{ for z in amd64_amazon_linux_2 ~}
${z} ansible_user=ec2-user ansible_ssh_common_args='-o StrictHostKeyChecking=no'
%{ endfor ~}

[aarch64_amazon_linux_2]
%{ for z in aarch64_amazon_linux_2 ~}
${z} ansible_user=ec2-user ansible_ssh_common_args='-o StrictHostKeyChecking=no'
%{ endfor ~}