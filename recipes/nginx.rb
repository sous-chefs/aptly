#
# Author:: Claudio Cesar Sanchez Tejeda <demonccc@gmail.com>
# Cookbook Name:: aptly
# Recipe:: nginx
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

include_recipe "nginx"

service "nginx" do
  supports :status => true, :restart => true, :reload => true
  action [:enable, :start]
end

template "#{node['nginx']['dir']}/sites-available/aptly" do
  source "nginx_site.erb"
  group "www-data"
  notifies :restart, "service[nginx]", :delayed
end

nginx_site "aptly" do
  enable true
end

execute "export_public_gpg_key" do
  command "sudo -u #{node['aptly']['user']} -i gpg --export --armor `gpg -K | grep \"sec.*2048R\" | awk '{print $2}' | sed 's/2048R\///g'` > #{node["aptly"]["public"]["key"]}"
  creates node["aptly"]["public"]["key"]
end
