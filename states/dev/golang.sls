extract_golang:
  archive.extracted:
    - name: /usr/local/go
    - source: salt://src/distfiles/go{{pillar.versions.golang}}.tar.gz
    - options: --strip-components=1
    - enforce_toplevel: False
  file.managed:
    - name: /etc/profile.d/golang.sh
    - source: salt://dev/golang-profile.sh
