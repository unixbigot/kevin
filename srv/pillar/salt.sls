#
# Set the location of your top level salt master here.
#
# Mine is a Raspberry Pi called "Tweety"
#
salt_syndic:
  master_host: tweety.local

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
  master_host: tweety.local
{% if grains['os'] == 'Ubuntu' and grains['osarch'] == 'amd64' %}
  apt_repo_path: http://repo.saltstack.com/apt/ubuntu/16.04/amd64/latest
  dist_codename: xenial
{% elif grains['os_family'] == 'Debian' and grains['osarch'] == 'armhf' %}
  apt_repo_path: https://repo.saltstack.com/apt/debian/8/armhf/latest
  dist_codename: jessie
{%endif%}

#
# Set up provisining server config
#
salt_provision:
  public_interface: wlan0
  interface: eth0
  repo: https://github.com/unixbigot/kevin.git
  ssh_secret_key: PASTE_HERE_id_provision
  ssh_public_key: PASTE_HERE_id_provision.pub
  git_secret_key: PASTE_HERE_id_github
  address:       192.168.0.1
  netmask:       255.255.255.0
  dhcp_start:    192.168.0.100
  dhcp_end:      192.168.0.100
  dhcp_lease:    5m
  target:        192.168.0.100
