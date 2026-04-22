# frozen_string_literal: true

provides :aptly_install
unified_mode true

use '_partial/_common'

property :repository_uri, String, default: 'http://repo.aptly.info/'
property :repository_distribution, String, default: 'squeeze'
property :repository_components, Array, default: ['main']
property :repository_key, String, default: 'https://www.aptly.info/pubkey.txt'
property :repository_cookbook, [String, nil]
property :packages, Array, default: %w(screen aptly graphviz bzip2 xz-utils)
property :shell, String, default: '/bin/bash'
property :config_path, String, default: '/etc/aptly.conf'
property :download_concurrency, Integer, default: 4
property :download_speed_limit, Integer, default: 0
property :architectures, Array, default: []
property :dependency_follow_suggests, [true, false], default: false
property :dependency_follow_recommends, [true, false], default: false
property :dependency_follow_all_variants, [true, false], default: false
property :dependency_follow_source, [true, false], default: false
property :gpg_disable_sign, [true, false], default: false
property :gpg_disable_verify, [true, false], default: false
property :gpg_provider, String, default: 'gpg'
property :download_source_packages, [true, false], default: false
property :skip_legacy_pool, [true, false], default: true
property :ppa_distributor_id, String, default: 'ubuntu'
property :ppa_codename, String, default: ''
property :file_system_publish_endpoints, Hash, default: {}
property :s3_publish_endpoints, Hash, default: {}
property :swift_publish_endpoints, Hash, default: {}
property :gpg_key_type, String, default: 'RSA'
property :gpg_key_length, [Integer, String], default: 4096
property :gpg_name_real, String, default: 'Aptly'
property :gpg_name_comment, String, default: 'Aptly Key'
property :gpg_name_email, String, default: 'organisation@example.org'
property :gpg_expire_date, [Integer, String], default: 0
property :gpg_passphrase, String, default: 'GreatPassPhrase', sensitive: true

default_action :create

action :create do
  apt_repository 'aptly' do
    uri new_resource.repository_uri
    distribution new_resource.repository_distribution
    components new_resource.repository_components
    key new_resource.repository_key
    cookbook new_resource.repository_cookbook unless new_resource.repository_cookbook.nil?
    sensitive true
  end

  gpg_install 'gpg'

  package new_resource.packages

  group new_resource.group do
    action :create
  end

  user new_resource.user do
    gid new_resource.group
    shell new_resource.shell
    home new_resource.root_dir
    manage_home true
    system true
  end

  directory new_resource.root_dir do
    owner new_resource.user
    group new_resource.group
    mode '0755'
    recursive true
  end

  template new_resource.config_path do
    cookbook 'aptly'
    source 'aptly.conf.erb'
    owner 'root'
    group 'root'
    mode '0644'
    variables(
      rootDir: new_resource.root_dir,
      downloadConcurrency: new_resource.download_concurrency,
      downloadSpeedLimit: new_resource.download_speed_limit,
      architectures: new_resource.architectures,
      dependencyFollowSuggests: new_resource.dependency_follow_suggests,
      dependencyFollowRecommends: new_resource.dependency_follow_recommends,
      dependencyFollowAllVariants: new_resource.dependency_follow_all_variants,
      dependencyFollowSource: new_resource.dependency_follow_source,
      gpgDisableSign: new_resource.gpg_disable_sign,
      gpgDisableVerify: new_resource.gpg_disable_verify,
      gpgProvider: new_resource.gpg_provider,
      downloadSourcePackages: new_resource.download_source_packages,
      skipLegacyPool: new_resource.skip_legacy_pool,
      ppaDistributorID: new_resource.ppa_distributor_id,
      ppaCodename: new_resource.ppa_codename,
      FileSystemPublishEndpoints: new_resource.file_system_publish_endpoints,
      S3PublishEndpoints: new_resource.s3_publish_endpoints,
      SwiftPublishEndpoints: new_resource.swift_publish_endpoints
    )
  end

  gpg_key 'aptly' do
    user new_resource.user
    group new_resource.group
    key_type new_resource.gpg_key_type
    key_length new_resource.gpg_key_length.to_s
    name_real new_resource.gpg_name_real
    name_comment new_resource.gpg_name_comment
    name_email new_resource.gpg_name_email
    expire_date new_resource.gpg_expire_date.to_s
    passphrase new_resource.gpg_passphrase
    home_dir "#{new_resource.root_dir}/.gnupg"
    action :generate
  end
end
