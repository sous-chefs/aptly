# frozen_string_literal: true
#
# Cookbook:: aptly
# Resource:: publish
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

property :publish_name,  String, name_property: true
property :type,          String, default: ''
property :endpoint,      String, default: ''
property :component,     Array, default: []
property :architectures, Array, default: ['amd64']
property :prefix,        String, default: ''
property :distribution,  String, default: ''
property :timeout,       Integer, default: 3600

action :create do
  components = new_resource.component.join(',')
  architectures = new_resource.architectures.join(',')
  endpoint = new_resource.endpoint.empty? ? '' : "#{new_resource.endpoint}:"

  execute "Publish #{new_resource.type} - #{new_resource.publish_name}" do
    command "aptly publish #{new_resource.type} -batch -passphrase='#{node['aptly']['gpg']['passphrase']}' -component='#{components}' -architectures='#{architectures}' -distribution='#{new_resource.distribution}' -- #{new_resource.publish_name} #{endpoint}#{new_resource.prefix}"
    user node['aptly']['user']
    group node['aptly']['group']
    environment aptly_env
    sensitive true
    timeout new_resource.timeout
    not_if %(aptly publish list | grep #{new_resource.publish_name})
  end
end

action :update do
  endpoint = new_resource.endpoint.empty? ? '' : "#{new_resource.endpoint}:"
  execute "Updating distribution - #{new_resource.prefix} #{new_resource.publish_name}" do
    command "aptly publish update -batch -passphrase='#{node['aptly']['gpg']['passphrase']}' #{new_resource.publish_name} #{endpoint}#{new_resource.prefix}"
    user node['aptly']['user']
    group node['aptly']['group']
    environment aptly_env
    timeout new_resource.timeout
  end
end

action :drop do
  endpoint = new_resource.endpoint.empty? ? '' : "#{new_resource.endpoint}:"
  prefix = new_resource.prefix.empty? ? './' : "#{new_resource.prefix}/"

  execute "Stop publishing - #{prefix}#{new_resource.publish_name}" do
    command "aptly publish drop #{new_resource.publish_name} #{endpoint}#{new_resource.prefix}"
    user node['aptly']['user']
    group node['aptly']['group']
    environment aptly_env
    timeout new_resource.timeout
    only_if %(aptly publish list | grep #{new_resource.publish_name})
  end
end
