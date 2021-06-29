# frozen_string_literal: true
#
# Cookbook:: aptly
# Spec:: mirror
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

require 'spec_helper'

# platforms = {
#   'debian' => '9',
#   'ubuntu' => '18.04',
# }

# platforms.each do |platform, version|
#   describe 'Test mirror resource' do
#     let(:chef_run) do
#       ChefSpec::SoloRunner.new(platform: platform, version: version, step_into: ['aptly_mirror']).converge('aptly_spec::mirror')
#     end

#     stubs_for_provider('aptly_mirror[ubuntu-precise-main]') do |provider|
#       allow(provider).to receive_shell_out('aptly mirror -raw list | grep ^ubuntu-precise-main$', { user: 'aptly', timeout: 3600.0, environment: { 'HOME' => '/opt/aptly', 'USER' => 'aptly' } }, stdout: '', stderr: '', exitstatus: 1)
#     end

#     stubs_for_resource('aptly_mirror[ubuntu-precise-main]') do |resource|
#       allow(resource).to receive_shell_out('aptly mirror -raw list | grep ^ubuntu-precise-main$', { user: 'aptly', environment: { 'HOME' => '/opt/aptly', 'USER' => 'aptly' } }, stdout: '', stderr: '', exitstatus: 1)
#       allow(resource).to receive_shell_out('aptly mirror show ubuntu-precise-main', exitstatus: 1)
#     end

#     stubs_for_resource() do |resource|
#       allow(resource).to receive_shell_out('aptly mirror -raw list | grep ^ubuntu-precise-main$', { user: 'aptly', environment: { 'HOME' => '/opt/aptly', 'USER' => 'aptly' } }, stdout: 'ubuntu-precise-main')
#       allow(resource).to receive_shell_out('aptly mirror show ubuntu-precise-main', stdout: mirror_show_after_create_stdout)
#     end

#     context 'Create action test' do
#       stubs_for_resource('execute[Creating mirror - ubuntu-precise-main]') do |resource|
#         allow(resource).to receive_shell_out('aptly mirror -raw list | grep ^ubuntu-precise-main$', { user: 'aptly', environment: { 'HOME' => '/opt/aptly', 'USER' => 'aptly' } }, stdout: '', stderr: '', exitstatus: 1)
#         allow(resource).to receive_shell_out('aptly mirror show ubuntu-precise-main', exitstatus: 1)
#       end

#       before do
#         stub_command('gpg --keyring trustedkeys.gpg --list-keys 437D05B5').and_return(false)
#         stub_command('gpg1 --keyring trustedkeys.gpg --list-keys 437D05B5').and_return(false)
#       end
#       it 'Run the custom resources' do
#         expect(chef_run).to create_aptly_mirror('ubuntu-precise-main').with(component: 'main', distribution: 'precise', keyid: '437D05B5', keyserver: 'keys.gnupg.net', uri: 'http://ubuntu.osuosl.org/ubuntu/', filter: 'my_awesome_package')
#       end
#       it 'Steps of resource' do
#         expect(chef_run).to run_execute('Installing external repository key')
#         expect(chef_run).to run_execute('Import system platform keyring')
#         expect(chef_run).to run_execute('Creating mirror - ubuntu-precise-main')
#       end
#     end

#     context 'Update and Drop action test' do
#       before do
#         stub_command('gpg --keyring trustedkeys.gpg --list-keys 437D05B5').and_return(false)
#         stub_command('gpg1 --keyring trustedkeys.gpg --list-keys 437D05B5').and_return(false)
#       end
#       it 'Run the custom resources' do
#         expect(chef_run).to update_aptly_mirror('ubuntu-precise-main')
#         expect(chef_run).to drop_aptly_mirror('ubuntu-precise-main')
#       end
#       it 'Steps of resource' do
#         expect(chef_run).to run_execute('Updating mirror - ubuntu-precise-main')
#         expect(chef_run).to run_execute('Droping mirror - ubuntu-precise-main')
#       end
#     end
#   end
# end
