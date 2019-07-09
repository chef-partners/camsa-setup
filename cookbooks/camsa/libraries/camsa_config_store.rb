require 'toml'
require 'uri'

module CAMSA
  class CAMSAConfigStore < CAMSABase

    resource_name :camsa_config_store

    property :name, String, name_property: true

    # Set the URL property
    property :url, String, default: lazy { node['camsa']['azure_functions']['camsa']['url'] }
    property :apikey, String, default: lazy { node['camsa']['azure_functions']['camsa']['apikey'] }

    # Define the properties that are used to set the data to send to
    # the endpoint
    # source_file - If this is specified the data will be read from this file
    property :source_file, String, default: ''

    # file_type_hint - Provide the resource with a hint on the type of file
    # If the file extension has not been specified then the resource will not
    # be able to determine how to ead it in
    property :file_type_hint, String, default: ''

    # source - Hashtable of values to send to the endpoint
    property :source, Hash, default: {}

    # Set the method to use when accessing the store
    property :http_method, String, default: 'POST'

    # Set a prefix that should be applyed to any keys that are added to the config store
    property :prefix, String, default: ''

    property :separate, Boolean, default: false

    action :run do

      headers = {}
      source = new_resource.source
      source_file = new_resource.source_file
      file_type_hint = new_resource.file_type_hint

      url = new_resource.url
      http_method = new_resource.http_method

      url += "/config"

      unless new_resource.apikey.empty?
        headers['x-functions-key'] = new_resource.apikey
      end

      # Ensure that either :source or :source_file has been specified
      if source.empty? && source_file.empty?
        log 'no_source' do
          message format(':source or :source_file must be specified for %s', new_resource)
          level :error
        end
      end

      if url == ''
        # If no URL has been specified do not attempt to make the call
        log 'No URL specified, skipping'
      else

        # If the source file exists, read it in, based on the file type
        # The values will be set in the source
        unless source_file.empty?
          if ::File.exist?(source_file)
            # Use the extension of the file to determine how to load the file
            extension = ::File.extname(source_file)
            unless extension.empty?
              case extension
              when '.toml'
                file_type_hint = 'toml'
              end
            end

            # Read in the file based on the file type hint
            case file_type_hint
            when 'toml'
              source = TOML.load_file(source_file)
            end
          else
            log 'source_file_not_found' do
              message format('Unable to find source file in resource %s: %s', new_resource, source_file)
              level :error
            end
          end
        end

        # Iterate around the keys in source and performt the necessary http requests
        if new_resource.separate
          source.each do |key, value|

            # ste the key with the prefix if on has been set
            unless new_resource.prefix.empty?
              key = format('%s_%s', new_resource.prefix, key)
            end

            camsa_http format('store_%s', key) do
              action http_method.downcase
              message Hash[key, value]
              status_codes [200, 204, 500]
              url url
              headers headers
            end
          end
        else
          camsa_http format('store_%s', new_resource.name) do
            action http_method.downcase
            message source
            status_codes [200, 204, 500]
            url url
            headers headers
          end
        end
      end
    end

    # Retrieve the named configuration item from the store
    action :retrieve do

      # Call the camsa http resource to get the data
      camsa_http new_resource.name do
        url prepare_url
        headers headers
        action :get
      end

    end

    action_class do

      def prepare_url

        url = new_resource.url
        parsed_uri = ::URI.parse(url)

        puts parsed_uri.scheme

        replacements = {
          scheme: parsed_uri.scheme,
          host: parsed_uri.host,
          path: format("config/%s", new_resource.name)
        }
        url = "%{scheme}://%{host}%{path}" % replacements

        url

      end
    end
  end
end
