# tag::saltintro[]
# install a package with the same name as the state
salt-cloud:
  pkg.installed

# install a file with the same name as the state
/root/.ssh/id_rsa:
  file.managed:
    - makedirs: True
    - source: salt://cloud/conf/id_rsa
    - mode: 600

/root/.ssh/id_rsa.pub:
  file.managed:
    - makedirs: True
    - source: salt://cloud/conf/id_rsa.pub
    - mode: 600

# end::saltintro[]
/etc/salt/cloud.conf.d/cloud.conf:
  file.managed:
    - source: salt://cloud/conf/cloud.conf

/etc/salt/cloud.providers.d/saltify.conf:
  file.managed:
    - source: salt://cloud/conf/saltify.conf

/etc/salt/cloud.profiles.d/centos-saltify.conf:
  file.managed:
    - source: salt://cloud/conf/centos-saltify.conf
# tag::saltintro[]

/etc/salt/cloud.providers.d/digitalocean.conf:
  file.managed:
    - source: salt://cloud/conf/digitalocean.conf
    - template: jinja

/etc/salt/cloud.profiles.d/centos-digitalocean.conf:
  file.managed:
    - source: salt://cloud/conf/centos-digitalocean.conf

# run a command, but only if the file doesn't exist yet
bootstrap:
  cmd.run:
    - name: curl -L https://bootstrap.saltstack.com -o /etc/salt/cloud.deploy.d/bootstrap-salt.sh
    - creates: /etc/salt/cloud.deploy.d/bootstrap-salt.sh
# end::saltintro[]

# salt-cloud requires latest python library requests to support SNI to run salt-cloud -u
# https://stackoverflow.com/questions/18578439/using-requests-with-tls-doesnt-give-sni-support/18579484#18579484

#python-pip:
#  pkg.installed
#
#python-ndg_httpsclient:
#  pkg.installed

#requests:
#  pip.installed:
#    - name: requests == 2.7.0
#    - require:
#      - pkg: python-pip
#      - pkg: python-ndg_httpsclient

