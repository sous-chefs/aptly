# `aptly_install`

Install and configure aptly for use by the other aptly custom resources.

## Actions

- `:create` installs the Aptly package repository, packages, system user, config file, and GPG key material.

## Common Properties

- `repository_uri` Aptly package repository URL
- `repository_distribution` Aptly package repository distribution
- `repository_components` Aptly package repository components
- `repository_key` Aptly package repository key URL
- `user` Aptly system user
- `group` Aptly system group
- `root_dir` Aptly home directory
- `tmp_dir` Temp directory used by Aptly commands
- `gpg_passphrase` Passphrase used for the generated Aptly GPG key

## Example

```ruby
aptly_install 'default' do
  user 'aptly'
  group 'aptly'
  root_dir '/opt/aptly'
  tmp_dir '/tmp'
  gpg_passphrase 'GreatPassPhrase'
end
```
