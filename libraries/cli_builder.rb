#
# Cookbook Name:: aptly
#
# Copyright 2014, Mathieu Sauve-Frankel
# Copyright 2013, Noah Kantrowicz
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

module CLIBuilder
  module ClassMethods
    def attribute(name, options={})
      is_cli_option = options.delete(:cli_option)

      if is_cli_option and not self.cli_options.member?(name)
        cli_actions = options.delete(:cli_actions)
        if cli_actions
          cli_actions.each do |action|
            cli_options[action.to_sym] = [] unless cli_options.has_key?(action)
            cli_options[action.to_sym] << name
          end
        else
          cli_options[:all] = [] unless cli_options.has_key?(:all)
          cli_options[:all] << name
        end
      end

      super
    end

    def cli_options
      @cli_options ||= if superclass.respond_to?('cli_options')
        superclass.cli_options.dup
      else
        {}
      end
    end

    def included(klass)
      super
      klass.extend ClassMethods
    end
  end

  extend ClassMethods

  def cli_args(action = :all)
    if self.class.cli_options.has_key?(action)
      argv = self.class.cli_options[action].map {|opt|
        val = send(opt)
        if val
          "-#{opt.to_s.gsub(/_/, '-')} #{send(opt)}"
        else
          nil
        end
      }
      argv.join(' ')
    else
      nil
    end
  end
end
