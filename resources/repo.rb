#
# Cookbook Name:: aptly
# Resource:: repo
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

actions :create, :drop, :add, :remove
default_action :create if defined?(default_action)

# Needed for Chef versions < 0.10.10
def initialize(*args)
  super
  @action = :create
end

attribute :name, :kind_of => String, :name_attribute => true
attribute :repo, :kind_of => String, :default => nil
attribute :component, :kind_of => String, :default => nil
attribute :comment, :kind_of => String, :default => nil
attribute :distribution, :kind_of => String, :default => nil
attribute :remove_files, :kind_of => [TrueClass, FalseClass], :default => false
attribute :directory, :kind_of => String, :default => nil
attribute :file, :kind_of => String, :default => nil
