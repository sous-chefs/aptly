# frozen_string_literal: true

aptly_user = 'aptly'
aptly_group = 'aptly'
aptly_root_dir = '/opt/aptly'
aptly_tmp_dir = '/tmp'
aptly_gpg_passphrase = 'GreatPassPhrase'

aptly_install 'default' do
  user aptly_user
  group aptly_group
  root_dir aptly_root_dir
  tmp_dir aptly_tmp_dir
  gpg_passphrase aptly_gpg_passphrase
end

aptly_repo 'my_repo' do
  comment 'A repository of packages'
  component 'main'
  distribution 'bionic'
  user aptly_user
  group aptly_group
  root_dir aptly_root_dir
  tmp_dir aptly_tmp_dir
end

aptly_repo 'repo_with_no_comment' do
  user aptly_user
  group aptly_group
  root_dir aptly_root_dir
  tmp_dir aptly_tmp_dir
  action :create
end

aptly_repo 'repo_with_no_comment' do
  user aptly_user
  group aptly_group
  root_dir aptly_root_dir
  tmp_dir aptly_tmp_dir
  action :drop
end

aptly_mirror 'nginx-bionic-main' do
  distribution 'bionic'
  component 'nginx'
  keyid '7BD9BF62'
  keyserver 'keyserver.ubuntu.com'
  uri 'http://nginx.org/packages/ubuntu/'
  filter 'nginx (>= 1.16.1)'
  user aptly_user
  group aptly_group
  root_dir aptly_root_dir
  tmp_dir aptly_tmp_dir
end

aptly_mirror 'nginx-bionic-main' do
  user aptly_user
  group aptly_group
  root_dir aptly_root_dir
  tmp_dir aptly_tmp_dir
  action :update
end

aptly_mirror 'nginx-bionic-main-to_edit' do
  distribution 'bionic'
  component 'nginx'
  keyid '7BD9BF62'
  keyserver 'keyserver.ubuntu.com'
  uri 'http://nginx.org/packages/ubuntu/'
  user aptly_user
  group aptly_group
  root_dir aptly_root_dir
  tmp_dir aptly_tmp_dir
end

aptly_mirror 'nginx-bionic-main-to_edit2' do
  mirror_name 'nginx-bionic-main-to_edit'
  distribution 'bionic'
  component 'nginx'
  keyid '7BD9BF62'
  keyserver 'keyserver.ubuntu.com'
  uri 'http://nginx.org/packages/ubuntu/'
  filter 'nginx (>= 1.16.1)'
  user aptly_user
  group aptly_group
  root_dir aptly_root_dir
  tmp_dir aptly_tmp_dir
end

aptly_mirror 'nginx-bionic-main-to_delete' do
  distribution 'bionic'
  component 'nginx'
  keyid '7BD9BF62'
  keyserver 'keyserver.ubuntu.com'
  uri 'http://nginx.org/packages/ubuntu/'
  user aptly_user
  group aptly_group
  root_dir aptly_root_dir
  tmp_dir aptly_tmp_dir
end

aptly_mirror 'nginx-bionic-main-to_delete' do
  user aptly_user
  group aptly_group
  root_dir aptly_root_dir
  tmp_dir aptly_tmp_dir
  action :drop
end

directory '/opt/aptly/pkgs' do
  owner aptly_user
  group aptly_group
end

pkg = 'grafana_6.3.2_amd64.deb'
pkg_url = 'https://dl.grafana.com/oss/release/grafana_6.3.2_amd64.deb'

remote_file "/opt/aptly/pkgs/#{pkg}" do
  source pkg_url
  backup 0
end

aptly_repo 'my_repo' do
  directory '/opt/aptly/pkgs'
  user aptly_user
  group aptly_group
  root_dir aptly_root_dir
  tmp_dir aptly_tmp_dir
  action :add
end

# NOTE: If changed update in the resources_tests.rb inspec tests as well
remote_file "#{Chef::Config[:file_cache_path]}/chef_15.2.20-1_amd64.deb" do
  source 'https://packages.chef.io/files/stable/chef/15.2.20/debian/8/chef_15.2.20-1_amd64.deb'
  backup 0
end

aptly_repo 'my_repo' do
  file "#{Chef::Config[:file_cache_path]}/chef_15.2.20-1_amd64.deb"
  user aptly_user
  group aptly_group
  root_dir aptly_root_dir
  tmp_dir aptly_tmp_dir
  action :add
