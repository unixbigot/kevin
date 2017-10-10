docker-dependencies:
  pkg.installed:
    - pkgs:
      - ca-certificates
      - apt-transport-https
      - python-apt
      - python-setuptools
      - python-pip

remove-fossil-docker:
  pkg.removed:
    - pkgs:
      - docker-engine
      - docker.io

# Raspbian breaks the regular pattern of distro/codename assumed by download.docker.com
{% if grains.os == 'Raspbian' %}
{%   set dist='debian' %}
{% else %}
{%   set dist=grains.os|lower %}
{% endif %}
{% set rel=grains.oscodename %}

docker-ce:
  pkgrepo.managed:
    - humanname: Docker Community Edition
    - name: deb [arch={{grains.osarch}}] https://download.docker.com/linux/{{dist}} {{rel}} stable
    - key_url: https://download.docker.com/linux/{{dist}}/gpg
  pkg.installed: []

docker-tools:
  cmd.run:
    - name: pip install --upgrade pip
    - unless: test -f /usr/local/bin/pip || test -f /usr/bin/pip
  pip.installed:
    - pkgs:
      - docker-compose
      - docker-py

{% if grains.os == 'Raspbian' %}
# If you're using a Pi, allow the 'pi' user to run docker
docker-perms:
  group.present:
    - name: docker
    - addusers:
      - pi
    - require:
      - pkg: docker-ce
{% endif %}

docker-env:
  file.managed:
    - name: /etc/profile.d/docker.sh
    - mode: 755
    - contents:
      - "export PYTHONPATH=/usr/local/lib/python2.7/dist-packages:/usr/lib/python2.7/dist-packages"
