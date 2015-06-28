# install the web server package along with its configuration file
nginx:
  pkg.installed:
    - name: nginx
  file.managed:
    - name: /etc/nginx/nginx.conf
    - source: salt://lb/conf/nginx.conf
    - require:
      - pkg: nginx
    - watch_in:
      - service: nginx
  service.running:
    - enable: true
    - require:
      - file: /etc/consul-template/nginx-consul.conf
      - service: consul-template
      - service: consul

# configure consul-template to keep a file up-to-date with all upstream servers
/etc/consul-template/nginx-consul.conf:
  file.managed:
    - source: salt://lb/conf/nginx-consul.conf
    - watch_in:
      - service: consul-template
    - require:
      - file: nginx
      - file: /etc/nginx/conf.d/upstream.ctmpl

# this is the template file for the upstream servers
/etc/nginx/conf.d/upstream.ctmpl:
  file.managed:
    - source: salt://lb/conf/upstream.ctmpl
    - require:
      - pkg: nginx
    - watch_in:
      - service: consul-template

# add monitoring for nginx in consul
/etc/consul/nginx.json:
  file.managed:
    - source: salt://lb/conf/nginx.json
    - watch_in:
      - service: consul
