# frozen_string_literal: true
#
# Cookbook:: aptly
# Spec:: mirror2
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

platforms = {
  'debian' => '9.5',
  'ubuntu' => '18.04',
}

platforms.each do |platform, version|
  describe 'Test mirror resource' do
    let(:chef_run) do
      ChefSpec::SoloRunner.new(platform: platform, version: version, step_into: ['aptly_mirror']).converge('aptly_spec::mirror2')
      # ChefSpec::SoloRunner.new(platform: platform, version: version, step_into: ['aptly_mirror']).converge('aptly::default')
    end

    # recipe do
    # aptly_mirror 'ubuntu-precise-main' do
    #   distribution 'precise'
    #   component 'main'
    #   cookbook 'aptly_spec'
    #   keyfile 'gpg_keyfile'
    #   filter 'my_awesome_package'
    #   action :create
    # end
    # end

    context 'Create action test with keyfile' do
      before do
        stub_command('aptly mirror -raw list | grep ^ubuntu-precise-main$').and_return(false)
      end
      it 'Run the custom resources' do
        expect(chef_run).to create_aptly_mirror('ubuntu-precise-main').with(component: 'main', distribution: 'precise', cookbook: 'aptly_spec', keyfile: 'gpg_keyfile', filter: 'my_awesome_package')
      end
      it 'Steps of resource' do
        expect(chef_run).to run_execute('Import system platform keyring')
        expect(chef_run).to create_if_missing_cookbook_file("#{Chef::Config['file_cache_path']}/gpg_keyfile")
        expect(chef_run).to run_execute('Installing external repository key from gpg_keyfile')
      end
    end
  end
end
