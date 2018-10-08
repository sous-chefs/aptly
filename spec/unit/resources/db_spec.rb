# frozen_string_literal: true
#
# Cookbook:: aptly
# Spec:: db
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
  describe 'Test db resource' do
    let(:chef_run) do
      ChefSpec::SoloRunner.new(platform: platform, version: version, step_into: ['aptly_db']).converge('aptly_spec::db')
      # ChefSpec::SoloRunner.new(platform: platform, version: version, step_into: ['aptly_db']).converge('aptly::default')
    end

    # recipe do
    #  aptly_db 'cleanup' do
    #    action :cleanup
    #  end
    #  aptly_db 'recover' do
    #    action :recover
    #  end
    # end

    it 'Run the custom resources' do
      expect(chef_run).to cleanup_aptly_db('cleanup')
      expect(chef_run).to recover_aptly_db('recover')
    end

    it 'Steps of resource' do
      expect(chef_run).to run_execute('DB Cleanup')
      expect(chef_run).to run_execute('DB Recover')
    end
  end
end
