#
# Recipe to integrate Chef Server with the Automate server when chef server is
# deployed separately to Automate

chefserver_datacollector 'chef_automate_token' do
  only_if { !node['camsa']['deploy']['automate'] && node['camsa']['deploy']['chef'] }
end