require 'spec_helper'
require_relative '../../libraries/helpers.rb'

RSpec.describe Aptly::Helpers do
  class DummyClass < Chef::Node
    include Aptly::Helpers
  end

  subject { DummyClass.new }

  describe '#mirror_exists?(mirror)' do
    before do
      allow(subject).to receive(:[]).with('aptly').and_return(aptly)
      # existing mirror config
      allow(subject).to receive(:mirror_exists?).with('ubuntu-precise-main').and_call_original
      allow(subject).to receive_shell_out('aptly mirror -raw list | grep ^ubuntu-precise-main$', stdout: 'ubuntu-precise-main')
      # missing mirror config
      allow(subject).to receive(:mirror_exists?).with('missing-repo-mirror').and_call_original
      allow(subject).to receive_shell_out('aptly mirror -raw list | grep ^missing-repo-mirror$', exitstatus: 1)
    end

    let(:aptly) { { 'rootDir' => '/opt/aptly', 'user' => 'aptly' } }

    context 'checks for existence of mirror' do
      let(:mirror) { 'ubuntu-precise-main' }

      it 'ubuntu-precise-main' do
        expect(subject.mirror_exists?(mirror)).to eq true
        expect(subject.mirror_exists?(mirror)).not_to eq false
      end
    end

    context 'checks for non-existence of mirror' do
      let(:mirror) { 'missing-repo-mirror' }

      it 'missing-repo-mirror' do
        expect(subject.mirror_exists?(mirror)).to eq false
        expect(subject.mirror_exists?(mirror)).not_to eq true
      end
    end
  end

  describe '#mirror_info(mirror)' do
    before do
      allow(subject).to receive(:[]).with('aptly').and_return(aptly)
      # existing mirror config
      allow(subject).to receive(:mirror_exists?).with('ubuntu-precise-main').and_call_original
      allow(subject).to receive(:mirror_info).with('ubuntu-precise-main').and_call_original
      allow(subject).to receive_shell_out('aptly mirror -raw list | grep ^ubuntu-precise-main$', stdout: 'ubuntu-precise-main')
      allow(subject).to receive_shell_out('aptly mirror show ubuntu-precise-main', stdout: mirror_show_after_create_stdout)
      # missing mirror config
      allow(subject).to receive(:mirror_exists?).with('missing-repo-mirror').and_call_original
      allow(subject).to receive(:mirror_info).with('missing-repo-mirror').and_call_original
      allow(subject).to receive_shell_out('aptly mirror -raw list | grep ^missing-repo-mirror$', exitstatus: 1)
      allow(subject).to receive_shell_out('aptly mirror show missing-repo-mirror', exitstatus: 1)
    end

    let(:aptly) { { 'rootDir' => '/opt/aptly', 'user' => 'aptly' } }

    context 'retrieves information for mirror' do
      let(:mirror) { 'ubuntu-precise-main' }

      it 'ubuntu-precise-main' do
        mirror_info = subject.mirror_info(mirror)
        expect(mirror_info['components']).to eq 'main'
        expect(mirror_info['distribution']).to eq 'precise'
        expect(mirror_info['archive_root_url']).to match /us.archive.ubuntu.com/
        expect(mirror_info).not_to eq nil
      end
    end

    context 'retrieves information for non-existent mirror' do
      let(:mirror) { 'missing-repo-mirror' }

      it 'missing-repo-mirror' do
        mirror_info = subject.mirror_info(mirror)
        expect(mirror_info).to eq nil
      end
    end
  end

  describe '#mirror_command(resource)' do
    before do
      @new_resource_missing = double(
        mirror_name: 'missing-repo-mirror',
        component: 'mirror',
        distribution: 'repo',
        uri: 'http://repo.example.com/missing',
        filter: '',
        filter_with_deps: false,
        dep_follow_all_variants: false,
        dep_follow_recommends: false,
        dep_follow_source: false,
        dep_follow_suggests: false,
        dep_verbose_resolve: false,
        architectures: ['amd64'],
        ignore_checksums: false,
        ignore_signatures: false,
        with_installer: false,
        with_udebs: false
      )
      @new_resource_existing = double(
        mirror_name: 'ubuntu-precise-main',
        component: 'main',
        distribution: 'precise',
        uri: 'http://ubuntu.osuosl.org/ubuntu/',
        filter: '',
        filter_with_deps: false,
        dep_follow_all_variants: false,
        dep_follow_recommends: false,
        dep_follow_source: false,
        dep_follow_suggests: false,
        dep_verbose_resolve: false,
        architectures: ['amd64'],
        ignore_checksums: false,
        ignore_signatures: false,
        with_installer: false,
        with_udebs: false
      )
      allow(subject).to receive(:[]).with('aptly').and_return(aptly)
      # existing mirror config
      allow(subject).to receive(:mirror_exists?).with('ubuntu-precise-main').and_call_original
      allow(subject).to receive_shell_out('aptly mirror -raw list | grep ^ubuntu-precise-main$', stdout: 'ubuntu-precise-main')
      # missing mirror config
      allow(subject).to receive(:mirror_exists?).with('missing-repo-mirror').and_call_original
      allow(subject).to receive_shell_out('aptly mirror -raw list | grep ^missing-repo-mirror$', exitstatus: 1)
    end

    let(:aptly) { { 'rootDir' => '/opt/aptly', 'user' => 'aptly' } }

    context 'creates missing mirror' do
      let(:command) { %(aptly mirror create -architectures amd64 missing-repo-mirror http://repo.example.com/missing repo mirror) }

      it 'missing-repo-mirror' do
        cmd = subject.mirror_command(@new_resource_missing)
        expect(cmd).to eq command
        expect(cmd).not_to match /\sedit\s/
      end
    end

    context 'edits existening mirror' do
      let(:command) { %(aptly mirror edit -architectures amd64 ubuntu-precise-main) }

      it 'ubuntu-precise-main' do
        cmd = subject.mirror_command(@new_resource_existing)
        expect(cmd).to eq command
        expect(cmd).not_to match /\screate\s/
      end
    end
  end

  describe '#aptly_env' do
    before do
      allow(subject).to receive(:[]).with('aptly').and_return(aptly)
    end

    let(:aptly) { { 'rootDir' => '/opt/aptly', 'user' => 'aptly' } }

    context 'sets proper environment' do
      it 'for USER and HOME' do
        expect(subject.aptly_env['USER']).to eq 'aptly'
        expect(subject.aptly_env['HOME']).to eq '/opt/aptly'
      end
    end
  end

  describe '#gpg_command' do
    before do
      allow(subject).to receive(:[]).with('platform').and_return(platform)
      allow(subject).to receive(:[]).with('platform_version').and_return(platform_version)
    end

    context 'on debian 8' do
      let(:platform) { 'debian' }
      let(:platform_version) { '8' }

      it 'returns gpg' do
        expect(subject.gpg_command).to eq 'gpg'
      end
    end

    context 'on debian 9' do
      let(:platform) { 'debian' }
      let(:platform_version) { '9' }

      it 'returns gpg1' do
        expect(subject.gpg_command).to eq 'gpg1'
      end
    end

    context 'on ubuntu 16.04' do
      let(:platform) { 'ubuntu' }
      let(:platform_version) { '16.04' }

      it 'returns gpg' do
        expect(subject.gpg_command).to eq 'gpg'
      end
    end

    context 'on ubuntu 18.04' do
      let(:platform) { 'ubuntu' }
      let(:platform_version) { '18.04' }

      it 'returns gpg1' do
        expect(subject.gpg_command).to eq 'gpg1'
      end
    end
  end

  describe '#filter' do
    before do
      allow(subject).to receive(:[]).with('f').and_return(filter_string)
    end

    context 'zip (<= 3.0)' do
      let(:filter_string) { 'zip (<= 3.0)' }

      it "returns -filter 'zip (<= 3.0)' argument" do
        expect(subject.filter(filter_string)).to eq " -filter 'zip (<= 3.0)'"
      end
    end

    context 'disabled' do
      let(:filter_string) { '' }

      it 'returns empty string' do
        expect(subject.filter(filter_string)).to eq ''
      end
    end
  end

  describe '#filter_with_deps' do
    before do
      allow(subject).to receive(:[]).with('f').and_return(filter_with_deps)
    end

    context 'enabled' do
      let(:filter_with_deps) { true }

      it "returns ' -filter-with-deps' argument with leading space" do
        expect(subject.filter_with_deps(filter_with_deps)).to eq ' -filter-with-deps'
      end
    end

    context 'disabled' do
      let(:filter_with_deps) { false }

      it 'returns empty string' do
        expect(subject.filter_with_deps(filter_with_deps)).to eq ''
      end
    end
  end

  describe '#dep_follow_all_variants' do
    before do
      allow(subject).to receive(:[]).with('f').and_return(dep_follow_all_variants)
    end

    context 'enabled' do
      let(:dep_follow_all_variants) { true }

      it "returns ' -dep-follow-all-variants' argument with leading space" do
        expect(subject.dep_follow_all_variants(dep_follow_all_variants)).to eq ' -dep-follow-all-variants'
      end
    end

    context 'disabled' do
      let(:dep_follow_all_variants) { false }

      it 'returns empty string' do
        expect(subject.dep_follow_all_variants(dep_follow_all_variants)).to eq ''
      end
    end
  end

  describe '#dep_follow_recommends' do
    before do
      allow(subject).to receive(:[]).with('f').and_return(dep_follow_recommends)
    end

    context 'enabled' do
      let(:dep_follow_recommends) { true }

      it "returns ' -dep-follow-recommends' argument with leading space" do
        expect(subject.dep_follow_recommends(dep_follow_recommends)).to eq ' -dep-follow-recommends'
      end
    end

    context 'disabled' do
      let(:dep_follow_recommends) { false }

      it 'returns empty string' do
        expect(subject.dep_follow_recommends(dep_follow_recommends)).to eq ''
      end
    end
  end

  describe '#dep_follow_source' do
    before do
      allow(subject).to receive(:[]).with('f').and_return(dep_follow_source)
    end

    context 'enabled' do
      let(:dep_follow_source) { true }

      it "returns ' -dep-follow-source' argument with leading space" do
        expect(subject.dep_follow_source(dep_follow_source)).to eq ' -dep-follow-source'
      end
    end

    context 'disabled' do
      let(:dep_follow_source) { false }

      it 'returns empty string' do
        expect(subject.dep_follow_source(dep_follow_source)).to eq ''
      end
    end
  end

  describe '#dep_follow_suggests' do
    before do
      allow(subject).to receive(:[]).with('f').and_return(dep_follow_suggests)
    end

    context 'enabled' do
      let(:dep_follow_suggests) { true }

      it "returns ' -dep-follow-suggests' argument with leading space" do
        expect(subject.dep_follow_suggests(dep_follow_suggests)).to eq ' -dep-follow-suggests'
      end
    end

    context 'disabled' do
      let(:dep_follow_suggests) { false }

      it 'returns empty string' do
        expect(subject.dep_follow_suggests(dep_follow_suggests)).to eq ''
      end
    end
  end

  describe '#dep_verbose_resolve' do
    before do
      allow(subject).to receive(:[]).with('f').and_return(dep_verbose_resolve)
    end

    context 'enabled' do
      let(:dep_verbose_resolve) { true }

      it "returns ' -dep-verbose-resolve' argument with leading space" do
        expect(subject.dep_verbose_resolve(dep_verbose_resolve)).to eq ' -dep-verbose-resolve'
      end
    end

    context 'disabled' do
      let(:dep_verbose_resolve) { false }

      it 'returns empty string' do
        expect(subject.dep_verbose_resolve(dep_verbose_resolve)).to eq ''
      end
    end
  end

  describe '#ignore_checksums' do
    before do
      allow(subject).to receive(:[]).with('f').and_return(ignore_checksums)
    end

    context 'enabled' do
      let(:ignore_checksums) { true }

      it "returns ' -ignore-checksums' argument with leading space" do
        expect(subject.ignore_checksums(ignore_checksums)).to eq ' -ignore-checksums'
      end
    end

    context 'disabled' do
      let(:ignore_checksums) { false }

      it 'returns empty string' do
        expect(subject.ignore_checksums(ignore_checksums)).to eq ''
      end
    end
  end

  describe '#ignore_signatures' do
    before do
      allow(subject).to receive(:[]).with('f').and_return(ignore_signatures)
    end

    context 'enabled' do
      let(:ignore_signatures) { true }

      it "returns ' -ignore-signatures' argument with leading space" do
        expect(subject.ignore_signatures(ignore_signatures)).to eq ' -ignore-signatures'
      end
    end

    context 'disabled' do
      let(:ignore_signatures) { false }

      it 'returns empty string' do
        expect(subject.ignore_signatures(ignore_signatures)).to eq ''
      end
    end
  end

  describe '#skip_existing_packages' do
    before do
      allow(subject).to receive(:[]).with('f').and_return(skip_existing_packages)
    end

    context 'enabled' do
      let(:skip_existing_packages) { true }

      it "returns ' -skip-existing-packages' argument with leading space" do
        expect(subject.skip_existing_packages(skip_existing_packages)).to eq ' -skip-existing-packages'
      end
    end

    context 'disabled' do
      let(:skip_existing_packages) { false }

      it 'returns empty string' do
        expect(subject.skip_existing_packages(skip_existing_packages)).to eq ''
      end
    end
  end

  describe '#with_installer' do
    before do
      allow(subject).to receive(:[]).with('f').and_return(with_installer)
    end

    context 'enabled' do
      let(:with_installer) { true }

      it "returns ' -with-installer' argument with leading space" do
        expect(subject.with_installer(with_installer)).to eq ' -with-installer'
      end
    end

    context 'disabled' do
      let(:with_installer) { false }

      it 'returns empty string' do
        expect(subject.with_installer(with_installer)).to eq ''
      end
    end
  end

  describe '#with_udebs' do
    before do
      allow(subject).to receive(:[]).with('f').and_return(with_udebs)
    end

    context 'enabled' do
      let(:with_udebs) { true }

      it "returns ' -with-udebs' argument with leading space" do
        expect(subject.with_udebs(with_udebs)).to eq ' -with-udebs'
      end
    end

    context 'disabled' do
      let(:with_udebs) { false }

      it 'returns empty string' do
        expect(subject.with_udebs(with_udebs)).to eq ''
      end
    end
  end
end
