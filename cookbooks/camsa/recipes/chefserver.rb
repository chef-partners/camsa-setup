#
# Recipe to configure the chef server when it is run as a separate machine
#

if !node['camsa']['deploy']['automate'] &&
   node['camsa']['deploy']['chefserver']

  camsa_config_store 'automate_fqdn' do
    action :retrieve
  end

  directory node['camsa']['chefserver']['dir']['config'] do
    recursive true
  end

  # Write out the configuration file that will read all files in from the config dir
  cookbook_file node['camsa']['chefserver']['file']['config'] do
    source 'chef-server.rb'
  end
  
  chefserver_datacollector 'chef_automate_token' do
    recursive true

    notifies :run, 'bash[chef_reconfigure]', :delayed
  end

  chefserver_ssl 'ssl_certificate' do
    notifies :run, 'bash[chef_reconfigure]', :delayed
  end


end