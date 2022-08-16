  #cloud-config
  package_upgrade: true
  packages:
    - httpd
    - curl
    - nano
    - epel-release
  locale: en_GB.UTF-8
  timezone: Europe/Warsaw
  runcmd:
    - [touch, /tmp/one]
    - [dnf, update -y]
    - [dnf, install -y podman]
    - [echo, net.ipv4.ip_unprivileged_port_start=80 >> /etc/sysctl.conf]

# firewall-cmd --permanent --zone=public --add-service=http && firewall-cmd --reload
# yum install epel-release -y
# sudo dnf remove -y cockpit*