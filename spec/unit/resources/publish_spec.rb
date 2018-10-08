# frozen_string_literal: true
#
# Cookbook:: aptly
# Spec:: publish
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
      ChefSpec::SoloRunner.new(platform: platform, version: version, step_into: ['aptly_publish']).converge('aptly_spec::publish')
      # ChefSpec::SoloRunner.new(platform: platform, version: version, step_into: ['aptly_publish']).converge('aptly::default')
    end

    # recipe do
    #  aptly_publish 'my_repo' do
    #    action :create
    #  end
    #  aptly_publish 'my_repo' do
    #    prefix 'foo'
    #    action :update
    #  end
    #
    #  aptly_publish 'my_repo' do
    #    prefix 'foo'
    #    action :drop
    # end

    context 'Create and Update action' do
      before do
        stub_command('aptly publish list | grep my_repo').and_return(false)
      end
      it 'Run the custom resources' do
        expect(chef_run).to create_aptly_publish('my_repo')
        expect(chef_run).to update_aptly_publish('my_repo').with(prefix: 'foo')
      end
      it 'Steps of resource' do
        expect(chef_run).to run_execute('Publish repo - my_repo')
        expect(chef_run).to run_execute('Updating distribution - foo my_repo')
      end
    end

    context 'Drop action' do
      before do
        stub_command('aptly publish list | grep my_repo').and_return(true)
      end
      it 'Run the custom resources' do
        expect(chef_run).to drop_aptly_publish('my_repo')
      end
      it 'Steps of resource' do
        expect(chef_run).to run_execute('Stop publishing - ./my_repo')
      end
    end
  end
end
