base:
  '*':
    - salt.minion
    - os.timezone
    - os.locale
    - os.keyboard
    - os.essential
    - net.zerotier
  roles:pamela:
    - match: grain
    - os.docker
    - net.zerotier
    - iot.pamela
  roles:nodered:
    - match: grain
    - dev.nodejs
    - iot.nodered
  roles:broker:
    - match: grain
    - mqtt.broker
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

