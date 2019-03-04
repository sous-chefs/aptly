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

property :mirror_name,      String, name_property: true
property :component,        String, default: ''
property :distribution,     String, default: ''
property :uri,              String, default: ''
property :keyid,            String, default: ''
property :keyserver,        String, default: 'keys.gnupg.net'
property :cookbook,         String, default: ''
property :keyfile,          String, default: ''
property :filter,           String, default: ''
property :filter_with_deps, [true, false], default: false
property :architectures,    String, default: ''
property :with_udebs,       [true, false], default: false
property :timeout,          Integer, default: 3600

action :create do
  if !new_resource.cookbook.empty? && !new_resource.keyfile.empty?
    install_local_key(new_resource.keyfile, new_resource.cookbook)
  elsif !new_resource.keyid.empty?
    install_key(new_resource.keyid, new_resource.keyserver)
  end

  execute 'Import system platform keyring' do
    command "#{gpg_command} --no-default-keyring --keyring /usr/share/keyrings/#{node['platform']}-archive-keyring.gpg --export | #{gpg_command} --no-default-keyring --keyring trustedkeys.gpg --import && touch #{node['aptly']['rootDir']}/.platform_keyring_imported"
    user node['aptly']['user']
    group node['aptly']['group']
    retries 2
    environment aptly_env
    not_if { ::File.exist?("#{node['aptly']['rootDir']}/.platform_keyring_imported") }
  end

  execute "Creating mirror - #{new_resource.mirror_name}" do
    command "aptly mirror create #{with_udebs(new_resource.with_udebs)} #{architectures(new_resource.architectures)} -filter '#{new_resource.filter}' #{filter_with_deps(new_resource.filter_with_deps)} #{new_resource.mirror_name} #{new_resource.uri} #{new_resource.distribution} #{new_resource.component}"
    user node['aptly']['user']
    group node['aptly']['group']
    environment aptly_env
    not_if %(aptly mirror -raw list | grep ^#{new_resource.mirror_name}$)
  end
end

action :update do
  execute "Updating mirror - #{new_resource.mirror_name}" do
    command "aptly mirror update #{new_resource.mirror_name}"
    user node['aptly']['user']
    group node['aptly']['group']
    environment aptly_env
    timeout new_resource.timeout
    only_if %(aptly mirror -raw list | grep ^#{new_resource.mirror_name}$)
  end
end

action :drop do
  execute "Droping mirror - #{new_resource.mirror_name}" do
    command "aptly mirror drop #{new_resource.mirror_name}"
    user node['aptly']['user']
    group node['aptly']['group']
    environment aptly_env
    only_if %(aptly mirror -raw list | grep ^#{new_resource.mirror_name}$)
  end
end

action_class do
  def install_key(keyid, keyserver)
    execute 'Installing external repository key' do
      command "#{gpg_command} --no-default-keyring --keyring trustedkeys.gpg --keyserver hkp://#{keyserver}:80 --recv-keys #{keyid}"
      user node['aptly']['user']
      group node['aptly']['group']
      environment aptly_env
      retries 2
      not_if %(#{gpg_command} --keyring trustedkeys.gpg --list-keys #{keyid})
    end
  end

  def install_local_key(keyfile, cb)
    cookbook_file "#{Chef::Config['file_cache_path']}/#{keyfile}" do
      cookbook cb
      action :create_if_missing
    end
    execute "Installing external repository key from #{keyfile}" do
      command "#{gpg_command} --no-default-keyring --keyring trustedkeys.gpg --import #{Chef::Config['file_cache_path']}/#{keyfile} && touch #{node['aptly']['rootDir']}/.#{keyfile}_imported"
      user node['aptly']['user']
      group node['aptly']['group']
      environment aptly_env
      not_if { ::File.exist?("#{node['aptly']['rootDir']}/.#{keyfile}_imported") }
    end
  end
end
