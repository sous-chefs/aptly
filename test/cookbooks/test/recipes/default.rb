# frozen_string_literal: true

aptly_user = 'aptly'
aptly_group = 'aptly'
aptly_root_dir = '/opt/aptly'
aptly_tmp_dir = '/tmp'
aptly_gpg_passphrase = 'GreatPassPhrase'
aptly_test_markers = '/tmp/aptly-kitchen-test-markers'

directory aptly_test_markers do
  mode '0755'
end

repo_drop_marker = "#{aptly_test_markers}/repo-drop"
mirror_update_marker = "#{aptly_test_markers}/mirror-update"
mirror_drop_marker = "#{aptly_test_markers}/mirror-drop"
snapshot_verify_marker = "#{aptly_test_markers}/snapshot-verify"
publish_switch_marker = "#{aptly_test_markers}/publish-switch"
db_maintenance_marker = "#{aptly_test_markers}/db-maintenance"

aptly_install 'default' do
  repository_key 'aptly_pubkey.asc'
  repository_cookbook 'test'
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
  not_if { ::File.exist?(repo_drop_marker) }
end

aptly_repo 'repo_with_no_comment' do
  user aptly_user
  group aptly_group
  root_dir aptly_root_dir
  tmp_dir aptly_tmp_dir
  action :drop
  not_if { ::File.exist?(repo_drop_marker) }
end

file repo_drop_marker do
  action :create_if_missing
  not_if %(aptly repo list --raw | grep ^repo_with_no_comment$)
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
  not_if { ::File.exist?(mirror_update_marker) }
end

file mirror_update_marker do
  action :create_if_missing
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
  not_if %(aptly mirror -raw list | grep ^nginx-bionic-main-to_edit$)
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
  not_if { ::File.exist?(mirror_drop_marker) }
end

aptly_mirror 'nginx-bionic-main-to_delete' do
  user aptly_user
  group aptly_group
  root_dir aptly_root_dir
  tmp_dir aptly_tmp_dir
  action :drop
  not_if { ::File.exist?(mirror_drop_marker) }
end

file mirror_drop_marker do
  action :create_if_missing
  not_if %(aptly mirror -raw list | grep ^nginx-bionic-main-to_delete$)
end

directory '/opt/aptly/pkgs' do
  owner aptly_user
  group aptly_group
end

fixture_build_root = '/tmp/aptly-fixture-packages'
fixture_packages = [
  {
    build_dir: "#{fixture_build_root}/grafana",
    package_name: 'grafana',
    version: '6.3.2',
    description: 'Grafana fixture package for Aptly integration tests',
    output_path: '/opt/aptly/pkgs/grafana_6.3.2_amd64.deb',
  },
  {
    build_dir: "#{fixture_build_root}/chef",
    package_name: 'chef',
    version: '15.2.20-1',
    description: 'Chef fixture package for Aptly integration tests',
    output_path: "#{Chef::Config[:file_cache_path]}/chef_15.2.20-1_amd64.deb",
  },
]

directory fixture_build_root do
  mode '0755'
end

fixture_packages.each do |fixture|
  directory fixture[:build_dir] do
    recursive true
    mode '0755'
  end

  directory "#{fixture[:build_dir]}/DEBIAN" do
    mode '0755'
  end

  directory "#{fixture[:build_dir]}/usr/share/doc/#{fixture[:package_name]}" do
    recursive true
    mode '0755'
  end

  file "#{fixture[:build_dir]}/DEBIAN/control" do
    content <<~CONTROL
      Package: #{fixture[:package_name]}
      Version: #{fixture[:version]}
      Section: misc
      Priority: optional
      Architecture: amd64
      Maintainer: Sous Chefs <maintainers@sous-chefs.org>
      Description: #{fixture[:description]}
    CONTROL
    mode '0644'
  end

  file "#{fixture[:build_dir]}/usr/share/doc/#{fixture[:package_name]}/README" do
    content "#{fixture[:description]}\n"
    mode '0644'
  end

  execute "build fixture package #{fixture[:package_name]}" do
    command "dpkg-deb --build #{fixture[:build_dir]} #{fixture[:output_path]}"
    creates fixture[:output_path]
  end
end

aptly_repo 'my_repo' do
  directory '/opt/aptly/pkgs'
  user aptly_user
  group aptly_group
  root_dir aptly_root_dir
  tmp_dir aptly_tmp_dir
  action :add
  not_if %(aptly repo show -with-packages my_repo | grep grafana_6.3.2_amd64)
end

# NOTE: If changed update in the resources_tests.rb inspec tests as well
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
  not_if { ::File.exist?(snapshot_verify_marker) }
end

file snapshot_verify_marker do
  action :create_if_missing
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
  not_if { ::File.exist?(publish_switch_marker) }
end

aptly_publish 'bionic' do
  prefix 'mirror'
  user aptly_user
  group aptly_group
  root_dir aptly_root_dir
  tmp_dir aptly_tmp_dir
  action :drop
  not_if { ::File.exist?(publish_switch_marker) }
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
  not_if { ::File.exist?(publish_switch_marker) }
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
  not_if { ::File.exist?(publish_switch_marker) }
end

file publish_switch_marker do
  action :create_if_missing
end

aptly_db 'Cleanup' do
  user aptly_user
  group aptly_group
  root_dir aptly_root_dir
  tmp_dir aptly_tmp_dir
  not_if { ::File.exist?(db_maintenance_marker) }
end

aptly_db 'Recover' do
  user aptly_user
  group aptly_group
  root_dir aptly_root_dir
  tmp_dir aptly_tmp_dir
  action :recover
  not_if { ::File.exist?(db_maintenance_marker) }
end

file db_maintenance_marker do
  action :create_if_missing
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
