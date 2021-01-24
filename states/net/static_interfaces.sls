{% if pillar.static_interfaces is defined %}
  {% for intf,config in pillar.static_interfaces.iteritems() %}
{{intf}}_static:
  network.managed:
    - name: {{intf}}
    - enabled: True
    - type: eth
    - proto: none
    {% if config.address is defined %}
    - ipaddr: {{config.address}}
    - netmask: {{config.netmask}}
    {% else %}
    - ipaddr: 0.0.0.0
    - netmask: 0.0.0.0
    {% endif %}
    {% if config.gateway is defined %}
    - gateway: {{config.gateway}}
    {% endif %}      
    - dns:
    {% if config.dns_server is defined %}
      - {{config.dns_server}}
    {% elif pillar.dhcp_server is defined and pillar.dhcp_server.address is defined %}    
      - {{pillar.dhcp_server.address}}
    {% else %}
      - 8.8.8.8
      - 8.8.4.4
    {% endif %}

    {% if config.hosts is defined %}
{{intf}}_hosts:
  file.append:
    - name: /etc/network/hosts-{{intf}}
    - text:
      {% for hostent in config.hosts %}
      - "{{hostent}}"
      {% endfor %}
    {% endif %}

  {% endfor %}



{% endif %}

