# frozen_string_literal: true
#
# Cookbook:: aptly
# Resource:: api_serve
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
provides :aptly_api_serve
unified_mode true
use '_partial/_common'

property :listen,  String
property :port,    [Integer, String], default: 8090
property :no_lock, [true, false], default: false

action :run do
  no_lock = new_resource.no_lock ? ' -no-lock' : ''

  execute 'Serve API service for Aptly' do
    user new_resource.user
    group new_resource.group
    environment resource_env
    command "screen -dmS aptly-api aptly api serve -listen=\"#{new_resource.listen}:#{new_resource.port}\"#{no_lock}"
    not_if %(ps aux | grep -q "[a]ptly api serve")
  end
end

action_class do
  def resource_env
    { 'HOME' => new_resource.root_dir, 'USER' => new_resource.user, 'TMPDIR' => new_resource.tmp_dir }
  end
end
