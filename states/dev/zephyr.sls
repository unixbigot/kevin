zephyr-deps:
  pkg.installed:
    - pkgs:
      - git
      - cmake
      - ninja-build
      - gperf 
      - ccache
      - dfu-util
      - device-tree-compiler
      - wget
      - python3-dev
      - python3-pip
      - python3-setuptools
      - python3-tk
      - python3-wheel
      - xz-utils
      - file
      - make
      - gcc
{%if grains.osarch=="arm64" and grains.os=="Ubuntu" %}
      - gcc-multilib-arm-linux-gnueabihf
      - g++-multilib-arm-linux-gnueabihf
{%else%}
      - gcc-multilib
      - g++-multilib
{%endif%}
      - libsdl2-dev

zephyr-west:
  pip.installed:
    - bin_env: '/usr/bin/pip3'
    - pkgs:
      - west
      - imgtool

gnuarm-embedded:
  archive.extracted:
    - name: /usr/local/gnuarmemb
    - source: https://developer.arm.com/-/media/Files/downloads/gnu-rm/9-2020q2/gcc-arm-none-eabi-9-2020-q2-update-aarch64-linux.tar.bz2
    - options: --strip-components=1
    - source_hash: 000b0888cbe7b171e2225b29be1c327c
    - enforce_toplevel: False
  file.managed:
    - name: /etc/profile.d/zephyr.sh
    - user: root
    - group: root
    - mode: 644
    - contents:
      - export ZEPHYR_TOOLCHAIN_VARIANT=gnuarmemb
      - export GNUARMEMB_TOOLCHAIN_PATH=/usr/local/gnuarmemb/
      - export PATH=${HOME}/.local/bin:${PATH}

{% if grains.zephyr.user is defined %}
{% set zephyr_user = grains.zephyr.user %}
{% elif pillar.zephyr.user is defined %}
{% set zephyr_user = pillar.zephyr.user %}
{% else %}
{% set zephyr_user = ubuntu %}
{% endif %}

{% if grains.zephyr.dir is defined %}
{% set zephyr_dir = grains.zephyr.dir %}
{% elif pillar.zephyr.dir is defined %}
{% set zephyr_dir = pillar.zephyr.dir %}
{% else %}
{% set zephyr_dir = zephyrproject %}
{% endif %}

zephyrproject:
  cmd.run:
    - cd: /home/{{zephyr_user}}
    - runas: {{zephyr_user}}
    - creates: /home/{{zephyr_user}}/{{zephyr_dir}}
    - name west init {{zephyr_dir}} && cd {{zephyr_dir}} && west update && west zephyr-export && pip3 install --user -r zephyr/scripts/requirements.txt

