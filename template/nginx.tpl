events {}
http {
    upstream opsman {
        ip_hash;
        %{ for backing in amd64_backing_opsman ~}
        ${backing}:8080;
        %{ endfor ~}
    }

    server {
        listen 3000;

        location / {
            proxy_pass http://opsman;
        }
    }
}