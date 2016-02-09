{% set consul_template_version = '0.12.2' %}

/usr/lib/systemd/system/fabio.service:
  file.managed:
    - source: salt://fabio/conf/fabio.service

/etc/fabio.properties:
  file.managed:
    - source: salt://fabio/conf/fabio.properties

/usr/bin/fabio:
  file.managed:
    - source: https://github.com/eBay/fabio/releases/download/v1.0.8/fabio-1.0.8_linux-amd64
    - source_hash: sha256=e45858c42b3b55bc3614e512d426212a9786c32fbf8d4cbd3f5737f30e3cb74a
    - mode: 755
  service.running:
    - enable: True
    - name: fabio
    - watch:
      - file: /usr/bin/fabio
      - file: /etc/fabio.properties
      - file: /usr/lib/systemd/system/fabio.service
    - require:
      - file: /usr/bin/fabio
      - file: /etc/fabio.properties
      - file: /usr/lib/systemd/system/fabio.service
