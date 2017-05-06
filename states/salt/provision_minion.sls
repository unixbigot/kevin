include:
  - salt.minion

provision_minion_id:
  file.managed:
    - name: /etc/salt/minion_id
    - contents:
      - {{ pillar.roles[0] + '-' + grains.hwaddr_interfaces.eth0 | replace(':','') }}

# This hack is here because file.serialize doesn't bloody work

provision_minion_grain:
  file.line:
    - name: /etc/salt/grains
    - after: "  - base"
    - mode: insert
    - content: "- provision_minion"
    - require:
      - file: salt-grains


{% if pillar.roles is defined %}
{% for role in pillar.roles %}
provision_minion_grain_{{role}}:
  file.line:
    - name: /etc/salt/grains
    - after: "  - provision_minion"
    - mode: insert
    - content: "- {{role}}"
    - require:
      - file: salt-grains
      - file: provision_minion_grain
    - watch_in:
      - service: provision_minion_restart
{% endfor %}
{% endif %}

provision_minion_restart:
  service.running:
    - name: salt-minion
    - watch:
      - file: provision_minion_id
      - file: provision_minion_grain
