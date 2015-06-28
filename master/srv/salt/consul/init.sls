# tag::consul[]
consul:
  pkg.installed:
    - sources:
      - consul: salt://consul/rpm/consul-0.5.2-1.el7.centos.x86_64.rpm
      - consul-ui: salt://consul/rpm/consul-ui-0.5.2-1.el7.centos.x86_64.rpm
  service.running:
    - enable: True
# don't use reload here as not all configuration elements can be reloaded
# and a non-working configuration will not be reloaded
#    - reload: True
    - watch:
      - pkg: consul

/etc/consul/consul-ui-service.json:
  file.managed:
    - source: salt://consul/conf/consul-ui-service.json
    - watch_in:
      - service: consul

/etc/consul/common.json:
  file.managed:
    - template: jinja
    - source: salt://consul/conf/common.json
    - watch_in:
      - service: consul
# end::consul[]

bind-utils:
  pkg.installed

/etc/consul/encrypt.json:
  file.managed:
    - source: salt://consul/conf/encrypt.json
    - watch_in:
      - service: consul
