#
# Cookbook:: aptly_test
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

include_recipe 'aptly'

aptly_repo 'my_repo' do
  comment 'A repository of packages'
  component 'main'
  distribution 'bionic'
end

aptly_repo 'repo_with_no_comment' do
  action :create
end

aptly_repo 'repo_with_no_comment' do
  action :drop
end

aptly_mirror 'nginx-bionic-main' do
  distribution 'bionic'
  component 'nginx'
  keyid '7BD9BF62'
  keyserver 'keyserver.ubuntu.com'
  uri 'http://nginx.org/packages/ubuntu/'
end

aptly_mirror 'nginx-bionic-main' do
  action :update
end

aptly_mirror 'nginx-bionic-main-to_delete' do
  distribution 'bionic'
  component 'nginx'
  keyid '7BD9BF62'
  keyserver 'keyserver.ubuntu.com'
  uri 'http://nginx.org/packages/ubuntu/'
end

aptly_mirror 'nginx-bionic-main-to_delete' do
  action :drop
end

directory '/opt/aptly/pkgs' do
  owner 'aptly'
  group 'aptly'
end

pkg = nil
pkg_url = nil

case node['platform']
when 'debian'
  pkg = case node['platform_version'].to_i
        when 8
          'wget_1.16-1+deb8u5_amd64.deb'
        when 9
          'wget_1.18-5+deb9u2_amd64.deb'
        end
  pkg_url = "http://ftp.fr.debian.org/debian/pool/main/w/wget/#{pkg}"
when 'ubuntu'
  pkg = case node['platform_version']
        when '16.04'
          'wget_1.17.1-1ubuntu1.4_amd64.deb'
        when '18.04'
          'wget_1.19.4-1ubuntu2.1_amd64.deb'
        end
  pkg_url = "http://security.ubuntu.com/ubuntu/pool/main/w/wget/#{pkg}"
end

remote_file "/opt/aptly/pkgs/#{pkg}" do
  source pkg_url
  backup 0
end

aptly_repo 'my_repo' do
  directory '/opt/aptly/pkgs'
  action :add
end

remote_file '/tmp/curl_7.26.0-1+wheezy25+deb7u1_amd64.deb' do
  source 'http://security-cdn.debian.org/debian-security/pool/updates/main/c/curl/curl_7.26.0-1+wheezy25+deb7u1_amd64.deb'
  backup 0
end

aptly_repo 'my_repo' do
  file '/tmp/curl_7.26.0-1+wheezy25+deb7u1_amd64.deb'
  action :add
end

aptly_snapshot 'my_snapshot' do
  from 'my_repo'
  type 'repo'
end

aptly_snapshot 'my_mirror_snapshot' do
  from 'nginx-bionic-main'
  type 'mirror'
end

aptly_snapshot 'my_snapshot' do
  action :verify
end

aptly_snapshot 'my_mirror_snapshot' do
  package_query 'curl_7.26.0-1+wheezy25+deb7u1_amd64.deb'
  source 'my_snapshot'
  destination 'new_my_snapshot'
  action :pull
end

aptly_snapshot 'new_my_snapshot' do
  action :drop
end

aptly_publish 'my_repo' do
  type 'repo'
  prefix 'ubuntu'
end

aptly_publish 'my_snapshot' do
  type 'snapshot'
  prefix 'snap'
end

aptly_publish 'my_mirror_snapshot' do
  type 'snapshot'
  prefix 'mirror'
end

aptly_publish 'bionic' do
  prefix 'mirror'
  action :drop
end

aptly_db 'Cleanup'

aptly_db 'Recover' do
  action :recover
end

aptly_serve 'Aptly HTTP Service'

aptly_api_serve 'Aptly API Service' do
  port 8090
end
