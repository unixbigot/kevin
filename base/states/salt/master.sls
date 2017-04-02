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
    - replace: False
  service.running:
    - enable: True
    - watch:
      - file: salt-master

  
