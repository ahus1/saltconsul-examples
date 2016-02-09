# tag::consul[]
{% set consul_version = '0.6.3' %}

/usr/share/consul_{{ consul_version }}:
  archive.extracted:
    - source: https://releases.hashicorp.com/consul/{{ consul_version }}/consul_{{ consul_version }}_linux_amd64.zip
    - source_hash: sha256=b0532c61fec4a4f6d130c893fd8954ec007a6ad93effbe283a39224ed237e250
    - archive_format: zip
    - if_missing: /usr/share/consul_{{ consul_version }}/consul

/usr/share/consul_web_ui_{{ consul_version }}:
  archive.extracted:
    - source: https://releases.hashicorp.com/consul/{{ consul_version }}/consul_{{ consul_version }}_web_ui.zip
    - source_hash: sha256=93bbb300cacfe8de90fb3bd5ede7d37ae6ce014898edc520b9c96a676b2bbb72
    - archive_format: zip
    - if_missing: /usr/share/consul_web_ui_{{ consul_version }}/index.html

/usr/bin/consul:
  file.managed:
    - source: /usr/share/consul_{{ consul_version }}/consul
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
    - template: jinja
    - defaults:
        consul_version: {{ consul_version }}
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
