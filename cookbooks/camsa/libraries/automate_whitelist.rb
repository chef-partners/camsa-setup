
module CAMSA
  class AutomateWhitelist < CAMSABase

    resource_name :automate_whitelist

    property :license, String, default: lazy { node.run_state[:automate][:license] }
    property :license_filename, String, default: lazy { ::File.join(node['camsa']['dirs']['data'], 'license.txt') }

    property :subscription_id, String, default: lazy { node['azure']['metadata']['compute']['subscriptionId'] }

    property :url, String, default: lazy { node['camsa']['azure_functions']['central']['url'] }
    property :apikey, String, default: lazy { node['camsa']['azure_functions']['central']['apikey'] }

    action :run do
      if new_resource.url.empty? || new_resource.apikey.empty?
        log 'whitelisting' do
          message 'Unable to determine if app is whitelisted as central functions URL or api key have not been specified'
          level :warn
        end
      else
        result = whitelisted?
        if result

          # Call function to add the data to the config store
          update_store(result)
        else
          log 'License and subscription are not whitelisted'
        end
      end
    end

    action_class do

      headers = {}

      # Determine if this subscription and license have been whitelisted
      def whitelisted?

        # Initialise method variables
        result = false

        # Setup the options to call the verify endpoint to see if this installation
        # has been whitelisted or not
        options = build_options

        # Set the data in the options
        options[:body] = {
          "subscription_id": new_resource.subscription_id,
          "automate_licence": new_resource.license,
        }

        @headers = {
          "x-functions-key": new_resource.apikey
        }
        options[:headers] = @headers

        # Configure the url that needs to be accessed
        url = format('%s/verify', new_resource.url)

        # Make the call
        response = make_request('post', url, [200, 401, 404], options)

        if response[:status_code] == 401
          log 'Unauthorised access to central functions' do
            level :warn
          end
        end

        # Use the status code to determine if the workspace id and key have been returned
        result = response[:data] if response[:status_code] == 200

        result

      end

      def update_store(details)

        # Add the workspace_key to the configuration store
        camsa_config_store 'central_logging_workspace_key' do
          source ({
            "workspace_key": details["workspace_key"],
            "category": 'central_logging',
          })
          not_if { url.empty? }
        end

        camsa_config_store 'central_logging_workspace_id' do
          source ({
            "workspace_id": details["workspace_id"],
            "category": 'central_logging',
          })
          not_if { url.empty? }
        end
      end
    end
  end
end