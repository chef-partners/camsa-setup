#
# Cookbook:: camsa
# Recipe:: clean
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

# This recipe should only be used during testing an development
# To make some operations idempotent certain operations drop semaphore flags
# onto the disk. This means that these operations will not run again.
# However during development this may be desirable, so if the clean attribute has
# been set these flag file will be deleted

require 'json'

if node['camsa']['clean']
  node['camsa']['automate']['tokens'].each do |token_name|
    # Set the flag for this token
    flag_filename = File.join(node['camsa']['dirs']['flags'], format('%s.flag', token_name))

    file flag_filename do
      action :delete
    end
  end
end

log node['camsa']['automate']['tokens'].to_json