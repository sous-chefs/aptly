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
require 'shellwords'

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

  execute "Publish #{new_resource.type} - #{new_resource.publish_name}" do
    command aptly_command('aptly', 'publish', new_resource.type, '-batch', *publish_signing_options, "-component=#{components}", *publish_architecture_options, "-distribution=#{new_resource.distribution}", '--', new_resource.publish_name, publish_endpoint_prefix)
    user new_resource.user
    group new_resource.group
    environment resource_env
    sensitive !new_resource.skip_signing
    timeout new_resource.timeout
    not_if { publish_exists?(new_resource.publish_name) }
  end
end

action :switch do
  execute "Switching distribution - #{new_resource.prefix}/#{new_resource.distribution} #{new_resource.publish_name}" do
    command aptly_command('aptly', 'publish', 'switch', '-batch', *publish_signing_options, publish_component_option, new_resource.distribution, publish_endpoint_prefix, new_resource.publish_name)
    user new_resource.user
    group new_resource.group
    environment resource_env
    sensitive !new_resource.skip_signing
    timeout new_resource.timeout
  end
end

action :update do
  execute "Updating distribution - #{new_resource.prefix} #{new_resource.publish_name}" do
    command aptly_command('aptly', 'publish', 'update', '-batch', *publish_signing_options, new_resource.publish_name, publish_endpoint_prefix)
    user new_resource.user
    group new_resource.group
    environment resource_env
    sensitive !new_resource.skip_signing
    timeout new_resource.timeout
  end
end

action :drop do
  prefix = new_resource.prefix.empty? ? './' : "#{new_resource.prefix}/"

  execute "Stop publishing - #{prefix}#{new_resource.publish_name}" do
    command aptly_command('aptly', 'publish', 'drop', new_resource.publish_name, publish_endpoint_prefix)
    user new_resource.user
    group new_resource.group
    environment resource_env
    timeout new_resource.timeout
    only_if { publish_exists?(new_resource.publish_name) }
  end
end

action_class do
  include ::Aptly::Helpers

  def publish_signing_options
    return ['-skip-signing'] if new_resource.skip_signing

    ["-passphrase=#{new_resource.gpg_passphrase}"]
  end

  def publish_component_option
    return if new_resource.component.empty?

    "-component=#{new_resource.component.join(',')}"
  end

  def publish_architecture_options
    return [] if new_resource.architectures.empty?

    ['-architectures', new_resource.architectures.join(',')]
  end

  def publish_endpoint_prefix
    endpoint = new_resource.endpoint.empty? ? '' : "#{new_resource.endpoint}:"
    "#{endpoint}#{new_resource.prefix}"
  end

  def resource_env
    { 'HOME' => new_resource.root_dir, 'USER' => new_resource.user, 'TMPDIR' => new_resource.tmp_dir }
  end

  def publish_exists?(publish_name)
    cmd = shell_out(aptly_command('aptly', 'publish', 'list'), user: new_resource.user, group: new_resource.group, environment: resource_env)
    cmd.exitstatus == 0 && cmd.stdout.include?(publish_name)
  end
end
