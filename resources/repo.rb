# frozen_string_literal: true
#
# Cookbook:: aptly
# Resource:: repo
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

property :repo_name,     String, name_property: true
property :component,     String, default: ''
property :comment,       String, default: ''
property :distribution,  String, default: ''
property :remove_files,  [true, false], default: false
property :force_replace, [true, false], default: false
property :directory,     String, default: ''
property :file,          String, default: ''
property :package_query, String, default: ''

action :create do
  opts = ''
  opts += " -comment='#{new_resource.comment}'" unless new_resource.comment.empty?
  opts += " -component='#{new_resource.component}'" unless new_resource.component.empty?
  opts += " -distribution='#{new_resource.distribution}'" unless new_resource.distribution.empty?

  execute "Creating Repo - #{new_resource.repo_name}" do
    command "aptly repo create#{opts} #{new_resource.repo_name}"
    user node['aptly']['user']
    group node['aptly']['group']
    environment aptly_env
    not_if %(aptly repo list --raw | grep #{new_resource.repo_name})
  end
end

action :drop do
  execute "Droping Repo - #{new_resource.repo_name}" do
    command "aptly repo drop #{new_resource.repo_name}"
    user node['aptly']['user']
    group node['aptly']['group']
    environment aptly_env
    only_if %(aptly repo list --raw | grep #{new_resource.repo_name})
  end
end

action :add do
  opts = ''
  opts += ' -force-replace' if new_resource.force_replace
  opts += ' -remove-files' if new_resource.remove_files

  if new_resource.file.empty?
    if ::Dir.exist?(new_resource.directory)
      execute "Adding packages from #{new_resource.directory}" do
        command "aptly repo add#{opts} #{new_resource.repo_name} #{new_resource.directory}"
        user node['aptly']['user']
        group node['aptly']['group']
        environment aptly_env
      end
    else
      Chef::Log.info "#{new_resource.directory} is not a valid directory"
    end
  elsif new_resource.directory.empty?
    if ::File.exist?(new_resource.file)
      pkg = ::File.basename(new_resource.file)
      pk = pkg.split('.').first
      execute "Adding Package - #{pkg}" do
        command "aptly repo add#{opts} #{new_resource.repo_name} #{new_resource.file}"
        user node['aptly']['user']
        group node['aptly']['group']
        environment aptly_env
        not_if %(aptly repo show -with-packages #{new_resource.repo_name} | grep #{pk})
      end
    else
      Chef::Log.info "#{new_resource.file} does not exist"
    end
  else
    Chef::Log.info 'You must specify a file OR a directory'
  end
end

action :remove do
  execute "Removing Package - #{new_resource.package_query}" do
    command "aptly repo remove #{new_resource.repo_name} #{new_resource.package_query}"
    user node['aptly']['user']
    group node['aptly']['group']
    environment aptly_env
    only_if %(aptly repo show -with-packages #{new_resource.repo_name} | grep #{new_resource.package_query})
  end
end
