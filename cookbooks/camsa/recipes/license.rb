#
# Cookbook:: camsa
# Recipe:: license
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

# Recipe to configure the license for Automate
automate = node['camsa']['automate']

if node['camsa']['deploy']['automate']
  # The web_request needs to be able to read the certificate files
  # In a normal chef-client run it would be able to do this because chef-client
  # is running as root
  # However when running in Test Kitchen it is not running as root so the
  # permissions of the files need to be changed in this situation
  # Iterate around the certs attribute and check the permissions for each, but only if not
  # running as root
  automate['certs'].each do |name, path|
    bash format('set_perms_%s', name) do
      code <<-EOH
      sudo chmod 0644 #{path}
      EOH
      not_if { ENV['TEST_KITCHEN'].nil? }
    end
  end

  # Create (if necessary) and the set the license on the server
  automate_license 'set_automate_license' do
    first_name node['camsa']['firstname']
    last_name node['camsa']['lastname']
    email node['camsa']['emailaddress']
    gdpr_agree node['camsa']['gdpr']
  end
end