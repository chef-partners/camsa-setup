
module CAMSA
  class AutomateDNS < CAMSABase

    resource_name :automate_dns

    # Set properties to send the data for the DNS entries
    property :verify_url, String, default: lazy { node['camsa']['azure_functions']['central']['url'] || '' }
    property :verify_apikey, String, default: lazy { node['camsa']['azure_functions']['central']['apikey'] || '' }

    property :license, String, default: lazy { node.run_state[:automate][:license] }
    property :subscription_id, String, default: lazy { node['azure']['metadata']['compute']['subscriptionId'] }

    # Define properties that need to be added to the request
    property :firstname, String, default: lazy { node['camsa']['firstname'] }
    property :lastname, String, default: lazy { node['camsa']['lastname'] }

    property :fqdn, String, default: lazy { node['fqdn'] }
    property :fqdn_pip, String, default: lazy { node['camsa']['tags']['x-pip-fqdn'] }

    property :creates, String, default: lazy { ::File.join(node['camsa']['dirs']['flags'], 'register_dns.flag') }

    action :run do
      register_with_dns unless sentinel_file.exist? || new_resource.verify_url.empty?
    end

    action_class do
      def register_with_dns

        # Get the options for the HTTP request
        options = build_options

        # Set the body of the rquest
        options[:body] = {
          name: format('%s %s', new_resource.firstname, new_resource.lastname),
          subscription_id: new_resource.subscription_id,
          automate_licence: new_resource.license,
          entries: [],
        }

        # Add in the enrties for the request if they have been specified
        unless new_resource.fqdn.empty? && new_resource.fqdn_pip.empty?

          # get the the hostname from the fqdn
          hostname = new_resource.fqdn.split(".")[0]

          options[:body][:entries] << {
            name: hostname,
            target: new_resource.fqdn_pip,
            type: 'cname',
          }
        end

        url = format('%s/dns?code=%s', new_resource.verify_url, new_resource.verify_apikey)
        response = make_request('post', url, [200, 500], options)

        # Write out the sentinel file
        ::File.write(new_resource.creates, '')
      end

      def sentinel_file
        ::Pathname.new(Chef::Util::PathHelper.cleanpath(
          new_resource.creates
        ))
      end
    end
  end
end
