magicmirror-prereqs:
  pkg.installed:
    - pkgs:
      - mosquitto-clients
      - xfce4
      - lightdm
      - chromium-browser
      - git
      - openssh-server
      - net-tools
      - ffmpeg
  npm.installed:
    - pkgs:
      - jsmpeg
      - node-rtsp-stream-es6