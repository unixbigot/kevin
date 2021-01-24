openocd-dir:
  file.directory:
    - name: /opt/openocd
    - user: accelerando
    - makedirs: True

openocd-deps:
  pkg.installed:
    - pkgs:
      - git
      - autoconf
      - libtool
      - make
      - pkg-config
      - libusb-1.0-0
      - libusb-1.0-0-dev

openocd-src:
  git.latest:
    - name: http://openocd.zylin.com/openocd
    - target: /opt/openocd
    - branch: master
    - user: accelerando
    - require:
      - file: openocd-dir
      - pkg: openocd-deps

openocd-bootstrap:
  cmd.run:
    - cwd: /opt/openocd
    - runas: accelerando
    - name: ./bootstrap
    - creates: /opt/openocd/configure
    - require:
      - git: openocd-src

openocd-configure:
  cmd.run:
    - cwd: /opt/openocd
    - runas: accelerando
    - name: ./configure --enable-sysfsgpio --enable-bcm2835gpio
    - creates: /opt/openocd/Makefile
    - require:
      - cmd: openocd-bootstrap
  
openocd-build:
  cmd.run:
    - cwd: /opt/openocd
    - runas: accelerando
    - name: make
    - creates: /opt/openocd/src/openocd
    - require:
      - cmd: openocd-configure

openocd-install:
  cmd.run:
    - cwd: /opt/openocd
    - runas: root
    - name: make install
    - creates: /usr/local/bin/openocd
    - require:
      - cmd: openocd-build
