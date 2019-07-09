# Custom resource to create a user on the Automate instance
# This needs to use the token value store in run_state to create the user, however 
# this cannot be done in a recipe as the run_state is not known until runtime
# and the inputs to the resource are evaluated at compile time

module CAMSA
  class AutomateUser < CAMSABase

    resource_name :automate_user

    property :firstname, String
    property :lastname, String
    property :username, String, name_property: true
    property :password, String
    property :url, String, default: 'https://127.0.0.1/api/v0/auth/users'
    property :ssl_verify, String, default: 'none'
    property :cert_file, String, default: '/hab/svc/deployment-service/data/deployment-service.crt'
    property :key_file, String, default: '/hab/svc/deployment-service/data/deployment-service.key'
    property :cacert_file, String, default: '/hab/svc/deployment-service/data/root.crt'
    property :token, String

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
        result = false

        # Set the URL
        url = format('%s/%s', new_resource.url, new_resource.username)

        # Make the request to determine if the user already exists
        options = build_options
        response = make_request('get', url, [200, 404], options)

        # If the status_code is 404 then the user does not exist
        result = true unless response[:status_code] == 404

        result
      end

      def create_user 

        # Get the token that needs to be used to create the user
        token = new_resource.token

        options = build_options
        options[:headers] = {
          "api-token": token
        }
        options[:body] = {
          "name": format('%s %s', new_resource.firstname, new_resource.lastname),
          "username": new_resource.username,
          "password": new_resource.password,
        }

        response = make_request('post', new_resource.url, [200], options)
      end
    end

  end
end