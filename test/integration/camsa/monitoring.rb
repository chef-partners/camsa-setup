# Tests to ensure that the monitoring of the componens has been configured
# correctly
base_dir = attribute('base_dir', default: '/usr/local/camsa', description: 'Base directory fo all CAMSA related files')
deploy_automate = attribute('deploy_automate', default: true, description: 'States if the machine has had Automate deployed to it')
deploy_chef = attribute('deploy_chef', default: true, description: 'States if the machine has had Chef deployed to it')
statsd_user = attribute('statsd_yser', default: 'statsd', description: 'User that the statsd service will run under')


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

  # Create array of the npm packages that need to be checked
  %w{statsd azure-storage sprintf-js}.each do |npm_package|
    describe npm(npm_package) do
      it { should be_installed }
    end
  end

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