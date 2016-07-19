#
# Cookbook Name:: aptly
# Recipe:: install
#
# Copyright 2014, Heavy Water Operations, LLC
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

include_recipe "apt"

environment = {
  "USER" => "#{node['aptly']['user']}",
  "HOME" => "#{node['aptly']['rootdir']}"
}

apt_repository "aptly" do
  uri node['aptly']['uri']
  distribution node['aptly']['dist']
  components node['aptly']['components']
  keyserver node['aptly']['keyserver']
  key node['aptly']['key']
  action :add
end

package "aptly"
package "graphviz"

group node['aptly']['group'] do
  action :create
end

user node['aptly']['user'] do
  gid node['aptly']['group']
  shell '/bin/bash'
  home node['aptly']['rootdir']
  system true
  action :create
end

directory node['aptly']['rootdir'] do
  owner node['aptly']['user']
  group node['aptly']['group']
  mode  00755
  recursive true
  action :create
end

%w{db pool public}.each do |dir|
  directory "#{node['aptly']['rootdir']}/#{dir}" do
    owner node['aptly']['user']
    group node['aptly']['group']
    mode 00755
    recursive true
    action :create
  end
end

template '/etc/aptly.conf' do
  source 'aptly.conf.erb'
  owner 'root'
  group 'root'
  mode  00644
  variables({
    :rootdir => node['aptly']['rootdir'],
    :downloadconcurrency => node['aptly']['downloadconcurrency'],
    :architectures => node['aptly']['architectures'],
    :dependencyfollowsuggests => node['aptly']['dependencyfollowsuggests'],
    :dependencyfollowrecommends => node['aptly']['dependencyfollowrecommends'],
    :dependencyfollowallvariants => node['aptly']['dependencyfollowallvariants'],
    :dependencyfollowsource => node['aptly']['dependencyfollowsource'],
    :gpgdisablesign => node['aptly']['gpgdisablesign'],
    :gpgdisableverify => node['aptly']['gpgdisableverify'],
    :downloadsourcepackages => node['aptly']['downloadsourcepackages'],
    :ppadistributorid => node['aptly']['ppadistributorid'],
    :ppacodename => node['aptly']['ppacodename'],
    :bucket => node['aptly']['bucket'],
    :region => node['aptly']['region'],
    :awsAccessKeyID => node['aptly']['awsAccessKeyID'],
    :awsSecretAccessKey => node['aptly']['awsSecretAccessKey']
  })
end

execute "initialize gpg for aptly user #{node['aptly']['user']}" do
  command "gpg --list-keys"
  environment environment
  user node['aptly']['user']
  group node['aptly']['group']
  not_if { Dir.exists?("#{node['aptly']['rootdir']}/.gnupg") }
end

execute "seed aptly db" do
  command "aptly repo list"
  environment environment
  user node['aptly']['user']
  group node['aptly']['group']
  not_if { File.exists?("#{node['aptly']['rootdir']}/db/CURRENT") }
end

execute "aptly db ownership" do
  command "chown -R #{node['aptly']['user']}:#{node['aptly']['group']} #{node['aptly']['rootdir']}/db"
end
