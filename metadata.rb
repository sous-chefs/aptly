name             'aptly'
maintainer       'Sous Chefs'
maintainer_email 'help@sous-chefs.org'
license          'Apache-2.0'
description      'Installs/Configures aptly'
long_description 'Installs/Configures aptly'
version          '1.2.0'
chef_version     '>= 13.0' if respond_to?(:chef_version)

supports 'ubuntu'
supports 'debian'

issues_url 'https://github.com/sous-chefs/aptly/issues'
source_url 'https://github.com/sous-chefs/aptly'
