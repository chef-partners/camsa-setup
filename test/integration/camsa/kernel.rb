deploy_automate = attribute('deploy_automate', default: true, description: 'States if the machine has had Automate deployed to it')

# Tests to ensure that the kernel has been configured properly if automate has been deployed
if deploy_automate
  describe kernel_parameter('vm.max_map_count') do
    its('value') { should eq 262144}
  end

  describe kernel_parameter('vm.dirty_expire_centisecs') do
    its('value') { should eq 20000 }
  end
end