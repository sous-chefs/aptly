# frozen_string_literal: true
#
# Cookbook:: aptly
# Spec:: repo
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
  describe 'Test repo resource' do
    let(:chef_run) do
      ChefSpec::SoloRunner.new(platform: platform, version: version, step_into: ['aptly_repo']).converge('aptly_spec::repo')
      # ChefSpec::SoloRunner.new(platform: platform, version: version, step_into: ['aptly_repo']).converge('aptly::default')
    end

    # recipe do
    #  aptly_repo 'my_repo' do
    #    comment 'A repository of packages'
    #    component 'main'
    #    distribution 'Ubuntu'
    #    action :create
    #  end

    #  aptly_repo 'my_repo' do
    #    action :drop
    #  end

    #  aptly_repo 'my_repo' do
    #    file '/tmp/package-1.0.1.deb'
    #    action :add
    #  end

    #  aptly_repo 'my_repo' do
    #    directory '/tmp/packages'
    #    action :add
    #  end

    #  aptly_repo 'my_repo' do
    #    package_query 'package-1.0.1.deb'
    #    action :remove
    #  end
    # end

    context 'Create action test' do
      before do
        stub_command('aptly repo list --raw | grep my_repo').and_return(false)
        stub_command('aptly repo show -with-packages my_repo | grep hosts').and_return(false)
      end
      it 'Run the custom resources' do
        expect(chef_run).to create_aptly_repo('my_repo').with(comment: 'A repository of packages', component: 'main', distribution: 'Ubuntu')
      end
      it 'Steps of resource' do
        expect(chef_run).to run_execute('Creating Repo - my_repo')
      end
    end

    context 'Add action with file' do
      before do
        stub_command('aptly repo list --raw | grep my_repo').and_return(true)
        stub_command('aptly repo show -with-packages my_repo | grep hosts').and_return(false)
      end
      it 'Run the custom resources' do
        expect(chef_run).to add_aptly_repo('my_repo').with(file: '/etc/hosts')
      end
      it 'Steps of resource' do
        expect(chef_run).to run_execute('Adding Package - hosts')
      end
    end

    context 'Drop and remove action' do
      before do
        stub_command('aptly repo list --raw | grep my_repo').and_return(true)
        stub_command('aptly repo show -with-packages my_repo | grep hosts').and_return(true)
      end
      it 'Run the custom resources' do
        expect(chef_run).to drop_aptly_repo('my_repo')
        expect(chef_run).to remove_aptly_repo('my_repo').with(package_query: 'hosts')
      end
      it 'Steps of resource' do
        expect(chef_run).to run_execute('Droping Repo - my_repo')
        expect(chef_run).to run_execute('Removing Package - hosts')
      end
    end
  end
end
