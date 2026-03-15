# frozen_string_literal: true

apt_update 'update'

package %w(haveged gnupg2)

service 'haveged' do
  supports [:status, :restart]
  action :start
end
