# tag::mastersetup[]
base:
  'master':
     - cloud
# end::mastersetup[]
# tag::consul[]
  '*':
     - tools
     - consul
# end::consul[]
# tag::dnsmasq[]
     - dnsmasq
# end::dnsmasq[]
# tag::websetup[]
  'web*':
     - web
# end::websetup[]
# tag::consultemplate[]
  'lb*':
     - consul-template
# end::consultemplate[]
# tag::lbsetup[]
     - lb
# end::lbsetup[]
