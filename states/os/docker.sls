docker-dependencies:
  pkg.installed:
    - pkgs:
      - ca-certificates
      - apt-transport-https
      - python-apt
      - python-setuptools
      - libffi-dev
    - cmd.run:
      - name: easy_install pip
      - unless: test -f /usr/local/bin/pip

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

#docker-tools:
#  cmd.run:
#    - name: pip install --upgrade pip
#    - unless: test -f /usr/local/bin/pip || test -f /usr/bin/pip

docker-compose-installation:
{% if grains.os == 'Raspbian' %}
  pip.installed:
    - pkgs:
      - docker-compose
{% else %}
  cmd.run:
    - name: curl -L https://github.com/docker/compose/releases/download/1.18.0/docker-compose-Linux-x86_64 -o /usr/local/bin/docker-compose
    - unless: ls /usr/local/bin/docker-compose
    - create: /usr/local/bin/docker-compose
{% endif %}

/usr/local/bin/docker-compose:
  file.managed:
    - user: root
    - group: root 
    - mode: 755

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
