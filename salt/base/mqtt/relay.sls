mqtt-relay:
  pkg.installed:
    - pkgs: mosquitto mosquitto-clients
  file.managed:
    - name: /etc/mosquitto/conf.d/relay.conf
    - source: salt://mqtt/relay.conf
  service.running:
    - name: mosquitto
    - enable: True
    - watch:
      - file: /etc/mosquitto/conf.d/relay.conf


  