embedded-deps:
  pkg.installed:
    - pkgs:
      - gkermit
      - emacs-nox
      - i2c-tools
      - pi-bluetooth
      - libhidapi-hidraw0
      - libhidapi-dev
      - libusb-dev
      - bluez
      - python3-hidapi
      - python3-bluez
      - wiringpi

embedded-python:
  pip.installed:
    - bin_env: '/usr/bin/pip3'
    - pkgs:
      - esptool

