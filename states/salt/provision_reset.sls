#
# Once a minion has been provisioned from a provisioning station
# using provision.sh, erase the temporary configuration that
# made the new minion use the provisioning station as its master.
#
reset-grains:
  grains.list_absent:
    - name: roles
    - value: provision_minion

reset-master-key:
  file.absent:
    - name: /etc/salt/pki/minion/minion_master.pub

reset-minion-config:
  file.replace:
    - name: /etc/salt/minion.d/local.conf
    - pattern: "master: {{pillar.salt_minion.provision_host}}"
    - repl: "master: {{pillar.salt_minion.master_host}}"



