miflora-prereqs:
  pkg.installed:
    - pkgs:
      - libbluetooth-dev
      - libglib2.0-dev
      - libboost-thread-dev
      - libboost-python-dev
    
miflora-python:
  pip.installed:
    - bin_env: '/usr/bin/pip3'
    - pkgs:
      - bluepy
      - miflora

miflora-script:
  file.managed:
    - name: /usr/local/bin/miflora-client.py
    - source: salt://iot/miflora-client.py
    - mode: 755
  cmd.run:
    - name: /usr/local/bin/miflora-client.py setup
    - onchanges:
      - file: wvdial-config

