# frozen_string_literal: true
#
# Cookbook:: aptly
# Spec:: repo2
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
  'debian' => '9',
  'ubuntu' => '18.04',
}

platforms.each do |platform, version|
  describe 'Test repo resource' do
    let(:chef_run) do
      ChefSpec::SoloRunner.new(platform: platform, version: version, step_into: ['aptly_repo']).converge('aptly_spec::repo2')
      # ChefSpec::SoloRunner.new(platform: platform, version: version, step_into: ['aptly_repo']).converge('aptly::default')
    end

    # recipe do
    #  aptly_repo 'my_repo' do
    #    directory '/tmp/packages'
    #    action :add
    #  end
    # end

    context 'Add action with directory' do
      stubs_for_provider('aptly_repo[my_repo]') do |provider|
        allow(provider).to receive_shell_out('aptly repo list --raw', stdout: '')
        allow(provider).to receive_shell_out('aptly repo show -with-packages my_repo', stdout: '')
      end

      it 'Run the custom resources' do
        expect(chef_run).to add_aptly_repo('my_repo').with(directory: '/tmp')
      end
      it 'Steps of resource' do
        expect(chef_run).to run_execute('Adding packages from /tmp')
      end
    end
  end
end
