#
# Author:: Claudio Cesar Sanchez Tejeda <demonccc@gmail.com>
# Cookbook Name:: aptly
# Recipe:: databag
#
# Copyright 2015, Claudio Cesar Sanchez Tejeda
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

data_bag(node['aptly']['repos']['databag']).each do |repo|
  aptly_repo repo do
    data_bag_item(node['aptly']['repos']['databag'], repo).each do |k,v|
      send(k, v) unless k.eql?('id')
    end
  end
end
