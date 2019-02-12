# This resource sends configuration data to the config store
# The URL that is used is the name of the resource

require "toml"

resource_name :config_store

# Set the URL to send the data to
property :url, String, name_property: true

# Set the source. This is a hashtable of the values that need to
# set in the configuration store
property :source, Hash, default: {}

# Define source_file. If this is set then the resource will use values
# from the specified file to send data
property :source_file, String, default: ''

# Define a property to provide a hint to the resource about the type
# of file that is being read. This is in case an extension is not set
# on the filename that has been supplied
property :file_type_hint, String, default: ''

# Define the method that the http_request will use.
# This will usually be POST, and this is the default
property :http_method, String, default: 'POST'

action :run do
  # Ensure that either source or source_file has been specified
  if new_resource.source.empty? && new_resource.source_file.nil?
    log 'no_source' do
      message 'A source or source_file must be specified'
      level :error
    end
  end

  # If the source_file has been specified, read in the file and
  # set the source key values
  source = new_resource.source
  unless new_resource.source_file.nil?

    # Ensure that the file exists
    if ::File.exist?(new_resource.source_file)

      # Use the extension of the file to determine how to load the file
      extension = ::File.extname(new_resource.source_file)
      if extension != ''
        case extension
        when '.toml'
          new_resource.file_type_hint = 'toml'
        end
      end

      # Use the file_type_hint to 
      case new_resource.file_type_hint
      when 'toml'
        source = TOML.load_file(new_resource.source_file)
      end
    else
      log 'source_file_not_found' do
        message format('Unable to find source file: %s', new_resource.source_file)
        level :error
      end
    end

    # Iterate around the source and perform the necessary http requests
    source.each do |key, value|
      http_request format('store_%s', key) do
        action new_resource.http_method.downcase.to_sym
        message Hash[key, value].to_json
        url new_resource.url
      end
    end
  end
end
