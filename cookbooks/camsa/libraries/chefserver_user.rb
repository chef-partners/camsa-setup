# Custom resource to create a user on the Chef Server

require 'json'
require 'base64'

module CAMSA
  class ChefServerUser < CAMSABase

    resource_name :chefserver_user

    property :firstname, String
    property :lastname, String
    property :username, String, name_property: true
    property :password, String
    property :emailaddress, String
    property :url, String, default: lazy { node['camsa']['azure_functions']['camsa']['url'] }

    action :create do

      if user_exist?
        log 'User exists'
      else
        log 'User does NOT exist' do
          level :warn
        end

        # Create the user
        log 'Creating user'
        create_user
      end
    end

    action_class do

      def user_exist?

        # Build up the command that needs to be run
        cmd = 'chef-server-ctl user-list --format json'

        log cmd do
          level :debug
        end

        # Execute the command and then see if the user exists
        result = shell_out(cmd)
        
        unless result.stderr == ''
          raise Chef::Exceptions::Application, format('Error retrieving user list: %s', result.stderr)
        end

        # Turn the stdout into an object from the json
        users = JSON.parse(result.stdout)

        # See if the username exists in the list
        users.include? new_resource.username
      end

      def create_user

        # Build up the command to add the user to the chef server
        replacements = {
          username: new_resource.username,
          fullname: format('%s %s', new_resource.firstname, new_resource.lastname),
          emailaddress: new_resource.emailaddress,
          password: new_resource.password,
        }
        cmd = 'chef-server-ctl user-create %{username} %{fullname} %{emailaddress} "%{password}" --filename %{username}.pem' % replacements

        log cmd do
          level :debug
        end

        # Execute the command
        result = shell_out(cmd)

        unless result.stderr == ''
          raise Chef::Exceptions::Application, format('Error creating new user: %s', result.stderr)
        end        

        # Ensure that the user is an admin so new users can be created
        cmd = 'chef-server-ctl grant-server-admin-permissions %s' % [new_resource.username]

        log cmd do
          level :debug
        end

        # Execute the command
        result = shell_out(cmd)

        unless result.stderr == ''
          raise Chef::Exceptions::Application, format('Error setting user as admin on server: %s', result.stderr)
        end        

        # Send the information to the configuration store if the URL is not empty
        if new_resource.url.empty?
          log "Unable to send data to Configuration as no URL has been supplied"
        else
          camsa_config_store 'store_chef_username' do
            url new_resource.url
            source({
              "user": new_resource.username
            })
          end

          camsa_config_store 'store_chef_user_password' do
            url new_resource.url
            source({
              "user_password": new_resource.password
            })
          end

          camsa_config_store 'store_chef_user_key' do
            url new_resource.url
            source({
              "user_key": Base64.strict_encode64(::IO.read(format('%s.pem', new_resource.username)))
            })
          end
        end
      end
    end

  end
end