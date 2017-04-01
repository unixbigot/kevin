homebridge-prereqs:
  pkg.installed:
    - pkgs:
      - libavahi-compat-libdnssd-dev

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
      - file: homebridge
      - file: homebridge-config
      - npm: homebridge-plugins
  service.running:
    - enable: True

homebridge-config:
  file.managed:
    - name: /home/homebridge/.homebridge/config.json
    - source: salt://iot/homebridge-config.json
    - makedirs: True
    - user: homebridge
    - group: homebridge
    - template: jinja
    - context:
      bridge: {{pillar.homebridge.bridge}}
      pin: {{pillar.homebridge.pin}}
      desc: {{pillar.homebridge.desc}}

homebridge-plugins:
  npm.installed:
    - require:
      - npm: homebridge
    - pkgs:
{% for pkg in pillar.homebridge.plugins %}
      - homebridge-{{pkg}}
{% endfor %}
