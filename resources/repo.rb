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
require 'shellwords'

provides :aptly_repo
unified_mode true
use '_partial/_common'

property :repo_name,     String, name_property: true
property :component,     String
property :comment,       String
property :distribution,  String
property :remove_files,  [true, false], default: false
property :force_replace, [true, false], default: false
property :directory,     String
property :file,          String
property :package_query, String

action :create do
  opts = ''
  opts += " -comment=#{Shellwords.escape(new_resource.comment)}" unless new_resource.comment.nil? || new_resource.comment.empty?
  opts += " -component=#{Shellwords.escape(new_resource.component)}" unless new_resource.component.nil? || new_resource.component.empty?
  opts += " -distribution=#{Shellwords.escape(new_resource.distribution)}" unless new_resource.distribution.nil? || new_resource.distribution.empty?

  execute "Creating Repo - #{new_resource.repo_name}" do
    command "aptly repo create#{opts} #{Shellwords.escape(new_resource.repo_name)}"
    user new_resource.user
    group new_resource.group
    environment resource_env
    not_if { repo_exists?(new_resource.repo_name) }
  end
end

action :drop do
  execute "Droping Repo - #{new_resource.repo_name}" do
    command "aptly repo drop #{Shellwords.escape(new_resource.repo_name)}"
    user new_resource.user
    group new_resource.group
    environment resource_env
    only_if { repo_exists?(new_resource.repo_name) }
  end
end

action :add do
  opts = ''
  opts += ' -force-replace' if new_resource.force_replace
  opts += ' -remove-files' if new_resource.remove_files

  if new_resource.directory && !new_resource.file
    if ::Dir.exist?(new_resource.directory)
      execute "Adding packages from #{new_resource.directory}" do
        command "aptly repo add#{opts} #{Shellwords.escape(new_resource.repo_name)} #{Shellwords.escape(new_resource.directory)}"
        user new_resource.user
        group new_resource.group
        environment resource_env
      end
    else
      Chef::Log.info "#{new_resource.directory} is not a valid directory"
    end
  elsif new_resource.file && !new_resource.directory
    if ::File.exist?(new_resource.file)
      pkg = ::File.basename(new_resource.file)
      pk = pkg.split('.').first
      execute "Adding Package - #{pkg}" do
        command "aptly repo add#{opts} #{Shellwords.escape(new_resource.repo_name)} #{Shellwords.escape(new_resource.file)}"
        user new_resource.user
        group new_resource.group
        environment resource_env
        not_if { package_exists?(new_resource.repo_name, pk) }
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
    command "aptly repo remove #{Shellwords.escape(new_resource.repo_name)} #{Shellwords.escape(new_resource.package_query)}"
    user new_resource.user
    group new_resource.group
    environment resource_env
    only_if { package_exists?(new_resource.repo_name, new_resource.package_query) }
  end
end

action_class do
  include ::Aptly::Helpers

  def resource_env
    { 'HOME' => new_resource.root_dir, 'USER' => new_resource.user, 'TMPDIR' => new_resource.tmp_dir }
  end

  def repo_exists?(repo_name)
    cmd = shell_out(aptly_command('aptly', 'repo', 'list', '--raw'), user: new_resource.user, group: new_resource.group, environment: resource_env)
    cmd.exitstatus == 0 && cmd.stdout.lines.any? { |line| line.chomp == repo_name }
  end

  def package_exists?(repo_name, package_query)
    cmd = shell_out(aptly_command('aptly', 'repo', 'show', '-with-packages', repo_name), user: new_resource.user, group: new_resource.group, environment: resource_env)
    cmd.exitstatus == 0 && cmd.stdout.include?(package_query)
  end
end
