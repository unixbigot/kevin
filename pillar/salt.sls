#
# Set the location of your top level salt master here.
#
# Mine is a Raspberry Pi called "Tweety", but I
# have a DNS alias "salt.lan" for it.
#
salt_syndic:
  master_host: salt.lan

#
# Define the location of official saltstack packages.
#
# In theory one could construct the package paths from
# the grain data (osarch, osmajorrelease etc) but
# in practice, Saltstack do not name their APT sources
# in a regular way, nor do they provide packages for
# every release, so you have to simply hard-code the
# most appropriate package for supported distributions.
# 
salt_minion:
  master_host: salt.lan
{% if grains['os'] == 'Ubuntu' and grains['osarch'] == 'amd64' %}
{# Saltstack only packages for LTS release, so "round" the OS version to the latest LTE #}
{% if grains['osmajorrelease'] <= 14 %}
  apt_repo_path: https://repo.saltstack.com/apt/ubuntu/14.04/amd64/latest
  dist_codename: trusty
{% elif grains['osmajorrelease'] < 18 %}  
  apt_repo_path: https://repo.saltstack.com/apt/ubuntu/16.04/amd64/latest
  dist_codename: xenial
{% else %}
  apt_repo_path: https://repo.saltstack.com/apt/ubuntu/18.04/amd64/latest
  dist_codename: bionic
{%endif%}
{% elif grains['os_family'] == 'Debian' and grains['osarch'] == 'armhf' %}
  apt_repo_path: https://repo.saltstack.com/apt/debian/9/armhf/latest
  dist_codename: stretch
{% elif grains['os_family'] == 'Debian' and grains['osarch'] == 'arm64' %}
  apt_repo_path: https://repo.saltstack.com/apt/debian/9/armhf/latest
  dist_codename: stretch
{%endif%}

salt_master:
  repo: https://github.com/unixbigot/kevin.git
  branch: master

#
# Set up provisining server config
#
salt_provision:
  user: provision
  target_user: pi
  interface: eth0
{% if grains.id == 'pickaxe' %}
  public_interface: wlx7cdd9017ca36
{% else %}
  public_interface: wlan0
{% endif %}
  ssh_secret_key: salt://credentials/id_provision
  ssh_public_key: salt://credentials/id_provision.pub
  address:       192.168.99.1
  netmask:       255.255.255.0
  dhcp_start:    192.168.99.100
  dhcp_end:      192.168.99.100
  dhcp_lease:    5m
  target:        192.168.99.100
