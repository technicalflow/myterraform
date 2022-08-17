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
    # - [curl, -sL, "https://github.com/docker/compose/releases/download/v2.9.0/docker-compose-linux-x86_64", -o, /usr/local/bin/docker-compose]
    # - chmod +x /usr/local/bin/docker-compose
    # - [curl, -sL, "https://github.com/technicalflow/docker.git", -o, /opt/docker/]
    - [ufw, allow, ssh]
    - [ufw, allow, http]
    - [ufw, allow, https]
    - [sh, -c, "yes y | ufw enable"]
    - [touch, /tmp/one]
    - docker run --name ipcheck -p 80:80 -d --restart=unless-stopped -m 128m --memory-swap 128m -e TZ=Europe/Warsaw techfellow/ipcheck:latest
    - [reboot]

  # scripts-user:
  # #!/bin/bash
  # echo 123 > /tmp/filetest