unified_mode true
use 'partial/_user'
use 'partial/_root_dir'

property :listen,  String, default: ''
property :port,    [Integer, String], default: 8090
property :no_lock, [true, false], default: false

action :run do
  no_lock = new_resource.no_lock ? ' -no-lock' : ''

  execute 'Serve API service for Aptly' do
    user new_resource.user
    group new_resource.group
    environment aptly_env(new_resource)
    command "screen -dmS aptly-api aptly api serve -listen=\"#{new_resource.listen}:#{new_resource.port}\"#{no_lock}"
    not_if %(ps aux | grep -q "[a]ptly api serve")
  end
end
