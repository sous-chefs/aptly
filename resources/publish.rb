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
provides :aptly_publish
unified_mode true
use '_partial/_common'

property :publish_name,   String, name_property: true
property :type,           String, default: ''
property :endpoint,       String, default: ''
property :component,      Array, default: []
property :architectures,  Array, default: []
property :prefix,         String, default: ''
property :distribution,   String, default: ''
property :timeout,        Integer, default: 3600
property :gpg_passphrase, String, default: '', sensitive: true
property :skip_signing,   [true, false], default: false

action :create do
  components = new_resource.component.join(',')
  endpoint = new_resource.endpoint.empty? ? '' : "#{new_resource.endpoint}:"
  signing_options = publish_signing_options

  execute "Publish #{new_resource.type} - #{new_resource.publish_name}" do
    command "aptly publish #{new_resource.type} -batch#{signing_options} -component='#{components}' #{architectures(new_resource.architectures)} -distribution='#{new_resource.distribution}' -- #{new_resource.publish_name} #{endpoint}#{new_resource.prefix}"
    user new_resource.user
    group new_resource.group
    environment resource_env
    sensitive !new_resource.skip_signing
    timeout new_resource.timeout
    not_if %(aptly publish list | grep #{new_resource.publish_name})
  end
end

action :switch do
  endpoint = new_resource.endpoint.empty? ? '' : "#{new_resource.endpoint}:"
  component = new_resource.component.empty? ? '' : "-component=#{new_resource.component.join(',')}"
  signing_options = publish_signing_options
  execute "Switching distribution - #{new_resource.prefix}/#{new_resource.distribution} #{new_resource.publish_name}" do
    command "aptly publish switch -batch#{signing_options} #{component} #{new_resource.distribution} #{endpoint}#{new_resource.prefix} #{new_resource.publish_name}"
    user new_resource.user
    group new_resource.group
    environment resource_env
    sensitive !new_resource.skip_signing
    timeout new_resource.timeout
  end
end

action :update do
  endpoint = new_resource.endpoint.empty? ? '' : "#{new_resource.endpoint}:"
  signing_options = publish_signing_options

  execute "Updating distribution - #{new_resource.prefix} #{new_resource.publish_name}" do
    command "aptly publish update -batch#{signing_options} #{new_resource.publish_name} #{endpoint}#{new_resource.prefix}"
    user new_resource.user
    group new_resource.group
    environment resource_env
    sensitive !new_resource.skip_signing
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
    environment resource_env
    timeout new_resource.timeout
    only_if %(aptly publish list | grep #{new_resource.publish_name})
  end
end

action_class do
  def publish_signing_options
    return ' -skip-signing' if new_resource.skip_signing

    " -passphrase='#{new_resource.gpg_passphrase}'"
  end

  def resource_env
    { 'HOME' => new_resource.root_dir, 'USER' => new_resource.user, 'TMPDIR' => new_resource.tmp_dir }
  end
end
