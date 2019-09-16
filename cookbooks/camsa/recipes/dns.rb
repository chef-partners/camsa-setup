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

# If the chef server is being deployed as a separate server, retrieve the license from the config_store
#config_store 'automate_license' do
#  action :retrieve

#  only_if { !node['camsa']['deploy']['automate'] && node['camsa']['deploy']['chef'] }
#end

# Configure the DNS entry for the server
automate_dns 'register_dns' do
  #license node.run_state[:http_data]['automate_license'] if !node['camsa']['deploy']['automate'] && node['camsa']['deploy']['chef']

  only_if { node['camsa']['managed_app'] }
end