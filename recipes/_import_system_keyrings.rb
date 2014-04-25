#
# Cookbook Name:: aptly
# Recipe:: _import_system_keyrings
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

keyring_files = Dir.glob('/usr/share/keyrings/*keyring.gpg').to_a
keyring_files.each do |key|
  name = File.basename("#{key}")
  execute "Importing System Keyring - #{name}" do
    user node['aptly']['user']
    group node['aptly']['group']
    cwd node['aptly']['rootdir']
    command "export HOME=#{node['aptly']['rootdir']} && gpg --keyring #{key} --export | gpg --no-default-keyring --keyring trustedkeys.gpg --import"
  end
end
