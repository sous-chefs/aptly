# frozen_string_literal: true
#
# Cookbook:: aptly
# Resource:: db
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
provides :aptly_db
unified_mode true
use '_partial/_common'

action :cleanup do
  execute 'DB Cleanup' do
    command 'aptly db cleanup'
    user new_resource.user
    group new_resource.group
    environment resource_env
  end
end

action :recover do
  execute 'DB Recover' do
    command 'aptly db recover'
    user new_resource.user
    group new_resource.group
    environment resource_env
  end
end

action_class do
  def resource_env
    { 'HOME' => new_resource.root_dir, 'USER' => new_resource.user, 'TMPDIR' => new_resource.tmp_dir }
  end
end
