dnsmasq:
  pkg.installed:
    - pkgs:
      - dnsmasq
      - iptables
  service.running:
    - enable: True
    - listen:
      - file: /etc/network/hosts-{{pillar.salt_provision.interface}}
      - file: /etc/dnsmasq.d/{{pillar.salt_provision.interface}}

/etc/network/interfaces:
  file.comment:
    - regex: ^(iface|allow-hotplug|no-auto-down) {{pillar.salt_provision.interface}}

parse-interfaces-dir:
  file.append:
    - name: /etc/network/interfaces
    - text:
      - ""
      - source-directory /etc/network/interfaces.d

/etc/network/interfaces.d/{{pillar.salt_provision.interface}}:
  file.managed:
    - makedirs: True
    - template: jinja
    - contents:
      - allow-hotplug {{pillar.salt_provision.interface}}
      - iface {{pillar.salt_provision.interface}} inet static
      - "  address {{pillar.salt_provision.address}}"
      - "  netmask {{pillar.salt_provision.netmask}}"
  cmd.run:
    - name: ifdown {{pillar.salt_provision.interface}} && ifup {{pillar.salt_provision.interface}}
    - onchanges:
      - file: /etc/network/interfaces
      - file: /etc/network/interfaces.d/{{pillar.salt_provision.interface}}

ip_forwarding:
  sysctl.present:
    - name: net.ipv4.ip_forward
    - value: 1
  iptables.set_policy:
    - chain: FORWARD
    - policy: ACCEPT

ip_masquerading:
  iptables.append:
    - table: nat
    - chain: POSTROUTING
    - out-interface: {{pillar.salt_provision.public_interface}}
    - jump: MASQUERADE

/etc/network/hosts-{{pillar.salt_provision.interface}}:
  file.managed:
    - template: jinja
    - contents:
      - {{pillar.salt_provision.address}} salt
      - {{pillar.salt_provision.target}} target

/etc/dnsmasq.d/{{pillar.salt_provision.interface}}:
  file.managed:
    - template: jinja
    - contents:
      - interface={{pillar.salt_provision.interface}}
      - dhcp-range={{pillar.salt_provision.dhcp_start}},{{pillar.salt_provision.dhcp_end}},{{pillar.salt_provision.dhcp_lease}}
      - no-hosts
      - addn-hosts=/etc/network/hosts-{{pillar.salt_provision.interface}}

provision-user:
  group.present:
    - name: {{pillar.salt_provision.user}}
  user.present:
    - name: {{pillar.salt_provision.user}}
    - gid_from_name: true
    - home: /home/{{pillar.salt_provision.user}}
    - shell: /bin/bash


ssh_config:
  file.managed:
    - name: /home/{{pillar.salt_provision.user}}/.ssh/config
    - user: {{pillar.salt_provision.user}}
    - group: {{pillar.salt_provision.user}}
    - mode: 600
    - makedirs: True
    - contents:
      - Host: target
      - "  User: {{pillar.salt_provision.target_user}}"

provision_ssh_id:
  file.managed:
    - name: /home/{{pillar.salt_provision.user}}/.ssh/id_provision
    - user: {{pillar.salt_provision.user}}
    - group: {{pillar.salt_provision.user}}
    - mode: 600
    - makedirs: True
    - source: {{pillar.salt_provision.ssh_secret_key}}

provision_ssh_pub:
  file.managed:
    - name: /home/{{pillar.salt_provision.user}}/.ssh/id_provision.pub
    - user: {{pillar.salt_provision.user}}
    - group: {{pillar.salt_provision.user}}
    - mode: 644
    - makedirs: True
    - source: {{pillar.salt_provision.ssh_public_key}}

salt_provision_repo:
  git.latest:
    - name: {{pillar.salt_provision.repo}}
    - target: /home/{{pillar.salt_provision.user}}/salt
    - user: {{pillar.salt_provision.user}}
    #- identity: {{pillar.salt_provision.git_secret_key}}
    - submodules: True

salt_provision_remove_srv:
  file.absent:
    - name: /srv

salt_provision_symlink:
  file.symlink:
    - name: /srv
    - target: /home/{{pillar.salt_provision.user}}/salt/srv
    - require:
      - salt_provision_remove_srv

salt_provision_conf:
  file.managed:
    - name: /etc/salt/master.d/salt_provision_server.conf
    - user: root
    - group: root
    - mode: 644
    - contents:
      - auto_accept: True

salt_provision_restart:
  service.running:
    - name: salt-master
    - watch:
      - file: salt_provision_conf
      - file: salt_provision_symlink
