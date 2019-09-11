#
# Cookbook:: camsa
# Recipe:: datadisks
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

# Recipe to install the require software
# For the Chef and Automate components the products will be deployed using the
# automate-ctl command.

# Reference attributes
dirs = node['camsa']['dirs']
automate = node['camsa']['automate']
automate_command = automate['command']['location']

# Install Chef or Automate if stated by the deployment
unless node['camsa']['deploy']['supermarket']

  # Download the automate package
  url = automate['download']['url']
  target = ::File.join(Chef::Config[:file_cache_path], ::File.basename(url))
  remote_file target do
    source url
  end

  # Unpack the downloaded files
  bash 'unpack-automate' do
    code <<-EOF
    `which unzip` -o #{target}
    mv chef-automate #{automate_command}
    EOF
    not_if { ::File.exist?(automate_command) }
  end

  # Ensure that the automate command is executebale
  file automate_command do
    mode '0755'
  end

  # If the config.toml file does not exist, initialise Chef automate
  bash 'initialise-automate' do
    code <<-EOF
    chef-automate init-config
    EOF
    cwd dirs['etc']
    not_if { ::File.exist?('config.toml') }
  end

  # Deployment
  # Determine the command to run based on what is being deployed
  # The Chef automate installer can install automate and chef
  cmd_parts = [
    automate_command,
    'deploy',
    'config.toml',
    '--accept-terms-and-mlsa',
  ]

  # If in debug mode add the debug flag
  cmd_parts << '--debug' if node['camsa']['debug']

  # Add the products to deploy
  cmd_parts << '--product automate' if node['camsa']['deploy']['automate']
  cmd_parts << '--product chef-server' if node['camsa']['deploy']['chef']

  bash 'deploy_software' do
    code cmd_parts.join(' ')
    cwd dirs['etc']
    returns [0, 95]

    # Notify resource to add the automate credentials to the config store
    notifies :run, 'camsa_config_store[automate_credentials]', :immediately
  end

  # Create resource to upload the Automate credentials
  credentials_file = ::File.join(dirs['etc'], 'automate-credentials.toml')
  camsa_config_store 'automate_credentials' do
    source_file credentials_file
    separate true
    prefix 'automate_credentials'

    # Do not run this resource by default as it will be notified
    action :run

    # Only do this if the credentials file exists
    only_if { ::File.exist?(credentials_file) && node['camsa']['deploy']['automate'] }
  end

  # Archive the credentials file so that it is not repeatedly processed when the
  # recipe is run
  archive_credentials_file = ::File.join(dirs['archive'], ::File.basename(credentials_file))
  file 'archive_automate_credentials' do
    path archive_credentials_file
    content lazy { IO.read(credentials_file) }
    mode '0600'
    
    # Only perform this if the credentials file exists and automate is deployed
    only_if { ::File.exist?(credentials_file) && node['camsa']['deploy']['automate'] }

    # Remove the orginal credentials file
    notifies :delete, 'file[remove_automate_credentials]', :immediately
  end

  # If deploying automate remove the credentials file after it has been archived
  file 'remove_automate_credentials' do
    path credentials_file
    action :nothing
  end

end