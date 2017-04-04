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
  roles:homebridge:
    - match: grain
    - dev.nodejs
    - iot.homebridge
  roles:developer:
    - match: grain
    - dev.golang
    - dev.nodejs
  roles:provisioning:
    - match: grain
    - salt.provision_master

