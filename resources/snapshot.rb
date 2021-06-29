unified_mode true
use 'partial/_user'
use 'partial/_root_dir'

property :snapshot_name, String, name_property: true
property :from,          String, default: ''
property :type,          String, default: ''
property :empty,         [true, false], default: false
property :source,        String, default: ''
property :destination,   String, default: ''
property :merge_sources, Array, default: []
property :package_query, String, default: ''
property :no_deps,       [true, false], default: false
property :no_remove,     [true, false], default: false
property :latest,        [true, false], default: false

action :create do
  if new_resource.empty
    execute "Creating Empty Snapshot - #{new_resource.snapshot_name}" do
      command "aptly snapshot create #{new_resource.snapshot_name} empty"
      user new_resource.user
      group new_resource.group
      environment aptly_env(new_resource)
      not_if %(aptly snapshot -raw list | grep ^#{new_resource.snapshot_name}$)
    end
  else
    execute "Creating Snapshot - #{new_resource.snapshot_name}" do
      command "aptly snapshot create #{new_resource.snapshot_name} from #{new_resource.type} #{new_resource.from}"
      user new_resource.user
      group new_resource.group
      environment aptly_env(new_resource)
      not_if %(aptly snapshot -raw list | grep ^#{new_resource.snapshot_name}$)
    end
  end
end

action :verify do
  execute "Verifying - #{new_resource.snapshot_name}" do
    command "aptly snapshot verify #{new_resource.snapshot_name}"
    user new_resource.user
    group new_resource.group
    environment aptly_env(new_resource)
    only_if %(aptly snapshot -raw list | grep ^#{new_resource.snapshot_name}$)
  end
end

action :pull do
  opts = ''
  opts += ' -no-deps' if new_resource.no_deps
  opts += ' -no-remove' if new_resource.no_remove

  execute "Pull to - #{new_resource.snapshot_name}" do
    command "aptly snapshot pull#{opts} #{new_resource.snapshot_name} #{new_resource.source} #{new_resource.destination} #{new_resource.package_query}"
    user new_resource.user
    group new_resource.group
    environment aptly_env(new_resource)
    not_if %(aptly snapshot -raw list | grep ^#{new_resource.snapshot_name}$)
  end
end

action :merge do
  opts = ''
  opts += ' -latest' if new_resource.latest
  opts += ' -no-remove' if new_resource.no_remove
  flatten_sources = new_resource.merge_sources.join(' ')

  execute "Merge Snapshots #{flatten_sources} TO #{new_resource.snapshot_name}" do
    command "aptly snapshot merge#{opts} #{new_resource.snapshot_name} #{flatten_sources}"
    user new_resource.user
    group new_resource.group
    environment aptly_env(new_resource)
    not_if %(aptly snapshot -raw list | grep ^#{new_resource.snapshot_name}$)
  end
end

action :drop do
  execute "Drop Snapshot #{new_resource.snapshot_name}" do
    command "aptly snapshot drop #{new_resource.snapshot_name}"
    user new_resource.user
    group new_resource.group
    environment aptly_env(new_resource)
    only_if %(aptly snapshot -raw list | grep ^#{new_resource.snapshot_name}$)
  end
end
