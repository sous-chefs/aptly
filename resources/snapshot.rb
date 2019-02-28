# frozen_string_literal: true
#
# Cookbook:: aptly
# Resource:: snapshot.rb
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

property :snapshot_name, String, name_property: true
property :from,          String, default: ''
property :type,          String, default: ''
property :empty,         [true, false], default: false
property :source,        String, default: ''
property :destination,   String, default: ''
property :merge_sources, Array, default: []
property :package_query, String, default: ''
property :no_deps,       [true, false], default: false
property :no_remove,     [true, false], default: false
property :latest,        [true, false], default: false

action :create do
  if new_resource.empty
    execute "Creating Empty Snapshot - #{new_resource.snapshot_name}" do
      command "aptly snapshot create #{new_resource.snapshot_name} empty"
      user node['aptly']['user']
      group node['aptly']['group']
      environment aptly_env
      not_if %(aptly snapshot -raw list | grep ^#{new_resource.snapshot_name}$)
    end
  else
    execute "Creating Snapshot - #{new_resource.snapshot_name}" do
      command "aptly snapshot create #{new_resource.snapshot_name} from #{new_resource.type} #{new_resource.from}"
      user node['aptly']['user']
      group node['aptly']['group']
      environment aptly_env
      not_if %(aptly snapshot -raw list | grep ^#{new_resource.snapshot_name}$)
    end
  end
end

action :verify do
  execute "Verifying - #{new_resource.snapshot_name}" do
    command "aptly snapshot verify #{new_resource.snapshot_name}"
    user node['aptly']['user']
    group node['aptly']['group']
    environment aptly_env
    only_if %(aptly snapshot -raw list | grep ^#{new_resource.snapshot_name}$)
  end
end

action :pull do
  opts = ''
  opts += ' -no-deps' if new_resource.no_deps
  opts += ' -no-remove' if new_resource.no_remove

  execute "Pull to - #{new_resource.snapshot_name}" do
    command "aptly snapshot pull#{opts} #{new_resource.snapshot_name} #{new_resource.source} #{new_resource.destination} #{new_resource.package_query}"
    user node['aptly']['user']
    group node['aptly']['group']
    environment aptly_env
    not_if %(aptly snapshot -raw list | grep ^#{new_resource.snapshot_name}$)
  end
end

action :merge do
  opts = ''
  opts += ' -latest' if new_resource.latest
  opts += ' -no-remove' if new_resource.no_remove
  flatten_sources = new_resource.merge_sources.join(' ')

  execute "Merge Snapshots #{flatten_sources} TO #{new_resource.snapshot_name}" do
    command "aptly snapshot merge#{opts} #{new_resource.snapshot_name} #{flatten_sources}"
    user node['aptly']['user']
    group node['aptly']['group']
    environment aptly_env
    not_if %(aptly snapshot -raw list | grep ^#{new_resource.snapshot_name}$)
  end
end

action :drop do
  execute "Drop Snapshot #{new_resource.snapshot_name}" do
    command "aptly snapshot drop #{new_resource.snapshot_name}"
    user node['aptly']['user']
    group node['aptly']['group']
    environment aptly_env
    only_if %(aptly snapshot -raw list | grep ^#{new_resource.snapshot_name}$)
  end
end
