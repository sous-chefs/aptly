name 'aptly_test'
maintainer 'The Authors'
maintainer_email 'you@example.com'
license 'Apache-2.0'
description 'Installs/Configures aptly_test'
long_description 'Installs/Configures aptly_test'
version '0.1.0'
chef_version '>= 12.14' if respond_to?(:chef_version)

depends 'aptly'
