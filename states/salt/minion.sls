pkg-depends:
  # Armbian ships without python-apt, which cannot 
  # be installed with salt's pkg module, which needs it.
  cmd.run:
    - name: apt install -y python-apt
    - unless: dpkg -l | grep "python-apt "

# 
# Install and configure the salt "minion" service
#
salt-minion:
  pkgrepo.managed:
    - humanname: SaltStack Repo
    - name: deb {{pillar.salt_minion.apt_repo_path}} {{pillar.salt_minion.dist_codename}} main
    - dist: {{pillar.salt_minion.dist_codename}}
    - key_url: {{pillar.salt_minion.apt_repo_path}}/SALTSTACK-GPG-KEY.pub
    - file: /etc/apt/sources.list.d/saltstack.list
  pkg:
    - installed
    - require:
      - pkgrepo: salt-minion
  file.managed:
    - name: /etc/salt/minion.d/local.conf
    - replace: False
    - contents: |
        hash_type: sha256
        master: {{pillar.salt_minion.master_host}}
  service.running:
    - enable: True
    - watch:
      - file: salt-grains
      - file: salt-minion

salt-grains:
  file.managed:
    - name: /etc/salt/grains
    - replace: False
    - contents:
      - roles: []

  
