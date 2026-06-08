# frozen_string_literal: true

require 'shellwords'

module Aptly
  module Helpers
    def aptly_command(*args)
      Shellwords.join(args.flatten.compact.reject { |arg| arg.to_s.empty? }.map(&:to_s))
    end

    def aptly_env(resource = self)
      {
        'HOME' => aptly_property(resource, :root_dir),
        'USER' => aptly_property(resource, :user),
        'TMPDIR' => aptly_property(resource, :tmp_dir) || '/tmp',
      }
    end

    def filter(f)
      f.empty? ? '' : " -filter #{Shellwords.escape(f)}"
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
      arr.empty? ? '' : " -architectures #{Shellwords.escape(arr.join(','))}"
    end

    def mirror_create_options(res)
      args = []
      args << '-with-installer' if res.with_installer
      args << '-with-udebs' if res.with_udebs
      args.push('-architectures', res.architectures.join(',')) unless res.architectures.empty?
      args.push('-filter', res.filter) unless res.filter.empty?
      args << '-filter-with-deps' if res.filter_with_deps
      args << '-dep-follow-all-variants' if res.dep_follow_all_variants
      args << '-dep-follow-recommends' if res.dep_follow_recommends
      args << '-dep-follow-source' if res.dep_follow_source
      args << '-dep-follow-suggests' if res.dep_follow_suggests
      args << '-dep-verbose-resolve' if res.dep_verbose_resolve
      args << '-ignore-signatures' if res.ignore_signatures
      args
    end

    def mirror_update_options(res)
      args = []
      args << '-dep-follow-all-variants' if res.dep_follow_all_variants
      args << '-dep-follow-recommends' if res.dep_follow_recommends
      args << '-dep-follow-source' if res.dep_follow_source
      args << '-dep-follow-suggests' if res.dep_follow_suggests
      args << '-dep-verbose-resolve' if res.dep_verbose_resolve
      args << '-ignore-checksums' if res.ignore_checksums
      args << '-ignore-signatures' if res.ignore_signatures
      args.push('-download-limit', res.download_limit) if res.download_limit > 0
      args.push('-max-tries', res.max_tries) if res.max_tries > 1
      args << '-skip-existing-packages' if res.skip_existing_packages
      args
    end

    def mirror_exists?(mirror_name, resource = self)
      cmd = shell_out(aptly_command('aptly', 'mirror', '-raw', 'list'),
        user: aptly_property(resource, :user),
        environment: aptly_env(resource))
      cmd.exitstatus == 0 && cmd.stdout.lines.any? { |line| line.chomp == mirror_name }
    end

    def mirror_show(mirror_name, resource = self)
      shell_out(aptly_command('aptly', 'mirror', 'show', mirror_name),
        user: aptly_property(resource, :user),
        environment: aptly_env(resource))
    end

    def mirror_info(mirror_name, resource = self)
      return unless mirror_exists?(mirror_name, resource)

      cmd = mirror_show(mirror_name, resource)
      # the output of aptly mirror show is broken into sections delimited
      # by a blank line. We're only interested in the first section
      output = cmd.stdout.split("\n\n").first
      # convert the output of the aptly mirror show command into a hash
      info = output.split("\n").map do |x|
        # the hash keys have spaces and hyphens replaced with underscore,
        # and periods are removed.
        k, v = x.split(/:\s*/, 2)
        [k.downcase.gsub('.', '').gsub(/(\s+|-)/, '_'), v]
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
      if mirror_exists?(res.mirror_name, res)
        aptly_command('aptly', 'mirror', 'edit', *mirror_create_options(res), res.mirror_name)
      else
        aptly_command('aptly', 'mirror', 'create', *mirror_create_options(res), res.mirror_name, res.uri, res.distribution, res.component)
      end
    end

    def mirror_update_command(res)
      aptly_command('aptly', 'mirror', 'update', *mirror_update_options(res), res.mirror_name)
    end

    def mirror_drop_command(res)
      aptly_command('aptly', 'mirror', 'drop', res.mirror_name)
    end

    def aptly_property(resource, property_name)
      resource.public_send(property_name)
    end
  end
end

Chef::Resource.include ::Aptly::Helpers
