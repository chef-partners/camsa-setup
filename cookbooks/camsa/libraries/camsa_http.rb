module CAMSA
  class CAMSAHttp < CAMSABase

    resource_name :camsa_http

    property :name, String, name_property: true

    property :url, String
    property :message, Hash, default: {}
    property :status_codes, Array, default: [200]

    property :headers, Hash, default: {}
    property :content_type, String, default: 'application/json'

    property :ssl_verify, String, default: 'peer'

    # Add properties that allow the setting for certificates
    property :cert_file, String, default: ''
    property :key_file, String, default: ''
    property :cacert_file, String, default: ''

    action :get do

      # Create the options hash to send with the request
      options = build_options

      # Call the make request metod to perform this operation
      result = make_request('get', new_resource.url, new_resource.status_codes, options)

      # the result should carry the data that has been requested
      # add it to the runstate of the node
      node.run_state[:http_data] = result[:data]

    end

    action :post do

      options = build_options

      # Call the make request metod to perform this operation
      result = make_request('post', new_resource.url, new_resource.status_codes, options)

    end
  end
end
