/usr/lib/systemd/system/consul-template.service:
  file.managed:
    - source: salt://consul-template/conf/consul-template.service

/etc/consul-template:
  file.recurse:
    - source: salt://consul-template/templates
    - makedirs: True

/usr/bin/consul-template:
  file.managed:
    - source: salt://consul-template/bin/consul-template
    - mode: 755
  service.running:
    - enable: True
    - name: consul-template
    - watch:
      - file: /usr/bin/consul-template
      - file: /etc/consul-template
      - file: /usr/lib/systemd/system/consul-template.service
    - require:
      - file: /usr/bin/consul-template
      - file: /etc/consul-template
      - file: /usr/lib/systemd/system/consul-template.service
