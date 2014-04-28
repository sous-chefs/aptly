aptly Cookbook
=====

This cookbook installs and configures aptly (http://www.aptly.info)

Requirements
------------

### Platform

* Ubuntu 12.04
* Ubuntu 14.04

Attributes
----------

* `default['aptly']['uri'] = 'http://repo.aptly.info/'`
* `default['aptly']['dist'] = "squeeze"`
* `default['aptly']['components'] = ['main']`
* `default['aptly']['keyserver'] = 'keys.gnupg.net'`
* `default['aptly']['key'] = '2A194991'`
* `default['aptly']['user'] = 'aptly'`
* `default['aptly']['group'] = 'aptly'`
* `default['aptly']['rootdir'] = "/opt/aptly"`
* `default['aptly']['downloadconcurrency'] = 4`
* `default['aptly']['architectures'] = []`
* `default['aptly']['dependencyfollowsuggests'] = false`
* `default['aptly']['dependencyfollowrecommends'] = false`
* `default['aptly']['dependencyfollowallvariants'] = false`
* `default['aptly']['dependencyfollowsource'] = false`
* `default['aptly']['gpgdisablesign'] = false`
* `default['aptly']['gpgdisableverify'] = false`
* `default['aptly']['downloadsourcepackages'] = false`
* `default['aptly']['ppadistributorid'] = ""`
* `default['aptly']['ppacodename'] = ""`

Recipes
-------
### `default`

Installs aptly

Usage
-----
### add to run_list

### include recipe
`include_recipe "aptly"`

Examples
---------

```ruby
aptly_repo "myrepo" do
  action :create
  comment "A repository of packages"
  component "main"
  distribution "Ubuntu"
end
```

```ruby
aptly_repo "myrepo" do
  action :create
end
```

```ruby
aptly_repo "myrepo" do
  action :drop
end
```

```ruby
aptly_repo "myrepo" do
  action :add
  file "/path/to/package-1.0.1.deb"
end
```

```ruby
aptly_repo "myrepo" do
  action :add
  directory "/path/to/packages"
end
```

```ruby
aptly_repo "myrepo" do
  action :remove
  file "/path/to/package-1.0.1.deb"
end
```

```ruby
aptly_mirror "ubuntu-precise-main" do
  action :create
  distribution "precise"
  component "main"
  keyid "437D05B5"
  keyserver "keys.gnupg.net"
  uri "http://ubuntu.osuosl.org/ubuntu/"
end
```

```ruby
aptly_mirror "ubuntu-precise-main" do
  action :update
end
```

```ruby
aptly_mirror "ubuntu-precise-main" do
  action :drop
end
```

```ruby
aptly_snapshot "pulltest" do
  action :create
  from "myrepo"
  type "repo"
  empty false
end
```

```ruby
aptly_snapshot "pulltest" do
  action :drop
end
```

```ruby
aptly_snapshot "merged-snapshot" do
  action :merge
  merge_source1 "pullrepo1"
  merge_source2 "pullrepo2"
end
```

```ruby
aptly_snapshot "merged-snapshot" do
  action :verify
end
```

```ruby
aptly_snapshot "pulledpork" do
  action :pull
  deps false
  remove false
  package "package-1.0.1"
  resource "pullrepo1"
  source "pullrepo2"
end
```

```ruby
aptly_publish "myrepo" do
  action :create
  type "repo"
  prefix "foo"
end
```

```ruby
aptly_publish "pulledpork" do
  action :create
  type "snapshot"
  prefix "bar"
end
```

```ruby
aptly_publish "mycompany" do
  action :update
  prefix "foo"
end
```

```ruby
aptly_publish "mycompany" do
  action :drop
  prefix "foo"
end
```

```ruby
aptly_db "cleanup" do
  action :cleanup
end
```

```ruby
aptly_db "recover" do
  action :recover
end
```


License & Authors
-----------------
- Author:: Aaron Baer (aaron@hw-ops.com)

```text
Copyright 2014, Heavy Water Operations, LLC

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
```
