#
# Cookbook Name:: aptly
# Recipe:: install_from_tarball
#
# Copyright 2016, Bloomberg Finance L.P.
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

ark 'aptly' do
  url node['aptly']['tarball']['uri']
  checksum node['aptly']['tarball']['checksum']
  version node['aptly']['tarball']['version']
  has_binaries ['aptly']
  prefix_bin '/usr/bin'
  prefix_root '/opt'
  prefix_home '/opt'
  action :install
end

if node[:platform_family] == 'fedora' ||
   node[:platform_family] == 'rhel' ||
   node[:platform_family] == 'suse' 
 package 'graphviz'
else
  log 'Unknown platform family, not attempting graphviz install'
end
