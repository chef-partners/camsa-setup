---
title: statsd-azure-queue.js
parent: Files
nav_order: 20
layout: default
---

# statsd-azure-queue.js

The Chef server emits metrics in Statsd format. The deployment installs a Statsd server on the same machine as the Chef server component and configures Chef to send data to it.

This file is a plugin for Stats that allows these messages to be sent to an Azure Queue. The messages are then read from the queue by an Azure Function that is deployed as part of CAMSA.

## Configuration

As this is a plugin for Stats there are no parameters that can be passed to it directly, however it does need configuration which is set in the main statsd configuration file.

The settings for this file are:

| Name | Description |
|---|---|
| storageAccountName | Name of the storage account with the queue |
| storageAccountKey | Account key associated with the specified storage account |
| queueName | Name of the queue to send messages to |

