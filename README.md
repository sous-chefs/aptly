# aptly Cookbook
[![Cookbook Version](https://img.shields.io/cookbook/v/aptly.svg)](https://supermarket.chef.io/cookbooks/aptly)
[![CircleCI](https://circleci.com/gh/sous-chefs/aptly.svg?style=svg)](https://circleci.com/gh/sous-chefs/aptly)

This cookbook installs and configures aptly (http://www.aptly.info)

Requirements
------------

### Platform

* Debian 8
* Debian 9
* Ubuntu 16.04
* Ubuntu 18.04

Attributes
----------

### Repository attributes
* `default['aptly']['repository']['uri'] = 'http://repo.aptly.info/'`
* `default['aptly']['repository']['dist'] = 'squeeze'`
* `default['aptly']['repository']['components'] = 'main'`
* `default['aptly']['repository']['key'] = 'https://www.aptly.info/pubkey.txt'`

### Global repository attributes
* `default['aptly']['user'] = 'aptly'`
* `default['aptly']['group'] = 'aptly'`
* `default['aptly']['rootDir'] = '/opt/aptly'`
* `default['aptly']['downloadConcurrency'] = 4`
* `default['aptly']['downloadSpeedLimit'] = 0`
* `default['aptly']['architectures'] = []`
* `default['aptly']['dependencyFollowSuggests'] = false`
* `default['aptly']['dependencyFollowRecommends'] = false`
* `default['aptly']['dependencyFollowAllVariants'] = false`
* `default['aptly']['dependencyFollowSource'] = false`
* `default['aptly']['gpgDisableSign'] = false`
* `default['aptly']['gpgDisableVerify'] = false`
* `default['aptly']['gpgProvider'] = 'gpg'`
* `default['aptly']['downloadSourcePackages'] = false`
* `default['aptly']['skipLegacyPool'] = true`
* `default['aptly']['ppaDistributorID'] = 'ubuntu'`
* `default['aptly']['ppaCodename'] = ''`
* `default['aptly']['FileSystemPublishEndpoints'] = {}`
* `default['aptly']['S3PublishEndpoints'] = {}`
* `default['aptly']['SwiftPublishEndpoints'] = {}`

### GPG attributes
* `default['aptly']['gpg']['name-real'] = 'Aptly'`
* `default['aptly']['gpg']['name-comment'] = 'Aptly Key'`
* `default['aptly']['gpg']['name-email'] = 'organisation@example.org'`
* `default['aptly']['gpg']['expire-date'] = 0`
* `default['aptly']['gpg']['passphrase'] = 'GreatPassPhrase'`

Recipes
-------
### `default`

Install and configure aptly

Resources
---------

### 'aptly_repo'

Manage local repositories

#### Actions

- `create` - (default) Create a repo
- `drop` - Drop an existed repository
- `add` - Add packages to a repository
- `remove` - remove a package from a repository

#### Properties

Name            | Types         | Description                                                       | Default         | Used with...
----------------| ------------- | ----------------------------------------------------------------- | --------------- | ------------
`repo_name`     | String        | Name of the repository                                            | <resource_name> | all
`component`     | String        | Repository component                                              | ''              | :create
`comment`       | String        | Repository's comment                                              | ''              | :create
`distribution`  | String        | Name of distribution repository                                   | ''              | :create
`remove_files`  | [true, false] | Remove files that have been imported successfully into repository | false           | :add
`force_replace` | [true, false] | Remove/override existing package when exists                      | false           | :add
`directory`     | String        | Look in this directory to add multiple packages                   | ''              | :add
`file`          | String        | Specify a package file to add to the repository                   | ''              | :add
`package_query` | String        | Package name to remove from repository                            | ''              | :remove

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

Name               | Types         | Description                                  | Default          | Used with...
------------------ | ------------- | -------------------------------------------- | ---------------- | ------------
`mirror_name`      | String        | Mirror name                                  | <resource_name>  | all
`component`        | String        | Repository component                         | ''               | :create
`distribution`     | String        | Name of distribution repository              | ''               | :create
`uri`              | String        | Uri of remote repository                     | ''               | :create
`keyid`            | String        | Remote repository key ID                     | ''               | :create
`keyserver`        | String        | Keys server                                  | 'keys.gnupg.net' | :create
`cookbook`         | String        | Cookbook name where you've store the keyfile | ''               | :create
`keyfile`          | String        | Key file name                                | ''               | :create
`filter`           | String        | Mirror filter                                | ''               | :creates
`filter_with_deps` | [true, false] | Include dependencies of filtered packages    | false            | :creates

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

Name            | Types         | Description                                              | Default         | Used with...
--------------- | ------------- | -------------------------------------------------------- | --------------- | --------------
`snapshot_name` | String        | Snapshot name                                            | <resource_name> | all
`from`          | String        | Name of mirror or repo to snapshot                       | ''              | :create
`type`          | String        | Type of snapshot source (repo, mirror or snapshot)       | ''              | :create
`empty`         | [true, false] | Create an empty snapshot                                 | false           | :create
`source`        | String        | Snapshot name where packages would be searched           | ''              | :pull
`destination`   | String        | Name of the snapshot that would be created               | ''              | :pull
`package_query` | String        | Query/package name to be pulled from                     | ''              | :pull
`no_deps`       | [true, false] | Don’t process dependencies                               | false           | :pull
`no_remove`     | [true, false] | Don’t remove other package versions when pulling package | false           | :pull, :merge
`merge_sources` | Array         | Array of snapshot names to merge                         | ''              | :merge
`latest`        | [true, false] | Use only the latest version of each package              | false           | :merge

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

Name            | Types  | Description                                     | Default          | Used with...
--------------- | ------ | ----------------------------------------------- | ---------------- | ----------------
`publish_name`  | String | Publication name                                | <resource_name>  | all
`type`          | String | Publish type (snapshot or repo)                 | ''               | :create
`component`     | String | Component name to publish                       | []               | :create
`distribution`  | String | Distribution name to publish                    | ''               | :create
`architectures` | String | Only mentioned architectures would be published | ['amd64']        | :create
`endpoint`      | String | An optional endpoint reference                  | ''               | :create, :update
`prefix`        | String | An optional prefix for publishing               | ''               | :create, :update


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

Name     | Types             | Description                              | Default             | Used with...
-------- | ----------------- | ---------------------------------------- | ------------------- | ----------------
`listen` | String            | Specify IP address about HTTP listening  | '' (all interfaces) | :run
`port`   | [Integer, String] | Publish type (snapshot or repo)          | 8080                | :run
`user`   | String            | Run command as user                      | 'aptly'             | :run
`group`  | String            | Run command as group                     | 'aptly'             | :run

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

Name      | Types             | Description                              | Default             | Used with...
--------- | ----------------- | ---------------------------------------- | ------------------- | ----------------
`listen`  | String            | Specify IP address about HTTP listening  | '' (all interfaces) | :run
`port`    | [Integer, String] | Publish type (snapshot or repo)          | 8080                | :run
`user`    | String            | Run command as user                      | 'aptly'             | :run
`group`   | String            | Run command as group                     | 'aptly'             | :run
`no_lock` | [true, false]     | Don’t lock the database                  | false               | :run

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


Usage
-----

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


Contributing
---------------

Please refer to each project's style guidelines and guidelines for submitting patches and additions. In general, we follow the "fork-and-pull" Git workflow.

1. **Fork** the repo on GitHub
2. **Clone** the project to your own machine
3. **Commit** changes to your own branch
4. **Push** your work back up to your fork
5. Submit a **Pull request** so that we can review your changes

NOTE: Be sure to merge the latest from "upstream" before making a pull request!

Testing
-------

Please contribute to keep unit and functional tests up to date.
After modifications, please run the following commands to check if you break something:

   * chef exec rspec
   * kitchen test default-ubuntu-1804

NOTE: Available distro tests: `default-debian-8`, `default-debian-9`, `default-ubuntu-1604` and `default-ubuntu-1804`

NOTE2: if you want to use Policyfile, rename `Policyfile.rb.dist` to `Policyfile.rb` in root and test directories, then execute `chef update` in each folder. Look inside `.kitchen.yml` and `spec/spec_helper.rb` too.

 
License & Authors
-----------------
- Author:: Aaron Baer (aaron@hw-ops.com)
- Contributor:: Michael Lopez (mickael.lopez@gmail.com)

```text
Copyright 2014, Heavy Water Operations, LLC
Copyright 2018, Michael Lopez

Licensed under the Apache License, Version 2.0 (the 'License');
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an 'AS IS' BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
```
