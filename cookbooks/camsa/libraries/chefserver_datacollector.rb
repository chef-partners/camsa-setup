

module CAMSA
  class ChefServerDataCollector < CAMSABase

    resource_name :chefserver_datacollector

    # Set the URL property
    property :url, String, default: lazy { node['camsa']['azure_functions']['camsa']['url'] }
    property :apikey, String, default: lazy { node['camsa']['azure_functions']['camsa']['apikey'] }

    # The name of the token to get to add to the chef server for sending
    # data to the Automate server
    property :token, String, name_property: true

    load_current_value do

    end

    action :run do

      if secret_exist?
        log "Integration exists"
      else
        log 'Integration does NOT exist' do
          level :warn
        end

        # Create the ncessary integration
        log 'Creating secret'
        create_secret
      end

    end

    action_class do

      def secret_exist?

        exist = true

        # Build up the command that is to be run
        cmd = 'chef-server-ctl show-secret data_collector token'

        log cmd do
          level :debug
        end

        # Execute the command and see if it errors
        # If it does then the secret does not exist
        result = shell_out(cmd)

        # If the stderr is not empty, see if it contains the phrase
        unless result.stderr == ''
          phrase = "Credential group 'data_collector' not found"

          if result.stderr.include?(phrase)
            exist = false
          else
            raise Chef::Exceptions::Application, format('Error checking for existing secret: %s', result.stderr)
          end
        end

        exist
      end

      def create_secret 

        # Use the base http class to get the data required
        url = new_resource.url
        parsed_uri = ::URI.parse(url)

        replacements = {
          scheme: parsed_uri.scheme,
          host: parsed_uri.host,
          path: format("%s/config/%s", parsed_uri.path, new_resource.token),
          query: parsed_uri.query,
        }
        url = "%{scheme}://%{host}%{path}?%{query}" % replacements

        options = build_options
        options[:headers]['x-functions-key'] = new_resource.apikey

        result = make_request('get', url, [200], options)

        log "Setting secret"

        # Get the automate fqdn to set in the chef server configuration file
        camsa_config_store 'automate_fqdn' do
          action :retrieve
        end

        # Build the command that is required
        cmd = 'chef-server-ctl set-secret data_collector token "%s"' % [result[:data][new_resource.token]]

        result = shell_out(cmd)

        unless result.stderr == ''
          raise Chef::Exceptions::Application, "Error setting 'data_collector' secret: %s" % [result.stderr]
        end
        
        # Update the configuration file with these settings
=begin        
        open('/etc/opscode/chef-server.rb', 'a') do |f|
          f.puts ''
          f.puts '# Setting data collector for Automate server'
          f.puts "data_collector['root_url'] = 'https://%s/data-collector/v0/'" % [node.run_state[:http_data]['automate_fqdn']]
          f.puts ''
          f.puts '# Setup access to CIS profiles in the Automate server'
          f.puts "profiles['root_url'] = 'https://%s'" % [node.run_state[:http_data]['automate_fqdn']]
        end
=end        

        template ::File.join(node['camsa']['chefserver']['dir']['config'], 'datacollector.rb') do
          source 'datacollector.rb'
          variables ({
            automate_fqdn: lazy { node.run_state[:http_data]['automate_fqdn'] }
          })
        end
      end
    end
  end
end