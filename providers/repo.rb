#
# Cookbook Name:: aptly
# Provider:: repo
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
  repo_name = new_resource.repo || new_resource.name
  execute "Creating Repo - #{new_resource.name}" do
    if !new_resource.comment.nil? || !new_resource.component.nil? || !new_resource.distribution.nil?
      command "aptly repo create -comment='#{new_resource.comment}' -component='#{new_resource.component}' -distribution='#{new_resource.distribution}' #{repo_name}"
    else
      command "aptly repo create #{repo_name}"
    end
    user node['aptly']['user']
    group node['aptly']['group']
    environment aptly_env
    not_if %{ aptly repo list --raw | grep #{repo_name} }
  end
end

action :drop do
  repo_name = new_resource.repo || new_resource.name
  execute "Droping Repo - #{new_resource.name}" do
    command "aptly repo drop #{repo_name}"
    user node['aptly']['user']
    group node['aptly']['group']
    environment aptly_env
    only_if %{ aptly repo list --raw | grep #{repo_name} }
  end
end

action :add do
  repo_name = new_resource.repo || new_resource.name
  if new_resource.file.nil?
    if ::Dir.exist?("#{new_resource.directory}")
      execute "Adding packages from #{new_resource.directory}" do
        if new_resource.remove_files
          command "aptly repo add -remove-files #{repo_name} #{new_resource.directory}"
        else
          command "aptly repo add #{repo_name} #{new_resource.directory}"
        end
        user node['aptly']['user']
        group node['aptly']['group']
        environment aptly_env
      end
    else
      Chef::Log.info "#{new_resource.directory} is not a valid directory"
    end
  elsif new_resource.directory.nil?
    if ::File.exists?("#{new_resource.file}")
      pkg = ::File.basename("#{new_resource.file}")
      pk = pkg.split('.').first
      execute "Adding Package - #{pkg}" do
        command "aptly repo add #{repo_name} #{new_resource.file}"
        user node['aptly']['user']
        group node['aptly']['group']
        environment aptly_env
        not_if %{ aptly repo show -with-packages #{repo_name} | grep #{pk} }
      end
    else
      Chef::Log.info "#{new_resource.file} does not exist"
    end
  else
      Chef::Log.info "You must specify a file OR a directory"
  end
end

action :remove do
  repo_name = new_resource.repo || new_resource.name
  pkg = ::File.basename("#{new_resource.file}").split('.').first
  execute "Removing Package - #{new_resource.file}" do
    command "aptly repo remove #{repo_name} #{pkg}"
    user node['aptly']['user']
    group node['aptly']['group']
    environment aptly_env
    only_if %{ aptly repo show -with-packages #{repo_name} | grep #{pkg} }
  end
end