end

aptly_snapshot 'my_snapshot' do
  from 'my_repo'
  type 'repo'
  user aptly_user
  group aptly_group
  root_dir aptly_root_dir
  tmp_dir aptly_tmp_dir
end

aptly_snapshot 'my_mirror_snapshot' do
  from 'nginx-bionic-main'
  type 'mirror'
  user aptly_user
  group aptly_group
  root_dir aptly_root_dir
  tmp_dir aptly_tmp_dir
end

aptly_snapshot 'my_switch_snapshot' do
  from 'nginx-bionic-main'
  type 'mirror'
  user aptly_user
  group aptly_group
  root_dir aptly_root_dir
  tmp_dir aptly_tmp_dir
end

aptly_snapshot 'my_snapshot' do
  user aptly_user
  group aptly_group
  root_dir aptly_root_dir
  tmp_dir aptly_tmp_dir
  action :verify
end

aptly_snapshot 'my_mirror_snapshot' do
  package_query 'chef_15.2.20-1_amd64.deb'
  source 'my_snapshot'
  destination 'new_my_snapshot'
  user aptly_user
  group aptly_group
  root_dir aptly_root_dir
  tmp_dir aptly_tmp_dir
  action :pull
end

aptly_snapshot 'new_my_snapshot' do
  user aptly_user
  group aptly_group
  root_dir aptly_root_dir
  tmp_dir aptly_tmp_dir
  action :drop
end

aptly_publish 'my_repo' do
  type 'repo'
  component ['main']
  distribution 'bionic'
  prefix 'ubuntu'
  gpg_passphrase aptly_gpg_passphrase
  skip_signing true
  user aptly_user
  group aptly_group
  root_dir aptly_root_dir
  tmp_dir aptly_tmp_dir
end

aptly_publish 'my_snapshot' do
  type 'snapshot'
  component ['main']
  distribution 'bionic'
  prefix 'snap'
  gpg_passphrase aptly_gpg_passphrase
  skip_signing true
  user aptly_user
  group aptly_group
  root_dir aptly_root_dir
  tmp_dir aptly_tmp_dir
end

aptly_publish 'my_mirror_snapshot' do
  type 'snapshot'
  component ['main']
  distribution 'bionic'
  prefix 'mirror'
  gpg_passphrase aptly_gpg_passphrase
  skip_signing true
  user aptly_user
  group aptly_group
  root_dir aptly_root_dir
  tmp_dir aptly_tmp_dir
end

aptly_publish 'bionic' do
  prefix 'mirror'
  user aptly_user
  group aptly_group
  root_dir aptly_root_dir
  tmp_dir aptly_tmp_dir
  action :drop
end

aptly_publish 'my_snapshot_for_switch' do
  publish_name 'my_mirror_snapshot'
  type 'snapshot'
  component ['main']
  distribution 'bionic'
  prefix 'switch'
  gpg_passphrase aptly_gpg_passphrase
  skip_signing true
  user aptly_user
  group aptly_group
  root_dir aptly_root_dir
  tmp_dir aptly_tmp_dir
  not_if %(aptly publish list -raw | egrep '^switch bionic$')
end

aptly_publish 'my_switch_snapshot' do
  type 'snapshot'
  component ['main']
  distribution 'bionic'
  prefix 'switch'
  gpg_passphrase aptly_gpg_passphrase
  skip_signing true
  user aptly_user
  group aptly_group
  root_dir aptly_root_dir
  tmp_dir aptly_tmp_dir
  action :switch
end

aptly_db 'Cleanup' do
  user aptly_user
  group aptly_group
  root_dir aptly_root_dir
  tmp_dir aptly_tmp_dir
end

aptly_db 'Recover' do
  user aptly_user
  group aptly_group
  root_dir aptly_root_dir
  tmp_dir aptly_tmp_dir
  action :recover
end

aptly_serve 'Aptly HTTP Service' do
  user aptly_user
  group aptly_group
  root_dir aptly_root_dir
  tmp_dir aptly_tmp_dir
end

aptly_api_serve 'Aptly API Service' do
  port 8090
  user aptly_user
  group aptly_group
  root_dir aptly_root_dir
  tmp_dir aptly_tmp_dir
end
