# frozen_string_literal: true
#
# Cookbook:: aptly
# Resource:: mirror
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

provides :aptly_mirror
unified_mode true
use '_partial/_common'

property :mirror_name,             String, name_property: true
property :component,               String, default: ''
property :distribution,            String, default: ''
property :uri,                     String, default: ''
property :keyid,                   String, default: ''
property :keyserver,               String, default: 'keys.gnupg.net'
property :cookbook,                String, default: ''
property :keyfile,                 String, default: ''
property :filter,                  String, default: ''
property :filter_with_deps,        [true, false], default: false
property :dep_follow_all_variants, [true, false], default: false
property :dep_follow_recommends,   [true, false], default: false
property :dep_follow_source,       [true, false], default: false
property :dep_follow_suggests,     [true, false], default: false
property :dep_verbose_resolve,     [true, false], default: false
property :architectures,           Array, default: []
property :ignore_checksums,        [true, false], default: false
property :ignore_signatures,       [true, false], default: false
property :with_installer,          [true, false], default: false
property :with_udebs,              [true, false], default: false
property :download_limit,          Integer, default: 0
property :max_tries,               Integer, default: 1
property :skip_existing_packages,  [true, false], default: false
property :timeout,                 Integer, default: 3600

load_current_value do |desired|
  if mirror_exists?(desired.mirror_name)
    # import the current config into the info hash
    info = mirror_info(desired.mirror_name)
    return if info.nil?
    # architectures defaults to the set in the Release file when empty, so if
    # the provided value is empty, then disregard loading the current value
    architectures desired.architectures.empty? ? desired.architectures : info['architectures']
    component info['components']
    distribution info['distribution']
    uri info['archive_root_url']
    component info['components']
    filter info['filter']
    filter_with_deps info['filter_with_deps']
    # ignoring these values because we cannot discover them or they're irrelevant
    keyid desired.keyid
    keyserver desired.keyserver
    ignore_checksums desired.ignore_checksums
    ignore_signatures desired.ignore_signatures
    dep_follow_all_variants desired.dep_follow_all_variants
    dep_follow_recommends desired.dep_follow_recommends
    dep_follow_source desired.dep_follow_source
    dep_follow_suggests desired.dep_follow_suggests
    dep_verbose_resolve desired.dep_verbose_resolve
  end
end

action :create do
  if !new_resource.cookbook.empty? && !new_resource.keyfile.empty?
    install_local_key(new_resource.keyfile, new_resource.cookbook)
  elsif !new_resource.keyid.empty?
    install_key(new_resource.keyid, new_resource.keyserver)
  end

  platform_keyring = "/usr/share/keyrings/#{node['platform']}-archive-keyring.gpg"
  trusted_keyring = "#{new_resource.root_dir}/.gnupg/trustedkeys.gpg"
  platform_keyring_marker = "#{new_resource.root_dir}/.platform_keyring_imported"

  execute 'Import system platform keyring' do
    command "gpg --no-default-keyring --keyring #{Shellwords.escape(platform_keyring)} --export | gpg --no-default-keyring --keyring #{Shellwords.escape(trusted_keyring)} --import && touch #{Shellwords.escape(platform_keyring_marker)}"
    user new_resource.user
    group new_resource.group
    retries 2
    environment resource_env
    not_if { ::File.exist?(platform_keyring_marker) }
  end

  converge_if_changed do
    execute "Creating mirror - #{new_resource.mirror_name}" do
      command mirror_command(new_resource)
      user new_resource.user
      group new_resource.group
      environment resource_env
      returns [0, 2]
    end
  end
end

action :update do
  execute "Updating mirror - #{new_resource.mirror_name}" do
    command mirror_update_command(new_resource)
    user new_resource.user
    group new_resource.group
    environment resource_env
    timeout new_resource.timeout
    returns [0, 2]
    only_if { mirror_exists?(new_resource.mirror_name, new_resource) }
  end
end

action :drop do
  execute "Droping mirror - #{new_resource.mirror_name}" do
    command mirror_drop_command(new_resource)
    user new_resource.user
    group new_resource.group
    environment resource_env
    only_if { mirror_exists?(new_resource.mirror_name, new_resource) }
  end
end

action_class do
  def resource_env
    { 'HOME' => new_resource.root_dir, 'USER' => new_resource.user, 'TMPDIR' => new_resource.tmp_dir }
  end

  def install_key(keyid, keyserver)
    package 'dirmngr'

    directory "#{new_resource.root_dir}/.gnupg" do
      owner new_resource.user
      group new_resource.group
      mode '0700'
      recursive true
    end

    execute "Import GPG key #{keyid}" do
      trusted_keyring = "#{new_resource.root_dir}/.gnupg/trustedkeys.gpg"
      command Shellwords.join(['gpg', '--no-default-keyring', '--keyring', trusted_keyring, '--keyserver', keyserver_uri(keyserver), '--recv-keys', keyid])
      user new_resource.user
      group new_resource.group
      environment resource_env
      not_if { gpg_key_imported?(trusted_keyring, keyid) }
    end
  end

  def keyserver_uri(keyserver)
    keyserver.match?(%r{^[a-z][a-z0-9+\-.]*://}i) ? keyserver : "hkp://#{keyserver}"
  end

  def install_local_key(keyfile, cb)
    cookbook_file "#{Chef::Config['file_cache_path']}/#{keyfile}" do
      cookbook cb
      action :create_if_missing
    end

    directory "#{new_resource.root_dir}/.gnupg" do
      owner new_resource.user
      group new_resource.group
      mode '0700'
      recursive true
    end

    execute "Import GPG key from #{keyfile}" do
      command Shellwords.join(['gpg', '--no-default-keyring', '--keyring', "#{new_resource.root_dir}/.gnupg/trustedkeys.gpg", '--import', "#{Chef::Config['file_cache_path']}/#{keyfile}"])
      user new_resource.user
      group new_resource.group
      environment resource_env
      creates "#{new_resource.root_dir}/.#{keyfile}_imported"
    end

    file "#{new_resource.root_dir}/.#{keyfile}_imported" do
      owner new_resource.user
      group new_resource.group
      action :create
    end
  end

  def gpg_key_imported?(trusted_keyring, keyid)
    cmd = shell_out(Shellwords.join(['gpg', '--no-default-keyring', '--keyring', trusted_keyring, '--list-keys', keyid]),
      user: new_resource.user,
      environment: resource_env)
    cmd.exitstatus == 0
  end
end
