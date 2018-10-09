name 'aptly'
maintainer 'Heavy Water Operations, LLC'
maintainer_email 'aaronb@heavywater.io'
license 'Apache-2.0'
description 'Installs/Configures aptly'
long_description 'Installs/Configures aptly'
version '0.4.0'
chef_version '>= 12.14' if respond_to?(:chef_version)

supports 'ubuntu'
supports 'debian'

issues_url 'https://github.com/sous-chef/aptly/issues'
source_url 'https://github.com/sous-chef/aptly'
