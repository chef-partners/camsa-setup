
# Custom resource to handle accessing HTTP APIs
#
# This has been built because of two reasons
#  1. It is not possible to get the response from the built in `http_request` resource
#  2. Not clear how the current HTTP class in Chef is meant to be used
#
#     Initially it looked as though the Chef::HTTP::BasiClient could be used. This looked
#     like it would be the way to do things as it had support for setting the SSL files
#     However when the Chef::HTTP::HttpRequest class was looked at it appears that using
#     the BasicClient class is deprecated.
#     It is not clear how to set the certificate files etc

# Include necessary libraries
require 'net/http'
require 'net/https'
require 'openssl'
require 'uri'
require 'json'

# Set attributes on the resource
attr_accessor :http, :uri

# Set the name of the resource
resource_name :web_request

# Set properties of the resource
# URL to call when making the request
property :url, String, default: ''
property :message, Hash, default: {}

# Headers that should be added to the request
property :headers, Hash, default: lazy { {} }

property :ssl_verify, String, default: 'peer'
property :content_type, String, default: 'application/json'

# Add properties that allow the setting for certificates
property :cert_file, String, default: ''
property :key_file, String, default: ''
property :cacert_file, String, default: ''

# Set return code that is acceptable
property :status_code, Array, default: [200]

def initialize(name, run_context = nil)
  super
  @message = name

end

def configure_http(uri)

  # Create the HTTP object
  http = ::Net::HTTP.new(uri.host, uri.port)

  # If the scheme of the uri is https enable it
  if uri.scheme == 'https'
    http.use_ssl = true

    case ssl_verify
    when 'peer'
      http.verify_mode = ::OpenSSL::SSL::VERIFY_PEER
    when 'none'
      http.verify_mode = ::OpenSSL::SSL::VERIFY_NONE
    end
  end

  # If any of the certificate options have been set, configure SSL
  if cert_file != ''
    unless ::File.exist?(cert_file)
      raise Chef::Exceptions::ConfigurationError, "The configured cert_file #{cert_file} does not exist"
    end
    http.cert = ::OpenSSL::X509::Certificate.new(::File.read(cert_file))
  end

  if key_file != ''
    unless ::File.exist?(key_file)
      raise Chef::Exceptions::ConfigurationError, "The configured key_file #{key_file} does not exist"
    end
    http.key = ::OpenSSL::PKey::RSA.new(::File.read(key_file))
  end

  if cacert_file != ''
    unless ::File.exist?(cacert_file)
      raise Chef::Exceptions::ConfigurationError, "The configured cacert_file #{cacert_file} does not exist"
    end
    http.ca_file = cacert_file
  end

  http
end

action :post do
  converge_by(format('%s POST to %s', new_resource, new_resource.url)) do
    unless node.run_state.key?(:web_response) 
      node.run_state[:web_response] = {}
    end
    node.run_state[:web_response][new_resource.name] = {}

    # Create a URI object from the URL
    # THis should be done as a property, but I cannot work out how to set this
    # using an initialize method or other helper
    uri = URI.parse(new_resource.url)

    # Configure the http response using the URI
    # Again this should be part of the initialization
    http = configure_http(uri)

    # Create the body to send to the server
    message = new_resource.message.to_json
    body = message

    # Create the request to run
    request = ::Net::HTTP::Post.new(uri.path)
    request.body = body
    request['Content-Type'] = new_resource.content_type

    # Attempt to perform the request
    response = http.request(request)

    # Determine the response code from the request
    # If it is not 200 then assume there is an error can raise and exception
    if new_resource.status_code.include?(response.code)
      raise Chef::Exceptions::ConfigurationError, format('Error in request: %s', response.body)
    else
      node.run_state[:web_response][new_resource.name] = JSON.parse(response.body)
    end
  end
end

action :get do
  converge_by(format('%s GET to %s', new_resource, new_resource.url)) do
    unless node.run_state.key?(:web_response) 
      node.run_state[:web_response] = {}
    end
    node.run_state[:web_response][new_resource.name] = {}

    uri = URI.parse(new_resource.url)
    http = configure_http(uri)
    request = ::Net::HTTP::Get.new(uri.path)
    response = http.request(request)

    # Determine the response code from the request
    # If it is not 200 then assume there is an error can raise and exception
    if new_resource.status_code.include?(response.code)
      raise Chef::Exceptions::ConfigurationError, format('Error in request [%s]: %s', response.code, response.body)
    else
      node.run_state[:web_response][new_resource.name] = JSON.parse(response.body)
    end
  end
end
