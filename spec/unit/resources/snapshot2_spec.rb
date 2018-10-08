# frozen_string_literal: true
#
# Cookbook:: aptly
# Spec:: snapshot2
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
  describe 'Test publish resource' do
    let(:chef_run) do
      ChefSpec::SoloRunner.new(platform: platform, version: version, step_into: ['aptly_snapshot']).converge('aptly_spec::snapshot2')
      # ChefSpec::SoloRunner.new(platform: platform, version: version, step_into: ['aptly_snapshot']).converge('aptly::default')
    end

    # recipe do
    #  aptly_snapshot 'my_snapshot' do
    #   empty: true
    #   action :create
    # end
    # end

    context 'Create an empty snapshot' do
      before do
        stub_command('aptly snapshot -raw list | grep ^my_snapshot$').and_return(false)
        stub_command('aptly snapshot -raw list | grep ^merged-snapshot$').and_return(false)
      end
      it 'Run the custom resources' do
        expect(chef_run).to create_aptly_snapshot('my_snapshot').with(empty: true)
      end
      it 'Steps of resource' do
        expect(chef_run).to run_execute('Creating Empty Snapshot - my_snapshot')
      end
    end
  end
end
