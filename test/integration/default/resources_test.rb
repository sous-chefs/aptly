control 'Resources Tests' do
  impact 1.0
  desc 'Ensure that resources are working well'

  describe command('aptly repo -raw list') do
    its('stdout') { should match /my_repo/ }
    its('exit_status') { should eq 0 }
  end

  describe command('aptly repo -raw list') do
    its('stdout') { should_not match /repo_with_no_comment/ }
    its('exit_status') { should eq 0 }
  end

  describe command('aptly mirror -raw list') do
    its('stdout') { should match /nginx-bionic-main/ }
    its('exit_status') { should eq 0 }
  end

  describe command('aptly mirror -raw list') do
    its('stdout') { should_not match /nginx-bionic-main-to_delete/ }
    its('exit_status') { should eq 0 }
  end

  describe command('aptly mirror -raw list') do
    its('stdout') { should match /nginx-bionic-main-to_edit/ }
    its('exit_status') { should eq 0 }
  end

  describe command('aptly mirror show nginx-bionic-main-to_edit') do
    its('stdout') { should match /Name: nginx-bionic-main-to_edit/ }
    its('stdout') { should match /Filter: nginx \(\>= 1.16.1\)/ }
    its('exit_status') { should eq 0 }
  end

  describe directory('/opt/aptly/pkgs') do
    it { should exist }
    its('owner') { should eq 'aptly' }
    its('group') { should eq 'aptly' }
  end

  describe command('aptly repo show -with-packages my_repo') do
    its('stdout') { should match /chef_.*/ }
    its('exit_status') { should eq 0 }
  end

  describe command('aptly repo show -with-packages my_repo | grep chef_15.2.20-1_amd64') do
    its('exit_status') { should eq 0 }
  end

  describe command('aptly snapshot -raw list') do
    its('stdout') { should match /my_snapshot/ }
    its('exit_status') { should eq 0 }
  end

  describe command('aptly snapshot -raw list') do
    its('stdout') { should match /my_mirror_snapshot/ }
    its('exit_status') { should eq 0 }
  end

  describe command('aptly snapshot -raw list') do
    its('stdout') { should_not match /new_my_snapshot/ }
    its('exit_status') { should eq 0 }
  end

  describe command('aptly publish list') do
    its('stdout') { should match %r{ubuntu/bionic} }
    its('exit_status') { should eq 0 }
  end

  describe command('aptly publish list') do
    its('stdout') { should match %r{snap/bionic} }
    its('stdout') { should match %r{switch/bionic.*my_switch_snapshot} }
    its('stdout') { should_not match %r{switch/bionic.*my_mirror_snapshot} }
    its('exit_status') { should eq 0 }
  end

  describe command('aptly publish list') do
    its('stdout') { should_not match %r{/mirror\/bionic/} }
    its('exit_status') { should eq 0 }
  end
end

control 'HTTP Resource Tests' do
  impact 1.0
  desc 'Ensure that serve resource run'

  describe command('ps aux | grep "[a]ptly serve" | grep -q -v SCREEN') do
    its('exit_status') { should eq 0 }
  end
  describe command('ps aux | grep "[a]ptly api serve" | grep -q -v SCREEN') do
    its('exit_status') { should eq 0 }
  end
end
