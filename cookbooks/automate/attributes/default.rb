# Define the configuration and log locations
default['automate']['download']['url'] = 'https://packages.chef.io/files/current/automate/latest/chef-automate_linux_amd64.zip'
default['automate']['command']['location'] = '/usr/local/bin/chef-automate'

# Set the paths to the certificate files
default['automate']['certs']['cert'] = '/hab/svc/deployment-service/data/deployment-service.crt'
default['automate']['certs']['key'] = '/hab/svc/deployment-service/data/deployment-service.key'
default['automate']['certs']['cacert'] = '/hab/svc/deployment-service/data/root.crt'