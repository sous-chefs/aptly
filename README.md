# aptly Cookbook

[![Cookbook Version](https://img.shields.io/cookbook/v/aptly.svg)](https://supermarket.chef.io/cookbooks/aptly)
[![Build Status](https://img.shields.io/circleci/project/github/sous-chefs/aptly/master.svg)](https://circleci.com/gh/sous-chefs/aptly)
[![OpenCollective](https://opencollective.com/sous-chefs/backers/badge.svg)](#backers)
[![OpenCollective](https://opencollective.com/sous-chefs/sponsors/badge.svg)](#sponsors)
[![License](https://img.shields.io/badge/License-Apache%202.0-green.svg)](https://opensource.org/licenses/Apache-2.0)

This cookbook installs and configures aptly [http://www.aptly.info](http://www.aptly.info)

## Maintainers

This cookbook is maintained by the Sous Chefs. The Sous Chefs are a community of Chef cookbook maintainers working together to maintain important cookbooks. If you’d like to know more please visit [sous-chefs.org](https://sous-chefs.org/) or come chat with us on the Chef Community Slack in [#sous-chefs](https://chefcommunity.slack.com/messages/C2V7B88SF).

## Requirements

### Platform

- Debian 9
- Debian 10
- Ubuntu 16.04
- Ubuntu 18.04

## Attributes

### Repository attributes

- `default['aptly']['repository']['uri'] = 'http://repo.aptly.info/'`
- `default['aptly']['repository']['dist'] = 'squeeze'`
- `default['aptly']['repository']['components'] = 'main'`
- `default['aptly']['repository']['key'] = 'https://www.aptly.info/pubkey.txt'`

### Global repository attributes

- `default['aptly']['user'] = 'aptly'`
- `default['aptly']['group'] = 'aptly'`
- `default['aptly']['rootDir'] = '/opt/aptly'`
- `default['aptly']['downloadConcurrency'] = 4`
- `default['aptly']['downloadSpeedLimit'] = 0`
- `default['aptly']['architectures'] = []`
- `default['aptly']['dependencyFollowSuggests'] = false`
- `default['aptly']['dependencyFollowRecommends'] = false`
- `default['aptly']['dependencyFollowAllVariants'] = false`
- `default['aptly']['dependencyFollowSource'] = false`
- `default['aptly']['gpgDisableSign'] = false`
- `default['aptly']['gpgDisableVerify'] = false`
- `default['aptly']['gpgProvider'] = 'gpg'`
- `default['aptly']['downloadSourcePackages'] = false`
- `default['aptly']['skipLegacyPool'] = true`
- `default['aptly']['ppaDistributorID'] = 'ubuntu'`
- `default['aptly']['ppaCodename'] = ''`
- `default['aptly']['FileSystemPublishEndpoints'] = {}`
- `default['aptly']['S3PublishEndpoints'] = {}`
- `default['aptly']['SwiftPublishEndpoints'] = {}`

### GPG attributes

- `default['aptly']['gpg']['key-type'] = 'RSA'`
- `default['aptly']['gpg']['key-length'] = 4096`
- `default['aptly']['gpg']['subkey-type'] = 'RSA'`
- `default['aptly']['gpg']['subkey-length'] = 4096`
- `default['aptly']['gpg']['name-real'] = 'Aptly'`
- `default['aptly']['gpg']['name-comment'] = 'Aptly Key'`
- `default['aptly']['gpg']['name-email'] = 'organisation@example.org'`
- `default['aptly']['gpg']['expire-date'] = 0`
- `default['aptly']['gpg']['passphrase'] = 'GreatPassPhrase'`

## Recipes

### `default`

Install and configure aptly

## Resources

### 'aptly_repo'

Manage local repositories

#### Actions

- `create` - (default) Create a repo
- `drop` - Drop an existed repository
- `add` - Add packages to a repository
- `remove` - remove a package from a repository

#### Properties

| Name            | Types         | Description                                                       | Default         | Used with... |
|-----------------|---------------|-------------------------------------------------------------------|-----------------|--------------|
| `repo_name`     | String        | Name of the repository                                            | <resource_name> | all          |
| `component`     | String        | Repository component                                              | ''              | :create      |
| `comment`       | String        | Repository's comment                                              | ''              | :create      |
| `distribution`  | String        | Name of distribution repository                                   | ''              | :create      |
| `remove_files`  | [true, false] | Remove files that have been imported successfully into repository | false           | :add         |
| `force_replace` | [true, false] | Remove/override existing package when exists                      | false           | :add         |
| `directory`     | String        | Look in this directory to add multiple packages                   | ''              | :add         |
| `file`          | String        | Specify a package file to add to the repository                   | ''              | :add         |
| `package_query` | String        | Package name to remove from repository                            | ''              | :remove      |

#### Examples

```ruby
aptly_repo 'my_repo' do
  comment 'A repository of packages'
  component 'main'
  distribution 'bionic'
  action :create
end
```

```ruby
aptly_repo 'repo_with_no_comment' do
  action :create
end
```

```ruby
aptly_repo 'my_repo' do
  action :drop
end
```

```ruby
aptly_repo 'my_repo' do
  file '/path/to/package-1.0.1.deb'
  action :add
end
```

```ruby
aptly_repo 'my_repo' do
  directory '/path/to/packages'
  action :add
end
```

```ruby
aptly_repo 'my_repo' do
  package_query 'package-1.0.1.deb'
  action :remove
end
```

### 'aptly_mirror'

Manage external mirror

#### Actions

- `create` - (default) Create a mirror from external repository
- `drop` - Drop created mirror
- `update` - Update/Sync your mirror

#### Properties

| Name                      | Types         | Description                                                                            | Default          | Used with...     |
|---------------------------|---------------|----------------------------------------------------------------------------------------|------------------|------------------|
| `mirror_name`             | String        | Mirror name                                                                            | <resource_name>  | all              |
| `component`               | String        | Repository component                                                                   | ''               | :create          |
| `distribution`            | String        | Name of distribution repository                                                        | ''               | :create          |
| `uri`                     | String        | Uri of remote repository                                                               | ''               | :create          |
| `keyid`                   | String        | Remote repository key ID                                                               | ''               | :create          |
| `keyserver`               | String        | Keys server                                                                            | 'keys.gnupg.net' | :create          |
| `cookbook`                | String        | Cookbook name where you've store the keyfile                                           | ''               | :create          |
| `keyfile`                 | String        | Key file name                                                                          | ''               | :create          |
| `filter`                  | String        | Mirror filter                                                                          | ''               | :create          |
| `filter_with_deps`        | [true, false] | Include dependencies of filtered packages                                              | false            | :create          |
| `dep_follow_all_variants` | [true, false] | When processing dependencies, follow _a_ & _b_ if dependency is '`a|b`'                | false            | :create, :update |
| `dep_follow_recommends`   | [true, false] | When processing dependencies, follow _Recommends_                                      | false            | :create, :update |
| `dep_follow_source`       | [true, false] | When processing dependencies, follow from binary to Source packages                    | false            | :create, :update |
| `dep_follow_suggests`     | [true, false] | When processing dependencies, follow _Suggests_                                        | false            | :create, :update |
| `dep_verbose_resolve`     | [true, false] | When processing dependencies, print detailed logs                                      | false            | :create, :update |
| `ignore_checksums`        | [true, false] | Ignore checksum mismatches while downloading package files and metadata                | false            | :update          |
| `ignore_signatures`       | [true, false] | Disable verification of Release file signatures (**WARNING**: Not Recommended)         | false            | :create, :update |
| `architectures`           | Array         | List of architectures                                                                  | []               | :create          |
| `with_installer`          | [true, false] | Whether to download installer files                                                    | false            | :create          |
| `with_udebs`              | [true, false] | Whether or not to download .udeb packages                                              | false            | :create          |
| `download_limit`          | Integer       | Limit download speed (kbytes/sec)                                                      | 0                | :update          |
| `max_tries`               | Integer       | Max download tries till process fails with download error                              | 1                | :update          |
| `skip_existing_packages`  | [true, false] | Do not check file existence for packages listed in the internal database of the mirror | false            | :update          |
| `timeout`                 | Integer       | Timeout in seconds                                                                     | 3600             | :update          |

Note: The "architectures" property will use the global configuration (settable via node['aptly']['architectures']) if you do not provide it for a particular repository here. If you do not provide either of them, it will default to all available architectures for that particular mirror. Note also that you need to `publish` with the architectures as well!

#### Examples

```ruby
aptly_mirror 'nginx-bionic' do
  distribution 'bionic'
  component 'nginx'
  keyid '7BD9BF62'
  keyserver 'keyserver.ubuntu.com'
  uri 'http://nginx.org/packages/ubuntu/'
end
```

```ruby
aptly_mirror 'nginx-bionic' do
  action :update
end
```

```ruby
aptly_mirror 'nginx-bionic' do
  action :drop
end
```

### 'aptly_snapshot'

Manage aptly snapshots

#### Actions

- `create` - (default) Create a snapshot from an internal repository or mirror
- `drop` - Drop created snapshot
- `verify` - Verifies dependencies between packages in snapshot
- `pull` - Pulls new packages to snapshot from source snapshot
- `merge` - Merges several source snapshots into new destination snapshot

#### Properties

| Name            | Types         | Description                                              | Default         | Used with...  |
|-----------------|---------------|----------------------------------------------------------|-----------------|---------------|
| `snapshot_name` | String        | Snapshot name                                            | <resource_name> | all           |
| `from`          | String        | Name of mirror or repo to snapshot                       | ''              | :create       |
| `type`          | String        | Type of snapshot source (repo, mirror or snapshot)       | ''              | :create       |
| `empty`         | [true, false] | Create an empty snapshot                                 | false           | :create       |
| `source`        | String        | Snapshot name where packages would be searched           | ''              | :pull         |
| `destination`   | String        | Name of the snapshot that would be created               | ''              | :pull         |
| `package_query` | String        | Query/package name to be pulled from                     | ''              | :pull         |
| `no_deps`       | [true, false] | Don’t process dependencies                               | false           | :pull         |
| `no_remove`     | [true, false] | Don’t remove other package versions when pulling package | false           | :pull, :merge |
| `merge_sources` | Array         | Array of snapshot names to merge                         | ''              | :merge        |
| `latest`        | [true, false] | Use only the latest version of each package              | false           | :merge        |

#### Examples

```ruby
aptly_snapshot 'my_snapshot' do
  from 'my_repo'
  type 'repo'
end
```

```ruby
aptly_snapshot 'my_snapshot' do
  action :drop
end
```

```ruby
aptly_snapshot 'merged_snapshot' do
  merge_sources %w(snapshot1 snapshot2)
  action :merge
end
```

```ruby
aptly_snapshot 'merged_snapshot' do
  action :verify
end
```

```ruby
aptly_snapshot 'merged_snapshot' do
  package_query 'curl_7.26.0-1+wheezy25+deb7u1_amd64.deb'
  source 'my_snapshot'
  destination 'new_my_snapshot'
  action :pull
end
```

### 'aptly_publish'

Publish, remove or update a repo or a snapshot

#### Actions

- `create` - (default) Publish a repo or a snapshot
- `drop` - Drop a publication
- `update` - Update publication

#### Properties

| Name            | Types   | Description                                     | Default         | Used with...     |
|-----------------|---------|-------------------------------------------------|-----------------|------------------|
| `publish_name`  | String  | Publication name                                | <resource_name> | all              |
| `type`          | String  | Publish type (snapshot or repo)                 | ''              | :create          |
| `component`     | String  | Component name to publish                       | []              | :create          |
| `distribution`  | String  | Distribution name to publish                    | ''              | :create          |
| `architectures` | Array   | Only mentioned architectures would be published | []              | :create          |
| `endpoint`      | String  | An optional endpoint reference                  | ''              | :create, :update |
| `prefix`        | String  | An optional prefix for publishing               | ''              | :create, :update |
| `timeout`       | Integer | Timeout in seconds                              | 3600            | all              |

Note: The "architectures" property will use the global configuration (settable via node['aptly']['architectures']) if you do not provide it for a particular repository here.

#### Examples

```ruby
aptly_publish 'my_repo' do
  type 'repo'
  component %w(main contrib)
  prefix 'my_company'
end
```

```ruby
aptly_publish 'my_snapshot' do
  type 'snapshot'
  endpoint 's3'
  prefix 'snap'
  action :create
end
```

```ruby
aptly_publish 'my_snapshot' do
  prefix 'snap'
  action :update
end
```

```ruby
aptly_publish 'my_snapshot' do
  prefix 'snap'
  action :drop
end
```

### 'aptly_serve'

Serve an HTTP Service

#### Actions

- `run` - (default) Run the service

#### Properties

| Name     | Types             | Description                             | Default             | Used with... |
|----------|-------------------|-----------------------------------------|---------------------|--------------|
| `listen` | String            | Specify IP address about HTTP listening | '' (all interfaces) | :run         |
| `port`   | [Integer, String] | Publish type (snapshot or repo)         | 8080                | :run         |
| `user`   | String            | Run command as user                     | 'aptly'             | :run         |
| `group`  | String            | Run command as group                    | 'aptly'             | :run         |

#### Examples

```ruby
aptly_serve 'Serve Aptly HTTP Service' do
  port 8090
end
```

### 'aptly_api_serve'

Serve an API Service

#### Actions

- `run` - (default) Run the service

#### Properties

| Name      | Types             | Description                             | Default             | Used with... |
|-----------|-------------------|-----------------------------------------|---------------------|--------------|
| `listen`  | String            | Specify IP address about HTTP listening | '' (all interfaces) | :run         |
| `port`    | [Integer, String] | Publish type (snapshot or repo)         | 8080                | :run         |
| `user`    | String            | Run command as user                     | 'aptly'             | :run         |
| `group`   | String            | Run command as group                    | 'aptly'             | :run         |
| `no_lock` | [true, false]     | Don’t lock the database                 | false               | :run         |

#### Examples

```ruby
aptly_api_serve 'Serve Aptly API Service' do
  port 8091
  no_lock true
end
```

### 'aptly_db'

Manage internal Aptly DB

#### Actions

- `cleanup` - (default) Database cleanup removes information about unreferenced packages and deletes files in the package pool that aren’t used by packages anymore.
- `recover` - Database recover does its best to recover database after crash.

#### Properties

None

#### Examples

```ruby
aptly_db 'cleanup' do
  action :cleanup
end
```

```ruby
aptly_db 'recover' do
  action :recover
end
```

## Usage

### include recipe in a wrapper cookbook and call resources if needed

```ruby
include_recipe 'aptly'

aptly_repo 'my_repo' do
  comment 'A repository of packages'
  component 'main'
  distribution 'bionic'
end

aptly_snapshot 'my_snapshot' do
  from 'my_repo'
  type 'repo'
end

aptly_publish 'my_repo' do
  type 'repo'
  prefix 'ubuntu'
end

aptly_serve 'Aptly HTTP Service'
```

## Testing

Please contribute to keep unit and functional tests up to date.
After modifications, please run the following commands to check if you break something:

- chef exec rspec
- kitchen test default-ubuntu-1804

NOTE: Available distro tests: `default-debian-8`, `default-debian-9`, `default-ubuntu-1604` and `default-ubuntu-1804`

NOTE2: if you want to use Policyfile, rename `Policyfile.rb.dist` to `Policyfile.rb` in root and test directories, then execute `chef update` in each folder. Look inside `.kitchen.yml` and `spec/spec_helper.rb` too.

## Contributors

This project exists thanks to all the people who [contribute.](https://opencollective.com/sous-chefs/contributors.svg?width=890&button=false)

### Backers

Thank you to all our backers!

![https://opencollective.com/sous-chefs#backers](https://opencollective.com/sous-chefs/backers.svg?width=600&avatarHeight=40)

### Sponsors

Support this project by becoming a sponsor. Your logo will show up here with a link to your website.

![https://opencollective.com/sous-chefs/sponsor/0/website](https://opencollective.com/sous-chefs/sponsor/0/avatar.svg?avatarHeight=100)
![https://opencollective.com/sous-chefs/sponsor/1/website](https://opencollective.com/sous-chefs/sponsor/1/avatar.svg?avatarHeight=100)
![https://opencollective.com/sous-chefs/sponsor/2/website](https://opencollective.com/sous-chefs/sponsor/2/avatar.svg?avatarHeight=100)
![https://opencollective.com/sous-chefs/sponsor/3/website](https://opencollective.com/sous-chefs/sponsor/3/avatar.svg?avatarHeight=100)
![https://opencollective.com/sous-chefs/sponsor/4/website](https://opencollective.com/sous-chefs/sponsor/4/avatar.svg?avatarHeight=100)
![https://opencollective.com/sous-chefs/sponsor/5/website](https://opencollective.com/sous-chefs/sponsor/5/avatar.svg?avatarHeight=100)
![https://opencollective.com/sous-chefs/sponsor/6/website](https://opencollective.com/sous-chefs/sponsor/6/avatar.svg?avatarHeight=100)
![https://opencollective.com/sous-chefs/sponsor/7/website](https://opencollective.com/sous-chefs/sponsor/7/avatar.svg?avatarHeight=100)
![https://opencollective.com/sous-chefs/sponsor/8/website](https://opencollective.com/sous-chefs/sponsor/8/avatar.svg?avatarHeight=100)
![https://opencollective.com/sous-chefs/sponsor/9/website](https://opencollective.com/sous-chefs/sponsor/9/avatar.svg?avatarHeight=100)
