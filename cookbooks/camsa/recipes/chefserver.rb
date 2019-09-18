#
# Recipe to configure the chef server when it is run as a separate machine
#

if !node['camsa']['deploy']['automate'] &&
   node['camsa']['deploy']['chef']

  camsa_config_store 'automate_fqdn' do
    action :retrieve
  end

  directory node['camsa']['chefserver']['dir']['config'] do
    recursive true
  end

  # Write out the configuration file that will read all files in from the config dir
  #cookbook_file node['camsa']['chefserver']['file']['config'] do
  #  source 'chef-server.rb'
  #end
  
  chefserver_datacollector 'chef_automate_token'

  chefserver_ssl 'ssl_certificate'

  # Use the configuration template to add the settings from the previous resources
  # This allows control and when chef server will be reconfigured
  template node['camsa']['chefserver']['file']['config'] do
    variables({
      integration: lazy { 
        if ::File.exist?(::File.join(node['camsa']['chefserver']['dir']['config'], 'datacollector.rb'))
          ::IO.read(::File.join(node['camsa']['chefserver']['dir']['config'], 'datacollector.rb'))
        else
          ""
        end
       },
       certificate: lazy { 
        if ::File.exist?(::File.join(node['camsa']['chefserver']['dir']['config'], 'chefssl.rb'))
          ::IO.read(::File.join(node['camsa']['chefserver']['dir']['config'], 'chefssl.rb'))
        else
          ""
        end
       }       
    })
    notifies :run, 'bash[chef_reconfigure]', :delayed
  end
end