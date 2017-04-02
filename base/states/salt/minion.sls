include:
  - salt.depends
 
# 
# Install and configure the salt "minion" service
#
salt-minion:
  pkg.installed:
    - require:
      - pkgrepo: salt-depends
  file.managed:
    - name: /etc/salt/minion.d/local.conf
    - replace: False
    - contents:
      - hash_type: sha256
      - master: {{pillar.salt_minion.master_host}}
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

 
