# Attributes that pertain to the URL and keys for the functions
# that need to be accessed during the installation of the software

# These values will be injected in to the Chef Infra run during the deployment

# CAMSA functions are those that have been deployed alongside the application
default['camsa']['azure_functions']['camsa']['url'] = ''
default['camsa']['azure_functions']['camsa']['apikey'] = ''

# Central functions are those that are to be contacted if the deployment is a
# managed application and need to verify the client as well as register for DNS
default['camsa']['azure_functions']['central']['url'] = ''
default['camsa']['azure_functions']['central']['apikey'] = ''

default['camsa']['monitoring']['automate']['function']['name'] = 'AutomateLog'