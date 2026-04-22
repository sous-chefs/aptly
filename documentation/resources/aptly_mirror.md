# `aptly_mirror`

Manage an external Aptly mirror.

## Actions

- `:create` creates or edits the mirror, depending on whether it already exists
- `:update` syncs an existing mirror
- `:drop` removes an existing mirror

## Key Properties

| Property | Type | Default | Notes |
| --- | --- | --- | --- |
| `mirror_name` | String | resource name | Mirror name in Aptly |
| `component` | String | `''` | Component passed to `aptly mirror create` |
| `distribution` | String | `''` | Distribution passed to `aptly mirror create` |
| `uri` | String | `''` | Upstream mirror URL |
| `keyid` | String | `''` | Remote repository signing key ID |
| `keyserver` | String | `'keys.gnupg.net'` | Keyserver used with `keyid`; accepts either a bare hostname or a full URI such as `hkps://keys.openpgp.org` |
| `cookbook` | String | `''` | Cookbook containing `keyfile` |
| `keyfile` | String | `''` | Local key file imported into Aptly's trusted keyring |
| `filter` | String | `''` | Aptly package filter |
| `filter_with_deps` | true, false | `false` | Include dependencies of filtered packages |
| `architectures` | Array | `[]` | When empty, the resource omits `-architectures` and Aptly uses the upstream mirror defaults |
| `ignore_checksums` | true, false | `false` | Used by `:update` |
| `ignore_signatures` | true, false | `false` | Used by `:create` and `:update` |
| `with_installer` | true, false | `false` | Include installer files |
| `with_udebs` | true, false | `false` | Include `.udeb` packages |
| `download_limit` | Integer | `0` | Used by `:update` |
| `max_tries` | Integer | `1` | Used by `:update` |
| `skip_existing_packages` | true, false | `false` | Used by `:update` |
| `timeout` | Integer | `3600` | Used by `:update` |
| `user` | String | `'aptly'` | Shared common property |
| `group` | String | `'aptly'` | Shared common property |
| `root_dir` | String | `'/opt/aptly'` | Shared common property |
| `tmp_dir` | String | `'/tmp'` | Shared common property |

## Examples

```ruby
aptly_mirror 'nginx-bionic' do
  distribution 'bionic'
  component 'nginx'
  uri 'http://nginx.org/packages/ubuntu/'
  keyid '7BD9BF62'
  keyserver 'keyserver.ubuntu.com'
  filter 'nginx (>= 1.16.1)'
end
```

```ruby
aptly_mirror 'debian-bookworm' do
  distribution 'bookworm'
  component 'main'
  uri 'https://deb.debian.org/debian/'
  keyid 'B7C5D7D6350947F8'
  keyserver 'hkps://keys.openpgp.org'
end
```
