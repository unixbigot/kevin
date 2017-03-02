dnsmasq:
  pkg.installed:
    - pkgs:
      - dnsmasq
  service.running:
    - enable: True
    - listen:
      - file: /etc/network/hosts-{{pillar.salt_provision.interface}}
      - file: /etc/dnsmasq.d/{{pillar.salt_provision.interface}}

/etc/network/interfaces:
  file.comment:
    - regex: ^iface eth0

/etc/network/interfaces.d/{{pillar.salt_provision.interface}}:
  file.managed:
    - source: salt://salt/provision_interface.conf
    - makedirs: True
    - template: jinja
    - context:
      interface: {{pillar.salt_provision.interface}}
      address: {{pillar.salt_provision.address}}
      netmask: {{pillar.salt_provision.netmask}}
  cmd.run:
    - name: ifdown {{pillar.bootstrap.interface}} && ifup {{pillar.bootstrap.interface}}
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
    - source: salt://salt/provision_hosts.conf
    - template: jinja
    - contents:
      - {{pillar.salt_provision.address}} salt
      - {{target}} target

/etc/dnsmasq.d/{{pillar.salt_provision.interface}}:
  file.managed:
    - source: salt://salt/provision_dnsmasq.conf
    - template: jinja
    - contents:
      - interface={{pillar.salt_provision.interface}}
      - dhcp-range={{pillar.salt_provision.dhcp_start}},{{pillar.salt_provision.dhcp_end}},{{pillar.salt_provision.dhcp_lease}}
      - no-hosts
      - addn-hosts=/etc/network/hosts-{{pillar.salt_provision.interface}}

ssh_config:
  file.managed:
    - name: /home/pi/.ssh/config
    - user: pi
    - group: pi
    - mode: 600
    - makedirs: True
    - contents:
      - Host: target
      - "  User: pi"

provision_ssh_id:
  file.managed:
    - name: /home/pi/.ssh/id_provision
    - user: pi
    - group: pi
    - mode: 600
    - makedirs: True
    - contents:
      - {{pillar.salt_provision.ssh_secret_key}}

provision_ssh_pub:
  file.managed:
    - name: /home/pi/.ssh/id_provision.pub
    - user: pi
    - group: pi
    - mode: 644
    - makedirs: True
    - contents:
      - {{pillar.salt_provision.ssh_public_key}}

salt_provision_repo:
  git.latest:
    - name: {{pillar.salt_provision.repo}}
    - target: /home/pi/salt
    - submodules: True
    - identity: {{pillar.salt_provision.git_secret_key}}
    - user: pi

salt_provision_symlink:
  file.symlink:
    - name: /srv
    - target: /home/pi/salt/srv

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
