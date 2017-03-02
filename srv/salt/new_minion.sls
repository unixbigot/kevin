include:
  - salt.minion

new_minion_id:
  file.managed:
    - name: /etc/salt/minion_id
    - contents:
      - {{pillar.roles[0] + '_' + grains.hwaddr_interfaces.eth0|replace(":","")}}

new_minion_grains:
  file.serialize:
    - name: /etc/salt/grains
    - formatter: yaml
    - user: root
    - group: root
    - mode: 644
    - merge_if_exists: true
    - dataset:
        new_minion: 1
        roles: 
{% for role in pillar.roles %}
          - {{role}}
{% endfor %}

new_minion_restart:
  service.running:
    - name: salt-minion
    - watch:
      - file: new_minion_id
      - file: new_minion_grains

