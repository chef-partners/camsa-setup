#
# Cookbook:: camsa
# Recipe:: user
#
# Copyright:: 2019, Chef Software
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

# Recipe to configure the Log Analytics monitoring for the servers, if enabled

# Automate monitoring
if node['camsa']['deploy']['automate'] &&
   node['camsa']['log_analytics']['enabled']

   # Configure the shell script that performs the monitoring
   filename = ::File.join(node['camsa']['dirs']['bin'], 'automate_monitoring.sh')
   template filename do
    source 'automate_monitoring.sh'
    variables({
      function_url: '%s/%s' % [node['camsa']['azure_functions']['camsa']['url'], node['camsa']['monitoring']['automate']['function']['name']],
      apikey: node['camsa']['azure_functions']['camsa']['apikey']
    })
    mode '0755'
   end

   # Create the cron to run the script regulalry
   cron_d 'automate_monitoring' do
    minute '*/5'
    command filename
   end
end

# Chef server monitoring
if node['camsa']['deploy']['chef'] &&
   node['camsa']['log_analytics']['enabled']

  # Install NodeJS on the machine to run statsd to recive data from the chef server
  include_recipe 'nodejs::install'

  # Install npm so that packages can be managed
  package 'npm'

  # Set the path to the statsd plugin, which will be put in place by the recipe
  plugin_path = ::File.join(node['camsa']['dirs']['working'], 'statsd', 'azure-queue', 'statsd-azure-queue.js')
  plugin_dir = ::File.dirname(plugin_path)

  # Create the user that statsd will run under
  user node['camsa']['chefserver']['user']['statsd']

  # Ensure that the necessary directories exist
  directory plugin_dir do
    recursive true
    owner node['camsa']['chefserver']['user']['statsd']
  end

  # The plugin is a javascript file that is stored in the cookbook, write this out to the disk
  cookbook_file plugin_path do
    source 'statsd-azure-queue.js'
    owner node['camsa']['chefserver']['user']['statsd']
  end

  # Install the specified npm packages
  node['camsa']['chefserver']['npm']['packages'].each do |package|
    npm_package package['name'] do
      version package['version'] if package.include?('version')
      options package['options']
    end
  end

  # Create the configuration file for statsd
  statsd_config_file = ::File.join(node['camsa']['dirs']['etc'], 'statsd_config.js')
  template statsd_config_file do
    source 'statsd_config.js'
    variables ({
      sa_name: node['camsa']['storage_account']['name'],
      access_key: node['camsa']['storage_account']['access_key'],
      plugin: plugin_path
    })
    owner node['camsa']['chefserver']['user']['statsd']
  end

  # Create the systemd service file to start Statsd on boot
  statsd_service_file = ::File.join('etc', 'systemd', 'system', 'statsd.service')
  template statsd_service_file do
    source 'statsd.service'
    variables ({
      user: node['camsa']['chefserver']['user']['statsd'],
      statsd_path: '',
      statsd_config_file: statsd_config_file
    })
  end

  # Enable and run the statsd service
  service 'statsd' do
    action [:enable, :start]
  end

  # TODO: The chef server configuration needs to be updated with the estats settings
  # This needs to be done by updating the Hab configuration and not the chef server config
  # directrly
=begin
chefserver_config_file = '/etc/opscode/chef-server.rb'
append_if_no_line 'chefserver_enable_statsd' do
  path chefserver_config_file
  line 'estatsd["enable"] = true'
  notifies :run, 'bash[chefserver-reconfigure]'
end

append_if_no_line 'chefserver_statsd_protocol' do
  path chefserver_config_file
  line 'estatsd["protocol"] = "statsd"'
  notifies :run, 'bash[chefserver-reconfigure]'
end

append_if_no_line 'chefserver_statsd_port' do
  path chefserver_config_file
  line 'estatsd["port"] = 8125'
  notifies :run, 'bash[chefserver-reconfigure]'
end
=end  
end