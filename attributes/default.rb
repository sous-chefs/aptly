default['aptly']['uri'] = 'http://repo.aptly.info/'
default['aptly']['dist'] = "squeeze"
default['aptly']['components'] = ['main']
default['aptly']['keyserver'] = 'keys.gnupg.net'
default['aptly']['key'] = '9E3E53F19C7DE460'

default['aptly']['tarball']['uri'] =
  'https://bintray.com/artifact/download/smira/aptly/' \
  'aptly_0.9.7_linux_amd64.tar.gz'

default['aptly']['tarball']['checksum'] =
  'ec877942783c7a24566c802120da51d4cecaf2c76d3151e1a4869da1ee0690f7'

default['aptly']['tarball']['version'] =
  begin
    require 'uri'
    filename =
      ::File.basename(URI.parse(node['aptly']['tarball']['uri']).path)
    /aptly_(.+?)_/.match(filename)[1]
  rescue
    1
  end

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
