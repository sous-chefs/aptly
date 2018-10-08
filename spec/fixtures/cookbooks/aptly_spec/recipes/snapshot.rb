#
# Cookbook:: aptly_spec
# Recipe:: snapshot
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

aptly_snapshot 'my_snapshot' do
  from 'my_repo'
  type 'repo'
  action :create
end
aptly_snapshot 'my_snapshot' do
  action :drop
end
aptly_snapshot 'merged-snapshot' do
  merge_sources %w(snap1 snap2)
  action :merge
end
aptly_snapshot 'merged-snapshot' do
  action :verify
end
aptly_snapshot 'merged-snapshot' do
  no_deps false
  no_remove false
  package_query 'hosts'
  source 'snap2'
  action :pull
end
