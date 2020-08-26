#
# Cookbook:: aptly
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

    def filter(f)
      f.empty? ? '' : " -filter '#{f}'"
    end

    def filter_with_deps(f)
      f == true ? ' -filter-with-deps' : ''
    end

    def dep_follow_all_variants(d)
      d == true ? ' -dep-follow-all-variants' : ''
    end

    def dep_follow_recommends(d)
      d == true ? ' -dep-follow-recommends' : ''
    end

    def dep_follow_source(d)
      d == true ? ' -dep-follow-source' : ''
    end

    def dep_follow_suggests(d)
      d == true ? ' -dep-follow-suggests' : ''
    end

    def dep_verbose_resolve(d)
      d == true ? ' -dep-verbose-resolve' : ''
    end

    def ignore_checksums(s)
      s == true ? ' -ignore-checksums' : ''
    end

    def ignore_signatures(s)
      s == true ? ' -ignore-signatures' : ''
    end

    def download_limit(l)
      l > 0 ? " -download-limit #{l}" : ''
    end

    def max_tries(m)
      m > 1 ? " -max-tries #{m}" : ''
    end

    def skip_existing_packages(s)
      s == true ? ' -skip-existing-packages' : ''
    end

    def with_installer(i)
      i == true ? ' -with-installer' : ''
    end

    def with_udebs(u)
      u == true ? ' -with-udebs' : ''
    end

    def architectures(arr)
      arr.empty? ? '' : " -architectures #{arr.join(',')}"
    end

    def mirror_exists?(m)
      shell_out("aptly mirror -raw list | grep ^#{m}$",
        user: node['aptly']['user'], environment: aptly_env).exitstatus == 0
    end

    def mirror_show(m)
      shell_out("aptly mirror show #{m}", user: node['aptly']['user'], environment: aptly_env)
    end

    def mirror_info(m)
      return unless mirror_exists?(m)
      cmd = mirror_show(m)
      # the output of aptly mirror show is broken into sections delimited
      # by a blank line. We're only interested in the first section
      output = cmd.stdout.split(/\n\n/).first
      # convert the output of the aptly mirror show command into a hash
      info = output.split(/\n/).map do |x|
        # the hash keys have spaces and hyphens replaced with underscore,
        # and periods are removed.
        k, v = x.split(/:\s*/, 2)
        [k.downcase().gsub('.', '').gsub(/(\s+|-)/, '_'), v]
      end.compact.to_h
      # convert the architectures to an array
      if info.key?('architectures')
        info['architectures'] = info['architectures'].split(/,\s*/)
      end
      # convert boolean values
      %w(download_sources download_udebs filter_with_deps).each do |k|
        if info.key?(k)
          info[k] = info[k] == 'yes'
        end
      end
      info
    end

    def mirror_command(res)
      if mirror_exists?(res.mirror_name)
        "aptly mirror edit#{with_installer(res.with_installer)}#{with_udebs(res.with_udebs)}#{architectures(res.architectures)}#{filter(res.filter)}#{filter_with_deps(res.filter_with_deps)}#{dep_follow_all_variants(res.dep_follow_all_variants)}#{dep_follow_recommends(res.dep_follow_recommends)}#{dep_follow_source(res.dep_follow_source)}#{dep_follow_suggests(res.dep_follow_suggests)}#{dep_verbose_resolve(res.dep_verbose_resolve)}#{ignore_signatures(res.ignore_signatures)} #{res.mirror_name}"
      else
        "aptly mirror create#{with_installer(res.with_installer)}#{with_udebs(res.with_udebs)}#{architectures(res.architectures)}#{filter(res.filter)}#{filter_with_deps(res.filter_with_deps)}#{dep_follow_all_variants(res.dep_follow_all_variants)}#{dep_follow_recommends(res.dep_follow_recommends)}#{dep_follow_source(res.dep_follow_source)}#{dep_follow_suggests(res.dep_follow_suggests)}#{dep_verbose_resolve(res.dep_verbose_resolve)}#{ignore_signatures(res.ignore_signatures)} #{res.mirror_name} #{res.uri} #{res.distribution} #{res.component}"
      end
    end
  end
end

Chef::Provider.include ::Aptly::Helpers
Chef::Recipe.include ::Aptly::Helpers
Chef::Resource.include ::Aptly::Helpers
