# Attributes that are for the chef server component

default['camsa']['chefserver']['npm']['packages'] = [
  {
    'name': 'statsd',
    'version': '0.8.4',
    'options': [
      '-g'
    ]
  },
  {
    'name': 'azure-storage',
    'path': '%s/statsd/azure-queue' % [node['camsa']['dirs']['working']]
  },
  {
    'name': 'sprintf-js',
    'path': '%s/statsd/azure-queue' % [node['camsa']['dirs']['working']]
  }
]

default['camsa']['chefserver']['version'] = '13.0.17'
default['camsa']['chefserver']['download']['url'] = "https://packages.chef.io/files/stable/chef-server/%s/ubuntu/18.04/chef-server-core_%s-1_amd64.deb" % [node['camsa']['chefserver']['version']]

# Set the user that Statsd will run run
default['camsa']['chefserver']['user']['statsd'] = 'statsd'

# Set the path to the statsd js
default['camsa']['chefserver']['statsd']['location'] = '/usr/local/lib/node_modules/statsd/stats.js'