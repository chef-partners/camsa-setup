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

# Set the user that Statsd will run run
default['camsa']['chefserver']['user']['statsd'] = 'statsd'

# Set the path to the statsd js
default['camsa']['chefserver']['statsd']['location'] = '/usr/local/lib/node_modules/statsd/stats.js'