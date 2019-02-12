
describe file('/tmp/kitchen/cache/chef-automate_linux_amd64.zip') do
  it { should exist }
end

describe file('/usr/local/bin/chef-automate') do
  it { should exist }
  its('mode') { should cmp '0755' }
end

describe kernel_parameter('vm.max_map_count') do
  its('value') { should eq 262144 }
end

describe kernel_parameter('vm.dirty_expire_centisecs') do
  its('value') { should eq 20000 }
end

# Ensure that the archive files exist and the original does not
describe file('/usr/local/camsa/automate_credentials.toml') do
  it { should_not exist }
end

describe file('/usr/local/camsa/archive/automate-credentials.toml') do
  it { should exist }
end

# Check that the automate server has been properly licensed
# Configure the command that will be used to get the license status
cmd = 'curl https://127.0.0.1/api/v0/license/status -k --cert /hab/svc/deployment-service/data/deployment-service.crt --key /hab/svc/deployment-service/data/deployment-service.key --cacert /hab/svc/deployment-service/data/root.crt'
describe json({command: cmd}) do
  its ('customer_name') { should include 'Russell Seymour'}
end
