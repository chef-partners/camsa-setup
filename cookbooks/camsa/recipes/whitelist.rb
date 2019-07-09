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

#
# Recipe to contact the CAMSA whielist function and get the workspace id and
# key. This is required to send data from the client managed application to the
# central logging.
#
# All the data is passed to the configuration store so that the necessary local
# functions are able to get the data

automate_whitelist 'central_logging_workspace' do
  only_if { node['camsa']['deploy']['automate'] }
end