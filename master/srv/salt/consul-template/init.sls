/usr/lib/systemd/system/consul-template.service:
  file.managed:
    - source: salt://consul-template/conf/consul-template.service

/etc/consul-template:
  file.recurse:
    - source: salt://consul-template/templates
    - makedirs: True

/usr/share/consul-template_0.12.0:
  archive.extracted:
    - source: https://releases.hashicorp.com/consul-template/0.12.0/consul-template_0.12.0_linux_amd64.zip
    - source_hash: sha256=1fff23fa44fd0af0cb56f011a911af1e9d407a2eeb360f520a503d2f330fdf43
    - archive_format: zip
    - if_missing: /usr/share/consul-template_0.12.0/consul-template

/usr/bin/consul-template:
  file.managed:
    - source: /usr/share/consul-template_0.12.0/consul-template
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
