  #cloud-config
  package_update: true
  package_upgrade: true
  packages:
    - curl
    - nano
    - docker.io
  locale: en_GB.UTF-8
  timezone: Europe/Warsaw
  runcmd:
    - [curl, "https://github.com/docker/compose/releases/download/v2.9.0/docker-compose-linux-x86_64", -o, /usr/local/bin/docker-compose]
    - [ufw, allow ssh]
    - [ufw, allow http]
    - [ufw, allow https]
    - [sh, -c, "yes y | ufw enable"]
    - [reboot]
    - [touch, /tmp/one]

  # scripts-user:
  # #!/bin/bash
  # echo 123 > /tmp/filetest
# UFW
# sudo ufw allow ssh
# sudo ufw allow http
# sudo ufw allow https
# yes y | sudo ufw enable

# sudo docker run -p 80:80 -d techfellow/ubuntu:latest