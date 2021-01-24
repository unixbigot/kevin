livecam-prereqs:
  pkg.installed:
    - pkgs:
      - fbset
      - libgstreamer1.0-0
      - gstreamer1.0-plugins-base
      - gstreamer1.0-plugins-good
      - gstreamer1.0-plugins-bad 
      - gstreamer1.0-plugins-ugly 
      - gstreamer1.0-libav 
      - gstreamer1.0-doc 
      - gstreamer1.0-tools 
      - gstreamer1.0-x 
      - gstreamer1.0-alsa 
      - gstreamer1.0-pulseaudio

livecam-script:
  file.managed:
    - name: /usr/local/bin/livecam.sh
    - source: salt://iot/livecam.sh
    - user: root
    - group: root
    - mode: 755

livecam-nolightdm:
  service.dead:
    - name: lightdm
    - enable: False

livecam-nogdm3:
  service.dead:
    - name: gdm3
    - enable: False

livecam-service:
  file.managed:
    - name: /etc/systemd/system/livecam.service
    - source: salt://iot/livecam.service
  cmd.run:
    - name: systemctl daemon-reload
    - onchanges:
      - file: livecam-service
  service.running:
    - name: livecam
    - enable: True
    - depends:
      - service: livecam-nolightdm
      - service: livecam-nogdm3
      - file: livecam-script
      - cmd: livecam-service

