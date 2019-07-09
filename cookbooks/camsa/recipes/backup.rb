#
# Cookbook:: camsa
# Recipe:: backup
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

# Recipe to configure backups for the different components
# This will write out the backup script to the disk and then configure the necessary cronjobs 
# for the backups
#
# As chef and automate are now installed in the same package (although can be on different servers)
# the same backup script can be used. In both cases the `automate` backup type will be used

# Write out the backup script to the correct location on disk
backup_filename = ::File.join(node['camsa']['dirs']['bin'], 'backup.sh')
cookbook_file backup_filename do
  source 'backup.sh'
  mode '0755'
end

# Create the backup script configuration file
config_filename = ::File.join(node['camsa']['dirs']['etc'], 'backup_config')
template config_filename do
  source 'backup_config.erb'
  variables ({
    sa_name: node['camsa']['storage_account']['name'],
    container_name: node['camsa']['storage_account']['container_name'],
    access_key: node['camsa']['storage_account']['access_key'],
  })
end

if node['camsa']['deploy']['automate'] ||
   node['camsa']['deploy']['chef']

  # Determine the type to pass to the backup script based on the runlist
  backup_type = 'automate'

end

if node['camsa']['deploy']['supermarket'] 
  backup_type = 'supermarket'
end

# Create the cronjob for the backup
timing = node['camsa']['cron']['backup'].split(' ')
cron_d format('%s_backup', backup_type) do
  minute timing[0]
  hour timing[1]
  day timing[2]
  month timing[3]
  weekday timing[4]
  command format('%s -t %s', backup_filename, backup_type)

  not_if { backup_type.nil? }
end