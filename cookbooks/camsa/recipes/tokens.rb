#
# Cookbook:: camsa
# Recipe:: tokens
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

# Recipe to generate the tokens in Automate that are required for API access

# Iterate around the tokens so that each one is created in the automate server
if node['camsa']['deploy']['automate']
  node['camsa']['automate']['tokens'].each do |token_name|
    # Set the flag for this token
    flag_filename = File.join(node['camsa']['dirs']['flags'], format('%s.flag', token_name))

    automate_token token_name do
      creates flag_filename
    end
  end
end
