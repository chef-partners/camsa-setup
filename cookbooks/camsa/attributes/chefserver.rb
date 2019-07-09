# Attributes that are for the chef server component

default['camsa']['chefserver']['npm']['packages'] = [
  {
    'name': 'statsd',
    'version': '0.8.0',
    'options': [
      '-g'
    ]
  },
  {
    'name': 'azure-storage',
    'options': [
      '-g'
    ]
  },
  {
    'name': 'sprintf-js',
    'options': [
      '-g'
    ]
  }
]

# Set the user that Statsd will run run
default['camsa']['chefserver']['user']['statsd'] = 'statsd'