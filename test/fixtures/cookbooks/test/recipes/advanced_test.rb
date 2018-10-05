#
# Cookbook Name:: aptly_test
# Recipe:: default
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

node.set['aptly']['ppadistributorid'] = 'Ubuntu'

aptly_repo 'myrepo' do
  action :create
  comment 'This is a great repo'
  component 'main'
  distribution 'mycompany'
end

aptly_repo 'nocomment' do
  action :create
end

aptly_repo 'nocomment' do
  action :drop
end

aptly_repo 'failtest' do
  action :drop
end

directory '/opt/aptly/pkgs' do
  owner 'aptly'
  group 'aptly'
end

remote_file '/opt/aptly/pkgs/wget_1.15-1ubuntu1_amd64.deb' do
  source 'http://mirrors.kernel.org/ubuntu/pool/main/w/wget/wget_1.15-1ubuntu1_amd64.deb'
end

aptly_repo 'myrepo' do
  action :add
  directory '/opt/aptly/pkgs'
end

aptly_snapshot 'pulltest' do
  action :create
  from 'myrepo'
  type 'repo'
  empty false
end

aptly_snapshot 'pulltest' do
  action :drop
end

%w(pullrepo1 pullrepo2).each do |repos|
  aptly_snapshot repos.to_s do
    action :create
    from 'myrepo'
    type 'repo'
    empty false
  end
end

aptly_snapshot 'merged-snapshot' do
  action :merge
  merge_source1 'pullrepo1'
  merge_source2 'pullrepo2'
end

aptly_snapshot 'merged-snapshot' do
  action :verify
end

aptly_snapshot 'pulledpork' do
  action :pull
  deps false
  remove false
  package 'wget_1.15-1ubuntu1_amd64.deb'
  resource 'pullrepo1'
  source 'pullrepo2'
end

%w(pulledpork merged-snapshot pullrepo1 pullrepo2).each do |repos|
  aptly_snapshot repos.to_s do
    action :drop
  end
end

aptly_mirror 'ubuntu-precise-main' do
  action :create
  distribution 'precise'
  component 'main'
  keyid '437D05B5'
  keyserver 'keys.gnupg.net'
  uri 'http://ubuntu.osuosl.org/ubuntu/'
end

aptly_mirror 'ubuntu-precise-main' do
  action :drop
end

aptly_db 'cleanup'

aptly_db 'recover' do
  action :recover
end
