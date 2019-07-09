---
title: statsd.service
parent: Templates
nav_order: 50
layout: default
---

# stats.service

So that statsd can be started on boot using systemd a configuration file required. This template provides that file.

This template file is written out to `/etc/systemd/system/statsd.service` by default and is populated from the attributes that are in the chef run.

## Configuration

As this is a template the settings for the file are injected directly into the script when Chef renders the file to disk. The following is a list of the settings that are applied to the script.

| Setting | Description | Example |
|---|---|---|
| user | User under which the service should run  |
| statsd_path | Path to the statsd server |
| statsd_config_file | Path to the statsd configuration file |

## Raw file

The following is an example of the backup configuration template

```
[Unit]
Description=StatsD daemon for Chef Server monitoring

[Service]
User=<%= @user %>
Type=simple
ExecStart=/usr/bin/node <%= @statsd_path %> <%= @statsd_config_file %>

[Install]
WantedBy=multi-user.target
```