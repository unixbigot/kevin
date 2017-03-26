nodered-base-install:
  npm.installed:
    - pkgs:
      - node-red
      - node-red-admin
    - user: root

nodered-johnny-five:
  npm.installed:
    - pkgs:
      - node-red-contrib-gpio
    - user: root
    - env:
      - npm_config_unsafe_perm: "true"

nodered-blynk:
  npm.installed:
    - name: node-red-contrib-blynk-websockets
    - user: root

nodered-user:
  group.present:
    - name: nodered
  user.present:
    - name: nodered
    - gid_from_name: true
    - home: /home/nodered
    - shell: /bin/bash

/lib/systemd/system/nodered.service:
  file.absent: []
  
iot-nodered-service:
  file.managed:
    - name: /etc/systemd/system/nodered.service
    - source: salt://iot/nodered.service
  cmd.run:
    - name: systemctl daemon-reload
    - onchanges:
      - file: iot-nodered-service
  service.running:
    - name: nodered
    - enable: True
    - onchange:
      - npm: node-serialport
      - npm: nodered-serial
      - npm: nodered-johnny-five
      - npm: nodered-blynk
    
