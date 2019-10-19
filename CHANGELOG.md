# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

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
