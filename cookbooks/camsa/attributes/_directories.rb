# Define the directories that need to be created on the machines so that the
# scritp etc required for CAMSA can be stored somewhere
default['camsa']['dirs']['working'] = '/usr/local/camsa'
default['camsa']['dirs']['bin'] = "#{node['camsa']['dirs']['working']}/bin"
default['camsa']['dirs']['etc'] = "#{node['camsa']['dirs']['working']}/etc"
default['camsa']['dirs']['archive'] = "#{node['camsa']['dirs']['working']}/archive"
default['camsa']['dirs']['flags'] = "#{node['camsa']['dirs']['working']}/flags"
default['camsa']['dirs']['data'] = "#{node['camsa']['dirs']['working']}/data"