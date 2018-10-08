# frozen_string_literal: true
#
# Cookbook:: aptly
# Attributes:: aptly
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

default['aptly']['repository']['uri'] = 'http://repo.aptly.info/'
default['aptly']['repository']['dist'] = 'squeeze'
default['aptly']['repository']['components'] = ['main']
default['aptly']['repository']['key'] = 'https://www.aptly.info/pubkey.txt'

default['aptly']['user'] = 'aptly'
default['aptly']['group'] = 'aptly'

default['aptly']['rootDir'] = '/opt/aptly'
default['aptly']['downloadConcurrency'] = 4
default['aptly']['downloadSpeedLimit'] = 0
default['aptly']['architectures'] = []
default['aptly']['dependencyFollowSuggests'] = false
default['aptly']['dependencyFollowRecommends'] = false
default['aptly']['dependencyFollowAllVariants'] = false
default['aptly']['dependencyFollowSource'] = false
default['aptly']['gpgDisableSign'] = false
default['aptly']['gpgDisableVerify'] = false
default['aptly']['gpgProvider'] = 'gpg'
default['aptly']['downloadSourcePackages'] = false
default['aptly']['skipLegacyPool'] = true
default['aptly']['ppaDistributorID'] = 'ubuntu'
default['aptly']['ppaCodename'] = ''
default['aptly']['FileSystemPublishEndpoints'] = {}
default['aptly']['S3PublishEndpoints'] = {}
default['aptly']['SwiftPublishEndpoints'] = {}

default['aptly']['gpg']['name-real'] = 'Aptly'
default['aptly']['gpg']['name-comment'] = 'Aptly Key'
default['aptly']['gpg']['name-email'] = 'organisation@example.org'
default['aptly']['gpg']['expire-date'] = 0
default['aptly']['gpg']['passphrase'] = 'GreatPassPhrase'
