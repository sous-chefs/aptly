# `aptly_repo`

Manage local repositories

## Actions

- `create` - (default) Create a repo
- `drop` - Drop an existed repository
- `add` - Add packages to a repository
- `remove` - remove a package from a repository

## Properties

| Name            | Types         | Description                                                       | Default         | Used with... |
| --------------- | ------------- | ----------------------------------------------------------------- | --------------- | ------------ |
| `repo_name`     | String        | Name of the repository                                            | <resource_name> | all          |
| `component`     | String        | Repository component                                              | ''              | :create      |
| `comment`       | String        | Repository's comment                                              | ''              | :create      |
| `distribution`  | String        | Name of distribution repository                                   | ''              | :create      |
| `remove_files`  | [true, false] | Remove files that have been imported successfully into repository | false           | :add         |
| `force_replace` | [true, false] | Remove/override existing package when exists                      | false           | :add         |
| `directory`     | String        | Look in this directory to add multiple packages                   | ''              | :add         |
| `file`          | String        | Specify a package file to add to the repository                   | ''              | :add         |
| `package_query` | String        | Package name to remove from repository                            | ''              | :remove      |

## Examples

```ruby
aptly_repo 'my_repo' do
  comment 'A repository of packages'
  component 'main'
  distribution 'bionic'
  action :create
end
```

```ruby
aptly_repo 'repo_with_no_comment' do
  action :create
end
```

```ruby
aptly_repo 'my_repo' do
  action :drop
end
```

```ruby
aptly_repo 'my_repo' do
  file '/path/to/package-1.0.1.deb'
  action :add
end
```

```ruby
aptly_repo 'my_repo' do
  directory '/path/to/packages'
  action :add
end
```

```ruby
aptly_repo 'my_repo' do
  package_query 'package-1.0.1.deb'
  action :remove
end
```
