salt-syndic:
  pkgrepo.managed:
    - humanname: SaltStack Repo
    - name: deb {{pillar.salt_minion.apt_repo_path}} {{pillar.salt_minion.dist_codename}} main
    - dist: {{pillar.salt_minion.dist_codename}}
    - key_url: {{pillar.salt_minion.apt_repo_path}}/SALTSTACK-GPG-KEY.pub
    - file: /etc/apt/sources.list.d/saltstack.list
  pkg:
    - installed
    - require:
      - pkgrepo: salt-syndic
  file.managed:
    - name: /etc/salt/master.d/syndic.conf
    - replace: False
    - contents:
      - syndic_master: {{pillar.salt_syndic.master_host}}
      - worker_threads: 3
  service.running:
    - enable: True
    - watch:
      - file: salt-syndic

  
