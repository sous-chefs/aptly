# frozen_string_literal: true
#
# Cookbook:: aptly
# Spec:: snapshot
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
  describe 'Test snapshot resource' do
    let(:chef_run) do
      ChefSpec::SoloRunner.new(platform: platform, version: version, step_into: ['aptly_snapshot']).converge('aptly_spec::snapshot')
      # ChefSpec::SoloRunner.new(platform: platform, version: version, step_into: ['aptly_snapshot']).converge('aptly::default')
    end

    # recipe do
    #  aptly_snapshot 'my_snapshot' do
    #   from 'my_repo'
    #   type 'repo'
    #   action :create
    # end
    # aptly_snapshot 'my_snapshot' do
    #   action :drop
    # end
    # aptly_snapshot 'merged-snapshot' do
    #   merge_source1 'snap1'
    #   merge_source2 'snap2'
    #   action :merge
    # end
    # aptly_snapshot 'merged-snapshot' do
    #   action :verify
    # end
    # aptly_snapshot 'merged-snapshot' do
    #   no_deps false
    #   no_remove false
    #   package '/etc/hosts'
    #   source 'snap2'
    #   action :pull
    # end
    # end

    context 'Create non empty snapshot with Merge and Pull actions' do
      before do
        stub_command('aptly snapshot -raw list | grep ^my_snapshot$').and_return(false)
        stub_command('aptly snapshot -raw list | grep ^merged-snapshot$').and_return(false)
      end
      it 'Run the custom resources' do
        expect(chef_run).to create_aptly_snapshot('my_snapshot').with(from: 'my_repo', type: 'repo')
        expect(chef_run).to merge_aptly_snapshot('merged-snapshot').with(merge_sources: %w(snap1 snap2))
        expect(chef_run).to pull_aptly_snapshot('merged-snapshot').with(no_deps: false, no_remove: false, package_query: 'hosts', source: 'snap2')
      end
      it 'Steps of resource' do
        expect(chef_run).to run_execute('Creating Snapshot - my_snapshot')
        expect(chef_run).to run_execute('Merge Snapshots snap1 snap2 TO merged-snapshot')
        expect(chef_run).to run_execute('Pull to - merged-snapshot')
      end
    end

    context 'Drop and Verify action' do
      before do
        stub_command('aptly snapshot -raw list | grep ^my_snapshot$').and_return(true)
        stub_command('aptly snapshot -raw list | grep ^merged-snapshot$').and_return(true)
      end
      it 'Run the custom resources' do
        expect(chef_run).to verify_aptly_snapshot('merged-snapshot')
        expect(chef_run).to drop_aptly_snapshot('my_snapshot')
      end
      it 'Steps of resource' do
        expect(chef_run).to run_execute('Verifying - merged-snapshot')
        expect(chef_run).to run_execute('Drop Snapshot my_snapshot')
      end
    end
  end
end
