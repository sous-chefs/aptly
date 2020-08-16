# frozen_string_literal: true
require 'chefspec'
require 'chefspec/berkshelf'
# require 'chefspec/policyfile'

RSpec.configure do |config|
  config.color = true               # Use color in STDOUT
  config.formatter = :documentation # Use the specified formatter
  config.log_level = :error         # Avoid deprecation notice SPAM
end

# at_exit { ChefSpec::Coverage.report! }

def mock_shell_out(exitstatus, stdout, stderr)
  shell_out = double('mixlib_shell_out')
  allow(shell_out).to receive(:exitstatus).and_return(exitstatus)
  allow(shell_out).to receive(:stdout).and_return(stdout)
  allow(shell_out).to receive(:stderr).and_return(stderr)
  shell_out
end

def mirror_show_after_create_stdout
  <<~EOF
Name: ubuntu-precise-main
Archive Root URL: http://us.archive.ubuntu.com/ubuntu/
Distribution: precise
Components: main
Architectures: amd64, armhf
Download Sources: no
Download .udebs: no
Filter: my_awesome_package
Filter With Deps: yes
Last update: 2020-08-15 12:27:29 UTC
Number of packages: 5

Information from release file:
Acquire-By-Hash: yes
Architectures: amd64 arm64 armhf i386 ppc64el s390x
Codename: precise
Components: main restricted universe multiverse
Date: Thu, 26 Apr 2018 23:37:48 UTC
Description:  Ubuntu Precise 12.04

Label: Ubuntu
Origin: Ubuntu
Suite: precise
Version: 12.04
EOF
end
