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

# Configure the SSL certificate for the machine(s)
unless node['camsa']['deploy']['supermarket']

  # determine the start and stop commands for the service that a
  # certificate is being sought for
  if node['camsa']['deploy']['automate']
    start_command = 'chef-automate start'
    stop_command = 'chef-automate stop'
  elsif !node['camsa']['deploy']['automate'] && node['camsa']['deploy']['chef']
    start_command = 'chef-server-ctl start nginx'
    stop_command = 'chef-server-ctl stop nginx'
  end

  # Create the ceritficate for the server
  camsa_certificate 'automate' do
    schedule node['camsa']['cron']['certificate']
    start_command start_command
    stop_command stop_command
    fqdn node['fqdn']
    email_address node['camsa']['emailaddress']
    only_if { node['camsa']['managed_app'] }
  end
  
  automate_ssl 'ssl_patch' do
    only_if { node['camsa']['managed_app'] && node['camsa']['deploy']['automate'] }
  end

  chefserver_ssl 'ssl_certificate' do
    only_if { node['camsa']['managed_app'] && !node['camsa']['deploy']['automate'] && node['camsa']['deploy']['chefserver'] }
  end
end