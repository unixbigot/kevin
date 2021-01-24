/etc/X11/Xsession.d/95-xhostroot:
  file.managed:
    - contents:
      - xhost +si:localuser:root
