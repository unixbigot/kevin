homebridge:
  group.present: []
  user.present:
    - gid_from_name: true
    - shell: /bin/bash
  npm.installed:
    - env:
      - npm_config_unsafe_perm: "true"
  file.managed:
    - name: /lib/systemd/system/homebridge.service
    - source: salt://iot/homebridge.service
  cmd.run:
    - name: systemctl daemon-reload
    - onchanges:
      - file: service
  service.running:
    - enable: True
    
