versions:
{% if grains['cpuarch'] == 'armv6l' %}
  # RasPi v2,v3, OrangePi etc.
  arduino: 1.8.1-linuxarm
  nodejs: v6.9.5-linux-armv6l
  golang: 1.8.3.linux-armv6l
{% elif grains['osarch'] == 'armhf' %}    
  # RasPi v1
  arduino: 1.8.1-linuxarm
  nodejs: v6.9.5-linux-armv7l
  golang: 1.8.3.linux-armv6l
{% elif grains['osarch'] == 'arm64' %}    
  # Orange Pi Prime
  arduino: 1.8.1-linuxarm
  nodejs: v10.5.0-linux-arm64
  golang: 1.10.3.linux-arm64
{% else %}
  arduino: 1.8.5-linux64
  nodejs: v6.9.5-linux-x64
  golang: 1.8.3.linux-amd64
{% endif %}
