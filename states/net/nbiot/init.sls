nbiot-deps:
  pkg.installed:
    - pkgs:
      - ppp

/etc/chatscripts/nbiot-connect:
  file.managed:
    - source: salt://net/nbiot/chat-connect
    - makedirs: True

/etc/chatscripts/nbiot-disconnect:
  file.managed:
    - source: salt://net/nbiot/chat-disconnect
    - makedirs: True

/etc/ppp/peers/nbiot:
  file.managed:
    - source: salt://net/nbiot/nbiot.peer
    - makedirs: True

/usr/local/sbin/nbiot.sh:
  file.managed:
    - source: salt://net/nbiot/nbiot.sh
    - mode: 744
    - makedirs: True

/etc/systemd/system/nbiot.service:
  file.managed:
    - source: salt://net/nbiot/nbiot.service

nbiot-running:
  cmd.run:
    - name: systemctl daemon-reload
    - onchanges:
      - file: /etc/systemd/system/nbiot.service
  service.running:
    - name: nbiot
    - enable: True
    - watch:
      - file: /etc/chatscripts/nbiot-connect
      - file: /etc/chatscripts/nbiot-disconnect
      - file: /etc/ppp/peers/nbiot
      - file: /etc/systemd/system/nbiot.service


