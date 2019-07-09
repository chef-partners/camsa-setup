---
title: automate_monitoring.sh
parent: Templates
nav_order: 10
layout: default
---

# automate_monitoring.sh

Automate does not have the ability to send metrics directly to Azure Log Analytics, so a cron job is required that will read the metrics from the Automate server every 5 minutes. This data is then sent to a deployed Azure Function which takes this data and adds it to Log Analytics.

By default this script will be written out to `/usr/local/camsa/bin/automate_monitoring.sh` and then scheduled on a cron by the `backup` recipe.

## Configuration

As this is a template the settings for the script are injected directly into the script when Chef renders the file to disk. The following is a list of the settings that are applied to the script.

| Setting | Description | Example |
|---|---|---|
| function_url | URL to the function that will recieve the Automate data |
| apikey | The apikey associated with the specified function |

## Raw Script

The following is an example of the monitoring script.

```bash
#!/usr/bin/env bash

journalctl -fu chef-automate --since "5 minutes ago" --until "now" -o json > /var/log/jsondump.json
curl -H "Content-Type: application/json" -H "x-functions-key: <%= @apikey %>" -X POST -d @/var/log/jsondump.json <%= @function_url %>
```