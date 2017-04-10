#
# Define the location of official saltstack packages.
#
# In theory one could construct the package paths from
# the grain data (osarch, osmajorrelease etc) but
# in practice, vendors don't provide packages for
# every combination (eg on ARM typically ONLY for jessie,
# requiring tweaks on ubuntu-based armbian)
#
#
zerotier:
  #
  # Where to get the packages
  #
  {% if grains['os'] == 'Ubuntu' and grains['osarch'] == 'amd64' %}
  apt_repo_path: https://download.zerotier.com/{{grains.os_family|lower}}/{{grains.lsb_distrib_codename}}
  dist_codename: {{grains.lsb_distrib_codename}}
  {% elif grains['os_family'] == 'Debian' and grains['osarch'] == 'armhf' %}
  apt_repo_path: http://download.zerotier.com/debian/jessie
  dist_codename: jessie
  {%endif%}
  #
  # Network to join
  #
  network: e5cd7a9e1ceef921
