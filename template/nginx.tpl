events {}
http {
    upstream opsman {
        ip_hash;
        %{ for ops in amd64_rhel_8_opsman ~}
        ${ops}:8080;
        %{ endfor ~}
    }

    server {
        listen 3000;

        location / {
            proxy_pass http://opsman;
        }
    }
}