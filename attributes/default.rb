default['aptly']['uri'] = 'http://repo.aptly.info/'
default['aptly']['dist'] = "squeeze"
default['aptly']['components'] = ['main']
default['aptly']['keyserver'] = 'keys.gnupg.net'
default['aptly']['key'] = '9E3E53F19C7DE460'

default['aptly']['user'] = 'aptly'
default['aptly']['group'] = 'aptly'

default['aptly']['rootdir'] = "/opt/aptly"
default['aptly']['downloadconcurrency'] = 4
default['aptly']['architectures'] = []
default['aptly']['dependencyfollowsuggests'] = false
default['aptly']['dependencyfollowrecommends'] = false
default['aptly']['dependencyfollowallvariants'] = false
default['aptly']['dependencyfollowsource'] = false
default['aptly']['gpgdisablesign'] = false
default['aptly']['gpgdisableverify'] = false
default['aptly']['downloadsourcepackages'] = false
default['aptly']['ppadistributorid'] = ""
default['aptly']['ppacodename'] = ""
default['aptly']['s3publishendpoints'] = {}
default['aptly']['swiftpublishendpoints'] = {}
