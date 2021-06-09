# `aptly_mirror`

Manage external mirror

## Actions

- `create` - (default) Create a mirror from external repository
- `drop` - Drop created mirror
- `update` - Update/Sync your mirror

## Properties

| Name                      | Types         | Description                                                                            | Default          | Used with...     |
| ------------------------- | ------------- | -------------------------------------------------------------------------------------- | ---------------- | ---------------- |
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

## Examples

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
| --------------- | ------------- | -------------------------------------------------------- | --------------- | ------------- |
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
