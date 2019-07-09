# Tests to ensure tat the users are setup on the Automate and Chef servers
deploy_automate = attribute('deploy_automate', default: true, description: 'States if the machine has had Automate deployed to it')
deploy_chef = attribute('deploy_chef', default: true, description: 'States if the machine has had Chef deployed to it')

username = attribute('username', description: 'Username setup on the server')

# Check that the Automate server has the specified user
if deploy_automate

  # Build up the URL that will be used to check for the user existence
  url = 'https://127.0.0.1/api/v0/auth/users/%s' % [username]
  describe http(url, ssl_verify: false) do
    its('status') { should cmp 200 }
  end
end

# Check that the chef server has the specified user
if deploy_chef

  # Configure the command to check for the user
  cmd = 'chef-server-ctl user-list --format json'
  describe json({command: cmd}) do
    # Need to work out how to test the body array itself as it is just an array
    # and is not nested
  end

  # The same needs to happen for the Org
end