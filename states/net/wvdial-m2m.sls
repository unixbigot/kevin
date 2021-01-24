wvdial-prereqs:
  pkg.installed:
    - pkgs:
      - wvdial

wvdial-m2m:
  file.managed:
    - name: /etc/systemd/system/wvdial-m2m.service
    - source: salt://net/wvdial-m2m.service
  cmd.run:
    - name: systemctl daemon-reload
    - onchanges:
      - file: wvdial-m2m
  service.running:
    - require:
      - file: wvdial-config
    - enable: True

wvdial-config:
  file.managed:
    - name: /etc/wvdial-m2m.conf
    - source: salt://net/wvdial-m2m.conf

wvdial-suppress-dns:
  file.comment:
    - name: /etc/ppp/peers/wvdial
    - regex: usepeerdns
    