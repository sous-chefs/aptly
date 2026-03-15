# `aptly_snapshot`

Manage aptly snapshots.

## Actions

- `:create` creates a snapshot from a repo, mirror, or empty base.
- `:verify` verifies an existing snapshot.
- `:pull` pulls packages from one snapshot into another.
- `:merge` merges multiple snapshots.
- `:drop` removes a snapshot.

## Example

```ruby
aptly_snapshot 'my_snapshot' do
  from 'my_repo'
  type 'repo'
  user 'aptly'
  group 'aptly'
  root_dir '/opt/aptly'
  tmp_dir '/tmp'
end
```
