nat_prereqs:
  pkg.installed:
    - pkgs:
      - iptables
      - iptables-persistent

nat_ip_forwarding_enabled:
  sysctl.present:
    - name: net.ipv4.ip_forward
    - value: 1
  iptables.set_policy:
    - chain: FORWARD
    - policy: ACCEPT

ip_forwarding_flush:
  iptables.flush:
    - chain: FORWARD

ip_masquerading_enabled:
  iptables.append:
    - table: nat
    - chain: POSTROUTING
    - out-interface: {{pillar.nat_router.outside_interface}}
    - jump: MASQUERADE
    - save: True

{% for inside in pillar.nat_router.inside_interfaces %}
masquerade_outbound_{{inside}}:
  iptables.append:
    - table: filter
    - chain: FORWARD
    - in-interface: {{inside}}
    - out-interface: {{pillar.nat_router.outside_interface}}
    - jump: ACCEPT
    - save: True

masquerade_return_{{inside}}:
  iptables.append:
    - table: filter
    - chain: FORWARD
    - match: state
    - connstate: RELATED,ESTABLISHED
    - in-interface: {{pillar.nat_router.outside_interface}}
    - out-interface: {{inside}}
    - jump: ACCEPT
    - save: True
{% endfor %}



