unified_mode true
use 'partial/_user'
use 'partial/_root_dir'

property :publish_name,   String, name_property: true
property :type,           String, default: ''
property :endpoint,       String, default: ''
property :component,      Array, default: []
property :architectures,  Array, default: []
property :prefix,         String, default: ''
property :distribution,   String, default: ''
property :timeout,        Integer, default: 3600
property :gpg_passphrase, String
property :gpg_provider,   String, default: 'gpg1'

action :create do
  components = new_resource.component.join(',')
  endpoint = new_resource.endpoint.empty? ? '' : "#{new_resource.endpoint}:"
  # -batch
  cmd = "aptly publish #{new_resource.type}"
  # cmd << " -passphrase='#{new_resource.gpg_passphrase}'" unless new_resource.gpg_passphrase.nil?
  cmd << " -component='#{components}'" unless new_resource.component.empty?
  cmd << " -architectures #{architectures.join(',')}" unless new_resource.architectures.empty?
  cmd << " -distribution='#{new_resource.distribution}'"
  cmd << " -gpg-provider='#{new_resource.gpg_provider}'"
  cmd << " -- #{new_resource.publish_name} #{endpoint}#{new_resource.prefix}"

  execute "Publish #{new_resource.type} - #{new_resource.publish_name}" do
    command cmd
    user new_resource.user
    group new_resource.group
    environment aptly_env(new_resource)
    sensitive false
    timeout new_resource.timeout
    not_if %(aptly publish list | grep #{new_resource.publish_name})
  end
end

action :update do
  endpoint = new_resource.endpoint.empty? ? '' : "#{new_resource.endpoint}:"
  passphrase = new_resource.gpg_passphrase.empty? ? '' : "-passphrase='#{new_resource.gpg_passphrase}'"

  execute "Updating distribution - #{new_resource.prefix} #{new_resource.publish_name}" do
    command "aptly publish update -batch #{passphrase} #{new_resource.publish_name} #{endpoint}#{new_resource.prefix}"
    user new_resource.user
    group new_resource.group
    environment aptly_env(new_resource)
    sensitive true
    timeout new_resource.timeout
  end
end

action :drop do
  endpoint = new_resource.endpoint.empty? ? '' : "#{new_resource.endpoint}:"
  prefix = new_resource.prefix.empty? ? './' : "#{new_resource.prefix}/"

  execute "Stop publishing - #{prefix}#{new_resource.publish_name}" do
    command "aptly publish drop #{new_resource.publish_name} #{endpoint}#{new_resource.prefix}"
    user new_resource.user
    group new_resource.group
    environment aptly_env(new_resource)
    timeout new_resource.timeout
    only_if %(aptly publish list | grep #{new_resource.publish_name})
  end
end
