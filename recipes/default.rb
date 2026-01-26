# frozen_string_literal: true
#
# Cookbook:: aptly
# Recipe:: default
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

apt_repository 'aptly' do
  uri node['aptly']['repository']['uri']
  distribution node['aptly']['repository']['dist']
  components node['aptly']['repository']['components']
  key node['aptly']['repository']['key']
  sensitive true
end

# Install gpg and haveged using the gpg cookbook
gpg_install 'gpg'

# Install additional packages needed by aptly
package %w(screen aptly graphviz)

# Needed if you change home directory after user creation
directory node['aptly']['rootDir'] do
  owner node['aptly']['user']
  group node['aptly']['group']
  mode '0755'
  recursive true
  only_if "getent passwd #{node['aptly']['user']}"
end

group node['aptly']['group'] do
  action :create
end

user node['aptly']['user'] do
  gid node['aptly']['group']
  shell '/bin/bash'
  home node['aptly']['rootDir']
  manage_home true
  system true
end

template '/etc/aptly.conf' do
  owner 'root'
  group 'root'
  mode  '0644'
  variables(rootDir: node['aptly']['rootDir'],
            downloadConcurrency: node['aptly']['downloadConcurrency'],
            downloadSpeedLimit: node['aptly']['downloadSpeedLimit'],
            architectures: node['aptly']['architectures'],
            dependencyFollowSuggests: node['aptly']['dependencyFollowSuggests'],
            dependencyFollowRecommends: node['aptly']['dependencyFollowRecommends'],
            dependencyFollowAllVariants: node['aptly']['dependencyFollowAllVariants'],
            dependencyFollowSource: node['aptly']['dependencyFollowSource'],
            gpgDisableSign: node['aptly']['gpgDisableSign'],
            gpgDisableVerify: node['aptly']['gpgDisableVerify'],
            gpgProvider: node['aptly']['gpgProvider'],
            downloadSourcePackages: node['aptly']['downloadSourcePackages'],
            skipLegacyPool: node['aptly']['skipLegacyPool'],
            ppaDistributorID: node['aptly']['ppaDistributorID'],
            ppaCodename: node['aptly']['ppaCodename'],
            FileSystemPublishEndpoints: node['aptly']['FileSystemPublishEndpoints'],
            S3PublishEndpoints: node['aptly']['S3PublishEndpoints'],
            SwiftPublishEndpoints: node['aptly']['SwiftPublishEndpoints'])
end

gpg_key 'aptly' do
  user node['aptly']['user']
  group node['aptly']['group']
  key_type node['aptly']['gpg']['key-type']
  key_length node['aptly']['gpg']['key-length'].to_s
  name_real node['aptly']['gpg']['name-real']
  name_comment node['aptly']['gpg']['name-comment']
  name_email node['aptly']['gpg']['name-email']
  expire_date node['aptly']['gpg']['expire-date'].to_s
  passphrase node['aptly']['gpg']['passphrase']
  home_dir "#{node['aptly']['rootDir']}/.gnupg"
  action :generate
end
