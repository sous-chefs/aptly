unified_mode true
use 'partial/_user'
use 'partial/_root_dir'

property :repository_uri,
        String,
        default: 'http://repo.aptly.info/'

property :repository_dist,
        String,
        default: 'squeeze'

property :repository_components,
        Array,
        default: ['main']

property :repository_key,
        String,
        default: 'https://www.aptly.info/pubkey.txt'

property :download_concurrency,
        Integer,
        default: 4

property :download_speedlimit,
        Integer,
        default: 0

property :architectures,
        Array,
        default: []

property :dependency_follow_suggests,
        [true, false],
        default: false

property :dependency_follow_recommends,
        [true, false],
        default: false

property :dependency_follow_all_variants,
        [true, false],
        default: false

property :dependency_follow_source,
        [true, false],
        default: false

property :gpg_disable_sign,
        [true, false],
        default: false

property :gpg_disable_verify,
        [true, false],
        default: false

property :gpg_provider,
        String,
        default: 'gpg'

property :gpg_key_type,
        String,
        default: 'RSA'

property :gpg_key_length,
        String,
        default: '4096'

property :gpg_subkey_type,
        String,
        default: 'RSA'

property :gpg_subkey_length,
        String,
        default: '4096'

property :gpg_name_real,
        String,
        default: 'Aptly'

property :gpg_name_comment,
        String,
        default: 'Aptly Key'

property :gpg_name_email,
        String,
        default: 'organisation@example.org'

property :gpg_expire_date,
        String,
        default: '0'

property :gpg_passphrase,
        String,
        default: 'GreatPassPhrase'

property :download_source_packages,
        [true, false],
        default: false

property :skip_legacy_pool,
        [true, false],
        default: true

property :ppa_distributor_id,
        String,
        default: 'ubuntu'

property :ppa_codename,
        String,
        default: ''

property :filesystem_publish_endpoints,
        Hash,
        default: {}

property :s3_publish_endpoints,
        Hash,
        default: {}

property :swift_publish_endpoints,
        Hash,
        default: {}

property :template_cookbook,
        String,
        default: 'aptly'

action :install do
  apt_repository 'aptly' do
    uri new_resource.repository_uri
    distribution new_resource.repository_dist
    components new_resource.repository_components
    key new_resource.repository_key
    sensitive true
  end

  package %w(screen aptly graphviz haveged gnupg1 gpgv1)

  service 'haveged' do
    supports [:status, :restart]
    action :start
  end

  # Needed if you change home directory after user creation
  directory new_resource.root_dir do
    owner new_resource.user
    group new_resource.group
    mode '0755'
    recursive true
    only_if "getent passwd #{new_resource.user}"
  end

  group new_resource.group do
    action :create
  end

  user new_resource.user do
    gid new_resource.group
    shell '/bin/bash'
    home new_resource.root_dir
    manage_home true
    system true
  end

  template '/etc/aptly.conf' do
    owner 'root'
    group 'root'
    mode  '0644'
    cookbook new_resource.template_cookbook
    variables(
      rootDir: new_resource.root_dir,
      downloadConcurrency: new_resource.download_concurrency,
      downloadSpeedLimit: new_resource.download_speedlimit,
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
      FileSystemPublishEndpoints: new_resource.filesystem_publish_endpoints,
      S3PublishEndpoints: new_resource.s3_publish_endpoints,
      SwiftPublishEndpoints: new_resource.swift_publish_endpoints
    )
  end

  bash 'Generate Aptly GPG Key pair' do
    user new_resource.user
    group new_resource.group
    environment aptly_env(new_resource)
    code <<-EOH
      TMP_REQUEST=$(mktemp /tmp/request.XXXXX)
      cat >$TMP_REQUEST <<EOF
  %echo Generating Aptly GPG key
  Key-Type: #{new_resource.gpg_key_type}
  Key-Length: #{new_resource.gpg_key_length}
  Subkey-Type: #{new_resource.gpg_subkey_type}
  Subkey-Length: #{new_resource.gpg_subkey_length}
  Name-Real: #{new_resource.gpg_name_real}
  Name-Comment: #{new_resource.gpg_name_comment}
  Name-Email: #{new_resource.gpg_name_email}
  Expire-Date: #{new_resource.gpg_expire_date}
  Passphrase: #{new_resource.gpg_passphrase}
  %commit
  %echo done
  EOF
    #{gpg_command} --batch --gen-key $TMP_REQUEST
    rm -f $TMP_REQUEST
    EOH
    not_if { key_exists(new_resource) }
  end
end

action :remove do
  apt_repository 'aptly' do
    action :remove
  end

  directory new_resource.root_dir do
    :remove
  end

  group new_resource.group do
    action :remove
  end

  user new_resource.user do
    action :remove
  end

  template '/etc/aptly.conf' do
    action :remove
  end
end
