#
# Cookbook Name:: aptly
# Resource:: publish
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

require 'chef/resource/lwrp_base'
require File.expand_path('../cli_builder', __FILE__)

class Chef
  class Resource
    class AptlyPublish < Chef::Resource::LWRPBase
      include CLIBuilder

      self.resource_name = 'aptly_publish'

      actions :create, :update, :drop
      default_action :create if defined?(default_action)

      # Needed for Chef versions < 0.10.10
      def initialize(name = nil, run_context = nil)
        super
        @action = :create
      end

      attribute :name, :kind_of => String, :name_attribute => true
      attribute :type, :kind_of => String, :default => nil
      attribute :prefix, :kind_of => String, :default => nil

      attribute :distribution, :kind_of => String, :default => nil,
        cli_option: true, cli_actions: [ :create ]

      attribute :force_overwrite, :equal_to => [ true, false ], default: nil,
        cli_option: true, cli_actions: [ :create, :update ]

    end
  end
end
