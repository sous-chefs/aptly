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

pkgs = %w(screen aptly graphviz)
pkgs = case node['platform']
       when 'debian'
         node['platform_version'].to_i < 9 ? %w(gnupg gpgv) + pkgs : %w(gnupg1 gpgv1) + pkgs
       when 'ubuntu'
         node['platform_version'].to_f < 18.04 ? %w(gnupg gpgv) + pkgs : %w(gnupg1 gpgv1) + pkgs
       end

package pkgs

# Needed if you change home directory after user creation
directory node['aptly']['rootDir'] do
  owner node['aptly']['user']
  group node['aptly']['group']
  mode '0755'
  recursive true
  only_if "getent #{node['aptly']['user']} passwd"
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

user_environment = {
  'USER' => node['aptly']['user'],
  'HOME' => node['aptly']['rootDir'],
}

bash 'Generate Aptly GPG Key pair' do
  user node['aptly']['user']
  group node['aptly']['group']
  environment user_environment
  code <<-EOH
    TMP_REQUEST=$(mktemp /tmp/request.XXXXX)
    cat >$TMP_REQUEST <<EOF
%echo Generating Aptly GPG key
Key-Type: 1
Subkey-Type: 1
Name-Real: #{node['aptly']['gpg']['name-real']}
Name-Comment: #{node['aptly']['gpg']['name-comment']}
Name-Email: #{node['aptly']['gpg']['name-email']}
Expire-Date: #{node['aptly']['gpg']['expire-date']}
Passphrase: #{node['aptly']['gpg']['passphrase']}
%commit
%echo done
EOF
  #{gpg_command} --batch --gen-key $TMP_REQUEST
  EOH
  not_if { ::File.exist?("#{node['aptly']['rootDir']}/.gnupg/trustdb.gpg") }
end
