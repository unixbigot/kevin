/etc/rsyslog.d/udp.conf:
  file.managed:
    - contents: |
        module(load="imudp")
        input(type="imudp" port="514")
