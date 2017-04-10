include:
  - salt.minion

provision_minion_id:
  file.managed:
    - name: /etc/salt/minion_id
    - contents:
      - {{ pillar.roles[0] + '-' + grains.hwaddr_interfaces.eth0 | replace(':','') }}

provision_minion_grains:
  file.serialize:
    - name: /etc/salt/grains
    - dataset:
      roles:
        - provision_minion
{% for role in pillar.roles %}
        - {{role}}
{% endfor %}
    - user: root
    - group: root
    - mode: 644
    - formatter: yaml
    - merge_if_exists: true

provision_minion_restart:
  service.running:
    - name: salt-minion
    - watch:
      - file: provision_minion_id
      - file: provision_minion_grains
