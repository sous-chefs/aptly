#
# Cookbook Name:: aptly
# Provider:: snapshot
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
  if new_resource.empty
    execute "Creating Empty Snapshot - #{new_resource.name}" do
      command "aptly snapshot create #{new_resource.name} empty"
      user node['aptly']['user']
      group node['aptly']['group']
      environment aptly_env
      not_if %{ aptly snapshot -raw list | grep #{new_resource.name} }
    end
  else
    execute "Creating Snapshot - #{new_resource.name}" do
      command "aptly snapshot create #{new_resource.name} from #{new_resource.type} #{new_resource.from}"
      user node['aptly']['user']
      group node['aptly']['group']
      environment aptly_env
      not_if %{ aptly snapshot -raw list | grep #{new_resource.name} }
    end
  end
end

action :verify do
  execute "Verifying - #{new_resource.name}" do
    command "aptly snapshot verify #{new_resource.name}"
    user node['aptly']['user']
    group node['aptly']['group']
    environment aptly_env
    only_if %{ aptly snapshot -raw list | grep #{new_resource.name} }
  end
end

action :pull do
  execute "Pull to - #{new_resource.name}" do
    command "aptly snapshot pull -no-deps=#{new_resource.deps} -no-remove=#{new_resource.remove} #{new_resource.resource} #{new_resource.source} #{new_resource.name} #{new_resource.package}"
    user node['aptly']['user']
    group node['aptly']['group']
    environment aptly_env
    not_if %{ aptly snapshot -raw list | grep #{new_resource.name} }
  end
end

action :merge do
  execute "Merge Snapshots #{new_resource.merge_source1} - #{new_resource.merge_source2}" do
    command "aptly snapshot merge #{new_resource.name} #{new_resource.merge_source1} #{new_resource.merge_source2}"
    user node['aptly']['user']
    group node['aptly']['group']
    environment aptly_env
    not_if %{ aptly snapshot -raw list | grep #{new_resource.name} }
  end
end

action :drop do
  execute "Drop Snapshot #{new_resource.name}" do
    command "aptly snapshot drop #{new_resource.name}"
    user node['aptly']['user']
    group node['aptly']['group']
    environment aptly_env
    only_if %{ aptly snapshot -raw list | grep #{new_resource.name} }
  end
end
