# `aptly_serve`

Run the Aptly HTTP publish service in a detached screen session.

## Actions

- `:run` starts `aptly serve`.

## Example

```ruby
aptly_serve 'Aptly HTTP Service' do
  listen '0.0.0.0'
  port 8080
  user 'aptly'
  group 'aptly'
  root_dir '/opt/aptly'
  tmp_dir '/tmp'
end
```
