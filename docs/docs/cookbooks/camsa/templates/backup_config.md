---
title: backup_config.erb
parent: Templates
nav_order: 20
layout: default
---

# backup_config.erb

The [backup script]({% link docs/cookbooks/camsa/files/backup.md %}) requires a configuration file so it can upload files to Azure Blog storage.

This template file is written out to `/usr/local/camsa/etc/backup_config` by default and is populated from the attributes that are in the chef run.

## Configuration

As this is a template the settings for the file are injected directly into the script when Chef renders the file to disk. The following is a list of the settings that are applied to the script.

| Setting | Description | Example |
|---|---|---|
| sa_name | Name of the storage account  |
| container_name | Name of the container to upload files to |
| access_key | Access key to use to upload files |

## Raw file

The following is an example of the backup configuration template

```
STORAGE_ACCOUNT=<%= @sa_name %>
CONTAINER_NAME=<%= @container_name %>
ACCESS_KEY=<%= @access_key %>
```