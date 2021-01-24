nodered-base-install:
  npm.installed:
    - pkgs:
      - node-red
      - node-red-admin
    - user: root

nodered-modules-unsafe:
  npm.installed:
    - pkgs:
      - node-red-contrib-gpio
      - "@abandonware/noble"
    - user: root
    - env:
      - npm_config_unsafe_perm: "true"

nodered-modules:
  npm.installed:
    - name: node-red-contrib-blynk-websockets
    - user: root

nodejs-permission:
  cmd.run:
    - name: setcap cap_net_raw+eip /usr/local/node/bin/node

nodered-user:
  user.present:
    - name: nodered
    - home: /home/nodered
    - createhome: True
    - usergroup: True
    - groups:
      - dialout
      - audio
      - video
      - input
      - i2c
{% if grains.os == 'Raspbian' %}
      - spi
      - gpio
{% endif %}
    - shell: /bin/bash

/lib/systemd/system/nodered.service:
  file.absent: []
  
nodered-package:
  file.managed:
    - name: /home/nodered/.node-red/package.json
    - user: nodered
    - group: nodered
    - mode: 644
    - source: salt://iot/nodered-package.json

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
    
