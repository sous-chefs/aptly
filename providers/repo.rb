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
  execute "Creating Repo - #{new_resource.name}" do
    if !new_resource.comment.nil? || !new_resource.component.nil? || !new_resource.distribution.nil?
      command "aptly repo create -comment='#{new_resource.comment}' -component='#{new_resource.component}' -distribution='#{new_resource.distribution}' #{new_resource.name}"
    else
      command "aptly repo create #{new_resource.name}"
    end
    user node['aptly']['user']
    not_if %{ aptly repo list --raw | grep #{new_resource.name} }
  end
end

action :drop do
  execute "Droping Repo - #{new_resource.name}" do
    command "aptly repo drop #{new_resource.name}"
    user node['aptly']['user']
    only_if %{ aptly repo list --raw | grep #{new_resource.name} }
  end
end

action :add do
  if new_resource.file.nil?
    if ::Dir.exist?("#{new_resource.directory}")
      execute "Adding packages from #{new_resource.directory}" do
        command "aptly repo add #{new_resource.name} #{new_resource.directory}"
        user node['aptly']['user']
      end
    else
      Chef::Log.info "#{new_resource.directory} is not a valid directory"
    end
  elsif new_resource.directory.nil?
    if ::File.exists?("#{new_resource.file}")
      pkg = ::File.basename("#{new_resource.file}")
      pk = pkg.split('.').first
      execute "Adding Package - #{pkg}" do
        command "aptly repo add #{new_resource.name} #{new_resource.file}"
        user node['aptly']['user']
        not_if %{ aptly repo show -with-packages #{new_resource.name} | grep #{pk} }
      end
    else
      Chef::Log.info "#{new_resource.file} does not exist"
    end
  else
      Chef::Log.info "You must specify a file OR a directory"
  end
end

action :remove do
  pkg = ::File.basename("#{new_resource.file}").split('.').first
  execute "Removing Package - #{new_resource.file}" do
    command "aptly repo remove #{new_resource.name} #{pkg}"
    user node['aptly']['user']
    only_if %{ aptly repo show -with-packages #{new_resource.name} | grep #{pkg} }
  end
end

