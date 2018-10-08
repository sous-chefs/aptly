#
# Cookbook:: aptly_spec
# Recipe:: repo
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

aptly_repo 'my_repo' do
  comment 'A repository of packages'
  component 'main'
  distribution 'Ubuntu'
  action :create
end

aptly_repo 'my_repo' do
  action :drop
end

aptly_repo 'my_repo' do
  file '/etc/hosts'
  action :add
end

aptly_repo 'my_repo' do
  package_query 'hosts'
  action :remove
end
