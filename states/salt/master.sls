include:
  - salt.depends

salt-master:
  pkg.installed:
    - pkgs:
      - salt-master
      - salt-ssh
    - require:
      - pkgrepo: salt-depends
  file.managed:
    - name: /etc/salt/master.d/local.conf
    - source: salt://salt/master-local.conf
  service.running:
    - enable: True
    - watch:
      - file: salt-master
      - file: salt-environments

salt-environments:
  file.managed:
    - name: /etc/salt/master.d/environments.conf
    - source: salt://salt/master-environments.conf

salt-base-repo:
  file.directory:
    - name: /srv/salt
    - makedirs: True
  git.latest:
    - name: {{pillar.salt_master.repo}}
    - branch: {{pillar.salt_master.branch}}
    - target: /srv/salt/base
    - identity: {{pillar.salt_master.git_secret_key}}

  
