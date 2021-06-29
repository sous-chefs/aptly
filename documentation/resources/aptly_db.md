# `aptly_db`

Manage internal Aptly DB

## Actions

- `cleanup` - (default) Database cleanup removes information about unreferenced packages and deletes files in the package pool that aren’t used by packages anymore.
- `recover` - Database recover does its best to recover database after crash.

## Properties

| Name    | Types  | Description          | Default |
| ------- | ------ | -------------------- | ------- |
| `user`  | String | Mirror name          | aptly   |
| `group` | String | Repository component | aptly   |

## Examples

```ruby
aptly_db 'cleanup' do
  action :cleanup
end
```

```ruby
aptly_db 'recover' do
  action :recover
end
```

## Usage

### include recipe in a wrapper cookbook and call resources if needed

```ruby
include_recipe 'aptly'

aptly_repo 'my_repo' do
  comment 'A repository of packages'
  component 'main'
  distribution 'bionic'
end

aptly_snapshot 'my_snapshot' do
  from 'my_repo'
  type 'repo'
end

aptly_publish 'my_repo' do
  type 'repo'
  prefix 'ubuntu'
end

aptly_serve 'Aptly HTTP Service'
```
