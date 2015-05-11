#
# Cookbook Name:: aptly
# Library:: matchers
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

if defined?(ChefSpec)
  # Repo commands
  def create_aptly_repo(resource_name)
    ChefSpec::Matchers::ResourceMatcher.new(:aptly_repo, :create, resource_name)
  end

  def drop_aptly_repo(resource_name)
    ChefSpec::Matchers::ResourceMatcher.new(:aptly_repo, :drop, resource_name)
  end

  def add_aptly_repo(resource_name)
    ChefSpec::Matchers::ResourceMatcher.new(:aptly_repo, :add, resource_name)
  end

  def remove_aptly_repo(resource_name)
    ChefSpec::Matchers::ResourceMatcher.new(:aptly_repo, :remove, resource_name)
  end

  # Mirror commands
  def create_aptly_mirror(resource_name)
    ChefSpec::Matchers::ResourceMatcher.new(:aptly_mirror, :create, resource_name)
  end

  def update_aptly_mirror(resource_name)
    ChefSpec::Matchers::ResourceMatcher.new(:aptly_mirror, :update, resource_name)
  end

  def drop_aptly_mirror(resource_name)
    ChefSpec::Matchers::ResourceMatcher.new(:aptly_mirror, :drop, resource_name)
  end

  # Publish commands
  def create_aptly_publish(resource_name)
    ChefSpec::Matchers::ResourceMatcher.new(:aptly_publish, :create, resource_name)
  end

  def update_aptly_publish(resource_name)
    ChefSpec::Matchers::ResourceMatcher.new(:aptly_publish, :update, resource_name)
  end

  def drop_aptly_publish(resource_name)
    ChefSpec::Matchers::ResourceMatcher.new(:aptly_publish, :drop, resource_name)
  end

  def switch_aptly_publish(resource_name)
    ChefSpec::Matchers::ResourceMatcher.new(:aptly_publish, :switch, resource_name)
  end

  # Db commands
  def cleanup_aptly_db(resource_name)
    ChefSpec::Matchers::ResourceMatcher.new(:aptly_db, :cleanup, resource_name)
  end

  def recover_aptly_db(resource_name)
    ChefSpec::Matchers::ResourceMatcher.new(:aptly_db, :recover, resource_name)
  end

  # Snapshot commands
  def create_aptly_snapshot(resource_name)
    ChefSpec::Matchers::ResourceMatcher.new(:aptly_snapshot, :create, resource_name)
  end

  def verify_aptly_snapshot(resource_name)
    ChefSpec::Matchers::ResourceMatcher.new(:aptly_snapshot, :verify, resource_name)
  end

  def pull_aptly_snapshot(resource_name)
    ChefSpec::Matchers::ResourceMatcher.new(:aptly_snapshot, :pull, resource_name)
  end

  def merge_aptly_snapshot(resource_name)
    ChefSpec::Matchers::ResourceMatcher.new(:aptly_snapshot, :merge, resource_name)
  end

  def drop_aptly_snapshot(resource_name)
    ChefSpec::Matchers::ResourceMatcher.new(:aptly_snapshot, :drop, resource_name)
  end
end
