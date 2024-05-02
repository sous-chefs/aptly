
# Changelog

All notable changes to this project will be documented in this file.

## Unreleased

- resolved cookstyle error: spec/fixtures/cookbooks/aptly_spec/.delivery/config.json:2:14 convention: `Style/StringLiterals`
- resolved cookstyle error: spec/fixtures/cookbooks/aptly_spec/.delivery/config.json:4:13 convention: `Style/StringLiterals`
- resolved cookstyle error: spec/fixtures/cookbooks/aptly_spec/.delivery/config.json:5:5 convention: `Style/TrailingCommaInHashLiteral`
- resolved cookstyle error: spec/fixtures/cookbooks/aptly_spec/.delivery/config.json:5:13 convention: `Style/StringLiterals`
- resolved cookstyle error: spec/fixtures/cookbooks/aptly_spec/.delivery/config.json:9:7 convention: `Style/TrailingCommaInHashLiteral`
- resolved cookstyle error: spec/fixtures/cookbooks/aptly_spec/.delivery/config.json:10:5 convention: `Style/TrailingCommaInHashLiteral`
- resolved cookstyle error: spec/fixtures/cookbooks/aptly_spec/.delivery/config.json:14:5 convention: `Style/TrailingCommaInHashLiteral`
- resolved cookstyle error: spec/fixtures/cookbooks/aptly_spec/.delivery/config.json:14:16 convention: `Style/StringLiterals`
- resolved cookstyle error: spec/fixtures/cookbooks/aptly_spec/.delivery/config.json:16:3 convention: `Style/TrailingCommaInHashLiteral`
- resolved cookstyle error: spec/fixtures/cookbooks/aptly_spec/.delivery/project.toml:15:8 convention: `Style/StringLiterals`
- resolved cookstyle error: spec/fixtures/cookbooks/aptly_spec/.delivery/project.toml:16:8 convention: `Style/StringLiterals`
- resolved cookstyle error: spec/fixtures/cookbooks/aptly_spec/.delivery/project.toml:21:10 convention: `Style/StringLiterals`
- resolved cookstyle error: spec/fixtures/cookbooks/aptly_spec/.delivery/project.toml:22:13 convention: `Style/StringLiterals`
- resolved cookstyle error: spec/fixtures/cookbooks/aptly_spec/.delivery/project.toml:23:10 convention: `Style/StringLiterals`
- resolved cookstyle error: spec/fixtures/cookbooks/aptly_spec/.delivery/project.toml:24:9 convention: `Style/StringLiterals`
- resolved cookstyle error: spec/fixtures/cookbooks/aptly_spec/.delivery/project.toml:28:11 convention: `Style/StringLiterals`

## 3.2.2 - *2024-05-02*

## 3.2.1 - *2024-05-02*

## 3.2.0 - *2023-09-29*

## 3.1.9 - *2023-09-28*

## 3.1.8 - *2023-09-04*

## 3.1.7 - *2023-09-04*

## 3.1.6 - *2023-06-08*

## 3.1.5 - *2023-06-08*

## 3.1.4 - *2023-06-08*

Standardise files with files in sous-chefs/repo-management

## 3.1.3 - *2023-03-02*

## 3.1.2 - *2023-03-01*

- Update workflows to 2.0.1
- Remove mdl and replace with markdownlint-cli2

## 3.1.1 - *2023-02-14*

- Remove delivery

## 3.1.0 - *2021-09-08*

- Add `switch` action to `aptly_publish` resource
- Add Ubuntu 20.04 to testing matrix; remove Ubuntu 16.04

## 3.0.0 - *2021-09-02*

- Set unified_mode to true for Chef 17 support
- Set minium Chef version to 15.3 for unified_mode

## 2.4.1 - *2021-08-30*

- Standardise files with files in sous-chefs/repo-management

## 2.4.0 - *2021-06-10*

- Make tmpdir configurable

## 2.3.3 - *2021-06-09*

- [CI] Update ActionsHub actions to point at main
- [CI] Update GitHub Actions checkout to v2
- Move resource documentation into the documentation folder

## 2.4.0 - *2021-06-10*

- Added ability to specify TMPDIR

## 3.2.0 - *2023-09-29*

- Allow specifying GPG passphrase explicitly in the publish resource

## 2.3.2 (2020-11-16)

- resolved cookstyle error: test/fixtures/cookbooks/aptly_test/recipes/default.rb:95:3 convention: `Style/CommentAnnotation`
- resolved cookstyle error: spec/libraries/helpers_spec.rb:2:18 convention: `Style/RedundantFileExtensionInRequire`
- resolved cookstyle error: test/integration/default/default_test.rb:1:1 convention: `Style/Encoding`
- resolved cookstyle error: test/integration/default/resources_test.rb:1:1 convention: `Style/Encoding`

## 2.3.1 (2020-09-16)

### Fixed

- Cookstyle Bot Auto Corrections with Cookstyle 6.17.7

## 2.3.0 (2020-08-26)

### Added

- Ability to edit existing mirror configuration
- Added missing properties to aptly_mirror resource
- Changed `aptly_mirror` resource's property `architectures` to use `node['aptly']['architectures']` rather than an empty list which was needed for idempotent mirror edits

## 2.2.0 (2020-08-20)

- Changed the `node['aptly']['gpg']['key-tpye']` attribute to `node['aptly']['gpg']['key-type']`. **WARNING**: This change may break existing cookbooks! Please adjust as needed.

## 2.1.2 (2020-06-18)

- Fixed Debian platform version in the spec tests

## 2.1.1 2020-05-05

- resolved cookstyle error: libraries/helpers.rb:51:14 warning: `Lint/SendWithMixinArgument`
- resolved cookstyle error: libraries/helpers.rb:52:16 warning: `Lint/SendWithMixinArgument`
- Use `true` and `false` in resources
- Migrate to Github Actions for testing

## 2.1.0 2020-02-17

- Extended Batch file and associated attributes
- Batch file is deleted from /tmp after successful application
- Publish resource :update has been extended with "sensetive true" parameters. So that the output of the assphrase during the chef-client run will be suppressed

## 2.0.2 2020-02-14

- Migrate to Github Actions for testing
- Changed usage of getent `<user>` passwd to getent passwd `<user>`
- Use `true` and `false` in resources

## 2.0.1 2019-10-19

- Latest Cookstyle changes in cookstyle 5.6.2

## [2.0.0] - 2019-09-04

- Add a `with_installer` parameter to the mirror resource
- Change `architectures` argument in both the mirror and publish resources for consistency

## [1.1.0] - 2019-08-03

- Add timeout argument for some time consuming resources
- Add support for aptly mirror `-filter-with-deps` argument
- Add support for aptly mirror `-with-udebs` and `-architectures` arguments
- Fix "can't modify frozen String" error caused by aptly_snapshot
- Fix broken `not_if` for in aptly_mirror resource
- Migrate to circleci for testing

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
