# Set the attributes to configure the data disk for the machine
default['camsa']['datadisks']['automate'] = [
  {
    "label": "\"AutomateDisk\"",
    "fstype": "ext4",
    "device": "/dev/sdc",
    "mount": "/hab"
  }  
]

# This definition is only used when the Chef server is deployed onto a 
# separate machine. It is ignored on an all in one machine
default['camsa']['datadisks']['chef'] = [
  {
    "label": "\"ChefDisk\"",
    "fstype": "ext4",
    "device": "/dev/sdc",
    "mount": "/opt/opscode"
  }  
]