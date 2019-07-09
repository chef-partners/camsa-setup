name 'camsa'
maintainer 'Chef Software Ltd'
maintainer_email 'partnereng@chef.io'
license 'Apache-2.0'
description 'Performs installation and configuration of software for Azure Managed App'
long_description 'Performs installation and configuration of software for Azure Managed App'
version '0.1.0'
chef_version '>= 12.1' if respond_to?(:chef_version)

gem 'toml'

depends 'filesystem', '~> 1.0.0'
depends 'nodejs', '~> 6.0'
depends 'line', '~> 2.2.0'