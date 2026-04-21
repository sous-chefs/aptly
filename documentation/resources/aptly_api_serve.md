# `aptly_api_serve`

Run the Aptly API service in a detached screen session.

## Actions

- `:run` starts `aptly api serve`.

## Common Properties

- `listen`
- `port`
- `no_lock`
- `user`
- `group`
- `root_dir`
- `tmp_dir`

## Example

```ruby
aptly_api_serve 'Aptly API Service' do
  listen '127.0.0.1'
  port 9090
  user 'aptly'
  group 'aptly'
  root_dir '/opt/aptly'
  tmp_dir '/tmp'
end
```
