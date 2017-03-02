salt-master:
  pkgrepo.managed:
    - humanname: SaltStack Repo
    - name: deb {{pillar.salt_minion.apt_repo_path}} {{pillar.salt_minion.dist_codename}} main
    - dist: {{pillar.salt_minion.dist_codename}}
    - key_url: {{pillar.salt_minion.apt_repo_path}}/SALTSTACK-GPG-KEY.pub
    - file: /etc/apt/sources.list.d/saltstack.list
  pkg.installed:
    - pkgs:
      - salt-master
      - salt-ssh
  file.managed:
    - name: /etc/salt/master.d/local.conf
    - source: salt://salt/master-local.conf
    - replace: False
  service.running:
    - enable: True
    - watch:
      - file: salt-master

  
