# tag::websetup[]
# install the web server package
httpd:
  pkg.installed:
    - name: httpd
  service.running:
    - enable: true

/var/www/html/index.html:
  file.managed:
    - template: jinja
    - source: salt://web/conf/index.html
/var/www/html/index.json:
  file.managed:
    - template: jinja
    - source: salt://web/conf/index.json
# end::websetup[]

# tag::consul[]
/etc/consul/httpd.json:
  file.managed:
    - source: salt://web/conf/httpd.json
    - watch_in:
      - service: consul
# end::consul[]
