# `aptly_publish`

Publish, update, switch, or drop Aptly publications.

## Actions

- `:create` publishes a repo or snapshot
- `:switch` switches an existing published distribution to a different snapshot
- `:update` updates an existing publication
- `:drop` removes a publication

## Key Properties

| Property | Type | Default | Notes |
| --- | --- | --- | --- |
| `publish_name` | String | resource name | Publication name in Aptly |
| `type` | String | `''` | `repo` or `snapshot` for `:create` |
| `component` | Array | `[]` | Passed to `-component` |
| `distribution` | String | `''` | Required for `:create` and `:switch` |
| `architectures` | Array | `[]` | When empty, the resource omits `-architectures` and Aptly uses its normal config defaults |
| `endpoint` | String | `''` | Optional publishing endpoint |
| `prefix` | String | `''` | Optional publication prefix |
| `gpg_passphrase` | String | `''` | Required unless `skip_signing true` |
| `skip_signing` | true, false | `false` | Uses `-skip-signing` instead of a passphrase |
| `timeout` | Integer | `3600` | Command timeout |
| `user` | String | `'aptly'` | Shared common property |
| `group` | String | `'aptly'` | Shared common property |
| `root_dir` | String | `'/opt/aptly'` | Shared common property |
| `tmp_dir` | String | `'/tmp'` | Shared common property |

## Example

```ruby
aptly_publish 'my_snapshot' do
  type 'snapshot'
  component ['main']
  distribution 'bionic'
  prefix 'snap'
  skip_signing true
end
```
