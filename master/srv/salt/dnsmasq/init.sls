dnsmasq:
  pkg.installed:
    - name: dnsmasq
  service.dead:
    - enable: False

/etc/NetworkManager/conf.d/10-dnsmasq.conf:
  file.managed:
    - source: salt://dnsmasq/conf/networkmanager-dnsmasq.conf

/etc/NetworkManager/dnsmasq.d/consul.conf:
  file.managed:
    - source: salt://dnsmasq/conf/dnsmasq-consul.conf

NetworkManager:
  service.running:
    - reload: False
    - watch:
      - file: /etc/NetworkManager/conf.d/10-dnsmasq.conf
      - file: /etc/NetworkManager/dnsmasq.d/consul.conf
