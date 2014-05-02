#
# Cookbook Name:: aptly
# Provider:: publish
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

use_inline_resources if defined?(use_inline_resources)

def whyrun_supported?
  true
end

action :create do
  execute "Publish #{new_resource.type} - #{new_resource.name}" do
    command "aptly publish #{new_resource.type} #{new_resource.name} #{new_resource.prefix}"
    user node['aptly']['user']
    group node['aptly']['group']
    environment aptly_env
    not_if %{ aptly publish list | grep #{new_resource.name} }
  end
end

action :update do
  execute "Updating distribution - #{new_resource.prefix} #{new_resource.name}" do
    command "aptly publish update #{new_resource.name} #{new_resource.prefix}"
    user node['aptly']['user']
    group node['aptly']['group']
    environment aptly_env
  end
end

action :drop do
  execute "Stop publishing - #{new_resource.prefix} #{new_resource.name}" do
    command "aptly publish drop #{new_resource.name} #{new_resource.prefix}"
    user node['aptly']['user']
    group node['aptly']['group']
    only_if %{ aptly publish list | grep #{new_resource.name} }
    environment aptly_env
  end
end
