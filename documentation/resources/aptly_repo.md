# `aptly_repo`

Manage local Aptly repositories.

## Actions

- `:create` creates a repository
- `:add` adds packages from a directory or a single file
- `:remove` removes packages matching a query
- `:drop` removes a repository

## Key Properties

| Property | Type | Default | Notes |
| --- | --- | --- | --- |
| `repo_name` | String | resource name | Repository name in Aptly |
| `component` | String | `nil` | Optional repository component |
| `comment` | String | `nil` | Optional repository comment |
| `distribution` | String | `nil` | Optional repository distribution |
| `remove_files` | true, false | `false` | Used by `:add` |
| `force_replace` | true, false | `false` | Used by `:add` |
| `directory` | String | `nil` | Used by `:add`; set exactly one of `directory` or `file` |
| `file` | String | `nil` | Used by `:add`; set exactly one of `directory` or `file` |
| `package_query` | String | `nil` | Used by `:remove` |
| `user` | String | `'aptly'` | Shared common property |
| `group` | String | `'aptly'` | Shared common property |
| `root_dir` | String | `'/opt/aptly'` | Shared common property |
| `tmp_dir` | String | `'/tmp'` | Shared common property |

## Example

```ruby
aptly_repo 'my_repo' do
  comment 'A repository of packages'
  component 'main'
  distribution 'bionic'
end
```
