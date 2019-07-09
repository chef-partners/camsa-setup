# Resource to handle the paritioning of the specified device and then
# formatting it
# This resource will create one partition on the whole of the disk

# Device that is to be formatted
property :device, String, name_property: true

# Label to be applied to the disk
property :label, String

# FSType for the disk, default is ext4
property :fstype, String, default: 'ext4'

# The mound point for the parition
property :mountpoint, String

action :create do

  # Determine the parition number using the device
  partition = "%s1" % [new_resource.device]

  # Using sfdisk parition the disk accordinly
  bash 'partition_disk' do
    code "echo ';' | sfdisk #{new_resource.device}"

    # Only partition the disk if the device does not already exist
    not_if { ::File.exist?(partition)}
  end

  # Use the filesystem resource to format the disk, add it to FStab and
  # mount it
  filesystem new_resource.label do
    fstype new_resource.fstype
    device partition
    mount new_resource.mountpoint
    action [:create, :enable, :mount]
  end
end