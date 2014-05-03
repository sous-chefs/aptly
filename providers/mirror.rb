#
# Cookbook Name:: aptly
# Provider:: mirror
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

use_inline_resources if defined?(use_inline_resources)

def whyrun_supported?
  true
end

def install_key(keyid, keyserver)
  execute "Installing external repository key" do
    command "gpg --no-default-keyring --keyring trustedkeys.gpg --keyserver #{keyserver} --recv-keys #{keyid}"
    user node['aptly']['user']
    group node['aptly']['group']
    environment aptly_env
  end
end


action :create do
  if !new_resource.keyid.nil?
    install_key(new_resource.keyid, new_resource.keyserver)
  end
  execute "Creating mirror - #{new_resource.name}" do
    command "aptly mirror create #{new_resource.name} #{new_resource.uri} #{new_resource.distribution} #{new_resource.component}"
    user node['aptly']['user']
    group node['aptly']['group']
    environment aptly_env
    not_if %{ aptly mirror -raw list | grep #{new_resource.name} }
  end
end

action :update do
  execute "Updating mirror - #{new_resource.name}" do
    command "aptly mirror update #{new_resource.name}"
    user node['aptly']['user']
    group node['aptly']['group']
    environment aptly_env
    only_if %{ aptly mirror -raw list | grep #{new_resource.name} }
  end
end

action :drop do
  execute "Droping mirror - #{new_resource.name}" do
    command "aptly mirror drop #{new_resource.name}"
    user node['aptly']['user']
    group node['aptly']['group']
    environment aptly_env
    only_if %{ aptly mirror -raw list | grep #{new_resource.name} }
  end
end

