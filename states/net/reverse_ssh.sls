{% set idfile = "id_"+grains.id %}
{% if pillar.reverse_ssh is defined and pillar.reverse_ssh.user is defined %}
{% set reverse_ssh_user = pillar.reverse_ssh.user %}
{% elif grains.reverse_ssh_user is defined %}
{% set reverse_ssh_user = grains.reverse_ssh_user %}
{% elif grains.os == "Raspbian" %}
{% set reverse_ssh_user = "pi" %}
{% else %}
{% set reverse_ssh_user = "accelerando" %}
{% endif %}

{% if pillar.reverse_ssh is defined and pillar.reverse_ssh.jumphost is defined %}
{% set jumphost = pillar.reverse_ssh.jumphost %}
{% elif grains.reverse_ssh_jumphost is defined %}
{% set jumphost = grains.reverse_ssh_jumphost %}
{% else %}
{% set jumphost = "salt.accelerando.io" %}
{% endif %}

/home/{{reverse_ssh_user}}/.ssh/id_rsa:
  file.managed:
    - source: salt://credentials/minion-ssh-up/{{idfile}}_up
    - user: {{reverse_ssh_user}}
    - group: {{reverse_ssh_user}}
    - mode: 600

/home/{{reverse_ssh_user}}/.ssh/id_rsa.pub:
  file.managed:
    - source: salt://credentials/minion-ssh-up/{{idfile}}_up.pub
    - user: {{reverse_ssh_user}}
    - group: {{reverse_ssh_user}}
    - mode: 600

/home/{{reverse_ssh_user}}/.ssh/authorized_keys:
  file.append:
    - source: salt://credentials/minion-ssh-down/{{idfile}}_down.pub
    - makedirs: True

{{jumphost}}:
  ssh_known_hosts:
    - present
    - user: {{reverse_ssh_user}}



  
