name             'aptly'
maintainer       'Heavy Water Operations, LLC'
maintainer_email 'aaronb@heavywater.io'
license          'Apache-2.0'
description      'Installs/Configures aptly'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          '0.2.9'

supports 'ubuntu'
supports 'debian'

depends 'apt'

source_url 'https://github.com/hw-cookbooks/aptly' if respond_to?(:source_url)
issues_url 'https://github.com/hw-cookbooks/aptly/issues' if respond_to?(:issues_url)
chef_version '>= 11' if respond_to?(:chef_version)
