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

# Recipe to configure the kernel for the Automate server
# This will only be run if automate is being deployed
node['camsa']['automate']['kernel'].each do |name, value|
  sysctl name do
    value value
    
    unless { node['camsa']['deploy']['supermarket'] }
  end
end