
# Custom resource to create a user on the Chef Server

require 'json'
require 'base64'

module CAMSA
  class ChefServerOrg < CAMSABase

    resource_name :chefserver_org

    property :name, String, name_property: true
    property :description, String
    property :username, String
    property :url, String, default: lazy { node['camsa']['azure_functions']['camsa']['url'] }

    action :create do
      if org_exist?
        log 'Org exists'
      else
        log 'Org does NOT exist' do
          level :warn
        end

        # Create the org
        log 'Creating org'
        create_org
      end
    end

    action_class do

      def org_exist?
        # Build up the command that needs to be run
        cmd = 'chef-server-ctl org-list --format json'

        log cmd do
          level :debug
        end

        # Execute the command and then see if the org exists
        result = shell_out(cmd)
        
        unless result.stderr == ''
          raise Chef::Exceptions::Application, format('Error retrieving org list: %s', result.stderr)
        end

        # Turn the stdout into an object from the json
        orgs = JSON.parse(result.stdout)

        # See if the username exists in the list
        orgs.include? new_resource.name        
      end

      def create_org

        # Build up the command to add the org to the chef server
        replacements = {
          username: new_resource.username,
          orgname: new_resource.name,
          description: new_resource.description,
        }
        cmd = 'chef-server-ctl org-create %{orgname} "%{description}" --association-user %{username} --filename %{orgname}-validator.pem' % replacements

        log cmd do
          level :debug
        end

        # Execute the command
        result = shell_out(cmd)

        unless result.stderr == ''
          raise Chef::Exceptions::Application, format('Error creating new org: %s', result.stderr)
        end

        # Send the information to the configuration store if the URL is not empty
        if new_resource.url.empty?
          log "Unable to send data to Configuration as no URL has been supplied"
        else
          camsa_config_store 'store_chef_org_name' do
            url new_resource.url
            source({
              "org": new_resource.name
            })
          end

          camsa_config_store 'storeorg_validator_key' do
            url new_resource.url
            source({
              "org_validator_key": Base64.strict_encode64(::IO.read(format('%s-validator.pem', new_resource.name)))
            })
          end
        end        
      end
    end
  end
end