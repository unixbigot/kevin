/etc/X11/Xsession.d/98-noscreensaver:
  file.managed:
    - contents:
      - xset s off
      - xset -dpms
      - xset s noblank
