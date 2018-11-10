# encoding: utf-8

control 'Default actions' do
  impact 1.0
  desc 'Ensure that the repository, packages and necessary default config are executed'

  describe apt('http://repo.aptly.info/') do
    it { should exist }
    it { should be_enabled }
  end

  describe package('screen') do
    it { should be_installed }
  end
  describe package('graphviz') do
    it { should be_installed }
  end
  describe package('haveged') do
    it { should be_installed }
  end

  os_name = os.name
  os_version = os.release

  gnupg_pkg = case os_name
              when 'debian'
                os_version.to_i < 9 ? 'gnupg' : 'gnupg1'
              when 'ubuntu'
                os_version.to_f < 18.04 ? 'gnupg' : 'gnupg1'
              end
  gpgv_pkg = case os_name
             when 'debian'
               os_version.to_i < 9 ? 'gpgv' : 'gpgv1'
             when 'ubuntu'
               os_version.to_f < 18.04 ? 'gpgv' : 'gpgv1'
             end

  describe package(gnupg_pkg) do
    it { should be_installed }
  end
  describe package(gpgv_pkg) do
    it { should be_installed }
  end
  describe package('aptly') do
    it { should be_installed }
  end

  describe directory('/opt/aptly') do
    its('owner') { should cmp 'aptly' }
    its('group') { should cmp 'aptly' }
    its('mode') { should cmp '0755' }
  end

  describe group('aptly') do
    it { should exist }
    its('gid') { should_not eq 0 }
  end

  describe user('aptly') do
    it { should exist }
    its('group') { should eq 'aptly' }
    its('home') { should eq '/opt/aptly' }
    its('shell') { should eq '/bin/bash' }
  end

  describe file('/etc/aptly.conf') do
    its('owner') { should eq 'root' }
    its('group') { should eq 'root' }
    its('mode') { should cmp '0644' }
    its('content') { should match %r{^\s*\"rootDir\":\ \"\/opt\/aptly\"} }
  end

  describe file('/opt/aptly/.gnupg/trustdb.gpg') do
    it { should exist }
  end
end
