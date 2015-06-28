# tag::mastersetup[]
base:
  'master':
     - cloud
# end::mastersetup[]
# tag::consul[]
  '*':
     - consul
# end::consul[]
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
