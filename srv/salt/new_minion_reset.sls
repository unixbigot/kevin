#
# Once a minion has been provisioned from a provisioning station
# using provision.sh, erase the temporary configuration that
# made the new minion use the provisioning station as its master.
#
new_minion_reset_options:
  file.replace:
    - name: /etc/salt/minion.d/options.conf
    - pattern: "master: {{pillar.salt_provision.master_host}}"
    - repl: "master: {{pillar.salt_minion.master_host}}"

new_minion_reset_grain:
  grains.absent:
    - name: new_minion

new_minion_reset_key:
  file.absent:
    - name: /etc/salt/pki/minion/minion_master.pub




