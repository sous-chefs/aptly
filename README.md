# aptly Cookbook

[![Cookbook Version](https://img.shields.io/cookbook/v/aptly.svg)](https://supermarket.chef.io/cookbooks/aptly)
[![Build Status](https://img.shields.io/circleci/project/github/sous-chefs/aptly/master.svg)](https://circleci.com/gh/sous-chefs/aptly)
[![OpenCollective](https://opencollective.com/sous-chefs/backers/badge.svg)](#backers)
[![OpenCollective](https://opencollective.com/sous-chefs/sponsors/badge.svg)](#sponsors)
[![License](https://img.shields.io/badge/License-Apache%202.0-green.svg)](https://opensource.org/licenses/Apache-2.0)

This cookbook installs and configures aptly [http://www.aptly.info](http://www.aptly.info)

## Maintainers

This cookbook is maintained by the Sous Chefs. The Sous Chefs are a community of Chef cookbook maintainers working together to maintain important cookbooks. If you’d like to know more please visit [sous-chefs.org](https://sous-chefs.org/) or come chat with us on the Chef Community Slack in [#sous-chefs](https://chefcommunity.slack.com/messages/C2V7B88SF).

## Requirements

### Platform

- Debian 9
- Debian 10
- Ubuntu 18.04
- Ubuntu 20.04

## Resources

- [`aptly_db`](documentation/resources/aptly_db.md)
- [`aptly_mirror`](documentation/resources/aptly_mirror.md)
- [`aptly_publish`](documentation/resources/aptly_publish.md)
- [`aptly_repo`](documentation/resources/aptly_repo.md)

## Testing

Please contribute to keep unit and functional tests up to date.
After modifications, please run the following commands to check if you break something:

- chef exec rspec
- kitchen test default-ubuntu-1804

NOTE: Available distro tests: `default-debian-8`, `default-debian-9`, `default-ubuntu-1604` and `default-ubuntu-1804`

NOTE2: if you want to use Policyfile, rename `Policyfile.rb.dist` to `Policyfile.rb` in root and test directories, then execute `chef update` in each folder. Look inside `.kitchen.yml` and `spec/spec_helper.rb` too.

## Contributors

This project exists thanks to all the people who [contribute.](https://opencollective.com/sous-chefs/contributors.svg?width=890&button=false)

### Backers

Thank you to all our backers!

![https://opencollective.com/sous-chefs#backers](https://opencollective.com/sous-chefs/backers.svg?width=600&avatarHeight=40)

### Sponsors

Support this project by becoming a sponsor. Your logo will show up here with a link to your website.

![https://opencollective.com/sous-chefs/sponsor/0/website](https://opencollective.com/sous-chefs/sponsor/0/avatar.svg?avatarHeight=100)
![https://opencollective.com/sous-chefs/sponsor/1/website](https://opencollective.com/sous-chefs/sponsor/1/avatar.svg?avatarHeight=100)
![https://opencollective.com/sous-chefs/sponsor/2/website](https://opencollective.com/sous-chefs/sponsor/2/avatar.svg?avatarHeight=100)
![https://opencollective.com/sous-chefs/sponsor/3/website](https://opencollective.com/sous-chefs/sponsor/3/avatar.svg?avatarHeight=100)
![https://opencollective.com/sous-chefs/sponsor/4/website](https://opencollective.com/sous-chefs/sponsor/4/avatar.svg?avatarHeight=100)
![https://opencollective.com/sous-chefs/sponsor/5/website](https://opencollective.com/sous-chefs/sponsor/5/avatar.svg?avatarHeight=100)
![https://opencollective.com/sous-chefs/sponsor/6/website](https://opencollective.com/sous-chefs/sponsor/6/avatar.svg?avatarHeight=100)
![https://opencollective.com/sous-chefs/sponsor/7/website](https://opencollective.com/sous-chefs/sponsor/7/avatar.svg?avatarHeight=100)
![https://opencollective.com/sous-chefs/sponsor/8/website](https://opencollective.com/sous-chefs/sponsor/8/avatar.svg?avatarHeight=100)
![https://opencollective.com/sous-chefs/sponsor/9/website](https://opencollective.com/sous-chefs/sponsor/9/avatar.svg?avatarHeight=100)
