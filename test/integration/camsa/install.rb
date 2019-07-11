# Tests to ensure that the installation has been completed properly
base_dir = input('base_dir', value: '/usr/local/camsa', description: 'Base directory fo all CAMSA related files')
deploy_automate = input('deploy_automate', value: true, description: 'States if the machine has had Automate deployed to it')

# Check that the download of the automate package was successful
describe file('/tmp/kitchen/cache/chef-automate_linux_amd64.zip') do
  it { should exist }
end

# The automate command file exists and has the correct permissions
describe file('/usr/local/bin/chef-automate') do
  it { should exist }
  its('mode') { should cmp '0755' }
end

# The config.toml file should exist in the working directory
describe file(::File.join(base_dir, 'etc', 'config.toml')) do
  it { should exist }
end

if deploy_automate
  # Ensure that the credentials file has been archived and does not
  # exist in the working directory
  describe file(::File.join(base_dir, 'etc', 'automate-credentials.toml')) do
    it { should_not exist }
  end

  describe file(::File.join(base_dir, 'archive', 'automate-credentials.toml')) do
    it { should exist }
  end
end