# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## Unreleased

### Fixed

- Cookstyle Bot Auto Corrections with Cookstyle 6.17.7

## 2.3.0 (2020-08-26)

### Added

- Ability to edit existing mirror configuration
- Added missing properties to aptly_mirror resource
- Changed `aptly_mirror` resource's property `architectures` to use `node['aptly']['architectures']` rather than an empty list which was needed for idempotent mirror edits

## 2.2.0 (2020-08-20)

### Fixed

- Changed the `node['aptly']['gpg']['key-tpye']` attribute to `node['aptly']['gpg']['key-type']`. **WARNING**: This change may break existing cookbooks! Please adjust as needed.

## 2.1.2 (2020-06-18)

- Fixed Debian platform version in the spec tests

## 2.1.1 2020-05-05

### Fixed

- resolved cookstyle error: libraries/helpers.rb:51:14 warning: `Lint/SendWithMixinArgument`
- resolved cookstyle error: libraries/helpers.rb:52:16 warning: `Lint/SendWithMixinArgument`
- Use `true` and `false` in resources

### Added

- Migrate to Github Actions for testing

## 2.1.0 2020-02-17

### Added

- Extended Batch file and associated attributes

### Fixed

- Batch file is deleted from /tmp after successful application
- Publish resource :update has been extended with "sensetive true" parameters. So that the output of the assphrase during the chef-client run will be suppressed

### Deprecated

### Removed

## 2.0.2 2020-02-14

### Added

- Migrate to Github Actions for testing

### Fixed

- Changed usage of getent <user> passwd to getent passwd <user>
- Use `true` and `false` in resources

### Deprecated

### Removed

## 2.0.1 2019-10-19

### Added

### Fixed

- Latest Cookstyle changes in cookstyle 5.6.2

### Deprecated

### Removed

## [2.0.0] - 2019-09-04

### Added

- Add a `with_installer` parameter to the mirror resource

### Fixed

- Change `architectures` argument in both the mirror and publish resources for consistency

### Deprecated

### Removed

## [1.1.0] - 2019-08-03

### Added

- Add timeout argument for some time consuming resources
- Add support for aptly mirror `-filter-with-deps` argument
- Add support for aptly mirror `-with-udebs` and `-architectures` arguments

### Fixed

- Fix "can't modify frozen String" error caused by aptly_snapshot
- Fix broken `not_if` for in aptly_mirror resource
- Migrate to circleci for testing

### Deprecated

### Removed

## v1.0.0 (24-10-2018)

- Big refactoring
- Update resource with latest usage of aptly
- Create aptly_serve and aptly_api_serve resource
- Create unit tests
- Enhance integration test
- Use Circle CI

## 0.3.0

- Require at least Chef 11 and remove Chef 10 compatibility code
- Resolve idempotency in the DB ownership resource
- Enable the configuration of the publishing endpoints
- Remove the Librarian Cheffile
- Add a chefignore file to reduce the number of files pulled down to each node
- Add chef_version, issues_url, and source_url metadata to metadata.rb
- Resolve all cookstyle warnings
- Remove test deps from the Gemfile and instead rely on ChefDK for testing
- Swap local testing with Rake for Delivery Local Mode
- Resolve all Foodcritic warnings

## 0.2.8

- Update GPG Key for aptly repository

## 0.2.6

- Support for multi-component publishing #16
- Add filter attribute in mirror provider #17

## 0.2.4

- use exact matches in provider for not_if checks
- Add chefspec matchers

## 0.2.3

- Support for cookbook file to distribute gpg key
- Initializing gpg config for default user

## 0.2.2

- Helper to define proper environment
- Add repo attribute to repo resource
- Fix group owner attribute
- Correction for aptly user seed action 0.2.1
- bug fix for writing files to the system as the wrong user

## 0.2.0

- add providers for all aptly functionality

## 0.1.0

- Initial release of aptly

--------------------------------------------------------------------------------

Check the [Markdown Syntax Guide](http://daringfireball.net/projects/markdown/syntax) for help with Markdown.

The [Github Flavored Markdown page](http://github.github.com/github-flavored-markdown/) describes the differences between markdown on github and standard markdown.
