# Automate License
#
# This recipe configures the trial license if it 
# has not been supplied to the client run

# Create a shortcut to the automate attributes
automate = node['automate']

# The web_request needs to be able to read the certificate files
# In a normal chef0-client run it would be able to do this because chef-client
# is running as root
# However when running in Test Kitchen it is not running as root so the
# permissions of the files need to be changed in this situation
# Iterate around the certs attribute and check the permissions for each, but only if not
# running as root
automate['certs'].each do |name, path|
  bash format('set_perms_%s', name) do
    code <<-EOH
    sudo chmod 0644 #{path}
    EOH
    not_if { ENV['TEST_KITCHEN'].nil? }
  end
end

# Determine if automate is licensed
# This done by calling the api endpoint to get the license status
# The response for this is is stored in node.run_state[:web_response]['is_automate_licensed']
web_request 'is_automate_licensed' do
  url 'https://127.0.0.1/api/v0/license/status'
  ssl_verify 'none'
  action :get
  status_code [200, 404]
end

# Attempt to create license key if one has not been specified
web_request 'trial_automate_license' do
  url 'https://automate-gateway:2000/license/request'
  action :post
  message ({
    first_name: node['camsa']['firstname'],
    last_name: node['camsa']['lastname'],
    email: node['camsa']['emailaddress'],
    gdpr_agree: node['camsa']['gdpr_agree'],
  })
  cert_file automate['certs']['cert']
  key_file automate['certs']['key']
  cacert_file automate['certs']['cacert']
  only_if { 
    node['camsa']['license'] == ''
  }
  not_if {
    lazy { node.run_state[:web_response]['is_automate_licensed'].key?(:license_id) }
  }
end

# Determine the license top use, this can be supplied or it may have been
# requested as a trial license in the previous resource
ruby_block 'determine_license' do
  block do
    node.run_state[:license] =  if node['camsa']['license'].empty?
                                  node.run_state[:web_response][:license]
                                else
                                  node['camsa']['license']
                                end
  end
end

# Apply the license to the local automate instance
bash 'apply_license' do
  code lazy { "chef-automate license apply #{node.run_state[:web_response]['trial_automate_license']['license']}" }
  not_if { 
    lazy { node.run_state[:web_response]['is_automate_licensed'].key?(:license_id) }
  }
end
