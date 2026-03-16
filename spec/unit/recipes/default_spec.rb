require 'spec_helper'

platforms = [
  %w(debian 11),
  %w(debian 12),
  ['ubuntu', '22.04'],
  ['ubuntu', '24.04'],
]

platforms.each do |platform, version|
  describe 'aptly_install' do
    context "when all attributes are default, on #{platform} #{version}" do
      let(:chef_run) do
        ChefSpec::SoloRunner.new(platform: platform, version: version, step_into: ['aptly_install']).converge('aptly_spec::install')
      end

      it 'Add aptly repository' do
        expect(chef_run).to add_apt_repository('aptly')
      end

      it 'installs gpg using gpg_install resource' do
        expect(chef_run).to install_gpg_install('gpg')
      end

      it 'installs the screen, aptly, graphviz, bzip2 and xz-utils packages' do
        expect(chef_run).to install_package(%w(screen aptly graphviz bzip2 xz-utils))
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
        expect(chef_run).to generate_gpg_key('aptly')
      end

      it 'converges successfully' do
        expect { chef_run }.not_to raise_error
      end
    end
  end
end
