# Test to ensure that certificates are in place
base_dir = attribute('base_dir', default: '/usr/local/camsa', description: 'Base directory fo all CAMSA related files')
deploy_automate = attribute('deploy_automate', default: true, description: 'States if the machine has had Automate deployed to it')
deploy_chef = attribute('deploy_chef', default: true, description: 'States if the machine has had Chef deployed to it')
deploy_supermarket = attribute('deploy_supermarket', default: true, description: 'States if the machine has had Chef deployed to it')
automate_fqdn = attribute('automate_fqdn', description: 'FQDN of the automate server')
managed_app = attribute('managed_app', default: false)

if deploy_automate && deploy_chef && managed_app

  describe file(::File.join(base_dir, 'etc', 'patch_ssl.toml')) do
    it { should exist }
  end

  # Check that the certificates are in place
  describe file('/etc/letsencrypt/live/%s/fullchain.pem' % [automate_fqdn]) do
    it { should exist }
  end

  describe file('/etc/letsencrypt/live/%s/privkey.pem' % [automate_fqdn]) do
    it { should exist }
  end  

end

describe package('certbot') do
  it { should be_installed }
end

describe file(::File.join(base_dir, 'bin', 'renew_cert.sh')) do
  it { should exist }
  its('mode') { should cmp '0755' }
end

# Sentinel file exists
describe file(::File.join(base_dir, 'flags', 'certificate.flag')) do
  it { should exist }
end

# Ensure the cronjob is in place
describe crontab(path: '/etc/cron.d/renew_certificate') do
  its('commands') { should include ::File.join(base_dir, 'bin', 'renew_cert.sh') }
  its('minutes') { should cmp '30' }
  its('hours') { should cmp '0' }  
end