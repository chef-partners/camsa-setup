# Test to check that the backups have been configured properly
base_dir = attribute('base_dir', default: '/usr/local/camsa', description: 'Base directory fo all CAMSA related files')
deploy_automate = attribute('deploy_automate', default: true, description: 'States if the machine has had Automate deployed to it')
deploy_chef = attribute('deploy_chef', default: true, description: 'States if the machine has had Chef deployed to it')
deploy_supermarket = attribute('deploy_supermarket', default: false, description: 'States if the machine has had Chef deployed to it')

# Set the path to the backup script
backup_script_file = ::File.join(base_dir, 'bin', 'backup.sh')
backup_config_file = ::File.join(base_dir, 'etc', 'backup_config')

# Ensure the backup script is in place
describe file(backup_script_file) do
  it { should exist }
  its('mode') { should cmp '0755' }
end

# Ensure the configuration file for the backup exists
describe file(backup_config_file) do
  it { should exist }
end

# Check that the crontab has been setup correctly
if deploy_automate || deploy_chef
  describe crontab(path: '/etc/cron.d/automate_backup') do
    its('commands') { should include "#{backup_script_file} -t automate"}
    its('minutes') { should cmp '0' }
    its('hours') { should cmp '1' }
  end
end

if deploy_supermarket
  describe crontab(path: '/etc/cron.d/supermarket_backup') do
    its('commands') { should include "#{backup_script_file} -t supermarket"}
    its('minutes') { should cmp '0' }
    its('hours') { should cmp '1' }
  end
end