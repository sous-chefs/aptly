# frozen_string_literal: true

apt_update 'update'

package %w(haveged gnupg2)

aptly_setup_markers = '/tmp/aptly-kitchen-test-setup-markers'
haveged_start_marker = "#{aptly_setup_markers}/haveged-started"

directory aptly_setup_markers do
  mode '0755'
end

service 'haveged' do
  supports [:status, :restart]
  action :start
  not_if { ::File.exist?(haveged_start_marker) }
end

file haveged_start_marker do
  action :create_if_missing
end
