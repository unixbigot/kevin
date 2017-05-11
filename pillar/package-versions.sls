versions:
{% if grains['cpuarch'] == 'armv6l' %}
  # RasPi v2,v3, OrangePi etc.
  arduino: 1.8.1-linuxarm
  nodejs: v6.9.5-linux-armv6l
  golang: 1.7.5.linux-armv6l
{% elif grains['osarch'] == 'armhf' %}    
  # RasPi v1
  arduino: 1.8.1-linuxarm
  nodejs: v6.9.5-linux-armv7l
  golang: 1.7.5.linux-armv6l
{% else %}
  arduino: 1.8.1-linux64
  nodejs: v6.9.5-linux-x64
  golang: 1.7.5.linux-amd64
{% endif %}
