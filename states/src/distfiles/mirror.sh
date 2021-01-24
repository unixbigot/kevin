#!/bin/bash
wget -N -i - <<EOF
https://downloads.arduino.cc/arduino-1.8.13-linux64.tar.xz
https://downloads.arduino.cc/arduino-1.8.13-linuxarm.tar.xz
https://downloads.arduino.cc/arduino-1.8.13-linuxaarch64.tar.xz
https://dl.google.com/go/go1.15.5.linux-amd64.tar.gz
https://dl.google.com/go/go1.15.5.linux-armv6l.tar.gz
https://dl.google.com/go/go1.15.5.linux-arm64.tar.gz
https://nodejs.org/dist/v14.15.1/node-v14.15.1-linux-x64.tar.xz
https://nodejs.org/dist/v14.15.1/node-v14.15.1-linux-armv7l.tar.xz
https://nodejs.org/dist/v14.15.1/node-v14.15.1-linux-arm64.tar.xz
EOF
sha256sum *z >checksums.txt
