events {}
http {
    upstream opsman {
        ip_hash;
        %{ for rhel in amd64_rhel_8_opsman ~}
        ${rhel}:8080;
        %{ endfor ~}
        %{ for suse in amd64_suse_15_opsman ~}
        ${suse}:8080;
        %{ endfor ~}
    }

    server {
        listen 3000;

        location / {
            proxy_pass http://opsman;
        }
    }
}