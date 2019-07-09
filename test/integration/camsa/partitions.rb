deploy_automate = attribute('deploy_automate', default: true, description: 'States if the machine has had Automate deployed to it')
deploy_chef = attribute('deploy_chef', default: true, description: 'States if the machine has had Chef deployed to it')
deploy_supermarket = attribute('deploy_supermarket', default: true, description: 'States if the machine has had Supermarket deployed to it')

# Based on the attributes, perform the relevant tests
if deploy_automate

  # Check that the /dev/dsc1 has been mounted on /hab
  describe mount('/hab') do
    it { should be_mounted }
    its('device') { should eq '/dev/sdc1' }
    its('type') { should eq 'ext4' }
  end
  
  # Ensure that the mount point is is fstab
  describe etc_fstab.where{ device_name == '/dev/sdc1' } do
    its('mount_point') { should cmp '/hab' }
  end
end
