# Define directories that need to be created for the setup
# Working directory
default['common']['dirs']['working'] = '/usr/local/camsa'
default['common']['dirs']['archive'] = "#{node['common']['dirs']['working']}/archive"

# Set the URL that will be used to post data to the config store
default['common']['config_store']['url'] = ''

# Define the default values for the CAMSA attributes
default['camsa']['license'] = ''
default['camsa']['firstname'] = ''
default['camsa']['lastname'] = ''
default['camsa']['emailaddress'] = ''
default['camsa']['gdpr'] = 1
