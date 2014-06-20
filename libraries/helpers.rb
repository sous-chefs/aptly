module ::Aptly
  def aptly(command)
    "sudo -u #{node['aptly']['user']} -i -- aptly #{command}"
  end

  def snapshot_list
    aptly('snapshot -raw list')
  end

  def mirror_list
    aptly('mirror -raw list')
  end

  def repo_list
    aptly('repo -raw list')
  end

  def publish_list
    aptly('publish list')
  end

end
