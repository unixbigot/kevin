include:
  - salt.master
  - salt.syndic

dnsmasq:
  pkg.installed:
    - pkgs:
      - dnsmasq
      - iptables
      - iptables-persistent
  service.running:
    - enable: True
    - listen:
      - file: /etc/network/hosts-{{pillar.salt_provision.interface}}
      - file: /etc/dnsmasq.d/{{pillar.salt_provision.interface}}

/etc/network/interfaces:
  file.replace:
    - pattern: "^(iface|allow-hotplug|no-auto-down) {{pillar.salt_provision.interface}}.*"
    - repl: ""

parse-interfaces-dir:
  file.append:
    - name: /etc/network/interfaces
    - text:
      - ""
      - source-directory /etc/network/interfaces.d

/etc/network/interfaces.d/{{pillar.salt_provision.interface}}:
  file.managed:
    - makedirs: True
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

save_iptables:
  cmd.run:
    - name: netfilter-persistent save
    - watch:
      - iptables: ip_forwarding
      - iptables: ip_masquerading

/etc/network/hosts-{{pillar.salt_provision.interface}}:
  file.managed:
    - contents:
      - {{pillar.salt_provision.address}} salt
      - {{pillar.salt_provision.target}} target

/etc/dnsmasq.d/{{pillar.salt_provision.interface}}:
  file.managed:
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

provision_sudo_group:
  group.present:
    - name: sudo
    - addusers:
      - {{pillar.salt_provision.user}}
    - require:
      - user: provision-user

provision_sudo_permission:
  file.append:
    - name: /etc/sudoers
    - text: "{{pillar.salt_provision.user}} ALL=(ALL:ALL) NOPASSWD: ALL"

ssh_config:
  file.managed:
    - name: /home/{{pillar.salt_provision.user}}/.ssh/config
    - user: {{pillar.salt_provision.user}}
    - group: {{pillar.salt_provision.user}}
    - mode: 600
    - makedirs: True
    - contents:
      - "Host target"
      - "   User {{pillar.salt_provision.target_user}}"

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

provision_ssh_authorized_keys:
  file.managed:
    - name: /home/{{pillar.salt_provision.user}}/.ssh/authorized_keys
    - user: {{pillar.salt_provision.user}}
    - group: {{pillar.salt_provision.user}}
    - mode: 600

provision_ssh_authorize:
  file.append:
      - name: /home/{{pillar.salt_provision.user}}/.ssh/authorized_keys
      - source: {{pillar.salt_provision.ssh_public_key}}
      - require:
        - file: provision_ssh_authorized_keys


salt_provision_symlink:
   file.symlink:
      - name: /home/{{pillar.salt_provision.user}}/salt
      - target: /srv/salt
      - makedirs: True

salt_provision_conf:
  file.managed:
    - name: /etc/salt/master.d/salt_provision_server.conf
    - user: root
    - group: root
    - mode: 644
    - contents:
      - auto_accept: True
    - require:
      - pkg: salt-master

salt_provision_restart:
  service.running:
    - name: salt-master
    - watch:
      - file: salt_provision_conf
      - file: salt_provision_symlink
