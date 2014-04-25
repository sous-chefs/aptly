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
include_recipe "aptly"

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
