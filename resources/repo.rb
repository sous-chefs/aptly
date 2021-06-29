unified_mode true
use 'partial/_user'
use 'partial/_root_dir'

property :repo_name,     String, name_property: true
property :component,     String, default: ''
property :comment,       String, default: ''
property :distribution,  String, default: ''
property :remove_files,  [true, false], default: false
property :force_replace, [true, false], default: false
property :directory,     String, default: ''
property :file,          String, default: ''
property :package_query, String, default: ''

action :create do
  opts = ''
  opts += " -comment='#{new_resource.comment}'" unless new_resource.comment.empty?
  opts += " -component='#{new_resource.component}'" unless new_resource.component.empty?
  opts += " -distribution='#{new_resource.distribution}'" unless new_resource.distribution.empty?

  execute "Creating Repo - #{new_resource.repo_name}" do
    command "aptly repo create#{opts} #{new_resource.repo_name}"
    user new_resource.user
    group new_resource.group
    environment aptly_env(new_resource)
    not_if %(aptly repo list --raw | grep #{new_resource.repo_name})
  end
end

action :drop do
  execute "Droping Repo - #{new_resource.repo_name}" do
    command "aptly repo drop #{new_resource.repo_name}"
    user new_resource.user
    group new_resource.group
    environment aptly_env(new_resource)
    only_if %(aptly repo list --raw | grep #{new_resource.repo_name})
  end
end

action :add do
  opts = ''
  opts += ' -force-replace' if new_resource.force_replace
  opts += ' -remove-files' if new_resource.remove_files

  if new_resource.file.empty?
    if ::Dir.exist?(new_resource.directory)
      execute "Adding packages from #{new_resource.directory}" do
        command "aptly repo add#{opts} #{new_resource.repo_name} #{new_resource.directory}"
        user new_resource.user
        group new_resource.group
        environment aptly_env(new_resource)
      end
    else
      Chef::Log.info "#{new_resource.directory} is not a valid directory"
    end
  elsif new_resource.directory.empty?
    if ::File.exist?(new_resource.file)
      pkg = ::File.basename(new_resource.file)
      pk = pkg.split('.').first
      execute "Adding Package - #{pkg}" do
        command "aptly repo add#{opts} #{new_resource.repo_name} #{new_resource.file}"
        user new_resource.user
        group new_resource.group
        environment aptly_env(new_resource)
        not_if %(aptly repo show -with-packages #{new_resource.repo_name} | grep #{pk})
      end
    else
      Chef::Log.info "#{new_resource.file} does not exist"
    end
  else
    Chef::Log.info 'You must specify a file OR a directory'
  end
end

action :remove do
  execute "Removing Package - #{new_resource.package_query}" do
    command "aptly repo remove #{new_resource.repo_name} #{new_resource.package_query}"
    user new_resource.user
    group new_resource.group
    environment aptly_env(new_resource)
    only_if %(aptly repo show -with-packages #{new_resource.repo_name} | grep #{new_resource.package_query})
  end
end
