# Attributes that pertain to the Automate server installed and configuration

# Define the tokens that are to be setup on the automate server
default['camsa']['automate']['tokens'] = [
  'user_automate_token',
]

# If the chef server is not being deployed to the same machine as automate then
# a chef token is required for integration
if !node['camsa']['deploy']['chef'] &&
   node['camsa']['deploy']['automate']
  node.default['camsa']['automate']['tokens'] << 'chef_automate_token'
end

# Define the kernel settings
default['camsa']['automate']['kernel'] = {
  "vm.max_map_count": 262144,
  "vm.dirty_expire_centisecs": 20000
}

# Set where the package should be downloaded from
default['camsa']['automate']['download']['channel'] = 'current'
default['camsa']['automate']['download']['url'] = 'https://packages.chef.io/files/%s/automate/latest/chef-automate_linux_amd64.zip' % [node['camsa']['automate']['download']['channel']]
default['camsa']['automate']['command']['location'] = '/usr/local/bin/chef-automate'

# Set the paths to the certificate files
# These are used to correctly access the server when creating the license
default['camsa']['automate']['certs']['cert'] = '/hab/svc/deployment-service/data/deployment-service.crt'
default['camsa']['automate']['certs']['key'] = '/hab/svc/deployment-service/data/deployment-service.key'
default['camsa']['automate']['certs']['cacert'] = '/hab/svc/deployment-service/data/root.crt'

default['camsa']['automate']['license'] = ''