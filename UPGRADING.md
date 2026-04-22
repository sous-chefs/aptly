# Upgrading

## v2.x to v3.x

Version 3.x removes the use of node attributes inside resources. All common settings are now exposed as resource properties with sensible defaults.

### Breaking Changes

#### Node Attributes No Longer Used in Resources

Resources no longer read from `node['aptly']` attributes. You must now pass these values explicitly as properties on each resource.

**Before (v2.x):**

```ruby
# Relied on node attributes
node.default['aptly']['user'] = 'aptly'
node.default['aptly']['group'] = 'aptly'
node.default['aptly']['rootdir'] = '/opt/aptly'

aptly_mirror 'my-mirror' do
  distribution 'focal'
  component 'main'
  uri 'http://archive.ubuntu.com/ubuntu/'
end
```

**After (v3.x):**

```ruby
aptly_mirror 'my-mirror' do
  distribution 'focal'
  component 'main'
  uri 'http://archive.ubuntu.com/ubuntu/'
  user 'aptly'        # defaults to 'aptly'
  group 'aptly'       # defaults to 'aptly'
  root_dir '/opt/aptly'  # defaults to '/opt/aptly'
  tmp_dir '/tmp'      # defaults to '/tmp'
end
```

#### New Common Properties

All resources now support these properties (with defaults):

| Property   | Type   | Default        | Description                    |
|------------|--------|----------------|--------------------------------|
| `user`     | String | `'aptly'`      | User to run aptly commands as  |
| `group`    | String | `'aptly'`      | Group to run aptly commands as |
| `root_dir` | String | `'/opt/aptly'` | Aptly root directory (HOME)    |
| `tmp_dir`  | String | `'/tmp'`       | Temporary directory (TMPDIR)   |

#### aptly_repo Resource Changes

The `directory` and `file` properties no longer default to empty strings. They are now `nil` by default and you must explicitly set one when using the `:add` action.

**Before (v2.x):**

```ruby
aptly_repo 'my-repo' do
  directory '/opt/aptly/pkgs'  # worked even with empty default
  action :add
end
```

**After (v3.x):**

```ruby
aptly_repo 'my-repo' do
  directory '/opt/aptly/pkgs'  # required - no default
  action :add
end
```

#### aptly_publish Resource Changes

The `gpg_passphrase` property no longer reads from `node['aptly']['gpg']['passphrase']`. You must pass it explicitly.

**Before (v2.x):**

```ruby
node.default['aptly']['gpg']['passphrase'] = 'secret'

aptly_publish 'my-snapshot' do
  type 'snapshot'
  prefix 'stable'
end
```

**After (v3.x):**

```ruby
aptly_publish 'my-snapshot' do
  type 'snapshot'
  prefix 'stable'
  gpg_passphrase 'secret'  # required - no default
end
```

### Migration Steps

1. **Identify all aptly resource usages** in your recipes
2. **Add explicit properties** for `user`, `group`, `root_dir`, and `tmp_dir` if you were relying on non-default node attributes
3. **Update `aptly_publish`** resources to include `gpg_passphrase`
4. **Update `aptly_repo`** resources using `:add` action to explicitly set `directory` or `file`
5. **Remove node attribute overrides** that are no longer used by resources

### Removed Cookbook Structure

Version 3.x completes the migration away from cookbook-level defaults:

- `recipes/default.rb` has been removed
- `attributes/default.rb` has been removed

Wrapper cookbooks should call `aptly_install` and the other custom resources directly.

### Wrapper Cookbook Pattern

If you have many resources and want to avoid repetition, use local variables:

```ruby
aptly_user = 'aptly'
aptly_group = 'aptly'
aptly_root_dir = '/opt/aptly'
aptly_tmp_dir = '/tmp'
aptly_gpg_passphrase = 'your-passphrase'

aptly_mirror 'my-mirror' do
  distribution 'focal'
  component 'main'
  uri 'http://archive.ubuntu.com/ubuntu/'
  user aptly_user
  group aptly_group
  root_dir aptly_root_dir
  tmp_dir aptly_tmp_dir
end

aptly_publish 'my-snapshot' do
  type 'snapshot'
  prefix 'stable'
  gpg_passphrase aptly_gpg_passphrase
  user aptly_user
  group aptly_group
  root_dir aptly_root_dir
  tmp_dir aptly_tmp_dir
end
```

## v1.x to v2.x

Here is a list of resources that have changed behavior between v1.x and 2.x

### aptly_mirror

aptly_mirror resource **architectures** property has changed in a way that it now requires a array instead of a string.

### aptly_publish

aptly_publish Resource **architectures** property no longer explicitly defaults to `['amd64']` thus no longer always overriding the global aptly configuration/cookbook attribute value of `default['aptly']['architectures']`. This mimics aptly's native behavior.
