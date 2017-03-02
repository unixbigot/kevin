base:
  '*':
    - salt.minion
    - os.timezone
    - os.locale
    - os.keyboard
    - os.essential
    - net.zerotier
  roles:nodered:
    - match: grain
    - dev.nodejs
    - iot.nodered
  serendipity:
    - dev.golang
  roles:developer:
    - match: grain
    - dev.golang
    - dev.nodejs
  roles:provisioning:
    - match: grain
    - salt.master
    - salt.syndic
    - salt.provisioning_server

