name 'common'
maintainer 'Solution Engineers'
maintainer_email 'partnereng@chef,io'
license 'Apache-2.0'
description 'Performs installation and common tasks for all machines'
long_description 'Performs installation and common tasks for all machines'
version '0.1.0'
chef_version '>= 12.1' if respond_to?(:chef_version)

gem 'toml'