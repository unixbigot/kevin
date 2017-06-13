#!/bin/bash
wget -N -i - <<EOF
https://downloads.arduino.cc/arduino-1.8.3-linux64.tar.xz
https://downloads.arduino.cc/arduino-1.8.3-linuxarm.tar.xz
https://storage.googleapis.com/golang/go1.8.3.linux-amd64.tar.gz
https://storage.googleapis.com/golang/go1.8.3.linux-armv6l.tar.gz
https://nodejs.org/dist/v6.9.5/node-v6.9.5-linux-armv7l.tar.xz
https://nodejs.org/dist/v6.9.5/node-v6.9.5-linux-x64.tar.xz
EOF
sha256sum *z >checksums.txt
