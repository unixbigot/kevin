{% set enable = false %}
{%if pillar.hostap.enable is not defined %} 
{% set enable = true %}
{%elif pillar.hostap.enable %}
{% set enable = true %}
{%endif%}

{% if enable %}
hostapd-installed:
  pkg.installed:
    - pkgs:
      - dnsmasq
      - hostapd
      - ifupdown
      - iptables-persistent

dnsmasq:
  pkg.installed: []
  service.running:
    - enable: True
    - listen:
      - file: /etc/dnsmasq.d/{{pillar.hostap.interface}}
      - file: /etc/network/hosts-{{pillar.hostap.interface}}
      - service: disable-systemd-resolver


{%if grains.os == 'Raspbian'%}
{{pillar.hostap.interface}}_fixedip:
  file.append:
    - name: /etc/dhcpcd.conf
    - text:
      - interface {{pillar.hostap.interface}}
      - static ip_address={{pillar.hostap.address}}/{{pillar.hostap.netcidrlen}}
      - static domain_name_servers={{pillar.hostap.address}}
{%else%}
{{pillar.hostap.interface}}_hostap:
  network.managed:
    - name: {{pillar.hostap.interface}}
    - enabled: True
    - type: eth
    - proto: static
    - ipaddr: {{pillar.hostap.address}}
    - netmask: {{pillar.hostap.netmask}}
    - dns:
      - 8.8.8.8
      - 8.8.4.4
{%endif%}

/etc/hostapd/hostapd.conf:
  file.managed:
    - source: salt://net/hostapd.conf
    - makedirs: True
    - template: jinja
    - context:
      config: {{pillar.hostap}}
{% if pillar.hostap.wpa_passphrase is defined %}
      wpa_passphrase: {{pillar.hostap.wpa_passphrase}}
{% endif %}

# Prevent systemd-resolver from binding to localhost
/etc/systemd/resolved.conf:
  file.append:
    - text: DNSStubListener=no

disable-systemd-resolver:
  service.dead:
    - name: systemd-resolver
    - enable: False

disable-wpa-supplicant:
  service.dead:
    - name: wpa-supplicant
    - enable: False


{%if grains.os != 'Raspbian'%}
# Create an override resolv.conf to replace the systemd linked version
/etc/resolv.conf.dnsmasq:
  file.managed:
    - contents: |
        nameserver 127.0.0.1
        search lan

# Replace the /etc/resolv.conf symlink with a link to our configuration
/etc/resolv.conf:
  file.symlink:
    - target: /etc/resolv.conf.dnsmasq
{%endif%}

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
        name: {{pillar.hostap.servername}}
{%if pillar.hostap.aliases is defined%}
	aliases: {{pillar.hostap.aliases}}
{%endif%}

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


{%if grains.os != 'Raspbian'%}
hostapd-disable-networkmanager:
  file.append:
    - name: /etc/NetworkManager/NetworkManager.conf
    - source: salt://net/hostapd_nm_append.txt
    - template: jinja
    - context:
        rec: "{{grains.hwaddr_interfaces[pillar.hostap.interface]}}"
{%endif%}

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
      - file: /etc/systemd/system/hostapd-{{pillar.hostap.interface}}.service

{% endif %}
