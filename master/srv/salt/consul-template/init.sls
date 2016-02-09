{% set consul_template_version = '0.12.2' %}

/usr/lib/systemd/system/consul-template.service:
  file.managed:
    - source: salt://consul-template/conf/consul-template.service

/etc/consul-template:
  file.recurse:
    - source: salt://consul-template/templates
    - makedirs: True

/usr/share/consul-template_{{ consul_template_version }}:
  archive.extracted:
    - source: https://releases.hashicorp.com/consul-template/{{ consul_template_version }}/consul-template_{{ consul_template_version }}_linux_amd64.zip
    - source_hash: sha256=a8780f365bf5bfad47272e4682636084a7475ce74b336cdca87c48a06dd8a193
    - archive_format: zip
    - if_missing: /usr/share/consul-template_{{ consul_template_version }}/consul-template

/usr/bin/consul-template:
  file.managed:
    - source: /usr/share/consul-template_{{ consul_template_version }}/consul-template
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
