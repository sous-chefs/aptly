default['aptly']['uri'] = 'http://repo.aptly.info/'
default['aptly']['dist'] = "squeeze"
default['aptly']['components'] = ['main']
default['aptly']['keyserver'] = 'keys.gnupg.net'
default['aptly']['key'] = '2A194991'

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

default["aptly"]["public"]["fqdn"] = "#{node['fqdn']}"
default["aptly"]["public"]["dir"] = "#{node['aptly']['rootdir']}/public"
default["aptly"]["public"]["key"] = "#{node["aptly"]["public"]["dir"]}/repo.key"

default['aptly']['api']['port'] = 8080

default["aptly"]["repos"]["databag"] = "aptly_repos"
