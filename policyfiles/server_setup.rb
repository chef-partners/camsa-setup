# automate.rb - Installs and configures Automate server

# Name of the policy file
name 'server_setup'

# Where to find cookbooks to build the policy file
default_source :supermarket
default_source :chef_repo, '../'

# Add dependencies
cookbook 'nodejs', '~> 6.0', :supermarket
cookbook 'line', '~> 2.2.0', :supermarket
cookbook 'filesystem', '~> 1.0.0', :supermarket

run_list [
  'camsa::os_packages',
  'camsa::directories',
  'camsa::config_store',
  'camsa::datadisks',
  'camsa::clean',
  'camsa::kernel',
  'camsa::install',
  'camsa::license',
  'camsa::tokens',
  'camsa::user',
  'camsa::whitelist',
  'camsa::monitoring',
  'camsa::backup',
  'camsa::dns',
  'camsa::certificate',
  'camsa::chefserver'
]
