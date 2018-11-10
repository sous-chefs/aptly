# frozen_string_literal: true
#
# Cookbook:: aptly
# Spec:: api_serve
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
require 'chefspec'

platforms = {
  'debian' => '9.5',
  'ubuntu' => '18.04',
}

platforms.each do |platform, version|
  describe 'Test api_serve resource' do
    let(:chef_run) do
      ChefSpec::SoloRunner.new(platform: platform, version: version, step_into: ['aptly_api_serve']).converge('aptly_spec::api_serve')
      # ChefSpec::SoloRunner.new(platform: platform, version: version, step_into: ['aptly_api_serve']).converge('aptly::default')
    end

    # recipe do
    #  aptly_api_serve 'Start API HTTP Service' do
    #    port 9090
    #  end
    # end

    before do
      stub_command('getent aptly passwd').and_return(true)
      stub_command('ps aux | grep -q "[a]ptly api serve"').and_return(false)
    end

    it 'Run the custom resource' do
      expect(chef_run).to run_aptly_api_serve('Start API HTTP Service')
    end

    it 'Steps of resource' do
      expect(chef_run).to run_execute('Serve API service for Aptly')
    end
  end
end
