# automate.rb - Installs and configures Automate server

# Name of the policy file
name 'automate'

# Where to find cookbooks to build the policy file
default_source :supermarket
default_source :chef_repo, '../'

include_policy 'base', path: './base.lock.json'

# Set the runlist for the base policy
run_list [
  'automate::kernel',
  'automate::install',
  'automate::license',
]
