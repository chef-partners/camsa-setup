# Tests to ensure that the monitoring of the componens has been configured
# correctly
base_dir = input('base_dir', value: '/usr/local/camsa', description: 'Base directory fo all CAMSA related files')
deploy_automate = input('deploy_automate', value: true, description: 'States if the machine has had Automate deployed to it')
deploy_chef = input('deploy_chef', value: true, description: 'States if the machine has had Chef deployed to it')
statsd_user = input('statsd_yser', value: 'statsd', description: 'User that the statsd service will run under')


# Automate server monitoring
if deploy_automate

  # Set the monitoring script
  monitor_script_path = ::File.join(base_dir, 'bin', 'automate_monitoring.sh')

  describe file(monitor_script_path) do
    it { should exist }
    its('mode') { should cmp '0755' }
  end

  describe crontab(path: '/etc/cron.d/automate_monitoring') do
    its('commands') { should include monitor_script_path }
    its('minutes') { should cmp '*/5' }
  end  
end

# Check the chef server monitoring
if deploy_chef

  # Check that the necssary packages are installed
  describe package('nodejs') do
    it { should be_installed }
  end

  describe package('npm') do
    it { should be_installed }
  end

  # Check necessary NPM packages are installed
  describe npm('statsd') do
    it { should be_installed }
  end
  
=begin
  describe npm('azure-storage', path: '/usr/local/camsa/statsd/azure-queue') do
    it { should be_installed }
  end

  describe npm('sprintf-js', path: '/usr/local/camsa/statsd/azure-queue') do
    it { should be_installed }
  end
=end

  # Ensure that the user exists
  describe user(statsd_user) do
    it { should exist }
  end

  describe file(::File.join(base_dir, 'statsd', 'azure-queue')) do
    it { should exist }
    its('owner') { should eq statsd_user}    
  end

  # Check that the plugin file has been copied to the machine
  describe file(::File.join(base_dir, 'statsd', 'azure-queue', 'statsd-azure-queue.js')) do
    it { should exist }
    its('owner') { should eq statsd_user}
  end

  # Check the configuration files for statsd
  describe file(::File.join(base_dir, 'etc', 'statsd_config.js')) do
    it { should exist }
    its('owner') { should eq statsd_user}
  end

  describe file('/etc/systemd/system/statsd.service') do
    it { should exist }
  end

  describe service('statsd') do
    it { should be_installed }
    it { should be_enabled }
    it { should be_running }
  end  

  # Ideally need to check that the chef server has been configured propeerly
  # This needs to be done using Hab and not the file directly
=begin
describe file('/etc/opscode/chef-server.rb') do 
  its('content') { should match(%r{^data_collector\['root_url'\]})}
  its('content') { should match(%r{^profiles\['root_url'\]})}
  its('content') { should match(%r{^estatsd\["enable"\]})}
  its('content') { should match(%r{^estatsd\["protocol"\]})}
  its('content') { should match(%r{^estatsd\["port"\]})}
end
=end  
end