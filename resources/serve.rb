# frozen_string_literal: true
#
# Cookbook:: aptly
# Resource:: serve
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

property :listen, String, default: ''
property :port,   [Integer, String], default: 8080
property :user,   String, default: 'aptly'
property :group,  String, default: 'aptly'

action :run do
  execute 'Serve HTTP service for Aptly' do
    user new_resource.user
    group new_resource.group
    environment aptly_env
    command "screen -dmS aptly aptly serve -listen=\"#{new_resource.listen}:#{new_resource.port}\""
    only_if %(aptly publish list | grep -q -v "[N]o snapshots")
    not_if %(ps aux | grep -q "[a]ptly serve")
  end
end
