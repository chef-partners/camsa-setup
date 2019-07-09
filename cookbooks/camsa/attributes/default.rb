# Attributes in here are ones that do not necessarily fit into any particular category

# State of the deployment of the application is managed
default['camsa']['managed_app'] = false

# Define what components are being deployed
# If Automate and Chef are both set to true, as is the default, then it will
# be an all in one installation
default['camsa']['deploy'] = {
  'automate': true,
  'chef': true,
  'supermarket': false,
}

# If there is an issue with the deployment and configuration debug mode
# can be tured on
default['camsa']['debug'] = false

# Define the user attributes to be used when configuring the servers
default['camsa']['firstname'] = ''
default['camsa']['lastname'] = ''
default['camsa']['username'] = ''
default['camsa']['password'] = ''
default['camsa']['emailaddress'] = ''
default['camsa']['gdpr'] = false

default['camsa']['chefserver']['org']['name'] = ''
default['camsa']['chefserver']['org']['description'] = ''

default['camsa']['log_analytics']['enabled'] = true

# Attribute to hold tags that are assigned to the instance in Azure
default['camsa']['tags'] = {}