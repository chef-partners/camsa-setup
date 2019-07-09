# Include necessary libraries
require 'net/http'
require 'net/https'
require 'openssl'
require 'uri'
require 'json'

module CAMSA
  class CAMSABase < Chef::Resource

    attr_accessor :data

    Boolean = property_type(
      is: [true, false],
      default: false
    ) unless defined?(Boolean)

    action_class do

      include Chef::Mixin::ShellOut

      def configure_http(uri, options = {})

        # Create the HTTP object
        http = ::Net::HTTP.new(uri.host, uri.port)

        # If the scheme of the request is HTTPS enable it
        if uri.scheme == 'https'
          http.use_ssl = true
          ::File.write('/home/azure/http.json', options.to_json)
          # Set certificate information if options has been set
          if options.key?(:ssl)
            case options[:ssl][:verify]
            when 'peer'
              http.verify_mode = ::OpenSSL::SSL::VERIFY_PEER
            when 'none'
              http.verify_mode = ::OpenSSL::SSL::VERIFY_NONE
            end

            # Set certificates for the request, if they have been specified
            unless options[:ssl][:certs][:cert].empty?

               unless ::File.exist?(options[:ssl][:certs][:cert])
                raise Chef::Exceptions::ConfigurationError, "The configured cert_file #{options[:ssl][:certs][:cert]} does not exist"
               end

               http.cert = ::OpenSSL::X509::Certificate.new(::File.read(options[:ssl][:certs][:cert]))
            end

            if options[:ssl][:certs].key?(:key) &&
              options[:ssl][:certs][:key] != ''
              
              unless ::File.exist?(options[:ssl][:certs][:key])
               raise Chef::Exceptions::ConfigurationError, "The configured key_file #{options[:ssl][:certs][:key]} does not exist"
              end

              http.key = ::OpenSSL::PKey::RSA.new(::File.read(options[:ssl][:certs][:key]))
            end
            
            if options[:ssl][:certs].key?(:cacert) &&
              options[:ssl][:certs][:cacert] != ''
              
              unless ::File.exist?(options[:ssl][:certs][:cacert])
               raise Chef::Exceptions::ConfigurationError, "The configured cacert_file #{options[:ssl][:certs][:cacert]} does not exist"
              end

              http.ca_file = options[:ssl][:certs][:cacert]
            end            
          end
        end

        # Return the http object
        http
      end

      def make_request(method, url, status_codes = [200], options = {})
        result = {}

        # Turn the URL string into a URI
        uri = ::URI.parse(url)

        # create the correct request object based on the method
        case method
        when 'get'
          request = ::Net::HTTP::Get.new(uri)
        when 'post'
          request = ::Net::HTTP::Post.new(uri)

          # if the options has a body add it to the request
          if options.key?(:body)
            request.body = options[:body].to_json
          end

          request['Content-Type'] = 'application/json'
          if options.key?(:contenttype)
            request['Content-Type'] = options[:contenttype]
          end
        end

        # If any headers exist in the options, add them to the request
        if options.key?(:headers) && !options[:headers].empty?
          options[:headers].each do |name, value|
            request.add_field(name, value)
          end
        end

        # Get the http request to work with
        http_options = options.key(:http) ? options[:http] : {}
        http = configure_http(uri, options[:http])

        # Perforn the request
        response = http.request(request)

        # Determine if the status code is not in the acceptable array
        if status_codes.include? response.code.to_i
          result[:status_code] = response.code.to_i
          result[:data] = JSON.parse(response.body) rescue response.body
        else
          raise Chef::Exceptions::ConfigurationError, format('Error in request [%s]: %s', response.code, response.body)
        end

        result
      end

      def build_options

        cert_file = ''
        key_file = ''
        cacert_file = ''

        headers = new_resource.respond_to?('headers') ? new_resource.headers : {}
        content_type = new_resource.respond_to?('content_type') ? new_resource.content_type : 'application/json'
        message = new_resource.respond_to?('message') ? new_resource.message : {}

        ssl_verify = new_resource.respond_to?('ssl_verify') ? new_resource.ssl_verify : 'none'

        if new_resource.respond_to?('cert_file')
          cert_file = new_resource.cert_file unless new_resource.cert_file.empty?
        end

        if new_resource.respond_to?('key_file')
          key_file = new_resource.key_file unless new_resource.key_file.empty?
        end

        if new_resource.respond_to?('cacert_file')
          cacert_file = new_resource.cacert_file unless new_resource.cacert_file.empty?
        end

        options = {
          "headers": headers,
          "contenttype": content_type,
          "http": {
            "ssl": {
              "verify": ssl_verify,
              "certs": {
                "cert": cert_file,
                "key": key_file,
                "ca": cacert_file,
              }
            }
          }
        }

        # Add in the message body if it has been supplied
        options[:body] = message unless message.empty?

        options
      end
    end
  end
end
