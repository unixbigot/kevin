
bluetooth:
  group.present:
    - addusers:
      - pi

/etc/machine-info:
  file.managed:
    - contents:
      - PRETTY_HOSTNAME={{grains.id}}

bluetooth-compat:
  file.replace:
    - name: /lib/systemd/system/bluetooth.service
    - pattern: ^ExecStart=/usr/lib/bluetooth/bluetoothd$
    - repl: ExecStart=/usr/lib/bluetooth/bluetoothd -C

bluetooth-post:
  file.line:
    - name: /lib/systemd/system/bluetooth.service
    - after: ^ExecStart=
    - mode: ensure
    - content: |
           ExecStartPost=/usr/bin/sdptool add SP
           ExecStartPost=/bin/hciconfig hci0 piscan

rfcomm:
  file.managed:
    - name: /etc/systemd/system/rfcomm.service
    - source: salt://os/rfcomm.service
    - mode: 644
  cmd.run:
    - name: systemctl daemon-reload
    - onchanges:
      - file: rfcomm
  service.running:
    - enable: True

