# This resource is responsible for generating the necessary Automate API tokens
# so that the chef server, logging and user access is enabled.

# IN order to act on the result from the command that generates the token the resource
# uses the ShellOut mixin to capture the data and then pass it to the config_store resource

# Additionally all the tokens are placed in the run_state so that they can be used later on if so
# required

module CAMSA
  class AutomateToken < CAMSABase

    resource_name :automate_token

    property :name, String, name_property: true

    property :creates, String, default: ''

    action :create do
      get_token_from_automate unless sentinel_file.exist?
    end

    action_class do
      include Chef::Mixin::ShellOut

      def get_token_from_automate
        @data ||= {}

        @data[:tokens] = {} unless @data.key?(:tokens)

        cmd = 'chef-automate admin-token'
        result = shell_out(cmd)

        # If there is no error save the token in the config store
        # and write out the flag file
        if result.stderr == ''
          # Use the config store resource to save the token result
          camsa_config_store format('store_%s', new_resource.name) do
            source({
                "#{new_resource.name}": "#{result.stdout.strip}"
            })
          end

          # Create the sentinel file that will be prevent automate from 
          # generating the token again. The contents of this file will be the token
          # This is not ideal but not easy to transfer values around classes
          ::File.write(new_resource.creates, result.stdout.strip)

          # Set the run_state with the value
          node.run_state[:tokens] ||= {}
          node.run_state[:tokens][new_resource.name] ||= result.stdout.strip
        else
        end
      end

      def sentinel_file
        ::Pathname.new(Chef::Util::PathHelper.cleanpath(
          new_resource.creates
        ))
      end
    end

  end
end