
accelerando:
  user.present:
    - usergroup: true
    - shell: /bin/bash
    - groups:
      - adm
      - dialout
      - cdrom
      - sudo
      - audio
      - video
      - plugdev
      - games
      - users
      - input
      - netdev
{% if grains.os == 'Raspbian' %}
      - spi
      - i2c
      - gpio
{% endif %}
