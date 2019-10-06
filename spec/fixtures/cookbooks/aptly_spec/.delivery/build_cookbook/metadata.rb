name 'build_cookbook'
maintainer 'Test Cookbook'
maintainer_email 'no-reply@example.com'
license 'apachev2'
version '0.1.0'
chef_version '>= 12.14' if respond_to?(:chef_version)

depends 'delivery-truck'
