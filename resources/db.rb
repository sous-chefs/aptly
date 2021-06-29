unified_mode true
use 'partial/_user'
use 'partial/_root_dir'

action :cleanup do
  execute 'DB Cleanup' do
    command 'aptly db cleanup'
    user new_resource.user
    group new_resource.group
    environment aptly_env(new_resource)
  end
end

action :recover do
  execute 'DB Recover' do
    command 'aptly db recover'
    user new_resource.user
    group new_resource.group
    environment aptly_env(new_resource)
  end
end
