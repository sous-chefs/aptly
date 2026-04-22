# `aptly_snapshot`

Manage Aptly snapshots.

## Actions

- `:create` creates a snapshot from a repo, mirror, snapshot, or empty base
- `:verify` verifies an existing snapshot
- `:pull` pulls packages from one snapshot into another
- `:merge` merges multiple snapshots
- `:drop` removes a snapshot

## Key Properties

| Property | Type | Default | Notes |
| --- | --- | --- | --- |
| `snapshot_name` | String | resource name | Snapshot name in Aptly |
| `from` | String | `''` | Source name for `:create` |
| `type` | String | `''` | Source type for `:create` |
| `empty` | true, false | `false` | Creates an empty snapshot when true |
| `source` | String | `''` | Used by `:pull` |
| `destination` | String | `''` | Used by `:pull` |
| `merge_sources` | Array | `[]` | Used by `:merge` |
| `package_query` | String | `''` | Used by `:pull` |
| `no_deps` | true, false | `false` | Used by `:pull` |
| `no_remove` | true, false | `false` | Used by `:pull` and `:merge` |
| `latest` | true, false | `false` | Used by `:merge` |
| `user` | String | `'aptly'` | Shared common property |
| `group` | String | `'aptly'` | Shared common property |
| `root_dir` | String | `'/opt/aptly'` | Shared common property |
| `tmp_dir` | String | `'/tmp'` | Shared common property |

## Example

```ruby
aptly_snapshot 'my_snapshot' do
  from 'my_repo'
  type 'repo'
end
```
