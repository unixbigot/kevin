salt-syndic:
  pkgrepo.managed:
    - humanname: SaltStack Repo
    - name: deb {{ pillar['salt-minion']['apt_repo_path'] }} {{ pillar['salt-minion']['dist_codename'] }} main
    - dist: {{ pillar['salt-minion']['dist_codename'] }}
    - key_url: {{ pillar['salt-minion']['apt_repo_path'] }}/SALTSTACK-GPG-KEY.pub
    - file: /etc/apt/sources.list.d/saltstack.list
  pkg:
    - installed
    - require:
      - pkgrepo: salt-syndic
  file.managed:
    - name: /etc/salt/master.d/syndic.conf
    - source: salt://salt/master-syndic.conf
    - replace: False
    - contents:
      - syndic_master: {{salt_syndic.master_host}}
  service.running:
    - enable: True
    - watch:
      - file: salt-syndic

  
