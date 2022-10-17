  #cloud-config
  package_upgrade: true
  packages:
    - curl
    - nano
    - docker.io
    - certbot
  locale: en_GB.UTF-8
  timezone: Europe/Warsaw
  runcmd:
    - [ufw, allow, ssh]
    - [ufw, allow, http]
    - [ufw, allow, https]
    - [sh, -c, "yes y | ufw enable"]
    - [touch, /tmp/one]
    - docker run --name ipcheck -p 80:80 -d --restart=unless-stopped -m 128m --memory-swap 128m -e TZ=Europe/Warsaw techfellow/ipcheck:latest
    # - docker run --name ipcheckhttps6 -p 443:443 -d -v /opt/cert/archive/testip.fun/:/opt:ro --restart=unless-stopped -m 128m --memory-swap 128m -e TZ=Europe/Warsaw techfellow/ipcheck:https
    
    #https
    # - curl -sL "https://github.com/docker/compose/releases/download/v2.9.0/docker-compose-linux-x86_64" -o /usr/local/bin/docker-compose
    # - chmod +x /usr/local/bin/docker-compose
    # - curl "https://raw.githubusercontent.com/technicalflow/docker/master/icanhaz/dc.yml" -o /opt/docker-compose.yml
    # - certbot certonly --manual --preferred-challenges dns-01 --email marek@techfellow.it --server https://acme-v02.api.letsencrypt.org/directory --work-dir=/etc/letsencrypt --config-dir=/etc/letsencrypt --no-eff-email --agree-tos --quiet -d testip.fun
    # - docker run --rm -dt  -v "/opt/ovh.tfvars:/opt/ovh.ini" -v "/etc/letsencrypt:/etc/letsencrypt" -v "/var/lib/letsencrypt:/var/lib/letsencrypt" certbot/dns-ovh certonly --dns-ovh --dns-ovh-credentials /opt/ovh.ini --email marek@techfellow.it --server https://acme-v02.api.letsencrypt.org/directory --no-eff-email --agree-tos -d testip.fun
    # - sleep 150
    # - cat /etc/letsencrypt/archive/testip.fun/cert1.pem > /opt/cert/cert.pem && cat /etc/letsencrypt/archive/testip.fun/privkey1.pem > /opt/cert/privkey.pem
    # - /usr/local/bin/docker-compose -f /opt/docker-compose.yml up -d
  
    - [reboot]


# sudo certbot renew --dry-run
  # scripts-user:
  # #!/bin/bash
  # echo 123 > /tmp/filetest

# systemctl disable apt-daily.timer
# systemctl disable apt-daily.service
# systemctl disable apt-daily-upgrade.timer
# systemctl disable apt-daily-upgrade.service
# systemctl disable unattended-upgrades.service


# ---
# version: "3.3"

# services:
#   ipcheck100:
# #    build: .
#     image: techfellow/ipcheck:latest
#     container_name: ipcheck100
#     mem_limit: 128m
#     ports:
#       - "80:80"
#     environment:
#       TZ: 'Europe/Warsaw'

#     restart: unless-stopped

#   ipcheckhttps100:
#     image: techfellow/ipcheck:httpsroot
#     container_name: ipcheckhttps100
#     environment:
#       TZ: 'Europe/Warsaw'
#     mem_limit: 128m
#     ports:
#       - 443:443

#     volumes:
#       - /opt:/opt:ro

#     restart: unless-stopped


