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

# Recipe to configure the data disks that have been added to the machine
# These are mounted so that the application is installed on the data disk
# and does not fill up the root disk

# If the automate component is being deployed format and mount the disk
if node['camsa']['deploy']['automate']

  node['camsa']['datadisks']['automate'].each do |datadisk|

    camsa_format_disk datadisk['device'] do
      label datadisk['label']
      fstype datadisk['fstype']
      mountpoint datadisk['mount']
    end

  end
end
