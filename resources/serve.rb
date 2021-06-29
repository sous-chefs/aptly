unified_mode true
use 'partial/_user'
use 'partial/_root_dir'

property :listen, String, default: ''
property :port,   [Integer, String], default: 8080

action :run do
  execute 'Serve HTTP service for Aptly' do
    user new_resource.user
    group new_resource.group
    environment aptly_env(new_resource)
    command "screen -dmS aptly aptly serve -listen=\"#{new_resource.listen}:#{new_resource.port}\""
    only_if %(aptly publish list | grep -q -v "[N]o snapshots")
    not_if %(ps aux | grep -q "[a]ptly serve")
  end
end
