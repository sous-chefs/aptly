#
# Cookbook Name:: aptly
# Resource:: snapshot
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

actions :create, :verify, :pull, :merge, :drop
default_action :create if defined?(default_action)

# Needed for Chef versions < 0.10.10
def initialize(*args)
  super
  @action = :create
end

attribute :name, :kind_of => String, :name_attribute => true
attribute :from, :kind_of => String, :default => nil
attribute :type, :kind_of => String, :default => nil
attribute :empty, :kind_of => [TrueClass, FalseClass], :default => false
attribute :source, :kind_of => String, :default => nil
attribute :merge_source1, :kind_of => String, :default => nil
attribute :merge_source2, :kind_of => String, :default => nil
attribute :resource, :kind_of => String, :default => nil
attribute :package, :kind_of => String, :default => nil
attribute :deps, :kind_of => [TrueClass, FalseClass], :default => false
attribute :remove, :kind_of => [TrueClass, FalseClass], :default => false
attribute :latest, :kind_of => [TrueClass, FalseClass], :default => false
