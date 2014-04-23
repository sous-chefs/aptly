name             'aptly'
maintainer       'Heavy Water Operations, LLC'
maintainer_email 'aaron@hw-ops.com'
license          'Apache 2.0'
description      'Installs/Configures aptly'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          '0.1.0'

supports "ubuntu"
supports "debian"

depends "apt"
