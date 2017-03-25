docker-dependencies:
  pkg.installed:
    - pkgs:
      - ca-certificates
      - apt-transport-https
      - python-apt
      - python-pip

docker-ce:
  pkgrepo.managed:
    - humanname: Docker Community Editition
    - name: deb [arch={{grains.osarch}}] https://download.docker.com/linux/ubuntu {{grains.lsb_distrib_codename}} stable
    - key_url: https://download.docker.com/linux/ubuntu/gpg
  pkg.installed: []

docker-compose:
  pip.installed:
    - pkgs:
      - docker-compose
      - docker-py


{% if grains.osarch == 'armhf' %}
docker-perms:
  group.present:
    - name: docker
    - addusers:
      - pi
    - require:
      - pkg: docker-ce
{% endif %}
