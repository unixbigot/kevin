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
salt-minion:
{% if grains['os'] == 'Ubuntu' and grains['osarch'] == 'amd64' %}
  apt_repo_path: http://repo.saltstack.com/apt/ubuntu/16.04/amd64/latest
  dist_codename: xenial
{% elif grains['os_family'] == 'Debian' and grains['osarch'] == 'armhf' %}
  apt_repo_path: https://repo.saltstack.com/apt/debian/8/armhf/latest
  dist_codename: jessie
{%endif%}
