
mjpg-streamer-dir:
  file.directory:
    - name: /opt/accelerando/mjpg-streamer
    - user: accelerando
    - makedirs: True

mjpg-build:
  pkg.installed:
    - pkgs:
      - cmake
      - build-essential
      - libjpeg-dev
      - lm-sensors
  git.latest:
    - name: ssh://git@github.com/accelerando-consulting/mjpg-streamer.git
    - target: /opt/accelerando/mjpg-streamer
    - branch: master
    - identity: salt://credentials/id_pamela
    - user: accelerando
    - require: 
      - file: mjpg-streamer-dir
  cmd.run:
    - onchanges:
      - git: mjpg-streamer
    - cwd: /opt/accelerando/mjpg-streamer/mjpg-streamer-experimental
    - name: make
    - user: accelerando
    - onchanges:
      - git: mjpg-build

mjpg-streamer:
  file.managed:
    - name: /etc/systemd/system/mjpg-streamer.service
    - source: salt://iot/mjpg-streamer.service
  cmd.run:
    - name: systemctl daemon-reload
    - onchanges:
      - git: mjpg-build
      - file: mjpg-streamer
  service.running:
    - name: mjpg-streamer
    - enable: True
    - watch:
      - file: mjpg-streamer
    - depends:
      - cmd: mjpg-build





