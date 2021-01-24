/home/accelerando/.awsrc:
  file.managed:
    - source: salt://net/aws_route_53.conf
    - template: jinja
    - context:
        accessKeyId: {{pillar.route53.accessKeyId}}
        secretAccessKey: {{pillar.route53.secretAccessKey}}
    - user: accelerando
    - group: accelerando
