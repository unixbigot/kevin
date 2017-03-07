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
  user: provision
  target_user: pi
  interface: eth0
{% if grains.id == 'pickaxe' %}
  public_interface: wlx7cdd9017ca36
{% else %}
  public_interface: wlan0
{% endif %}
  repo: https://github.com/unixbigot/kevin.git
  ssh_secret_key: salt://credentials/id_provision
  ssh_public_key: salt://credentials/id_provision.pub
  git_secret_key: salt://credentials/id_github
  git_public_key: salt://credentials/id_github.pub
  address:       192.168.99.1
  netmask:       255.255.255.0
  dhcp_start:    192.168.99.100
  dhcp_end:      192.168.99.100
  dhcp_lease:    5m
  target:        192.168.99.100

  
