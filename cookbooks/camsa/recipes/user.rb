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

# Recipe to create the user on the Automate and Chef server based on what
# has been deployed

# If the username has not been set use the firstname and lastname to generate it
if node['camsa']['username'].empty?
  node.default['camsa']['username'] = "%s%s" % [node['camsa']['firstname'].downcase, node['camsa']['lastname'].downcase]
end

# Create the automate user
if node['camsa']['deploy']['automate']
  automate_user node['camsa']['username'] do
    firstname node['camsa']['firstname']
    lastname node['camsa']['lastname']
    password node['camsa']['password']

    # User the named token that has been stored in the run state
    # This might be better to get from the config store rather than the run state
    # as this may be executed on a different run to when the token was generated
    token lazy { node.run_state[:tokens]['user_automate_token'] }
  end
end

# Create the Chef organisation and user
if node['camsa']['deploy']['chef']
  chefserver_user node['camsa']['username'] do
    firstname node['camsa']['firstname']
    lastname node['camsa']['lastname']
    username node['camsa']['username']
    password node['camsa']['password']
    emailaddress node['camsa']['emailaddress']
  end

  chefserver_org node['camsa']['chefserver']['org']['name'] do
    description node['camsa']['chefserver']['org']['description']
    username node['camsa']['username']
  end
end
