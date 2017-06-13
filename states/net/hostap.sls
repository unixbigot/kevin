hostapd-installed:
  pkg.installed:
    - pkgs:
      - dnsmasq
      - hostapd
      - iptables-persistent

/etc/network/interfaces.d/{{pillar.hostap.interface}}:
  file.managed:
    - source: salt://net/interface-static.conf
    - template: jinja
    - makedirs: True
    - context:
      interface: {{pillar.hostap.interface}}
      address: {{pillar.hostap.address}}
      netmask: {{pillar.hostap.netmask}}

/etc/hostapd/hostapd.conf:
  file.managed:
    - source: salt://net/hostapd.conf
    - template: jinja
    - context:
      config: {{pillar.hostap}}

/etc/default/hostapd:
  file.managed:
    - source: salt://net/hostapd_default.conf
    - template: jinja

/etc/systemd/system/hostapd-{{pillar.hostap.interface}}.service:
  file.managed:
    - source: salt://net/hostapd_service.conf
    - template: jinja
    - context:
      interface: {{pillar.hostap.interface}}

/etc/network/hosts-{{pillar.hostap.interface}}:
  file.managed:
    - source: salt://net/hostapd_hosts.conf
    - template: jinja
    - context:
      address: {{pillar.hostap.address}}

/etc/dnsmasq.d/{{pillar.hostap.interface}}:
  file.managed:
    - source: salt://net/dnsmasq.conf
    - template: jinja
    - context:
      interface:  {{pillar.hostap.interface}}
      address:    {{pillar.hostap.address}}
      dhcp_start: {{pillar.hostap.dhcp_start}}
      dhcp_end:   {{pillar.hostap.dhcp_end}}
      dhcp_lease: {{pillar.hostap.dhcp_lease}}
      netmask:    {{pillar.hostap.netmask}}

hostapd-running:
  cmd.run:
    - name: systemctl daemon-reload
    - onchanges:
      - file: /etc/systemd/system/hostapd-{{pillar.hostap.interface}}.service
  service.running:
    - name: hostapd-{{pillar.hostap.interface}}
    - enable: True
    - watch:
      - file: /etc/hostapd/hostapd.conf
      - file: /etc/default/hostapd
      - file: /etc/network/interfaces.d/{{pillar.hostap.interface}}
      - file: /etc/systemd/system/hostapd-{{pillar.hostap.interface}}.service

dnsmasq-running:
  service.running:
    - name: dnsmasq
    - enable: True
    - watch:
      - file: /etc/dnsmasq.d/{{pillar.hostap.interface}}
      - file: /etc/network/hosts-{{pillar.hostap.interface}}
