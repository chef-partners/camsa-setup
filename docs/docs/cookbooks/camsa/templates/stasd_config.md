---
title: statsd_config.js
parent: Templates
nav_order: 40
layout: default
---

# statsd_config.js

Statsd requires a configuration file which contains the settings to be able to write out the files to Azure blob storage.

This template file is written out to `/usr/local/camsa/etc/statsd_config.js` by default and is populated from the attributes that are in the chef run.

## Configuration

As this is a template the settings for the file are injected directly into the script when Chef renders the file to disk. The following is a list of the settings that are applied to the script.

| Setting | Description | Example |
|---|---|---|
| storageAccountName | Name of the storage account  |
| storageAccountKey | Key to use when accessing the storage account |
| queueName | Name of the queue to put messages onto |
| plugin | The name of the plugins that need to be run by Statsd |

## Raw file

The following is an example of the backup configuration template

```js
{
  storageAccountName: "<%= @sa_name %>",
  storageAccountKey: "<%= @access_key %>",
  queueName: "chef-statsd",
  backends: [ "<%= @plugin %>" ]
}
```