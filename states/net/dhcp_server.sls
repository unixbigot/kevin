{%if pillar.dhcp_server is defined %}
{%if pillar.dhcp_server.enable %} 

dnsmasq:
  pkg.installed: []
  service.running:
    - enable: True
    - listen:
      - file: /etc/network/hosts-{{pillar.dhcp_server.interface}}
      - file: /etc/dnsmasq.d/{{pillar.dhcp_server.interface}}

/etc/network/hosts-{{pillar.dhcp_server.interface}}:
  file.managed:
    - source: salt://net/dhcp_server_hosts.conf
    - template: jinja
    - context:
      address: {{pillar.dhcp_server.address}}
{% if pillar.hostname is defined %}
      hostname: {{pillar.hostname}}
{% endif %}
{% if pillar.dns is defined and pillar.dns.hosts is defined %}
      hosts: {{pillar.dns.hosts}}
{% endif %}

/etc/dnsmasq.d/{{pillar.dhcp_server.interface}}:
  file.managed:
    - source: salt://net/dnsmasq.conf
    - template: jinja
    - context:
      interface:  {{pillar.dhcp_server.interface}}
      address:    {{pillar.dhcp_server.address}}
      dhcp_start: {{pillar.dhcp_server.dhcp_start}}
      dhcp_end:   {{pillar.dhcp_server.dhcp_end}}
      dhcp_lease: {{pillar.dhcp_server.dhcp_lease}}
      netmask:    {{pillar.dhcp_server.netmask}}
{% if pillar.dhcp_server.dns_server is defined %}
      dns_server: {{pillar.dhcp_server.dns_server}}
{% endif %}      

{% endif %}
{% endif %}
