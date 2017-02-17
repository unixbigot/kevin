salt-minion:
  pkgrepo.managed:
    - humanname: SaltStack Repo
    - name: deb {{ pillar['salt-minion']['apt_repo_path'] }} {{ pillar['salt-minion']['dist_codename'] }} main
    - dist: {{ pillar['salt-minion']['dist_codename'] }}
    - key_url: {{ pillar['salt-minion']['apt_repo_path'] }}/SALTSTACK-GPG-KEY.pub
    - file: /etc/apt/sources.list.d/saltstack.list
  pkg:
    - installed
    - require:
      - pkgrepo: salt-minion
  file.managed:
    - name: /etc/salt/minion.d/local.conf
    - source: salt://salt/minion-local.conf
    - replace: False
  service.running:
    - enable: True
    - watch:
      - file: salt-grains
      - file: salt-minion
salt-grains:
  file.managed:
    - name: /etc/salt/grains
    - source: salt://salt/minion-grains.conf
    - replace: False

  
