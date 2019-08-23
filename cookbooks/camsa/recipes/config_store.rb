#
# Cookbook:: camsa
# Recipe:: config_store
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

# Recipe to extract all the relevant information from the server and add to
# the configuration store using the API
#
# This information is retrieved from the Ohai data that is supplied from the
# Azure metadata

# The tags that have been applied to the instance in azure are not an object 
# when retrieved from Ohai. These need to be turned into an object so that the
# relevant attributes can be set properly
#
# The tags are in the form:
#   name:foo;fqdn:foo.bar.com

tags = node['azure']['metadata']['compute']['tags'].split(';').map { |i| i.split ':'}.to_h

node.override['camsa']['tags'] = tags

# Now that the tags have been set, set the attributes
#node.override['camsa']['config_store']['items']['automate']['automate_fqdn'] = tags['x-fqdn']
node.override['camsa']['config_store']['items']['automate']['pip_automate_fqdn'] = tags['x-pip-fqdn']
#node.override['camsa']['config_store']['items']['chef']['automate_fqdn'] = tags['x-fqdn']
node.override['camsa']['config_store']['items']['chef']['pip_chef_fqdn'] = tags['x-pip-fqdn']
#node.override['camsa']['config_store']['items']['supermarket']['automate_fqdn'] = tags['x-fqdn']
node.override['camsa']['config_store']['items']['supermarket']['pip_supermarket_fqdn'] = tags['x-pip-fqdn']

# Iterate around the basic configuration store items
node['camsa']['config_store']['items'].each do |server_type, details|

  # Add the items to the configuration store based on whether the server type is being
  # deployed or not
  if node['camsa']['deploy'][server_type]
    details.each do |name, value|
      camsa_config_store name do
        source ({
          "#{name}": "#{value}"
        })
      end
    end
  end
end