# Test to check that the backups have been configured properly
base_dir = input('base_dir', value: '/usr/local/camsa', description: 'Base directory fo all CAMSA related files')
deploy_automate = input('deploy_automate', value: true, description: 'States if the machine has had Automate deployed to it')
deploy_chef = input('deploy_chef', value: true, description: 'States if the machine has had Chef deployed to it')
deploy_supermarket = input('deploy_supermarket', value: false, description: 'States if the machine has had Chef deployed to it')

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
if (deploy_automate || deploy_chef) && ::File.exist?('/etc/cron.d/automate_backup')
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