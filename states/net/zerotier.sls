zerotier-one:
  pkgrepo.managed:
    - humanname: ZeroTier Repo
    - name: deb {{pillar.zerotier.apt_repo_path}} {{pillar.zerotier.dist_codename}} main
    - key_url: https://download.zerotier.com/contact%40zerotier.com.gpg
    - file: /etc/apt/sources.list.d/zerotier.list
  pkg:
    - installed
    - require:
      - pkgrepo: zerotier-one
  cmd.run:
    - name: zerotier-cli join {{pillar.zerotier.network}}
    - unless: zerotier-cli listnetworks | grep {{pillar.zerotier.network}}
    - require:
      - pkg: zerotier-one
      


  
