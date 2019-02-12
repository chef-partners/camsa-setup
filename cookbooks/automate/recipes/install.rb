
# Reference attributes
dirs = node['common']['dirs']
automate = node['automate']
automate_command = automate['command']['location']

# Download the automate package
url = automate['download']['url']
target = ::File.join(Chef::Config[:file_cache_path], ::File.basename(url))
remote_file target do
  source url
  not_if { ::File.exist?(target) }
end

# Unpack the downloaded files
bash 'unpack-automate' do
  code <<-EOF
gunzip -S .zip < #{target} > #{automate_command}
  EOF
  not_if { ::File.exist?(automate_command) }
end

# Ensure that the automate command is executable
file automate_command do
  mode '0755'
end

# If the config.toml file does not exist, initialise Chef automate
bash 'initialise-automate' do
  code <<-EOF
  chef-automate init-config
  EOF
  cwd dirs['working']
  not_if { ::File.exist?('config.toml') }
end

# Deploy automate
# If a return value of 95 is revceived, proceed as this means that automate
# has already been deployed
bash 'deploy-automate' do
  environment({
    "GRPC_GO_LOG_SEVERIY_LEVEL": 'info',
    "GRPC_GO_LOG_VERBOSITY_LEVEL": '2',
  })
  code <<-EOF
  chef-automate deploy config.toml --accept-terms-and-mlsa --debug
  EOF
  cwd dirs['working']
  returns [0, 95]

  # Notify resources that work with the credentials file to file
  notifies :run, 'config_store[store_credentials]', :immediately
end

# The deployment will have created a credentials file, from which the details
# need to be uploaded to the configuration store
credentials_file = ::File.join(dirs['working'], 'automate-credentials.toml')
config_store 'store_credentials' do
  url node['common']['config_store']['url']
  source_file credentials_file
  only_if { 
    ::File.exist?(credentials_file) && node['common']['config_store']['url'] != ''
  }
  action :nothing
end

# Copy the credentials file into another location as it does not
# need to be processed again when the recipe runs
archive_credentials_file = ::File.join(dirs['archive'], 'automate-credentials.toml')
file 'archive_credentials_file' do
  path archive_credentials_file
  content lazy { IO.read(credentials_file) }
  mode '0600'
  only_if { ::File.exist?(credentials_file) }
  action :create
end

file 'remove_credentials_file' do
  path credentials_file
  only_if { ::File.exist?(credentials_file) }
  action :delete
end
