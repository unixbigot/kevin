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

