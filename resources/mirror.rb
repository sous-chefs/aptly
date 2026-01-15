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
unified_mode true
use '_partials/_common'

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

  execute 'Import system platform keyring' do
    command "gpg --no-default-keyring --keyring /usr/share/keyrings/#{node['platform']}-archive-keyring.gpg --export | gpg --no-default-keyring --keyring #{new_resource.root_dir}/.gnupg/trustedkeys.gpg --import && touch #{new_resource.root_dir}/.platform_keyring_imported"
    user new_resource.user
    group new_resource.group
    retries 2
    environment resource_env
    not_if { ::File.exist?("#{new_resource.root_dir}/.platform_keyring_imported") }
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
    command "aptly mirror update#{dep_follow_all_variants(new_resource.dep_follow_all_variants)}#{dep_follow_recommends(new_resource.dep_follow_recommends)}#{dep_follow_source(new_resource.dep_follow_source)}#{dep_follow_suggests(new_resource.dep_follow_suggests)}#{dep_verbose_resolve(new_resource.dep_verbose_resolve)}#{ignore_checksums(new_resource.ignore_checksums)}#{ignore_signatures(new_resource.ignore_signatures)}#{download_limit(new_resource.download_limit)}#{max_tries(new_resource.max_tries)}#{skip_existing_packages(new_resource.skip_existing_packages)} #{new_resource.mirror_name}"
    user new_resource.user
    group new_resource.group
    environment resource_env
    timeout new_resource.timeout
    returns [0, 2]
    only_if { mirror_exists?(new_resource.mirror_name) }
  end
end

action :drop do
  execute "Droping mirror - #{new_resource.mirror_name}" do
    command "aptly mirror drop #{new_resource.mirror_name}"
    user new_resource.user
    group new_resource.group
    environment resource_env
    only_if { mirror_exists?(new_resource.mirror_name) }
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
      command "gpg --no-default-keyring --keyring #{new_resource.root_dir}/.gnupg/trustedkeys.gpg --keyserver hkp://#{keyserver} --recv-keys #{keyid}"
      user new_resource.user
      group new_resource.group
      environment resource_env
      not_if "gpg --no-default-keyring --keyring #{new_resource.root_dir}/.gnupg/trustedkeys.gpg --list-keys #{keyid}"
    end
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
      command "gpg --no-default-keyring --keyring #{new_resource.root_dir}/.gnupg/trustedkeys.gpg --import #{Chef::Config['file_cache_path']}/#{keyfile}"
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
end
