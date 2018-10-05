# frozen_string_literal: true

control 'Aptly should be installed' do
  title 'Should install the Aply binary'

  desc 'Aplty binary'
  describe command('aptly') do
    it { should exist }
  end
end
