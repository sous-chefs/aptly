#
# Cookbook:: aptly
# Spec:: default
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

require 'spec_helper'

platforms = [
  %w(debian 11),
  %w(debian 12),
  ['ubuntu', '22.04'],
  ['ubuntu', '24.04'],
]

platforms.each do |platform, version|
  describe 'Test aptly default recipe' do
    context "when all attributes are default, on #{platform} #{version}" do
      let(:chef_run) do
        # for a complete list of available platforms and versions see:
        # https://github.com/customink/fauxhai/blob/master/PLATFORMS.md
        runner = ChefSpec::ServerRunner.new(platform: platform, version: version) do |node|
          # node.override['aptly'] = {
          #  'user' => 'my_user',
          #  'group' => 'my_group',
          #  'rootDir' => '/data/aptly',
          # }
        end
        runner.converge('aptly::default')
      end

      before do
        stub_command('getent passwd aptly').and_return(true)
      end

      it 'Add aptly repository' do
        expect(chef_run).to add_apt_repository('aptly')
      end

      packages = case platform
                 when 'debian'
                   version.to_i < 9 ? %w(gnupg gpgv) : %w(gnupg1 gpgv1)
                 when 'ubuntu'
                   if version.to_f < 18.04
                     %w(gnupg gpgv)
                   else
                     version.to_f < 22.04 ? %w(gnupg1 gpgv1) : %w(gnupg gpgv)
                   end
                 end
      packages += %w(screen aptly graphviz haveged)
      it 'installs the gnupg, gpgv, screen, aptly, graphviz and haveged package' do
        expect(chef_run).to install_package(packages)
      end

      it 'Create aptly group' do
        expect(chef_run).to create_group('aptly')
      end
      it 'Create aptly user' do
        expect(chef_run).to create_user('aptly')
      end

      it 'Create aptly root directory' do
        expect(chef_run).to create_directory('/opt/aptly').with(
          user: 'aptly',
          group: 'aptly'
        )
      end

      it 'Generate aptly.conf' do
        expect(chef_run).to create_template('/etc/aptly.conf')
      end

      it 'Generate GPG Keys' do
        expect(chef_run).to run_bash('Generate Aptly GPG Key pair')
      end

      it 'converges successfully' do
        expect { chef_run }.to_not raise_error
      end
    end
  end
end
