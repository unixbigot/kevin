salt-depends:
{%if grains.osarch=="arm64" and grains.os=="Ubuntu" %}
  # In Ubuntu 20.10 server, system salt package is suitable!
  test.succeed_without_changes:
    - name: system-salt-is-suitable
{%else%}    
  # Armbian ships without python-apt, which cannot 
  # be installed with salt's pkg module, which needs it.
  cmd.run:
    - name: apt install -y python-apt
    - unless: dpkg -l | grep "python-apt "
  # Raspbian ships without apt-transport-https, which
  # Salt, Docker et.al need for secure repos
  pkg.installed:
    - pkgs:
      - ca-certificates
      - apt-transport-https
    - require:
      - cmd: salt-depends
  pkgrepo.managed:
    - humanname: SaltStack Repo
    - name: deb {{pillar.salt_minion.apt_repo_path}} {{pillar.salt_minion.dist_codename}} main
    - dist: {{pillar.salt_minion.dist_codename}}
    - key_url: {{pillar.salt_minion.apt_repo_path}}/SALTSTACK-GPG-KEY.pub
    - file: /etc/apt/sources.list.d/saltstack.list
    - require:
      - pkg: salt-depends
{%endif%}    
