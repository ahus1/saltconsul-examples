# tag::consul[]
/usr/share/consul_0.6.0:
  archive.extracted:
    - source: https://releases.hashicorp.com/consul/0.6.0/consul_0.6.0_linux_amd64.zip
    - source_hash: sha256=307fa26ae32cb8732aed2b3320ed8daf02c28b50d952cbaae8faf67c79f78847
    - archive_format: zip
    - if_missing: /usr/share/consul_0.6.0/consul

/usr/share/consul_web_ui_0.6.0:
  archive.extracted:
    - source: https://releases.hashicorp.com/consul/0.6.0/consul_0.6.0_web_ui.zip
    - source_hash: sha256=73c5e7ee50bb4a2efe56331d330e6d7dbf46335599c028344ccc4031c0c32eb0
    - archive_format: zip
    - if_missing: /usr/share/consul_web_ui_0.6.0/index.html

/usr/bin/consul:
  file.managed:
    - source: /usr/share/consul_0.6.0/consul
    - mode: 755
    - watch_in:
      - service: consul

/etc/sysconfig/consul:
  file.managed:
    - source: salt://consul/conf/sysconfig-consul
    - watch_in:
      - service: consul

/etc/consul:
  file.directory

/var/lib/consul:
  file.directory:
    - user: consul
    - group: consul
    - recurse:
        - user
        - group
    - require:
       - group: consul
       - user: consul

/etc/consul/consul.json:
  file.managed:
    - source: salt://consul/conf/consul.json
    - watch_in:
      - service: consul

/usr/lib/systemd/system/consul.service:
  file.managed:
    - source: salt://consul/conf/consul.service
    - watch_in:
      - service: consul

/etc/consul/consul-ui-service.json:
  file.managed:
    - source: salt://consul/conf/consul-ui-service.json
    - watch_in:
      - service: consul

/etc/consul/consul-ui.json:
  file.managed:
    - source: salt://consul/conf/consul-ui.json
    - watch_in:
      - service: consul

/etc/consul/common.json:
  file.managed:
    - template: jinja
    - source: salt://consul/conf/common.json
    - watch_in:
      - service: consul

consul:
  group.present: []
  user.present:
    - groups:
      - consul
  service.running:
    - enable: True
# don't use reload here as not all configuration elements can be reloaded
# and a non-working configuration will not be reloaded
#    - reload: True

# end::consul[]

bind-utils:
  pkg.installed

/etc/consul/encrypt.json:
  file.managed:
    - source: salt://consul/conf/encrypt.json
    - watch_in:
      - service: consul
