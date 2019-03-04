#
# Cookbook Name:: aptly
# Library:: helpers
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

module Aptly
  module Helpers
    def aptly_env
      { 'HOME' => node['aptly']['rootDir'], 'USER' => node['aptly']['user'] }
    end

    def gpg_command
      case node['platform']
      when 'debian'
        node['platform_version'].to_i < 9 ? 'gpg' : 'gpg1'
      when 'ubuntu'
        node['platform_version'].to_f < 18.04 ? 'gpg' : 'gpg1'
      end
    end

    def filter_with_deps(a)
      a == true ? '-filter-with-deps' : ''
    end

    def with_udebs(u)
      u == true ? '-with-udebs' : ''
    end

    def architectures(a)
      a.empty? ? '' : "-architectures #{a}"
    end
  end
end

Chef::Recipe.send(:include, ::Aptly::Helpers)
Chef::Resource.send(:include, ::Aptly::Helpers)
