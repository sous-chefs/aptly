# Upgrading

## v1.x to v2.x

Here is a list of resources that have changed behavior between v1.x and 2.x

### aptly_mirror

aptly_mirror resource **architectures** property has changed in a way that it now requires a array instead of a string.

### aptly_publish

aptly_publish Resource **architectures** property no longer explicitly defaults to `['amd64']` thus no longer always overriding the global aptly configuration/cookbook attribute value of `default['aptly']['architectures']`. This mimics aptly's native behavior.
