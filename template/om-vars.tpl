# Application Database member IPs
appdb:
%{ for app in appdb ~}
  - ${ app }
%{ endfor ~}

om_url:
  - ${ om_url }

amd64_backing_private:
%{ for node in amd64_backing_private ~}
  - ${ node }
%{ endfor ~}

amd64_backing_public:
%{ for node in amd64_backing_public ~}
  - ${ node }
%{ endfor ~}
