# `aptly_db`

Run Aptly database maintenance commands.

## Actions

- `:cleanup` removes unreferenced package metadata and pool files
- `:recover` attempts database recovery after corruption or an unclean shutdown

## Common Properties

- `user`
- `group`
- `root_dir`
- `tmp_dir`

## Example

```ruby
aptly_db 'cleanup' do
  action :cleanup
end
```
