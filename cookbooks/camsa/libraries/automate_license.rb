require 'json'

module CAMSA
  class AutomateLicense < CAMSABase

    resource_name :automate_license

    property :name, String, name_property: true
    property :url, String, default: 'https://127.0.0.1/api/v0/license/status'

    # Set certificate properties
    property :ssl_verify, String, default: 'none'
    property :cert_file, String, default: '/hab/svc/deployment-service/data/deployment-service.crt'
    property :key_file, String, default: '/hab/svc/deployment-service/data/deployment-service.key'
    property :cacert_file, String, default: '/hab/svc/deployment-service/data/root.crt'

    property :license, String, default: lazy { node['camsa']['automate']['license'] }
    property :license_filename, String, default: lazy { ::File.join(node['camsa']['dirs']['data'], 'license.txt') }
    property :trial_url, String, default: 'https://automate-gateway:2000/license/request'

    property :first_name, String, default: ''
    property :last_name, String, default: ''
    property :email, String, default: ''
    property :gdpr_agree, Boolean

    action :apply do
      
      license = new_resource.license

      # Set the filename for the license file
      license_filename = new_resource.license_filename

      # Determine if the instance is licensed or not
      if licensed?
        log 'Automate is licensed' do
          message node['camsa']['automate']['license']
        end

        # Read the license in so that it can be used by other resources
        license = ::IO.read(license_filename)
      else
        log 'Automate is NOT licensed' do
          level :warn
        end

        # Automate is not licensed, if a license has not been supplied request a trial licene
        # When a trial license is requested it will automatically license Automate
        if license == ''
          log 'Requesting Trial Licence'

          license = request_trial

        else

          # If a license has been set apply it to the installation
          log 'Applying license to local instance'

          # Command to execute to apply the license
          cmd = format('chef-automate license apply %s', license)

          result = shell_out(cmd)

          unless result.stderr == ''
            raise Chef::Exceptions::Application, format('Error applying License: %s', result.stderr)
          end

        end

        # Write out the license to disk as it maybe required again
        # Ideally this will be stored in the config store but this is not always available, especially during testing
        ::File.write(license_filename, license)

      end

      # Add the license to the run state
      node.run_state[:automate] ||= {}
      node.run_state[:automate][:license] ||= license

      # Add the license to the config_store
      camsa_config_store 'automate_license' do
        source({
            "automate_license": license
        })
      end
    end

    action_class do

      def licensed?
        # Initalise method variables
        result = false

        # Make a request to the specified endpoint
        options = build_options

        response = make_request('get', new_resource.url, [200, 401, 404], options)

        # If the status_code is 404 then the instance is not licensed
        result = true unless response[:status_code] == 404
        
        result
      end

      def request_trial
        # Define the result to return
        result = ''

        # Use the make_request function to get a license for the server
        options = build_options
        options[:body] = {
          first_name: new_resource.first_name,
          last_name: new_resource.last_name,
          email: new_resource.email,
          gdpr_agree: new_resource.gdpr_agree,
        }

        response = make_request('post', new_resource.trial_url, [200], options)

        result = response[:data]['license'] if response[:status_code] == 200

        result
      end
    end

  end
end