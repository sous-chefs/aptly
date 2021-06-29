require 'spec_helper'
require_relative '../../libraries/helpers'

RSpec.describe Aptly::Helpers do
  class DummyClass < Chef::Node
    include Aptly::Helpers
  end

  subject { DummyClass.new }

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
