base:
  '*':
    - common
    - package-versions
  os_family:Debian:
    - match: grain
    - salt
    - zerotier
  roles:homebridge:
    - match: grain
    - homebridge
