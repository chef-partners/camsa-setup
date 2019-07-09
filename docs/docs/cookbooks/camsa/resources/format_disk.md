---
title: format_disk
parent: Resources
nav_order: 10
layout: default
---

# format_disk

This is a simple resource that groups other resources together to allow the formattign and mounting of disks.

When CAMSA is deployed each machine has a data disk attached to it. This resource is used to partition the disk (the whole of the disk is used), format it and then mount it.

## Syntax

```ruby
format_disk 'name' do
  device        String   # Name of the device, if not specified the name of the resource will be used
  label         String   # Label to be applied to the partition
  fstype        String   # The filesystem type
  mountpoint    String   # Mount point for the partition
  action        Symbol   # Action to run on the resource, default: create
end
```

where:

  - `format_disk` is the resource
  - `name` is the name given to the resource block
  - `action` identifies which steps the chef-client will take to bring the nodes into the desired state
  - `device`, `label`, `fstype` and `mountpoint` are properties of this resource, with the ruby type shown.

## Actions

The `format_disk` resource has the following actions:

`:create` - Create the parition and format the disk

## Defaults

| Property | Default Value |
|---|---|
| fstype | ext4 |

