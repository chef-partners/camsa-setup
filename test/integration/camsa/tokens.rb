deploy_automate = attribute('deploy_automate', default: true, description: 'States if the machine has had Automate deployed to it')
deploy_chef = attribute('deploy_chef', default: true, description: 'States if the machine has had Chef deployed to it')

# Test to check that tokens have been created properly
# This checks for the existence of the sentinel files
if deploy_automate
  describe file('/usr/local/camsa/flags/user_automate_token.flag') do
    it { should exist }
  end
end

if deploy_automate && !deploy_chef
  describe file('/usr/local/camsa/flags/chef_automate_token.flag') do
    it { should exist }
  end  
end