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
    - os.docker
  roles:embedded:
    - dev.embedded
    - dev.pyocd
    - dev.jaylink
    - dev.zephyr
  roles:video:
    - dev.video
  roles:provisioning:
    - match: grain
    - salt.provision_master
  roles:accelerando:
    - match: grain
    - iot.accelerando
  roles:pamela:
    - match: grain
    - iot.accelerando
    - os.docker
    - os.noscreensaver
    - dev.nodejs
    - dev.golang 
    - iot.pamela
    - net.rsyslog-udp
    #- net.wvdial-m2m
    #- net.hostapd
    #- net.static_interfaces
    #- net.dhcp_server
    - net.nat_router
  roles:iotlab:
    - match: grain
    - os.docker
  roles:pamelapi:
    - match: grain
    - iot.accelerando
    - os.docker
    - dev.nodejs
    - dev.golang 
  roles:pamelatv:
    - match: grain
    - iot.accelerando
    - dev.nodejs
    - iot.livecam
    #- iot.magicmirror
  roles:pamelacam:
    - match: grain
    - iot.accelerando
    - iot.mjpg-streamer
  roles:btconsole:
    - match: grain
    - os.btconsole
  thermosphere-cloud:
    - os.docker
    - dev.golang
  roles:pikiosk:
    - match: grain
    - os.btconsole
    - os.rootxhost
    - os.noscreensver
    - os.avoidwarnings
  piano:
    - os.btconsole
    - iot.regonsite
  picard:
    - os.btconsole
    - net.hostapd
    - os.docker
    - iot.thermosphere

