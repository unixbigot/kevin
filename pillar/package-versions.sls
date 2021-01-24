versions:
{% if grains['cpuarch'] == 'armv6l' %}
  # RasPi v2,v3, OrangePi etc.
  arduino: 1.8.13-linuxarm
  nodejs: v14.15.1-linux-armv7l
  golang: 1.15.5.linux-armv6l
{% elif grains['osarch'] == 'armhf' %}    
  # RasPi v1
  arduino: 1.8.13-linuxarm
  nodejs: v14.15.1-linux-armv7l
  golang: 1.15.5.linux-armv6l
{% elif grains['osarch'] == 'arm64' %}    
  # Orange Pi Prime
  arduino: 1.8.13-linuxaarch64
  nodejs: v14.15.1-linux-arm64
  golang: 1.15.5.linux-arm64
{% else %}
  arduino: 1.8.13-linux64
  nodejs: v14.15.1-linux-x64
  golang: 1.15.5.linux-amd64
{% endif %}
