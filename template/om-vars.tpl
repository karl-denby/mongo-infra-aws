# Application Database member IPs
appdb:
%{ for app in appdb ~}
  - ${ app }
%{ endfor ~}

om_url:
  - ${ om_url }

amd64_rhel_8_private:
%{ for node in amd64_rhel_8_private ~}
  - ${ node }
%{ endfor ~}

amd64_rhel_8_public:
%{ for node in amd64_rhel_8_public ~}
  - ${ node }
%{ endfor ~}

amd64_suse_15_private:
%{ for node in amd64_suse_15_private ~}
  - ${ node }
%{ endfor ~}

amd64_suse_15_public:
%{ for node in amd64_suse_15_public ~}
  - ${ node }
%{ endfor ~}
