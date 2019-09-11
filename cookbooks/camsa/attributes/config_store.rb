# A lot of information is required by other aspects of CAMSA so set
# attributes there that inform the config_store recipe which configuration
# items to store

default['camsa']['config_store']['items'] = {
  'automate': {
    'automate_fqdn': node['fqdn'],
    'pip_automate_fqdn': '',
    'automate_internal_ip': node['azure']['metadata']['network']['local_ipv4'][0],
  },
  'chef': {
    'chefserver_fqdn': node['fqdn'],
    'pip_chef_fqdn': '',
    'chef_internal_ip': node['azure']['metadata']['network']['local_ipv4'][0],
  },
  'supermarket': {
    'supermarket_fqdn': node['fqdn'],
    'pip_supermarket_fqdn': '',
    'supermarket_internal_ip': node['azure']['metadata']['network']['local_ipv4'][0],
  }
}