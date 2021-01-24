pyocd-deps:
  pkg.installed:
    - pkgs:
      - python3
      - cargo
      - openocd
      - libusb-dev

pyocd:
  pip.installed:
    - bin_env: '/usr/bin/pip3'
    - pkgs:
      - pyocd
