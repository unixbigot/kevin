#
# Remove stale debian nodejs and install latest tarball
#
install-nodejs:
  pkg.removed:
    - pkgs:
      - nodejs
      - nodejs-legacy
  file.directory:
    - name: /usr/local/node
  archive.extracted:
    - name: /usr/local/node
    - source: salt://src/distfiles/node-{{pillar.versions.nodejs}}.tar.xz
    - options: --strip-components=1
    - archive_format: tar
    - enforce_toplevel: False

nodejs-profile:
  file.managed:
    - name: /etc/profile.d/nodejs.sh
    - source: salt://dev/nodejs-profile.sh
    - user: root
    - group: root
    - mode: 644
    
nodejs-symlink:
  file.symlink:
    - name:   /usr/local/bin/node
    - target: /usr/local/node/bin/node
    
npm-symlink:    
  file.symlink:
    - name:   /usr/local/bin/npm
    - target: /usr/local/node/bin/npm
    
